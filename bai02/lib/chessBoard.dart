import 'package:flutter/material.dart';

import 'square.dart';

class chessBoard extends StatefulWidget {
  List<Map<String, int>> queensPiece;
  final int index;
  chessBoard({super.key, required this.queensPiece, required this.index});

  @override
  State<chessBoard> createState() => _chessBoardState();
}

class _chessBoardState extends State<chessBoard> {
  bool isQueen(int row, int col) {
    return widget.queensPiece
        .any((piece) => piece['row'] == row && piece['col'] == col);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Cách ${widget.index + 1}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
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
                int row = index ~/ 8 + 1;
                int col = index % 8 + 1;
                bool isWhite = (row + col) % 2 == 0;
                return Square(
                  isWhite: isWhite,
                  isQueen: isQueen(row, col),
                  onTap: null,
                );
              }),
        ),
      ],
    );
  }
}
