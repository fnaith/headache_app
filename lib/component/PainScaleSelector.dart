import 'package:flutter/material.dart';

class PainScaleSelector extends StatelessWidget {
  const PainScaleSelector({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  static final scales = ['不痛', '小痛', '中痛', '大痛'];

  @override
  Widget build(BuildContext context) {
    return Column(
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
