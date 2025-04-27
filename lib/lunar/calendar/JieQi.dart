import 'Solar.dart';

/// 节气
/// @author 6tail
class JieQi {
  /// 24 Tiết Khí (Solar Terms)
  static List<String> JIE_QI = [
    'Đông Chí', // 冬至
    'Tiểu Hàn', // 小寒
    'Đại Hàn', // 大寒
    'Lập Xuân', // 立春
    'Vũ Thủy', // 雨水
    'Kinh Trập', // 惊蛰
    'Xuân Phân', // 春分
    'Thanh Minh', // 清明
    'Cốc Vũ', // 谷雨
    'Lập Hạ', // 立夏
    'Tiểu Mãn', // 小满
    'Mang Chủng', // 芒种
    'Hạ Chí', // 夏至
    'Tiểu Thử', // 小暑
    'Đại Thử', // 大暑
    'Lập Thu', // 立秋
    'Xử Thử', // 处暑
    'Bạch Lộ', // 白露
    'Thu Phân', // 秋分
    'Hàn Lộ', // 寒露
    'Sương Giáng', // 霜降
    'Lập Đông', // 立冬
    'Tiểu Tuyết', // 小雪
    'Đại Tuyết', // 大雪
  ];

  /// 名称
  String? _name;

  /// 阳历日期
  Solar? _solar;

  /// 是否节令
  bool _jie = false;

  /// 是否气令
  bool _qi = false;

  JieQi(String name, Solar solar) {
    setName(name);
    _solar = solar;
  }

  String getName() => _name!;

  void setName(String name) {
    _name = name;
    for (int i = 0, j = JIE_QI.length; i < j; i++) {
      if (name == JIE_QI[i]) {
        if (i % 2 == 0) {
          _qi = true;
        } else {
          _jie = true;
        }
        return;
      }
    }
  }

  Solar getSolar() => _solar!;

  void setSolar(Solar solar) {
    _solar = solar;
  }

  bool isJie() => _jie;

  bool isQi() => _qi;

  @override
  String toString() => '$_name';
}
