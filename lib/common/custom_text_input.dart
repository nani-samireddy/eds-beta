import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final bool readOnly;
  final String hintText;
  final String labelText;
  final TextInputType type;
  final TextEditingController controller;
  final String? prefixText;
  final bool enable;
  final String? Function(String value) validator;
  final void Function(String value)? onChange;
  final void Function()? onTap;
  final bool? isValid;
  const CustomTextInput({
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.type,
    required this.validator,
    this.onTap,
    this.prefixText,
    this.onChange,
    this.isValid,
    this.enable = true,
    this.readOnly = false,
    super.key,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _isValid = false;
  @override
  void didChangeDependencies() {
    setState(() {
      _isValid = widget.isValid ?? false;
    });
    super.didChangeDependencies();
  }

  String? _errorText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: (value) {
            setState(() {
              if (widget.isValid != null) {
                _isValid = widget.isValid!;
              } else {
                String? err = widget.validator(value);
                _isValid = (err == null);
                _errorText = err;
              }
            });
            if (widget.onChange != null) {
              widget.onChange!(value);
            }
          },
          enabled: widget.enable,
          keyboardType: widget.type,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            errorText: _errorText,
            enabled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            disabledBorder: widget.enable
                ? Styles.inputBorderStyle
                : Styles.disabledInputBorderStyle,
            border: _isValid
                ? Styles.enabledInputBorderStyle
                : Styles.inputBorderStyle,
            enabledBorder: _isValid
                ? Styles.enabledInputBorderStyle
                : Styles.inputBorderStyle,
            focusedBorder: _isValid
                ? Styles.enabledInputBorderStyle
                : Styles.inputBorderStyle,
          ),
        ),
      ),
    );
  }
}
