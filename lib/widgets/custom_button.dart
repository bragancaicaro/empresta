
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final Widget widgetChildButton;

  const CustomButton({super.key, this.onTap, required this.widgetChildButton});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
          child: widgetChildButton
        ),
      )
    );
  }
}