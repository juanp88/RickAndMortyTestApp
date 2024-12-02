import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback action;

  const CustomTextButton({required this.text, required this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: TextButton(
          onPressed: action,
          child: Text(text),
        ),
      ),
    );
  }
}
