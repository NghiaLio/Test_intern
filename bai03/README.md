# ♛ Chessboard  App (Flutter)

Thay vì sử dụng thuật toán viết bằng Dart hay chuyển sang viết hàm tìm các vị trí của 8 quân hậu bằng C, rồi dùng kỹ thuật FFI để gọi từ Dart xuống

---

## 🎯 Bài toán

**Mục tiêu:**  
Thay vì viết thuật toán 8 quân hậu bằng Dart, ta sẽ:

- Viết thuật toán giải bài toán 8 quân hậu bằng ngôn ngữ C, lưu kết quả các vị trí vào mảng.

- Sử dụng FFI (Foreign Function Interface) để gọi hàm C từ Dart/Flutter.

- Trả kết quả từ C về Dart dưới dạng `List<List<Position>>`, mỗi lời giải gồm 8 Position(row,colcol).



---

## 🧠 Hướng giải quyết

> -  Viết thuật toán C trả về một mảng 2 chiều lưu trữ các cách giải 
> - Chuyển mảng 2 chiều về mảng 1 chiều để truyền sang Dart

### Các bước thực hiện:
##### C side

- Dùng `FFI_PLUGIN_EXPORT` trước `get_solutions` để xuất symbol.

- Lưu toàn bộ nghiệm vào một buffer “flatten” dạng `Position*`.
- `get_solutions(int* out_count)` trả về `Pointer<Position>` và gán `*out_count `bằng số nghiệm tìm được.

##### Dart side

- Định nghĩa `class Position extends Struct`

- Tạo `lookupFunction` cho `get_solutions`

- Gọi `get_solutions` để nhận `Pointer<Position>` và `count`

- Duyệt `ptr.elementAt(solIndex * 8 + j).ref` để lấy từng `(row,col)`


### Các Promt AI đã hỏi
> Setup FFI plugins for Flutter

> Chuyển mảng 2 chiều sang mảng 1 chiều

> Truyền mảng 1 chiều sang Flutter sử dụng FFI_PLUGIN_EXPORT

> ... một số promt cơ bản khác

#### Truy cập example/lib/ để xem code UI flutter
## 🖼️ Demo

[https://github.com/user-attachments/assets/5b740314-42da-4d3c-ae72-80bb41595a7b](https://github.com/user-attachments/assets/382e768d-3533-4f66-8f7f-ac9ecabddeb7)
