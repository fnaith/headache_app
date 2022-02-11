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
    final ThemeData theme = Theme.of(context);
    Color sliderColor = theme.colorScheme.primary;
    switch (value) {
      case 0: break;
      case 1: case 2: case 3: case 4:
        sliderColor = Colors.yellow;
        break;
      case 5: case 6: case 7: case 8: case 9:
        sliderColor = Colors.orange;
        break;
      default:
        sliderColor = Colors.red;
        break;
    }
    return Row(
      children: <Widget>[
        const Text('     '),
        Text(label),
        Slider(
          activeColor: sliderColor,//theme.colorScheme.primary,
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
