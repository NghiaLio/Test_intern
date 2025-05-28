import 'dart:math';

import 'package:flutter/material.dart';

import 'square.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int? selectedRow;
  int? selectedCol;

  void placeQueen(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Demo'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              itemCount: 64,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;
                bool isWhite = (row + col) % 2 == 0;
                return Square(
                  isWhite: isWhite,
                  isQueen: selectedRow == row && selectedCol == col,
                  onTap: () => placeQueen(row, col),
                );
              }),
        ),
      ),
    );
  }
}
