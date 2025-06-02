import 'package:bai03/bai03_bindings_generated.dart';
import 'package:flutter/material.dart';
import 'package:bai03/bai03.dart' as bai03;
import 'chessBoard.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late List<List<Position>> allSolutions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allSolutions = bai03.getAllSolutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giải thuật 8 quân hậu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              allSolutions.isEmpty
                  ? 'Không có giải pháp nào'
                  : 'Tổng số giải pháp: ${allSolutions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width + 50,
              child: PageView.builder(
                  itemCount: allSolutions.length,
                  itemBuilder: (context, index) => chessBoard(
                      queensPiece: allSolutions[index], index: index)),
            ),
          ],
        ),
      ),
    );
  }
}
