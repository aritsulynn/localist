import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.asset(
        'assets/images/panda.jpg',
        width: 400,
        height: 400,
        fit: BoxFit.cover,
      ),
    );
  }
}
