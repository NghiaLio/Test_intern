# ♟️ SelectionSort sử dụng C + Flutter (FFI)

## 🧭 Mục tiêu

- Viết thuật toán **SelectionSort** bằng **ngôn ngữ C** để tận dụng hiệu năng cao.
- Dùng **FFI trong Dart/Flutter** để gọi hàm C và lấy dữ liệu về Flutter.
- Xây dựng **Animation** để mô phỏng quá trình săp xếp.

---

## 🧠 Ý tưởng tổng quan
- Mục tiêu: Tạo một ứng dụng Flutter hiển thị trực quan quá trình thực hiện thuật toán Selection Sort.

- Cách tiếp cận:

  - Viết thuật toán Selection Sort bằng ngôn ngữ C, với khả năng ghi lại từng bước hoán đổi.

  - Sử dụng FFI để gọi hàm C từ Dart.

  - Trong Flutter, hiển thị mảng và các bước hoán đổi dưới dạng animation.

---
## 🔧 Các bước thực hiện

### 1.⚙️Cài đặt FFI pluggin
Tương tự như `bai03` ta cài đặt FFI Pluggin cho project. Tham khảo [tại đây.](../bai03/README.md)

### 2. 🧑‍💻Viết thuật toán bằng C 
##### 2.1. File `bai04.h` 
```dart 
...
FFI_PLUGIN_EXPORT int32_t** get_sort_steps(int32_t* array, int32_t length, int32_t* step_count) ;

FFI_PLUGIN_EXPORT void free_steps(int32_t** steps, int32_t step_count) ;

```
##### 2.1. File `bai04.c` 
Sử dụng thuật toán SelectionSort,lưu từng bước sắp xếp vào một mảng.
```dart 
...
FI_PLUGIN_EXPORT int32_t** get_sort_steps(int32_t* array, int32_t length, int32_t* step_count){
    int32_t** steps = malloc(sizeof(int32_t*) * length);
    *step_count = 0;

    int32_t* arr = malloc(sizeof(int32_t) * length);
    memcpy(arr, array, sizeof(int32_t) * length);

    for (int i = 0; i < length - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < length; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        if (minIdx != i) {
            int temp = arr[i];
            arr[i] = arr[minIdx];
            arr[minIdx] = temp;
        }

        // Lưu snapshot
        steps[*step_count] = malloc(sizeof(int32_t) * length);
        memcpy(steps[*step_count], arr, sizeof(int32_t) * length);
        (*step_count)++;
    }

    // Snapshot cuối (mảng đã sắp xếp)
    steps[*step_count] = malloc(sizeof(int32_t) * length);
    memcpy(steps[*step_count], arr, sizeof(int32_t) * length);
    (*step_count)++;

    free(arr);
    return steps;
};

FFI_PLUGIN_EXPORT void free_steps(int32_t** steps, int32_t step_count){
    for (int i = 0; i < step_count; i++) {
        free(steps[i]);
    }
    free(steps);
};


```

### 3. Tích hợp với Dart (Flutter) 🛠️
- Tại `lib/bai04_bindings_generated.dart`:
    - Load thư viện và truy cập
    ``` dart
    typedef GetStepsNative = Pointer<Pointer<Int32>> Function(Pointer<Int32>, Int32, Pointer<Int32>);
    typedef GetStepsDart = Pointer<Pointer<Int32>> Function(Pointer<Int32>, int, Pointer<Int32>);

    typedef FreeStepsNative = Void Function(Pointer<Pointer<Int32>>, Int32);
    typedef FreeStepsDart = void Function(Pointer<Pointer<Int32>>, int);

    class Bai03Bindings {
        ...
        late final GetStepsDart getSteps = _lookup<NativeFunction<GetStepsNative>>('get_sort_steps').asFunction<GetStepsDart>();

        late final FreeStepsDart freeSteps = _lookup<NativeFunction<FreeStepsNative>>('free_steps').asFunction();
        ...
    }

    ```
    - Lấy dữ liệu và chuyển thành Dart List
    ```dart
    class Bai03Bindings {
        ...
        Future<List<List<int>>> getSortSteps(List<int> data) async {
          final ptr = calloc<Int32>(data.length);
          final stepCountPtr = calloc<Int32>();

          for (int i = 0; i < data.length; i++) {
            ptr[i] = data[i];
          }

          final result = getSteps(ptr, data.length, stepCountPtr);
          final stepCount = stepCountPtr.value;

          List<List<int>> steps = [];
          for (int i = 0; i < stepCount; i++) {
            final stepPtr = result.elementAt(i).value;
            steps.add(List.generate(data.length, (j) => stepPtr[j]));
          }

          freeSteps(result, stepCount);
          calloc.free(ptr);
          calloc.free(stepCountPtr);
          return steps;
        }
    }
    
    ```
- Tại `lib/bai04.dart` gọi hàm `native function` được trả về trong file `bai04_bindings_generated.dart`
```dart
... 
Future<List<List<int>>> getSortSteps(List<int> data) => _bindings.getSortSteps(data);
...
```
### 4. Xây dựng UI 📲
- Tạo một `List` danh sách các số nguyên.
 
##### 4.1. Tạo các cột tượng trưng cho các giá trị 
- Tạo các `Container()` với `height` là giá tri các số nguyên trong danh sách, mỗi `Container` sẽ có `key` tương ứng để phân biệt.
- Sử dụng `ListView.builder()` để tạo một danh sách các cột gần nhau.
- Mỗi cột bọc trong `AnimatedSwitcher` để tạo hiểu ứng chuyển đổi:
```dart
return AnimatedSwitcher(
  duration: const Duration(milliseconds: 500),
  transitionBuilder: (child, animation) => SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  ),
  child: _col(...,
      key: ValueKey(data[index])), //cột 
);
```
##### 4.2. Xây dựng hàm tạo hiệu ứng chuyển đổi
##### *🧠 Ý tưởng:*
- Đánh dấu cột `min` màu `blue`, cột đang xét màu `red`, cột sau khi đã sắp xếp màu `green`, màu ban đầu của tất cả các cột `grey`
- Đánh dấu cột đầu bằng màu `blue`.
- Khi kiểm tra các cột tiếp theo, cột đang xét sẽ là `red`, các cột đã qua sẽ trả về `grey`.
- Nếu gặp cột nhỏ hơn, cột đó thành `blue`, cột `blue` trước đó về `grey`.
- Sau cùng, cột nhỏ nhất được đưa lên đầu và đánh dấu màu `green`.

##### 🔄*Thực hiện:*
- Tạo một `List` chứa màu cho từng cột.
```dart
List<Color> colorOfColumns1 = List.generate( 15 /* chiều dài danh sách số nguyên*/, (index) => Colors.grey);
```
- Hàm `getSortSteps()` gọi từ C trả về một mảng gồm các bước sắp xếp `sortedData1`, mỗi bước sắp xếp là một mảng số nguyên.
- Vòng lặp ngoài: Duyệt qua từng bước sắp xếp trong `sortedData1`.
- Đánh dấu cột đang xét: Cột đầu tiên của mỗi bước được tô màu xanh dương `(blue)`.
- Vòng lặp trong: Duyệt qua các cột phía sau, mỗi cột đang xét sẽ được tô màu đỏ `(red)`. Nếu không phải là cột đầu tiên, cột trước đó sẽ trả về màu xám `(grey)`.
- Kiểm tra giá trị nhỏ nhất: Nếu phát hiện cột có giá trị nhỏ nhất mới (theo từng bước trong `sortedData1`), cột đó sẽ được tô màu xanh dương.
- Cập nhật lại màu: Sau khi kiểm tra xong, các cột sẽ trả về màu xám `(grey)`.
- Cập nhật dữ liệu: Sau mỗi bước, mảng dữ liệu data1 được cập nhật theo trạng thái mới từ `sortedData1`, cột đã đúng vị trí được tô màu xanh lá `(green)`.
- Kết thúc: Khi hoàn thành, tất cả các cột sẽ được tô màu xanh lá `(green)`.

```dart
void selectionSort() async {
    for (int i = 0; i < sortedData1.length; i++) {
      setState(() {
        colorOfColumns1[currentIndex1] = Colors.blue;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      for (int j = currentIndex1 + 1; j < data1.length; j++) {
        setState(() {
          colorOfColumns1[j] = Colors.red;
          if (j - 1 != currentIndex1) {
            colorOfColumns1[j - 1] = Colors.grey;
          }
        });
        await Future.delayed(const Duration(milliseconds: 150));
        if (data1[j] == sortedData1[i][currentIndex1]) {
          setState(() {
            colorOfColumns1[j] = Colors.blue;
            colorOfColumns1[currentIndex1] = Colors.grey;
          });
          await Future.delayed(const Duration(milliseconds: 150));
        }

        setState(() {
          colorOfColumns1[j] = Colors.grey;
        });

        await Future.delayed(const Duration(milliseconds: 150));
      }
      setState(() {
        data1 = sortedData1[i];
        colorOfColumns1[currentIndex1] = Colors.green;
        currentIndex1 = currentIndex1 + 1;
      });
    }
    setState(() {
      colorOfColumns1.map((toElement) => Colors.green).toList();
    });
  }
```

### 5. 🎬 Video minh họa

[https://github.com/user-attachments/assets/0dd0ce10-4167-49ed-8ff4-57bd838f3b9b](https://github.com/user-attachments/assets/8c920beb-3312-4f61-8790-0dd1fb0a4cc2)

---
## 🤔 Nhận xét cá nhân
Cách trên mô tả được phần nào thuật toán `SelectionSort` nhưng vẫn chưa mô tả đúng về từng bước:
  - ❌ Sau khi tìm được `minIndex` thì phải đánh dấu cột `minIndex` để so sánh. Cách mô tả trên chưa làm được điều đó.
  - 🔜 Vì đây là một thuật toán đơn giản nên thuật toán được viết trực tiếp bằng `Dart` thì việc xây dựng `Animation` sẽ dễ dàng, ngắn gọn hơn.

---
## 📚 Bài học rút ra
- Hiểu cách viết và sử dụng thuật toán Selection Sort trong C.

- Nắm vững cách sử dụng FFI để gọi hàm C từ Dart.

- Thực hành xây dựng giao diện Flutter để hiển thị animation thuật toán.
