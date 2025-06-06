
# 🧪 ♛ Chessboard  App (Flutter)

## 🧭 Mục tiêu
- Hiểu thuật toán quay lui (*Backtracking*).
- Áp dụng được thuật toán vào bài toán cụ thể.
- Hiển thị các cách giải trên bàn cờ.
---

## 🔧 Các bước thực hiện

1. **Phân tích yêu cầu**: 
   - Viết thuật toán bằng Dart để tìm các lời giải.
   - Tạo hàm hứng sự kiện người dùng quệt trái và phải để di chuyển giữa các lời giải.

2. **Cách làm**:  
    2.1. **Viết thuật toán bằng Dart**:
    - Thuật toán:
        ```
        List<int> X = List.filled(9, 0); // Chỉ số từ 1..8

        List<int> col = List.filled(9, 1);  // col[1]..col[8]
        List<int> d1  = List.filled(17, 1); // d1[i - j + 8] ∈ 0..16
        List<int> d2  = List.filled(17, 1); // d2[i + j - 2] ∈ 0..16

        void inKQ() {
            for (int i = 1; i <= 8; i++) {
                print('$i -> ${X[i]}');
            }
            print('\n');
        }

        void Try(int i) {
            for (int j = 1; j <= 8; j++) {
                int d1Index = i - j + 8;
                int d2Index = i + j - 2;

                if (col[j] == 1 && d1[i - j + 8] == 1 && d2[i + j- 2] == 1) { 
                X[i] = j;
                col[j] = d1[i - j + 8] = d2[i + j - 2] = 0;
                if (i == 8) {
                    inKQ();
                } else {
                    Try(i + 1);
                }
                // backtrack
                col[j] = d1[i - j + 8] = d2[i + j - 2] = 1;
                }
            }
        }

        void main() {
            Try(1);
        }

        ```
    - Sử dụng một `List<List<Map<String, int>>> result` để lưu các lời giải.
    - Tạo một hàm `void queensPiece()` để thêm vị trí các hàng, cột vào `result` thay cho hàm `inKQ()` ở thuật toán trên. 
    ```
    void queensPiece() {
        final List<Map<String, int>> queens = [];
        for (int i = 1; i <= 8; i++) {
            queens.add({'row': i, 'col': X[i]});
        }
        results.add(queens);
    }
    ```
    2.2. **Tạo bàn cờ và các ô vuông**:
    - Sử dụng `GridView.builder` để tạo ra một bàn cờ với 64 ô (8x8) .
    - Vị trí hàng `row = index ~/ 8` , vị trí cột `col = index % 8`.
    - Để các ô liền kề có màu khác nhau ta sử dụng biến kiểm tra `bool isWhite = (row + col) % 2 == 0`. Nếu `true` thì ô vuông có màu trắng, `false` thì ô vuông có màu đen.

    2.3. **Hiển thị các vị trí quân hậu**:
    - Tại mỗi ô vuông sử dụng biến `bool isQueen(int row, int col)` để kiểm tra xem có hiển thị quân hậu tại ô này hay không.
    ```
    bool isQueen(int row, int col) {
        // kiểm tra xem vị trí hàng, cột có ở trong danh sách trả về ở result
        return widget.queensPiece
            .any((piece) => piece['row'] == row && piece['col'] == col);
    }
    ```
    2.4. **Hiển thị các cách giải**:
    - Sử dụng `PageView.builder()` để hiển thị các cách giải lên màn hình. Mỗi màn hình là một cách giải.  
3. **Kết quả**
   - 8 Quân hậu được hiển thị trên bàn cờ đảm bảo yêu cầu đề bài.
   - Người dùng có thể vuốt qua phải hoặc trái để xem các cách giải.
4. **Kiểm thử và demo**
   - Test thủ công: Tại `terminal` di chuyển đến thư mục `bai02` và chạy lệnh `flutter run --yourdevice` hoặc mở file `main.dart` và chọn `run and debug`

---

## 🖼 Demo

https://github.com/user-attachments/assets/0b2d6504-c653-4f24-a78c-aa87eb7de107

---
## 💬 Prompt có thể tham khảo

> "Viết thuật toán giải bài 8 quân hậu bằng Dart, trả về danh sách tất cả các lời giải dưới dạng danh sách các vị trí quân hậu trên mỗi hàng."

> "Trong Flutter, thêm PageView để chuyển qua lại các lời giải khi người dùng quẹt trái hoặc phải."


## ❤️ Phần tâm đắc

- Biết áp dụng thuật toán vào một bài toán cụ thể
- Việc cài đặt backtracking rất gọn gàng và dễ đọc.
---

## 📚 Bài học rút ra

- Kỹ năng cài thuật toán backtracking trong Dart.
- Cách tổ chức dữ liệu sao cho dễ binding với UI.
- Quen tay hơn với xử lý gestures trong Flutter (`GestureDetector`, `PageView`, v.v.)

---
## 📂 Cấu trúc thư mục
bai02/
├── lib/
│ ├── main.dart # App chính
│ ├── home.dart # Giải thuật 8 quân hậu và hiển thị các cách giải
│ ├── chessBoard.dart # Xây dựng bàn cờ và quân hậu
│ └── square.dart # Tạo ô vuông
├── assets/
│ └── icon # Icon quân hậu
└── README.md



