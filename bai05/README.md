# 🔺 Ứng dụng Vẽ Tam Giác Đa Chạm với Flutter

## 🎯 Mục tiêu

Xây dựng một ứng dụng Flutter cho phép người dùng **vẽ một tam giác bằng 3 điểm chạm** trên màn hình. Sau khi tam giác được tạo, người dùng có thể **chạm và kéo từng đỉnh** để di chuyển, cập nhật lại hình tam giác tương ứng theo thời gian thực.

---

## 🛠️ Kỹ thuật sử dụng

- Flutter (Dart)
- GestureDetector
- CustomPainter
- Xử lý đa chạm (multi-touch)

---

## 🚀 Cách hoạt động

1. **Giai đoạn vẽ**:
   - Người dùng lần lượt chạm vào 3 điểm khác nhau trên màn hình để xác định 3 đỉnh của tam giác.

2. **Giai đoạn chỉnh sửa**:
   - Sau khi đủ 3 đỉnh, người dùng có thể **chạm và kéo từng đỉnh** để thay đổi hình dạng tam giác.

---

## 🚀 Cách làm 
#### Bước 1: Khởi tạo danh sách các đỉnh

```dart
List<Offset> trianglePoints = [];
```
#### Bước 2: Sử dụng GestureDetector để lắng nghe chạm và kéo
```dart
GestureDetector(
  onPanDown: (details) {
    // Thêm điểm hoặc kiểm tra gần đỉnh nào để kéo
  },
  onPanUpdate: (details) {
    // Di chuyển đỉnh đang chọn
  },
)
```
#### Bước 3: Vẽ tam giác với CustomPainter

```dart

class TrianglePainter extends CustomPainter {
  final List<Offset> points;

  TrianglePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length == 3) {
      final paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(points[0].dx, points[0].dy)
        ..lineTo(points[1].dx, points[1].dy)
        ..lineTo(points[2].dx, points[2].dy)
        ..close();

      canvas.drawPath(path, paint);
    }

    // Vẽ các đỉnh (hình tròn nhỏ)
    for (final point in points) {
      canvas.drawCircle(point, 10, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

```

## 🖼 Demo

https://github.com/user-attachments/assets/a9995583-1281-440c-a7fa-6407688ac0d8

---

## 💡 Phần tâm đắc
- Học được cách sử dụng GestureDetector để bắt sự kiện chạm và kéo.

- Biết cách vẽ đồ họa theo tọa độ người dùng nhập vào bằng CustomPainter.

- Hiểu về tương tác đa chạm và quản lý trạng thái điểm trên giao diện.

## 🧠 Bài học rút ra
- Biết cách cập nhật lại canvas theo thời gian thực khi người dùng kéo.

- Làm quen với kiến trúc tách biệt phần logic và phần hiển thị bằng CustomPainter.
