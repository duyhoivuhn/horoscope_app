import 'FotoFestival.dart';
import 'Lunar.dart';
import 'LunarMonth.dart';
import 'util/FotoUtil.dart';
import 'util/LunarUtil.dart';

/// 佛历
/// @author 6tail
class Foto {
  static const int DEAD_YEAR = -543;

  /// 阴历
  Lunar? _lunar;

  Foto(this._lunar);

  static Foto fromLunar(Lunar lunar) {
    return new Foto(lunar);
  }

  static Foto fromYmdHms(
      int year, int month, int day, int hour, int minute, int second) {
    return fromLunar(Lunar.fromYmdHms(
        year + DEAD_YEAR - 1, month, day, hour, minute, second));
  }

  static Foto fromYmd(int year, int month, int day) {
    return fromYmdHms(year, month, day, 0, 0, 0);
  }

  Lunar getLunar() => _lunar!;

  int getYear() {
    int sy = _lunar!.getSolar().getYear();
    int y = sy - DEAD_YEAR;
    if (sy == _lunar!.getYear()) {
      y++;
    }
    return y;
  }

  int getMonth() => _lunar!.getMonth();

  int getDay() => _lunar!.getDay();

  String getYearInChinese() {
    String y = getYear().toString();
    String s = '';
    for (int i = 0, j = y.length; i < j; i++) {
      s += LunarUtil.NUMBER[y.codeUnitAt(i) - 48];
    }
    return s;
  }

  String getMonthInChinese() => _lunar!.getMonthInChinese();

  String getDayInChinese() => _lunar!.getDayInChinese();

  List<FotoFestival> getFestivals() {
    List<FotoFestival> l = <FotoFestival>[];
    List<FotoFestival>? fs =
        FotoUtil.FESTIVAL['${getMonth().abs()}-${getDay()}'];
    if (null != fs) {
      l.addAll(fs);
    }
    return l;
  }

  List<String> getOtherFestivals() {
    List<String> l = <String>[];
    List<String>? fs = FotoUtil.OTHER_FESTIVAL['${getMonth()}-${getDay()}'];
    if (null != fs) {
      l.addAll(fs);
    }
    return l;
  }

  bool isMonthZhai() {
    int m = getMonth();
    return 1 == m || 5 == m || 9 == m;
  }

  /// Kiểm tra xem có phải là ngày Dương Công Kỵ hay không
  bool isDayYangGong() {
    // Lặp qua danh sách các lễ hội (FotoFestival) của ngày
    for (FotoFestival f in getFestivals()) {
      // Nếu tên của lễ hội là 'Dương Công Kỵ'
      if ('Dương Công Kỵ' == f.getName()) {
        // '杨公忌' là Dương Công Kỵ
        // Trả về true (đúng là ngày Dương Công Kỵ)
        return true;
      }
    }
    // Nếu không tìm thấy lễ hội 'Dương Công Kỵ' trong danh sách, trả về false
    return false;
  }

  bool isDayZhaiShuoWang() {
    int d = getDay();
    return 1 == d || 15 == d;
  }

  bool isDayZhaiSix() {
    int d = getDay();
    if (8 == d || 14 == d || 15 == d || 23 == d || 29 == d || 30 == d) {
      return true;
    } else if (28 == d) {
      LunarMonth? m = LunarMonth.fromYm(_lunar!.getYear(), getMonth());
      return null != m && 30 != m.getDayCount();
    }
    return false;
  }

  bool isDayZhaiTen() {
    int d = getDay();
    return 1 == d ||
        8 == d ||
        14 == d ||
        15 == d ||
        18 == d ||
        23 == d ||
        24 == d ||
        28 == d ||
        29 == d ||
        30 == d;
  }

  bool isDayZhaiGuanYin() {
    String k = '${getMonth()}-${getDay()}';
    for (String d in FotoUtil.DAY_ZHAI_GUAN_YIN) {
      if (k == d) {
        return true;
      }
    }
    return false;
  }

  String getXiu() {
    return FotoUtil.getXiu(getMonth(), getDay());
  }

  String getXiuLuck() {
    return LunarUtil.XIU_LUCK[getXiu()]!;
  }

  String getXiuSong() {
    return LunarUtil.XIU_SONG[getXiu()]!;
  }

  String getZheng() {
    return LunarUtil.ZHENG[getXiu()]!;
  }

  String getAnimal() {
    return LunarUtil.ANIMAL[getXiu()]!;
  }

  String getGong() {
    return LunarUtil.GONG[getXiu()]!;
  }

  String getShou() {
    return LunarUtil.SHOU[getGong()]!;
  }

  @override
  String toString() {
    return '${getYearInChinese()}年${getMonthInChinese()}月${getDayInChinese()}';
  }

  String toFullString() {
    String s = toString();
    for (FotoFestival f in getFestivals()) {
      s += ' (';
      s += f.toString();
      s += ')';
    }
    return s;
  }
}
