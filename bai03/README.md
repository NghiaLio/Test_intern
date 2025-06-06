# ♟️ 8 Quân Hậu sử dụng C + Flutter (FFI)

## 🧭 Mục tiêu

- Viết thuật toán tìm **tất cả lời giải bài toán 8 quân hậu** bằng **ngôn ngữ C** để tận dụng hiệu năng cao.
- Dùng **FFI trong Dart/Flutter** để gọi hàm C và lấy dữ liệu về Flutter.
- Hiển thị các lời giải lên bàn cờ 8x8, và **hỗ trợ vuốt trái/phải để xem từng lời giải**.

---

## 🔧 Các bước thực hiện

### 1. Cài đặt FFI pluggin
Chạy lệnh sau trong thư mục đang hoạt động để tạo dự án bằng mẫu trình bổ trợ:
> flutter create --template=plugin_ffi  --platforms=android,ios,linux,macos,windows ffigen_app

Tham số --platforms chỉ định những nền tảng mà trình bổ trợ của bạn sẽ hỗ trợ.
Bạn có thể kiểm tra bố cục của dự án đã tạo bằng lệnh tree hoặc trình khám phá tệp của hệ điều hành.
```
$ tree -L 2 ffigen_app
ffigen_app
├── CHANGELOG.md
├── LICENSE
├── README.md
├── analysis_options.yaml
├── android
│   ├── build.gradle
│   ├── ffigen_app_android.iml
│   ├── local.properties
│   ├── settings.gradle
│   └── src
├── example
│   ├── README.md
│   ├── analysis_options.yaml
│   ├── android
│   ├── ffigen_app_example.iml
│   ├── ios
│   ├── lib
│   ├── linux
│   ├── macos
│   ├── pubspec.lock
│   ├── pubspec.yaml
│   └── windows
├── ffigen.yaml
├── ffigen_app.iml
├── ios
│   ├── Classes
│   └── ffigen_app.podspec
├── lib
│   ├── ffigen_app.dart
│   └── ffigen_app_bindings_generated.dart
├── linux
│   └── CMakeLists.txt
├── macos
│   ├── Classes
│   └── ffigen_app.podspec
├── pubspec.lock
├── pubspec.yaml
├── src
│   ├── CMakeLists.txt
│   ├── ffigen_app.c
│   └── ffigen_app.h
└── windows
    └── CMakeLists.txt

17 directories, 26 files
```

Để đảm bảo hệ thống xây dựng và các điều kiện tiên quyết được cài đặt chính xác và hoạt động trên từng nền tảng được hỗ trợ, hãy tạo và chạy ứng dụng mẫu đã tạo cho từng mục tiêu:
- Tại thư mục chủ vừa tạo `ffigen_app` di chuyển tới thư mục `example` bằng lệnh `cd exmaple`
- Tại `example` chạy lệnh `flutter run`
- Bạn sẽ thấy một cửa sổ ứng dụng đang chạy như sau:
    ![Image](https://github.com/user-attachments/assets/945cb2fb-3394-4217-9083-acdf482c076e)

---

### 2. Viết thuật toán bằng C

Tạo hai file mới `extends.c` và `extends.h` trong thư mục `src` (hoặc bạn có thể sử dụng file có sẵn)

Thêm file `.c` vào `CMakeLists.txt` 
```c
add_library(bai03 SHARED
  ...
  "extends.c"
)
```

##### 2.1. File `extends.h` 
- Khai báo `struct Position` để lưu trữ vị trí hàng,cột.
- Sử dụng `FFI_PLUGIN_EXPORT` để `export` struct này sang file `.c`
```c
...

typedef struct {
    int row;
    int col;
} Position;


...

FFI_PLUGIN_EXPORT Position* get_solutions(int* out_count);

```

##### 2.2. File `extends.c` 
- Sử dụng backtracking để tìm tất cả các lời giải
- Mỗi lời giải là một mảng gồm 8 số nguyên (cột đặt quân hậu ở mỗi hàng)
- Kết quả được lưu vào bộ nhớ cấp phát động

```c
#include "extends.h"
...

/// Mảng global flatten: allSolutions_flatten[i * N + j]
static Position* allSolutions_flatten = NULL;
static int solutionCount = 0;
static int X[N + 1];
static bool colUsed[N + 1], diag1[2 * N], diag2[2 * N];
static void solve(int i) {
    if (i == N + 1) {
        if (solutionCount >= MAX_SOLUTIONS) return;
        // Lưu nghiệm thứ solutionCount vào vị trí (solutionCount * N) … (solutionCount * N + N-1)
        for (int k = 1; k <= N; k++) {
            allSolutions_flatten[solutionCount * N + (k - 1)].row = k;
            allSolutions_flatten[solutionCount * N + (k - 1)].col = X[k];
        }
        solutionCount++;
        return;
    }
    for (int j = 1; j <= N; j++) {
        int d1 = i - j + N;   // k1
        int d2 = i + j - 2;   // k2
        if (!colUsed[j] && !diag1[d1] && !diag2[d2]) {
            X[i] = j;
            colUsed[j] = diag1[d1] = diag2[d2] = true;
            solve(i + 1);
            colUsed[j] = diag1[d1] = diag2[d2] = false;
        }
    }
}
FFI_PLUGIN_EXPORT Position* get_solutions(int* out_count) {
    // Nếu chưa allocate thì cấp phát size = MAX_SOLUTIONS * N
    if (allSolutions_flatten == NULL) {
        allSolutions_flatten = (Position*)malloc(sizeof(Position) * MAX_SOLUTIONS * N);
    }
    solutionCount = 0;
    // Khởi các mảng đánh dấu
    for (int j = 1; j <= N; j++) colUsed[j] = false;
    for (int t = 0; t < 2 * N; t++) {
        diag1[t] = false;
        diag2[t] = false;
    }
    // Chạy giải
    solve(1);
    // Trả về con trỏ + số nghiệm
    *out_count = solutionCount;
    return allSolutions_flatten;
}
```


### 3. Tích hợp với Dart (Flutter)
- Tại `lib/bai03_bindings_generated.dart`:
    - Tạo `class Position` tương ứng với `Struct` trong C.
    ```dart
    final class Position extends Struct {
    @Int32()
    external int row;

    @Int32()
    external int col;
    }
    ```
    - Load thư viện và truy cập
    ``` dart
    typedef C_GetSolutions = Pointer<Position> Function(Pointer<Int32>);
    typedef Dart_GetSolutions = Pointer<Position> Function(Pointer<Int32>);

    class Bai03Bindings {
        ...
        late final _getSolutionsPtr =_lookup<ffi.NativeFunction<C_GetSolutions>>('get_solutions');
        late final _getSolutions = _getSolutionsPtr.asFunction<Dart_GetSolutions>();
        ...
    }

    ```
    - Lấy dữ liệu và chuyển thành Dart List
    ```dart
    class Bai03Bindings {
        ...
       // Trả về một list các nghiệm. Mỗi nghiệm là List<Position> độ dài 8.
        List<List<Position>> getAllSolutions() {
            final countPtr = calloc<Int32>();
            final ptr = _getSolutions(countPtr);
            final count = countPtr.value;
            calloc.free(countPtr);

            List<List<Position>> results = [];

            for (var solIndex = 0; solIndex < count; solIndex++) {
            List<Position> oneSolution = [];
            for (var j = 0; j < 8; j++) {
                final posPtr = ptr.elementAt(solIndex * 8 + j);
                oneSolution.add(posPtr.ref);
            }
            results.add(oneSolution);
            }
            return results;
        }
    }
    
    ```
- Tại `lib/bai03.dart` gọi hàm `native function` được trả về trong file `bai03_bindings_generated.dart`
```dart
... 
List<List<Position>> getAllSolutions() => _bindings.getAllSolutions();
...
```

### 4. Xây dựng UI
Di chuyển tới thư mục `./example/lib/` để viết các file xây dựng giao diện
- Tạo giao diện bàn cờ như `bai02`. Tham khảo [tại đây.](../bai02/lib/)
- Dữ liệu lời giải lúc nào được trả về từ hàm `getAllSolutions()`
```dart 
late List<List<Position>> allSolutions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allSolutions = bai03.getAllSolutions();
  }
```
## 🖼️ Demo
![Image](https://github.com/user-attachments/assets/18de6ef4-0074-4f46-8bc6-d3d47ee9cf4b)

---
## 💬 Prompt AI đã dùng
> Viết hàm bằng ngôn ngữ C để giải bài toán 8 quân hậu, trả về danh sách tất cả lời giải dưới dạng mảng các mảng 8 phần tử.

> Trong Flutter, sử dụng FFI để gọi hàm từ thư viện C và lấy dữ liệu lời giải.

## ❤️ Phần tâm đắc
- Tận dụng được hiệu năng của ngôn ngữ C cho phần thuật toán.
- Học được cách kết nối native C code với Flutter bằng FFI Pluggin.
- Rõ ràng việc tách biệt tính toán và hiển thị giúp ứng dụng sạch hơn, tối ưu hơn.

---
## 📚 Bài học rút ra

- Hiểu cách dùng dart:ffi để gọi hàm C, xử lý con trỏ và bộ nhớ.
- Nắm chắc mô hình phân tầng giữa native code và UI code.

## 📂 Cấu trúc thư mục chính

```css
bai03/
├── src/
│   ├── bai03.c         ← Code native viết bằng C (vd: sort, 8 queens...)
│   ├── bai03.h         ← Khai báo các hàm cần expose sang Dart
│   └── CMakeLists.txt       ← Build C lib trên macOS/Linux/Windows
├── lib/
│   ├── bai03.dart                     ← API public gọi từ Flutter
│   └── bai03_bindings_generated.dart  ← Tự động sinh từ ffigen.yaml
├── example/
│   └── lib/main.dart         ← App Flutter demo sử dụng plugin

```