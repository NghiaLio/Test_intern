import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final bool isQueen;
  VoidCallback? onTap;
  Square({super.key, required this.isWhite, required this.isQueen, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isWhite ? Colors.green : const Color.fromARGB(255, 226, 208, 202),
        child: isQueen ? Image.asset('assets/icon/queenblack.png') : null,
      ),
    );
  }
}