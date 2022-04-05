import 'package:flutter/material.dart';

class RegisterDropdown<T> extends StatelessWidget {
  const RegisterDropdown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChanged,
      required this.hintText,
      this.prefixIcon})
      : super(key: key);
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;
  final String hintText;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
        isExpanded: true,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        hint: Text(hintText),
        value: value,
        items: items,
        onChanged: onChanged);
  }
}
