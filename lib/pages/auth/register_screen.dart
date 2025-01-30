import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/services/auth.dart';

class RegisterPage extends StatelessWidget {
  final AuthService authService = Get.find<AuthService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => authService.registerWithEmailAndPassword(
                context: context,
                email:  emailController.text.trim(),
                password:  passwordController.text.trim(),
                name: nameController.text,
                surname: surnameController.text,
                phone: "12412412"
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
