import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rest_reservation/pages/auth/login_screen.dart';
import 'package:rest_reservation/pages/home_page/home_page.dart';
import 'package:rest_reservation/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Реєстрація нового користувача
  Future<void> registerWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String surname,
    required String phone,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Будь ласка, заповніть всі поля')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Зберігаємо додаткові дані користувача в Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'surname': surname,
          'phone': phone,
          'email': email,
          'createdAt': DateTime.now(),
        });

        // Зберігаємо ID користувача в SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.uid);

        // Показуємо успішне повідомлення
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Реєстрація успішна!')),
        );

        // Перенаправляємо на головний екран
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  MainPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(context, e);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сталася непередбачена помилка.')),
      );
      debugPrint('Register error: $e');
    }
  }

  // Авторизація
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Будь ласка, заповніть всі поля')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);

      // Показуємо успішне повідомлення
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вхід успішний!')),
      );

      // Перенаправляємо на головний екран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      handleAuthException(context, e);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сталася помилка. Спробуйте пізніше.')),
      );
      debugPrint('Sign-in error: $e');
    }
  }

  // Вихід
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ви вийшли з облікового запису')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сталася помилка під час виходу.')),
      );
      debugPrint('Sign-out error: $e');
    }
  }

  // Отримання поточного користувача
  User? get currentUser => _auth.currentUser;

  // Завантаження даних користувача з Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Get user data error: $e');
    }
    return null;
  }

  // Обробка помилок FirebaseAuth
  void handleAuthException(BuildContext context, FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Цей email вже використовується.';
        break;
      case 'invalid-email':
        errorMessage = 'Неправильний формат email.';
        break;
      case 'weak-password':
        errorMessage = 'Пароль занадто слабкий.';
        break;
      case 'user-not-found':
        errorMessage = 'Користувача з таким email не знайдено.';
        break;
      case 'wrong-password':
        errorMessage = 'Неправильний пароль.';
        break;
      default:
        errorMessage = 'Сталася помилка. Спробуйте ще раз.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
