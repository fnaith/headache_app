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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text('     '),
        Text(label),
        Slider(
          value: value.toDouble(),
          max: 10,
          divisions: 10,
          label: value.toString(),
          onChanged: (double? newValue) {
            onChanged(newValue!.toInt());
          },
        )
      ]
    );
  }
}
