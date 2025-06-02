import 'dart:math';

import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<double> heights =
      List.generate(15, (index) => 20 + Random().nextInt(81).toDouble());

  List<Color> colorOfColumns = List.generate(15, (index) => Colors.grey);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void swap(int i, int j) {
    setState(() {
      final temp = heights[i];
      heights[i] = heights[j];
      heights[j] = temp;
    });
  }

  Future<void> selectionSort() async {
    for (int i = 0; i < heights.length - 1; i++) {
      int minIdx = i;
      // Đánh dấu cột minIdx là blue, các cột khác là grey
      setState(() {
        for (int k = 0; k < colorOfColumns.length; k++) {
          if (colorOfColumns[k] == Colors.green) {
            continue; // Giữ nguyên màu green
          }
          colorOfColumns[k] = (k == minIdx) ? Colors.blue : Colors.grey;
        }
      });
      await Future.delayed(const Duration(milliseconds: 400));

      for (int j = i + 1; j < heights.length; j++) {
        // Chỉ cột j là red, các cột khác (trừ minIdx) là grey
        setState(() {
          for (int k = 0; k < colorOfColumns.length; k++) {
            if (colorOfColumns[k] == Colors.green) {
              continue; // Giữ nguyên màu green
            }
            if (k == minIdx) {
              colorOfColumns[k] = Colors.blue;
            } else if (k == j) {
              colorOfColumns[k] = Colors.red;
            } else {
              colorOfColumns[k] = Colors.grey;
            }
          }
        });
        await Future.delayed(const Duration(milliseconds: 400));

        if (heights[j] < heights[minIdx]) {
          // Đổi màu minIdx cũ về grey, minIdx mới thành blue
          setState(() {
            if (colorOfColumns[minIdx] != Colors.green) {
              colorOfColumns[minIdx] = Colors.grey;
            }
            if (colorOfColumns[j] != Colors.green) {
              colorOfColumns[j] = Colors.blue;
            }
          });
          minIdx = j;
          await Future.delayed(const Duration(milliseconds: 400));
        }
      }
      if (minIdx != i) {
        swap(i, minIdx);
      }
      setState(() {
        colorOfColumns[i] = Colors.green;
      });
      await Future.delayed(const Duration(milliseconds: 600));
    }
    // Sau khi sort xong, tất cả cột thành green
    setState(() {
      for (int k = 0; k < colorOfColumns.length; k++) {
        colorOfColumns[k] = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200, // Set a fixed height to see the difference
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: heights.length,
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
                child: _col(heights[index], colorOfColumns[index],
                    key: ValueKey(heights[index])),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => selectionSort(), // Swap first two bars
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }

  Widget _col(double height, Color color, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        height: 200,
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
