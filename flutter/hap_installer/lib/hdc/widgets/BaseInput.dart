import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseInput extends StatefulWidget {
  final String value;
  final String? helpText;
  final String? suffixText;
  final Function? onChanged;

  const BaseInput({
    super.key,
    required this.value,
    this.helpText,
    this.suffixText,
    this.onChanged,
  });

  @override
  State<BaseInput> createState() => _BaseInputState();
}

class _BaseInputState extends State<BaseInput> {
  late TextEditingController textController;

  String get value => widget.value;
  String? get helpText => widget.helpText;
  String? get suffixText => widget.suffixText;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      minLines: 1,
      controller: textController,
      decoration: InputDecoration(helperText: helpText, suffixText: suffixText),
      onChanged: (context) {},
    );
  }
}
