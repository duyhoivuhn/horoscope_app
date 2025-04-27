import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horoscope_app/styles.dart';

class PickerUtil {
  // --- Cập nhật hàm _selectDate ---
  static Future<void> selectDate({
    required BuildContext context,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) async {
    // Giá trị tạm thời để lưu lựa chọn trong picker
    DateTime tempPickedDate =
        selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 18));

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250, // Chiều cao của modal
          // Sử dụng màu nền hệ thống của Cupertino
          color: Colors.white,
          child: Column(
            children: [
              // Thanh chứa nút "Xong"
              Container(
                color: CupertinoColors.secondarySystemBackground.resolveFrom(
                  context,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Xong',
                        style: AppStyle.t20B.apply(color: Colors.black45),
                      ),
                      onPressed: () {
                        // Cập nhật ngày đã chọn khi nhấn "Xong"
                        onDateSelected(tempPickedDate);
                        Navigator.of(context).pop(); // Đóng modal
                      },
                    ),
                  ],
                ),
              ),
              // Phần DatePicker
              Expanded(
                child: CupertinoDatePicker(
                  backgroundColor: Colors.white12,
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempPickedDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  // Cập nhật giá trị tạm thời khi người dùng cuộn
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    // Không cần setState ở đây nữa vì đã xử lý trong nút "Xong"
  }

  // --- Hàm mới để chọn giờ, phút, giây ---
  static Future<void> selectTime({
    required BuildContext context,
    int? initialHour,
    int? initialMinute,
    int? initialSecond,
    // Callback trả về giờ, phút, giây riêng lẻ
    required Function(int hour, int minute, int second) onTimeSelected,
  }) async {
    // Lấy giờ hiện tại làm giá trị mặc định nếu không có initial value
    final now = DateTime.now();
    int tempHour = initialHour ?? now.hour;
    int tempMinute = initialMinute ?? now.minute;
    int tempSecond = initialSecond ?? now.second;

    // Controller để đặt giá trị ban đầu
    final FixedExtentScrollController hourController =
        FixedExtentScrollController(initialItem: tempHour);
    final FixedExtentScrollController minuteController =
        FixedExtentScrollController(initialItem: tempMinute);
    final FixedExtentScrollController secondController =
        FixedExtentScrollController(initialItem: tempSecond);

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280, // Tăng chiều cao một chút
          color:
              Colors
                  .white, // Hoặc CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              // Thanh nút "Xong"
              Container(
                color: CupertinoColors.secondarySystemBackground.resolveFrom(
                  context,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Xong',
                        style: AppStyle.t20B.apply(color: Colors.black45),
                      ),
                      onPressed: () {
                        // Gọi callback với giá trị tạm thời đã chọn
                        onTimeSelected(tempHour, tempMinute, tempSecond);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Phần Picker giờ, phút, giây
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Giờ (0-23) ---
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: hourController,
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          tempHour = index;
                        },
                        // Tạo danh sách 24 giờ (00-23)
                        children: List<Widget>.generate(24, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 20,
                              ), // Điều chỉnh cỡ chữ nếu cần
                            ),
                          );
                        }),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4.0), // Căn chỉnh dấu :
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // --- Phút (0-59) ---
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: minuteController,
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          tempMinute = index;
                        },
                        // Tạo danh sách 60 phút (00-59)
                        children: List<Widget>.generate(60, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // --- Giây (0-59) ---
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: secondController,
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          tempSecond = index;
                        },
                        // Tạo danh sách 60 giây (00-59)
                        children: List<Widget>.generate(60, (int index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
