# ♛ Chessboard  App (Flutter)

Ứng dụng Flutter hiển thị bàn cờ vua 8x8, cho phép người dùng đặt một quân **hậu (♛)** vào bất kỳ ô nào trên bàn cờ

---

## 🎯 Bài toán

**Mục tiêu:**  
Hãy vẽ một bàn cờ vua có kích thước 8 x 8 ô.
Đặt một quân hậu ở một ô bất kỳ trong bàn cờ bằng lệnh place_queen(int row, int column).

---

## 🧠 Hướng giải quyết

### 1. Hiển thị bàn cờ 8x8
- Sử dụng `GridView.builder` để tạo bảng 8x8.
- Xen kẽ ô trắng và đen bằng công thức: `(row + col) % 2 == 0`.

### 2. Quản lý vị trí quân hậu
- Biến `selectedRow` và `selectedCol` lưu vị trí quân hậu.
- Hàm `place_queen(int row, int col)` cập nhật vị trí 
## 🖼️ Demo

![](/assets/image/image.png)





