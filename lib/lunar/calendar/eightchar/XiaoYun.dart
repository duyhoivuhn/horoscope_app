import '../../lunar.dart';
import 'DaYun.dart'; // Giữ lại import này
import '../util/LunarUtil.dart'; // Giữ lại import này

/// Tiểu Vận (Minor Fortune Cycle)
/// @author 6tail
class XiaoYun {
  /// Số thứ tự, 0-9
  int _index = 0;

  /// Năm
  int _year = 0;

  /// Tuổi
  int _age = 0;

  /// Có phải là đẩy thuận hay không (true = thuận, false = nghịch)
  bool _forward = false;

  /// Đại Vận (Major Fortune Cycle) chứa Tiểu Vận này
  DaYun? _daYun;

  /// Âm lịch của ngày sinh
  Lunar? _lunar;

  /// Khởi tạo một đối tượng Tiểu Vận.
  ///
  /// [daYun] Đại Vận chứa Tiểu Vận này.
  /// [index] Chỉ số của Tiểu Vận trong Đại Vận (0-9).
  /// [forward] Hướng đẩy của Vận (true = thuận, false = nghịch).
  XiaoYun(DaYun daYun, int index, bool forward) {
    _daYun = daYun;
    _lunar = daYun.getLunar();
    _index = index;
    _year = daYun.getStartYear() + index;
    _age = daYun.getStartAge() + index;
    _forward = forward;
  }

  /// Lấy số thứ tự của Tiểu Vận trong Đại Vận (0-9).
  int getIndex() => _index;

  /// Lấy năm Dương lịch của Tiểu Vận.
  int getYear() => _year;

  /// Lấy tuổi Âm lịch của người đó trong năm Tiểu Vận này.
  int getAge() => _age;

  /// Lấy Can Chi của năm Tiểu Vận.
  String getGanZhi() {
    // Tính toán dựa trên Can Chi giờ sinh và thứ tự Tiểu Vận.
    int offset = LunarUtil.getJiaZiIndex(_lunar!.getTimeInGanZhi());
    int add = _index + 1; // Tiểu Vận bắt đầu từ 1
    if (_daYun!.getIndex() > 0) {
      // Nếu không phải Đại Vận đầu tiên (trước khởi vận), cộng thêm tuổi khởi vận - 1
      add += _daYun!.getStartAge() - 1;
    }
    // Cộng hoặc trừ offset tùy theo chiều thuận/nghịch
    offset += _forward ? add : -add;
    int size = LunarUtil.JIA_ZI.length; // 60 Giáp Tý
    // Đảm bảo offset nằm trong khoảng 0-59
    while (offset < 0) {
      offset += size;
    }
    offset %= size;
    // LunarUtil.JIA_ZI chứa danh sách Can Chi (Giáp Tý) bằng tiếng Trung.
    return LunarUtil.JIA_ZI[offset];
  }

  /// Lấy Tuần (Xun) của Can Chi năm Tiểu Vận (tiếng Trung).
  String getXun() => LunarUtil.getXun(getGanZhi());

  /// Lấy Tuần Không (Xun Kong) của Can Chi năm Tiểu Vận (tiếng Trung).
  String getXunKong() => LunarUtil.getXunKong(getGanZhi());
}
