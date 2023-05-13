import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.borderSideColor,
    this.inputFormatters,
  });

  final TextInputType keyboardType;
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Color? borderSideColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters ?? [],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          // color: AppColors.primaryWhite,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderSideColor ?? Colors.white),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
