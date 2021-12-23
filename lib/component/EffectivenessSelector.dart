import 'package:flutter/material.dart';

class EffectivenessSelector extends StatelessWidget {
  const EffectivenessSelector({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  static final scales = ['沒效', '有一點效', '有效', '完全不痛'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(label),
        DropdownButton<int>(
          value: value,
          items: List.generate(4, (index) => index, growable: true).map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(scales[value]),
            );
          }).toList(),
          onChanged: (int? newValue) {
            onChanged(newValue!);
          },
        )
      ]
    );
  }
}
