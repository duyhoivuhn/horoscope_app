import 'package:flutter/material.dart';
import 'package:horoscope_app/lunar/calendar/util/AppUtil.dart'; // Cần import material

class DaiVanTable extends StatefulWidget {
  // Thêm tham số để nhận năm bắt đầu Đại Vận từ bên ngoài
  final int startDaiVanYear;

  const DaiVanTable({
    super.key,
    required this.startDaiVanYear, // Bắt buộc phải cung cấp năm bắt đầu
  });

  @override
  State<DaiVanTable> createState() => _DaiVanTableState();
}

class _DaiVanTableState extends State<DaiVanTable> {
  // Biến state để lưu trữ năm Đại Vận đang được chọn
  int? _selectedDaiVanYear;

  // Danh sách các năm để hiển thị trong dropdown
  List<int> _daiVanYearsList = [];

  DateTime solarDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị được chọn ban đầu là năm bắt đầu
    _selectedDaiVanYear = widget.startDaiVanYear;
    solarDate = DateTime(_selectedDaiVanYear ?? 1995, 1, 1);
    // Tạo danh sách các năm Đại Vận
    _generateDaiVanYears();

    setState(() {});
  }

  // Hàm tạo danh sách các năm Đại Vận
  void _generateDaiVanYears() {
    _daiVanYearsList = []; // Xóa danh sách cũ (nếu có)
    // Tính năm tối đa (bắt đầu + 100), nhưng đảm bảo không vượt quá giới hạn hợp lý (ví dụ 120 tuổi)
    // Hoặc đơn giản là lặp 10 lần (cho 10 chu kỳ 10 năm)
    final int maxYear =
        widget.startDaiVanYear +
        90; // 10 chu kỳ * 10 năm = 100 năm, nên max là start + 90

    for (int year = widget.startDaiVanYear; year <= maxYear; year += 10) {
      // Chỉ thêm nếu năm hợp lệ (ví dụ: lớn hơn 0)
      if (year > 0) {
        _daiVanYearsList.add(year);
      }
    }

    // Đảm bảo giá trị được chọn ban đầu có trong danh sách
    // (Trường hợp startDaiVanYear <= 0 hoặc có lỗi logic khác)
    if (!_daiVanYearsList.contains(_selectedDaiVanYear)) {
      _selectedDaiVanYear =
          _daiVanYearsList.isNotEmpty ? _daiVanYearsList.first : null;
    }
  }

  // Hàm này có thể được gọi từ widget cha nếu năm bắt đầu thay đổi
  // Ví dụ: khi người dùng chọn ngày sinh khác
  void updateStartYear(int newStartYear) {
    setState(() {
      _selectedDaiVanYear = newStartYear;

      _generateDaiVanYears();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng Padding để tạo khoảng cách xung quanh dropdown
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chọn Đại Vận:', // Thêm nhãn cho dropdown
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ), // Kiểu chữ cho nhãn
              ),
              SizedBox(height: 8), // Khoảng cách giữa nhãn và dropdown
              // Container để tùy chỉnh giao diện dropdown (viền, nền) nếu muốn
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.9,
                  ), // Nền trắng hơi trong suốt
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ), // Viền xám nhạt
                ),
                child: DropdownButtonHideUnderline(
                  // Ẩn đường gạch chân mặc định
                  child: DropdownButton<int>(
                    value: _selectedDaiVanYear, // Giá trị đang được chọn
                    isExpanded:
                        true, // Cho phép dropdown mở rộng hết chiều ngang
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black54,
                    ), // Icon mũi tên
                    // Danh sách các mục trong dropdown
                    items:
                        _daiVanYearsList.map((int year) {
                          return DropdownMenuItem<int>(
                            value: year, // Giá trị của mục này
                            child: Text(
                              'Đại Vận $year tuổi', // Text hiển thị cho người dùng
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(), // Chuyển map thành List
                    // Hàm được gọi khi người dùng chọn một mục mới
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        solarDate = DateTime(newValue, 1, 1);
                        setState(() {
                          _selectedDaiVanYear = newValue;
                          // Tại đây, bạn có thể gọi một hàm callback để thông báo
                          // cho widget cha về sự thay đổi năm Đại Vận được chọn
                          // ví dụ: widget.onDaiVanSelected(newValue);
                        });
                      }
                    },
                    // Có thể thêm hint nếu _selectedDaiVanYear có thể là null ban đầu
                    // hint: Text('Chọn năm'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildListContent(),
        ],
      ),
    );
  }

  _buildListContent() {
    return Column(
      children: [
        _buildItem(
          title: 'Xuất Can',
          value: AppUtil(solarDateTime: solarDate).getThapThanNam(),
        ),
        _buildItem(
          title: 'Thiên Can',
          value: AppUtil(solarDateTime: solarDate).getThienCanNam(),
        ),
        _buildItem(
          title: 'Địa chi',
          value: AppUtil(solarDateTime: solarDate).getDiaChiNam(),
        ),
        _buildItem(
          title: 'Tàng Can',
          value: AppUtil(solarDateTime: solarDate).getTangCanNam(),
        ),
        _buildItem(
          title: 'Trường Sinh',
          value: AppUtil(solarDateTime: solarDate).getTruongSinhNam(),
        ),
        _buildItem(
          title: 'Nạp Âm',
          value: AppUtil(solarDateTime: solarDate).getNapAmNam(),
        ),
      ],
    );
  }

  _buildItem({required String title, required String value}) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            border: Border.all(color: Colors.black),
          ),
          child: Center(child: Text(title)),
        ),
        tb(value: value),
      ],
    );
  }

  Widget tb({
    Color? bg,
    required String value,
    TextStyle? style,
    double? height,
  }) {
    return Expanded(
      child: Container(
        height: height ?? 50,
        decoration: BoxDecoration(
          color: bg ?? Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(value, style: style, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
