
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  //
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isObscured;
  final Function()? toggleVisibility;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isObscured = false,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: controller,
        obscureText:
            isPassword ? isObscured : false, // Приховує текст, якщо це пароль
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          hintText: hintText,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: Color(0xFF929292), // Колір обводки, коли поле не в фокусі
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: Color(0xFF929292), // Колір обводки, коли поле не в фокусі
              width: 1.0,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: toggleVisibility,
                )
              : null, // Додає іконку для пароля
        ),
      ),
    );
  }
}