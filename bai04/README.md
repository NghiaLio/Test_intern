## 🎯 Bài toán

**Mục tiêu:**  
Sử dụng thuật toán Selection Sort để sắp xếp
Viết thuật toán bằng C và mô phỏng thuật toán bằng Flutter 

---

## 🧠 Hướng giải quyết

### 1. Viết thuật toán bằng C.
- Viết thuật toán SelectionSort với kết quả trả về là một mảng 2 chiều chứa các snapshot từng bước sắp xếp.
- Promt hỏi AI:
  > Viết hàm selectionSort bằng C với kết quả đầu ra là một mảng 2 chiều chứa từng bước sắp xếp

### 2. Sử dụng FFI_PLUGINS_EXPORT để chuyển dữ liệu sang Dart
- Gọi FFI , lấy danh sách các bước dưới dạng `List<List<intint>>`
- Promt AI đã hỏi:
  > Kết hợp C code gọi từ FFI, nhận dữ liệu các bước rồi mô phỏng.
### 3. Mô phỏng bằng Flutter

  ##### 3.1. Tạo các cột mô phỏng giá trị
    Tạo mảng có giá trị là chiều cao của các Container()
  ##### 3.2. Tạo animation mô phỏng quá trình swap
  Với giá trị trả về từ hàm C là 1 mảng gồm các mảng đã đổi vị trí.Ví dụ:
  > Hàm truyền sang là : `[50,20,100,60,80]`
    Hàm nhận về sẽ là : `[
      [20,50,100,60,80], 
      [20,50,60,100,80], 
      [20,50,60,80,100], 
    ]`

  Ta quy định: `blue` đánh dấu cột nhỏ nhất, `red` đánh dấu cột đang xét, `green` là cột đã được sắp xếp
  
  - Đầu tiên tô cột đầu (tương ứng giá trị đầu của mảng) màu `blue`
  - Lần lượt đổi màu các cột còn lại sang `red` (tương ứng với xét các giá trị còn lại)
  - Gặp cột nhỏ hơn thì đổi màu cột đầu về mặc định và tô cột nhỏ hơn đó màu `blue`
  - Sử dụng `AnimatedSwitcher` để tạo hoạt ảnh chuyển đổi giữa 2 cột
  - Lặp lại các bước trên với cột tiếp theo sau cột đầu....
## 🖼️ Demo

