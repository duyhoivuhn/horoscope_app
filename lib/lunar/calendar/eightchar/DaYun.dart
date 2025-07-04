import '../../lunar.dart';
import 'LiuNian.dart'; // Giả sử bạn cũng muốn giữ các import này
import 'XiaoYun.dart';
import 'Yun.dart';
import '../util/LunarUtil.dart';

/// Đại Vận
/// @author 6tail
class DaYun {
  /// Năm bắt đầu (bao gồm)
  int _startYear = 0;

  /// Năm kết thúc (bao gồm)
  int _endYear = 0;

  /// Tuổi bắt đầu (bao gồm)
  int _startAge = 0;

  /// Tuổi kết thúc (bao gồm)
  int _endAge = 0;

  /// Số thứ tự, 0-9
  int _index = 0;

  /// Vận (Fortune Cycle/Luck Cycle)
  Yun? _yun;

  /// Âm lịch
  Lunar? _lunar;

  DaYun(Yun yun, int index) {
    _yun = yun;
    _lunar = yun.getLunar();
    _index = index;
    int birthYear = _lunar!.getSolar().getYear();
    int year = yun.getStartSolar().getYear();
    if (index < 1) {
      _startYear = birthYear;
      _startAge = 1;
      _endYear = year - 1;
      _endAge = year - birthYear;
    } else {
      int add = (index - 1) * 10;
      _startYear = year + add;
      _startAge = _startYear - birthYear + 1;
      _endYear = _startYear + 9;
      _endAge = _startAge + 9;
    }
  }

  int getStartYear() => _startYear;

  int getEndYear() => _endYear;

  int getStartAge() => _startAge;

  int getEndAge() => _endAge;

  int getIndex() => _index;

  Lunar getLunar() => _lunar!;

  String getGanZhi() {
    if (_index < 1) {
      return '';
    }
    int offset = LunarUtil.getJiaZiIndex(_lunar!.getMonthInGanZhiExact());
    offset += _yun!.isForward() ? _index : -_index;
    int size = LunarUtil.JIA_ZI.length;
    if (offset >= size) {
      offset -= size;
    }
    if (offset < 0) {
      offset += size;
    }
    return LunarUtil.JIA_ZI[offset];
  }

  String getXun() => LunarUtil.getXun(getGanZhi());

  String getXunKong() => LunarUtil.getXunKong(getGanZhi());

  /// Lấy 10 vòng Lưu Niên
  List<LiuNian> getLiuNian() {
    return getLiuNianBy(10);
  }

  /// Lấy Lưu Niên
  /// [n] Số vòng
  List<LiuNian> getLiuNianBy(int n) {
    if (_index < 1) {
      n = _endYear - _startYear + 1;
    }
    List<LiuNian> l = <LiuNian>[];
    for (int i = 0; i < n; i++) {
      l.add(LiuNian(this, i));
    }
    return l;
  }

  /// Lấy 10 vòng Tiểu Vận
  List<XiaoYun> getXiaoYun() {
    return getXiaoYunBy(10);
  }

  /// Lấy Tiểu Vận
  /// [n] Số vòng
  List<XiaoYun> getXiaoYunBy(int n) {
    if (_index < 1) {
      n = _endYear - _startYear + 1;
    }
    List<XiaoYun> l = <XiaoYun>[];
    for (int i = 0; i < n; i++) {
      l.add(XiaoYun(this, i, _yun!.isForward()));
    }
    return l;
  }
}
