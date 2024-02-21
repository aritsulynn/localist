import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(text: 'TOTAL', value: 12),
        buildDivider(),
        buildButton(text: 'ONGOING', value: 3),
        buildDivider(),
        buildButton(text: 'COMPLETED', value: 9),
      ],
    );
  }

  Widget buildButton({required String text, required int value}) {
    return MaterialButton(
        onPressed: () {},
        padding: EdgeInsets.symmetric(vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$value',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ));
  }

  Widget buildDivider() {
    return Container(
      height: 0, // Adjust the height to fit your design
      width: 1, // This will be the thickness of the divider
      color: Colors.grey, // Choose a color that fits your app's theme
      margin: const EdgeInsets.symmetric(
          horizontal: 12), // Add some spacing on both sides
    );
  }
}
