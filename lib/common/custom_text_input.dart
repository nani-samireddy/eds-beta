import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextInputType type;
  final TextEditingController controller;
  final String? prefixText;
  final bool enable;
  final Function(String value) validator;
  final Function(String value) onChange;
  const CustomTextInput({
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.type,
    required this.validator,
    required this.onChange,
    this.prefixText,
    this.enable = true,
    super.key,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _isValid = false;

  String? _errorText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  String? err = widget.validator(value);
                  _isValid = (err == null);
                  _errorText = err;
                });
                widget.onChange(value);
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
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
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
        ],
      ),
    );
  }
}
