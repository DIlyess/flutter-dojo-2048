import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile(this.value, {super.key});

  final int value;

  @override
  Widget build(BuildContext context) {
    Color? getColor(int value) {
      switch (value) {
        case 2:
          return Colors.orangeAccent[100];
        case 4:
          return Colors.orangeAccent[200];
        case 8:
          return Colors.orangeAccent[400];
        case 16:
          return Colors.orangeAccent[700];
        case 32:
          return Colors.deepOrangeAccent[100];
        case 64:
          return Colors.deepOrangeAccent[200];
        case 128:
          return Colors.deepOrangeAccent[400];
        case 256:
          return Colors.deepOrangeAccent[700];
        case 512:
          return Colors.orange[800];
        case 1024:
          return Colors.orange[900];
        case 2048:
          return Colors.deepOrange[900];
        default:
          return Colors.grey[400];
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Container(
        padding: const EdgeInsets.all(4),
        width: width,
        height: width,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: getColor(value),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value != 0 ? value.toString() : '',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
