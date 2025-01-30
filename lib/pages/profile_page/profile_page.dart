import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';




class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Реактивні дані користувача
  var userData = <String, dynamic>{}.obs;
  var isUploading = false.obs;
 @override
 
  @override
  void onInit() {
    super.onInit();
    if (_auth.currentUser != null) {
      fetchUserData(); // Завантаження даних, якщо користувач вже увійшов
    }
  }
  // Завантаження даних користувача
  Future<void> fetchUserData() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();

      if (snapshot.exists) {
        userData.assignAll(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
// Завантаження фото користувача
  Future<void> uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    isUploading.value = true; // Початок завантаження

    try {
      File file = File(pickedFile.path);
      String filePath = 'user_profiles/${_auth.currentUser?.uid}.jpg';
      TaskSnapshot snapshot = await _storage.ref(filePath).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Оновлення фото у Firestore
      await _firestore.collection('users').doc(_auth.currentUser?.uid).update({'photoUrl': downloadUrl});
      userData['photoUrl'] = downloadUrl;
      update();

      Get.snackbar('Success', 'Profile picture updated successfully.');
    } catch (e) {
      print("Error uploading image: $e");
      Get.snackbar('Error', 'Failed to upload profile picture.');
    } finally {
      isUploading.value = false;
    }
  }
  // Оновлення імені користувача
  Future<void> updateName(String name) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update({'name': name});
      userData['name'] = name; // Локальне оновлення
      update(); // Оновлюємо віджет
    } catch (e) {
      print("Error updating name: $e");
    }
  }
   // Вихід користувача
   Future<void> logout() async {
    try {
      await _auth.signOut();
      userData.clear(); // Очищення даних після виходу
      Get.snackbar('Success', 'Logged out successfully.');
    } catch (e) {
      print("Error during logout: $e");
      Get.snackbar('Error', 'Failed to log out.');
    }
  }
}


class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.userData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileInfo(),
              const SizedBox(height: 24),
              _buildEditButton(),
              const SizedBox(height: 16),
              _buildLogoutButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Stack(
            children: [
              Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.userData['photoUrl'] != null
                        ? NetworkImage(controller.userData['photoUrl'])
                        : const AssetImage('assets/images/user_avatar.png') as ImageProvider,
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => controller.uploadProfileImage(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          controller.userData['name'] ?? 'Name not set',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          controller.userData['email'] ?? 'Email not set',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        Get.to(() => EditProfilePage());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff5B4CBD),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () => controller.logout(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = controller.userData['name'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await controller.updateName(nameController.text);
                  Get.back();
                  Get.snackbar('Success', 'Profile updated successfully.');
                } else {
                  Get.snackbar('Error', 'Name cannot be empty.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff5B4CBD),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
