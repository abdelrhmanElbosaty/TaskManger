import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const TextFieldWidget({
    super.key,
    this.controller,
    this.label,
    this.maxLength,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      maxLength: maxLength,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), label: Text(label ?? '')),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
