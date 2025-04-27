import 'package:flutter/material.dart';

// Đây là một widget Stateless cơ bản để chứa biểu đồ Tứ Trụ
class TuTruChartWidget extends StatelessWidget {
  // Dữ liệu mẫu cho biểu đồ (bạn sẽ cần một cấu trúc dữ liệu chi tiết hơn)
  final Map<String, dynamic> chartData = {
    'gio': {
      'label': 'GIỜ',
      'topValue': '23:00',
      'subLabel': 'Thiên Ấn',
      'mainStem': 'MẬU',
      'mainBranch': 'TÝ',
      'hiddenStems': ['QUÝ'],
      'tenGods': ['T.Quan'],
      'bottomLabels': ['Dương', 'Tích Lịch Hỏa'],
    },
    'ngay': {
      'label': 'NGÀY',
      'topValue': '19',
      'subLabel': 'NHẬT CHỦ',
      'mainStem': 'CANH',
      'mainBranch': 'THÌN',
      'branchComment':
          'Khố Thực Thương', // Ví dụ cho chú thích nhỏ dưới Địa Chi
      'hiddenStems': ['QUÝ', 'MẬU', 'ẤT'],
      'tenGods': ['T.Quan', 'T.Ấn', 'C.Tài'],
      'bottomLabels': ['Dương', 'Bạch Lạp Kim'],
    },
    'thang': {
      'label': 'THÁNG',
      'topValue': '04',
      'subLabel': 'Tỵ Kiên',
      'mainStem': 'CANH',
      'mainBranch': 'THÌN',
      'branchComment': 'Khố Thực Thương',
      'hiddenStems': ['QUÝ', 'MẬU', 'Ất'], // Có thể trùng với Ngày trong ảnh
      'tenGods': ['T.Quan', 'T.Ấn', 'C.Tài'], // Có thể trùng với Ngày trong ảnh
      'bottomLabels': ['Dương', 'Bạch Lạp Kim'],
    },
    'nam': {
      'label': 'NĂM',
      'topValue': '1995',
      'subLabel': 'Chính Tài',
      'mainStem': 'ẤT',
      'mainBranch': 'HỢI',
      'branchComment': 'Nhập Mộ', // Ví dụ
      'hiddenStems': ['NHÂM'], // Có thể chỉ có 1 hoặc nhiều
      'tenGods': ['T.Thần'], // Có thể chỉ có 1 hoặc nhiều
      'bottomLabels': ['Suy', 'Mộ', 'Sơn Đầu Hỏa'], // Có thể nhiều dòng
    },
  };

  // Hàm helper để vẽ một cột (trụ) của biểu đồ
  Widget _buildPillarColumn(
    BuildContext context,
    String pillarKey,
    Map<String, dynamic> data,
  ) {
    // Các giá trị mặc định nếu dữ liệu không có
    final label = data['label'] ?? '';
    final topValue = data['topValue'] ?? '';
    final subLabel = data['subLabel'] ?? '';
    final mainStem = data['mainStem'] ?? '';
    final mainBranch = data['mainBranch'] ?? '';
    final branchComment = data['branchComment'] ?? '';
    final hiddenStems = (data['hiddenStems'] as List<String>?) ?? [];
    final tenGods = (data['tenGods'] as List<String>?) ?? [];
    final bottomLabels = (data['bottomLabels'] as List<String>?) ?? [];

    // Màu nền ví dụ (bạn sẽ cần tùy chỉnh dựa trên ảnh)
    Color headerColor = Colors.amber.shade200;
    Color mainPillarColor = Colors.amber.shade100;
    Color hiddenTenGodColor = Colors.white;
    Color bottomColor = Colors.grey.shade200;

    // Độ dày đường viền
    BorderSide border = BorderSide(color: Colors.grey.shade400, width: 0.5);

    // TextStyle ví dụ
    TextStyle labelStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    TextStyle topValueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    TextStyle subLabelStyle = TextStyle(fontSize: 10);
    TextStyle mainStemBranchStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
    TextStyle commentStyle = TextStyle(
      fontSize: 9,
      fontStyle: FontStyle.italic,
    );
    TextStyle hiddenTenGodStyle = TextStyle(fontSize: 10);
    TextStyle bottomLabelStyle = TextStyle(fontSize: 10);

    // Helper để vẽ một ô/hàng có viền
    Widget buildCell({
      Widget? child,
      Color? color,
      EdgeInsetsGeometry? padding,
      double? height,
      BorderSide? bottomBorder,
      BorderSide? rightBorder,
    }) {
      return Container(
        height: height,
        padding: padding ?? EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          border: Border(
            bottom: bottomBorder ?? BorderSide.none,
            right: rightBorder ?? BorderSide.none,
          ),
        ),
        alignment: Alignment.center,
        child: child,
      );
    }

    return Expanded(
      // Expanded để mỗi cột chiếm không gian đều nhau
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Kéo giãn theo chiều ngang
        children: [
          // Hàng label (GIỜ, NGÀY, THÁNG, NĂM) - Phần mũi tên phía trên phức tạp hơn, tạm dùng Container
          buildCell(
            child: Text(label, style: labelStyle),
            color: headerColor,
            height: 30,
            bottomBorder: border,
            // rightBorder: border, // Viền phải có thể được đặt ở Container bao ngoài Row
          ),

          // Hàng giá trị trên cùng (23:00, 19, 04, 1995)
          buildCell(
            child: Text(topValue, style: topValueStyle),
            color: headerColor,
            height: 30,
            bottomBorder: border,
            // rightBorder: border,
          ),

          // Hàng sub-label (Thiên Ấn, NHẬT CHỦ, ...)
          buildCell(
            child: Text(subLabel, style: subLabelStyle),
            color: mainPillarColor,
            height: 25,
            bottomBorder: border,
            // rightBorder: border,
          ),

          // Hàng Thiên Can và Địa Chi chính
          Expanded(
            // Sử dụng Expanded để phần này chiếm không gian còn lại
            child: buildCell(
              color: mainPillarColor,
              bottomBorder: border,
              // rightBorder: border,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Canh giữa theo chiều dọc
                children: [
                  Text(mainStem, style: mainStemBranchStyle),
                  Text(mainBranch, style: mainStemBranchStyle),
                  if (branchComment.isNotEmpty) // Hiển thị chú thích nếu có
                    Text(branchComment, style: commentStyle),
                  // Có thể thêm biểu tượng não ở đây nếu cần, dùng Stack hoặc Row
                ],
              ),
            ),
          ),

          // Hàng Thiên Can Tàng và Thập Thần (chia thành nhiều ô nhỏ theo chiều ngang)
          // Số lượng ô nhỏ có thể khác nhau giữa các trụ, nên ta tạo hàng riêng
          // Hàng Thiên Can Tàng
          buildCell(
            color: hiddenTenGodColor,
            height: 25, // Chiều cao cố định cho hàng này
            bottomBorder: border,
            // rightBorder: border,
            padding:
                EdgeInsets
                    .zero, // Đặt padding.zero để các Row con tự quản lý padding
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch, // Kéo giãn các ô con theo chiều dọc
              children:
                  hiddenStems
                      .map(
                        (stem) => Expanded(
                          child: Container(
                            // Mỗi Thiên Can Tàng là một Container
                            decoration: BoxDecoration(
                              border: Border(
                                right: border,
                              ), // Viền phải giữa các ô tàng
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(2.0),
                            child: Text(stem, style: hiddenTenGodStyle),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Hàng Thập Thần
          buildCell(
            color: hiddenTenGodColor,
            height: 25, // Chiều cao cố định cho hàng này
            bottomBorder: border,
            // rightBorder: border,
            padding: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  tenGods
                      .map(
                        (god) => Expanded(
                          child: Container(
                            // Mỗi Thập Thần là một Container
                            decoration: BoxDecoration(
                              border: Border(
                                right: border,
                              ), // Viền phải giữa các ô thập thần
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(2.0),
                            child: Text(god, style: hiddenTenGodStyle),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Các hàng trống hoặc chứa thông tin khác (Lộc, Tuyệt, Mộ,...)
          // Bạn sẽ cần thêm các hàng này tùy thuộc vào dữ liệu và thiết kế.
          // Ví dụ: hàng cho "Lộc" (chỉ có ở trụ Tháng trong ảnh)
          if (pillarKey == 'thang') // Chỉ vẽ ô Lộc cho trụ Tháng
            buildCell(
              color: hiddenTenGodColor,
              height: 25,
              bottomBorder: border,
              // rightBorder: border,
              child: Text(
                'Lộc',
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
            ),
          // Ví dụ: một hàng trống
          buildCell(
            color: hiddenTenGodColor,
            height: 25,
            bottomBorder: border,
            // rightBorder: border,
            child: Container(), // Ô trống
          ),

          // Hàng cuối cùng (Dương, Tích Lịch Hỏa, Suy, Mộ, ...)
          buildCell(
            color: bottomColor,
            height: 40, // Chiều cao có thể lớn hơn
            // bottomBorder: border, // Viền cuối cùng
            // rightBorder: border,
            padding: EdgeInsets.zero,
            child: Column(
              // Sử dụng Column vì có thể có nhiều dòng ở đây
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  bottomLabels
                      .map(
                        (bLabel) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1.0,
                            horizontal: 4.0,
                          ),
                          child: Text(bLabel, style: bottomLabelStyle),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0), // Khoảng lề xung quanh biểu đồ
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0.5,
        ), // Viền bao quanh toàn bộ biểu đồ
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Kéo giãn các cột theo chiều dọc
        children: [
          _buildPillarColumn(context, 'gio', chartData['gio']!), // Trụ Giờ
          _buildPillarColumn(context, 'ngay', chartData['ngay']!), // Trụ Ngày
          _buildPillarColumn(
            context,
            'thang',
            chartData['thang']!,
          ), // Trụ Tháng
          _buildPillarColumn(context, 'nam', chartData['nam']!), // Trụ Năm
        ],
      ),
    );
  }
}

// Cách sử dụng trong ứng dụng của bạn:
// Trong widget build() của một màn hình Scaffold:
// body: Center(
//   child: TuTruChartWidget(), // Gọi widget biểu đồ
// ),
