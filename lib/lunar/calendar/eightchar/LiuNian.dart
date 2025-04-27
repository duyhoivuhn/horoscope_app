import '../../lunar.dart';
import 'DaYun.dart'; // Giữ lại import này
import 'LiuYue.dart'; // Giữ lại import này
import '../util/LunarUtil.dart'; // Giữ lại import này

/// Lưu Niên (Vòng Vận Hàng Năm)
/// @author 6tail
class LiuNian {
  /// Số thứ tự, 0-9
  int _index = 0;

  /// Năm
  int _year = 0;

  /// Tuổi
  int _age = 0;

  /// Đại Vận (Vòng Vận Lớn)
  DaYun? _daYun;

  /// Âm lịch
  Lunar? _lunar;

  LiuNian(DaYun daYun, int index) {
    _daYun = daYun;
    _lunar = daYun.getLunar();
    _index = index;
    _year = daYun.getStartYear() + index;
    _age = daYun.getStartAge() + index;
  }

  /// Lấy tên tháng theo tiếng Trung (từ LunarUtil.MONTH).
  /// Để có tiếng Việt, cần sửa đổi LunarUtil.MONTH hoặc thêm logic dịch.
  String getMonthInChinese() => LunarUtil.MONTH[_index + 1];

  /// Lấy số thứ tự (0-9) của Lưu Niên trong Đại Vận.
  int getIndex() => _index;

  /// Lấy năm Dương lịch của Lưu Niên.
  int getYear() => _year;

  /// Lấy tuổi Âm lịch của người đó trong năm Lưu Niên này.
  int getAge() => _age;

  /// Lấy Can Chi của năm Lưu Niên.
  String getGanZhi() {
    // Can Chi không liên quan đến ngày sinh và ngày khởi vận.
    // '立春' (Lập Xuân) được giữ nguyên vì nó là key trong bảng Tiết Khí.
    int offset = LunarUtil.getJiaZiIndex(_lunar!
            .getJieQiTable()['Lập Xuân']!
            .getLunar()
            .getYearInGanZhiExact()) +
        _index;
    if (_daYun!.getIndex() > 0) {
      offset += _daYun!.getStartAge() - 1;
    }
    offset %= LunarUtil.JIA_ZI.length;
    // LunarUtil.JIA_ZI chứa danh sách Can Chi (Giáp Tý) bằng tiếng Trung.
    return LunarUtil.JIA_ZI[offset];
  }

  /// Lấy Tuần (Xun) của Can Chi năm Lưu Niên (tiếng Trung).
  String getXun() => LunarUtil.getXun(getGanZhi());

  /// Lấy Tuần Không (Xun Kong) của Can Chi năm Lưu Niên (tiếng Trung).
  String getXunKong() => LunarUtil.getXunKong(getGanZhi());

  /// Lấy danh sách 12 Lưu Nguyệt (Vòng Vận Hàng Tháng) trong năm Lưu Niên này.
  List<LiuYue> getLiuYue() {
    int n = 12;
    List<LiuYue> l = <LiuYue>[];
    for (int i = 0; i < n; i++) {
      l.add(LiuYue(this, i));
    }
    return l;
  }
}
