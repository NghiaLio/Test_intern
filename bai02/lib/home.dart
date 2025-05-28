import 'package:bai02/chessBoard.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // Mảng X lưu vị trí quân hậu tại hàng i (i từ 1 đến 8)
  List<int> X = List.filled(9, 0); // Chỉ số từ 1..8

// Đánh dấu cột, đường chéo chính và phụ còn trống
  List<int> col = List.filled(9, 1); // col[1]..col[8]
  List<int> d1 = List.filled(17, 1); // d1[i - j + 8] ∈ 0..16
  List<int> d2 = List.filled(17, 1); // d2[i + j - 2] ∈ 0..16

  final List<List<Map<String, int>>> results = [];
  List<Map<String, int>>? queensPiece() {
    final List<Map<String, int>> queens = [];
    for (int i = 1; i <= 8; i++) {
      queens.add({'row': i, 'col': X[i]});
    }
    results.add(queens);
  }

  void Try(int i) {
    for (int j = 1; j <= 8; j++) {
      int d1Index = i - j + 8;
      int d2Index = i +
          j -
          2; //do d1, d2 từ 2 đến 16 nên phải trừ 2, nếu từ 1 dến 15 thì là trừ 1;
      if (col[j] == 1 && d1[d1Index] == 1 && d2[d2Index] == 1) {
        X[i] = j;
        col[j] = d1[d1Index] = d2[d2Index] = 0;

        if (i == 8) {
          queensPiece();
        } else {
          Try(i + 1);
        }

        // backtrack
        col[j] = d1[d1Index] = d2[d2Index] = 1;
      }
    }
  }

  @override
  void initState() {
    Try(1);
    print(results.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giải thuật 8 quân hậu'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width + 50,
          child: PageView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) =>
                  chessBoard(queensPiece: results[index], index: index)),
        ),
      ),
    );
  }
}
