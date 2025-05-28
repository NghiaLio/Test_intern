# ♛ Chessboard  App (Flutter)

Ứng dụng Flutter hiển thị bàn cờ vua 8x8, hiển thị các cách đặt tám quân **hậu (♛)** sao cho không có hai quân hậu nào chiếu lẫn nhau

---

## 🎯 Bài toán

**Mục tiêu:**  
Hãy vẽ một bàn cờ vua có kích thước 8 x 8 ô.
Hiển thị các cách đặt 8 quân hậuhậu.

---

## 🧠 Hướng giải quyết

### 1. Hiển thị bàn cờ 8x8
- Sử dụng `GridView.builder` để tạo bảng 8x8.
- Xen kẽ ô trắng và đen bằng công thức: `(row + col) % 2 == 0`.

### 2. Sử dụng thuật toán 8 quân hậu để lấy ra vị trí các hàng, cột
- Thuật toán 8 quân hậu (viết bằng Dart).
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
- Lưu các giá trị cột , hàng vào một mảng

### 3. Sử dụng PageView để render các cách lên màn hình
## 🖼️ Demo

![Image](https://github.com/user-attachments/assets/1a6e31c6-2670-4bb9-b75d-61dbf6d101aa)
![Image](https://github.com/user-attachments/assets/392c023c-e267-4094-ac65-129dbe210351)






