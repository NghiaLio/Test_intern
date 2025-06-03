import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Offset> points = [
    Offset(100, 100),
    Offset(200, 300),
    Offset(50, 300),
  ];

  int? draggingPointIndex;

  void onPanStart(details){
    final touchPoint = details.localPosition;
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - touchPoint).distance < 20) {
        draggingPointIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vẽ Tam Giác Đa Chạm")),
      body: GestureDetector(
        // Kiểm tra xem điểm chạm gần đỉnh nào nhất
        onPanStart: (details) => onPanStart(details),
        //cập nhật vị trí đỉnh
        onPanUpdate: (details) {
          if (draggingPointIndex != null) {
            setState(() {
              points[draggingPointIndex!] = details.localPosition;
            });
          }
        },
        //reset trạng thái kéo
        onPanEnd: (details) {
          draggingPointIndex = null;
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: TrianglePainter(points),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final List<Offset> points;
  TrianglePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final border = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);

    for (var point in points) {
      canvas.drawCircle(point, 10, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

