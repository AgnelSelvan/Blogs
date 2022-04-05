import 'package:flutter/material.dart';
import 'package:loop_calling/core/utils/enum/input.dart';
import 'package:loop_calling/core/utils/input_validator.dart';
import 'package:loop_calling/res/colors.dart';
import 'package:loop_calling/views/pages/register.dart';

class RegisterTextField extends StatefulWidget {
  const RegisterTextField(
      {Key? key,
      required this.hintText,
      required this.labelText,
      this.onChanged,
      this.controller,
      this.validator,
      this.textInputType,
      this.maxLines,
      this.enabled,
      required this.inputType,
      required this.leadingIcon,
      this.focusNode,
      this.obsecureText})
      : super(key: key);

  final String labelText;
  final String hintText;
  final IconData leadingIcon;
  final StringCallback? onChanged;
  final TextEditingController? controller;
  final ValidatorCallback? validator;
  final TextInputType? textInputType;
  final bool? enabled;
  final int? maxLines;
  final InputType inputType;
  final bool? obsecureText;
  final FocusNode? focusNode;
  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField>
    with InputValidator {
  String? get validatorCallback => widget.inputType == InputType.username
      ? validateFullName(widget.controller?.text)
      : widget.inputType == InputType.password
          ? validatePassword(widget.controller?.text)
          : null;

  @override
  void initState() {
    super.initState();

    if (widget.enabled == null) {
      try {
        widget.controller?.addListener(() {
          setState(() {});
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      validator: widget.validator,
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.textInputType,
      obscureText: widget.obsecureText ?? false,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.grey[400]!),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.primarySwatch.shade100, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        prefixIcon: Icon(widget.leadingIcon),
        suffixIcon: (widget.enabled == false)
            ? null
            : widget.controller?.text == ""
                ? null
                : Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (validatorCallback == null)
                          ? Colors.green[50]
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      (validatorCallback == null) ? Icons.check : Icons.cancel,
                      size: 16,
                      color: (validatorCallback == null)
                          ? Colors.green[400]
                          : Colors.red[400],
                    ),
                  ),
      ),
    );
  }
}
