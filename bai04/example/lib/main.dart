import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bai04/bai04.dart' as bai04;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? sortSteps;
  List<int> data1 = List.generate(15, (index) {
    final numRan = Random().nextInt(100);
    if (numRan < 10) {
      return numRan * 10; // Ensure no zero values
    }
    return numRan;
  });
  List<int> data2 = [100, 60, 85, 20, 40, 30, 10, 75];
  List<Color> colorOfColumns1 = List.generate(15, (index) => Colors.grey);
  List<Color> colorOfColumns2 = List.generate(10, (index) => Colors.grey);
  List<List<int>> sortedData1 = [];
  List<List<int>> sortedData2 = [];
  Future<void> getsortSteps() async {
    try {
      final listSort1 = await bai04.getSortSteps(data1);
      final listSort2 = await bai04.getSortSteps(data2);
      setState(() {
        sortedData1 = listSort1;
        sortedData2 = listSort2;
        sortSteps = sortedData2.length;
      });
    } catch (e) {
      print('Error getting sort steps: $e');
    }
  }

  int currentIndex1 = 0;
  int currentIndex2 = 0;

  void selectionSort() async {
    for (int i = 0; i < sortedData1.length; i++) {
      setState(() {
        colorOfColumns1[currentIndex1] = Colors.blue;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      for (int j = currentIndex1 + 1; j < data1.length; j++) {
        setState(() {
          colorOfColumns1[j] = Colors.red;
          if (j - 1 != currentIndex1) {
            colorOfColumns1[j - 1] = Colors.grey;
          }
        });
        await Future.delayed(const Duration(milliseconds: 150));
        if (data1[j] == sortedData1[i][currentIndex1]) {
          setState(() {
            colorOfColumns1[j] = Colors.blue;
            colorOfColumns1[currentIndex1] = Colors.grey;
          });
          await Future.delayed(const Duration(milliseconds: 150));
        }

        setState(() {
          colorOfColumns1[j] = Colors.grey;
        });

        await Future.delayed(const Duration(milliseconds: 150));
      }
      setState(() {
        data1 = sortedData1[i];
        colorOfColumns1[currentIndex1] = Colors.green;
        currentIndex1 = currentIndex1 + 1;
      });
    }
    setState(() {
      colorOfColumns1.map((toElement) => Colors.green).toList();
    });
  }

  int i = 0;
  void _playAnimation() async{
    while (i < sortSteps!) {
      setState(() {
        data2 = sortedData2[i];
        colorOfColumns2[currentIndex2] = Colors.green;
        i++;
        currentIndex2++;
      });
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  void initState() {
    super.initState();
    getsortSteps();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: selectionSort,
                    child: const Text(
                      'Play 1',
                      style: TextStyle(fontSize: 18),
                    )),
                ElevatedButton(
                    onPressed: _playAnimation,
                    child: const Text(
                      'Play 2',
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ),
            row_Col(data1, colorOfColumns1),
            const SizedBox(height: 20),
            row_Col(data2, colorOfColumns2),
          ],
        ),
      ),
    );
  }

  Widget row_Col(List<int> data, List<Color> colorOfColumns) {
    return SizedBox(
      height: 200, // Set a fixed height to see the difference
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
            child: _col(data[index].toDouble(), colorOfColumns[index],
                key: ValueKey(data[index])),
          );
        },
      ),
    );
  }

  Widget _col(double height, Color color, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        // height: 200,
        width: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: height,
              width: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Text(
                height.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
