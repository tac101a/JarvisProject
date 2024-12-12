import 'package:flutter/material.dart';

const InputDecoration textFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Color.fromARGB(255, 155, 154, 159), // Custom hint text color
  ),
  filled: true,
  fillColor: Color.fromARGB(255, 245, 244, 250),
  contentPadding: EdgeInsets.all(20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
    borderSide: BorderSide.none, // No border line
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0), // Rounded corners when focused
    ),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 19, 81, 166), // Border color when focused
      width: 1.5, // Border width when focused
    ),
  ),
);

InputDecoration passwordFieldDecoration(
    {required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String hintText}) {
  return textFieldDecoration.copyWith(
      hintText: hintText,
      suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off))
      //suffixIcon: const Icon(Icons.visibility_off),
      );
}

final InputDecoration emailFieldDecoration = textFieldDecoration.copyWith(
  hintText: 'Enter your email address',
);

final InputDecoration usernameFieldDecoration = textFieldDecoration.copyWith(
  hintText: 'Enter your username',
);

const Color primaryBlue = Color.fromARGB(255, 20, 80, 165);
