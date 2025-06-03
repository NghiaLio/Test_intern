
## 🎯 Bài toán

**Mục tiêu:**  
Xử lý đa chạm để vẽ một tam giác có 3 đỉnh. Người dùng có thể chạm vào từng đỉnh để di
chuyển vẽ lại tam giác

---

## 🧠 Hướng giải quyết

### 1. Biểu diễn dữ liệu
- Mỗi đỉnh là một Offset(x, y).
- Lưu tam giác thành List<Offset> points = [A, B, C];

### 2. Bắt sự kiện chạm
Sử dụng GestureDetector:
- onPanStart: kiểm tra điểm chạm gần đỉnh nào nhất.
- onPanUpdate: cập nhật vị trí đỉnh đó.
- onPanEnd: reset trạng thái kéo.
### 3.Vẽ lại tam giác 
Sử dụng `CustomPainter` để vẽ tam giác từ danh sách `Offset`.
> Promt đã hỏi AI: Vẽ tam giác bằng Custom Paint() với các đỉnh là các OffSet 
## 🖼️ Demo

