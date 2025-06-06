# 🧪 ♛ Chessboard  App (Flutter)

## 🧭 Mục tiêu
- Tạo được một bàn cờ 8x8, có thể nhấp vào một ô bất kì để đặt quân hậu vào ô đó.

---

## 🔧 Các bước thực hiện

1. **Phân tích yêu cầu**: 
   - Vẽ một bàn cờ vua 8x8.
   - Đặt một quân hậu vào một ô bất kì.

2. **Cách làm**:  
    2.1. **Tạo bàn cờ và các ô vuông**:
    - Sử dụng `GridView.builder` để tạo ra một bàn cờ với 64 ô (8x8) .
    - Vị trí hàng `row = index ~/ 8` , vị trí cột `col = index % 8`.
    - Để các ô liền kề có màu khác nhau ta sử dụng biến kiểm tra `bool isWhite = (row + col) % 2 == 0`. Nếu `true` thì ô vuông có màu trắng, `false` thì ô vuông có màu đen.

    2.2. **Đặt quân hậu**:
    - Dùng 2 biến `int selectedRow;int selectedCol` để lưu vị trí đặt quân hậu.
    - Xây dựng hàm `placeQueen(int row, int col)` để cập nhật vị trí quân hậu.
    - Mỗi ô vuông được đặt trong `GestureDetector` để bắt sự kiện `onTap`. Mỗi khi nhấn vào ô vuông sẽ gọi hàm `placeQueen()`
    

3. **Kiểm thử và demo**
   - Mở thư mục `bai01` trong `terminal`, nhập lệnh `flutter run --yourdevice` hoặc chọn tập tin `main.dart` và chọn `Run and debug`
---

## 🖼 Video Demo
https://github.com/user-attachments/assets/9eb41bd4-3787-495e-87ec-23dcdbdef285

---

## ❤️ Phần tâm đắc

- Cách tổ chức code rõ ràng

---








