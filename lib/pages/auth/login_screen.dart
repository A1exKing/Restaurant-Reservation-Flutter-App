import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/auth/register_screen.dart';
import 'package:rest_reservation/services/auth.dart';


class LoginPage extends StatelessWidget {
  final AuthService authService = Get.put(AuthService());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onPressed: () => authService.signIn(
                context: context,
                email:  emailController.text.trim(),
                password:  passwordController.text.trim(),
               
              ),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Get.to(() => RegisterPage()),
              child: Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
