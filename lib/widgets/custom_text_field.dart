
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
 final TextEditingController controller;
 final TextStyle textStyle;
 final String hint;
 final bool obscureText;
 final TextInputType keyboardType;
 final int maxLength;
 final String? errorText;
 final Widget? suffixIcon;
 final Widget? prefixIcon;
 final int? maxLines;
 List<TextInputFormatter>? inputFormatter;
 CustomTextField({
    super.key, 
    required this.controller, 
    required this.textStyle,
    required this.hint, 
    required this.obscureText, 
    required this.keyboardType, 
    required this.maxLength,
    this.errorText,
    this.suffixIcon, 
    this.prefixIcon, 
    this.maxLines, 
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle,
      obscureText: obscureText,
      maxLength: maxLength,
      inputFormatters: inputFormatter,
      decoration: InputDecoration(
        counterText: '',
        errorText: errorText,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent) 
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45, width: 2) 
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintMaxLines: maxLines,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45, width: 2) 
        ),
        hintText: hint,
        
      ),
      
      
    );
  }
}
