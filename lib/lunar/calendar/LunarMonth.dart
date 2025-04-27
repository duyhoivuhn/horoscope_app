import 'LunarYear.dart';
import 'NineStar.dart';
import 'Solar.dart';
import 'util/LunarUtil.dart';

/// 农历月
/// @author 6tail
class LunarMonth {
  /// 农历年
  int _year = 0;

  /// 农历月：1-12，闰月为负数，如闰2月为-2
  int _month = 0;

  /// 天数，大月30天，小月29天
  int _dayCount = 0;

  /// 初一的儒略日
  double _firstJulianDay = 0;

  int _index = 0;

  int _zhiIndex = 0;

  LunarMonth(
      int year, int month, int dayCount, double firstJulianDay, int index) {
    _year = year;
    _month = month;
    _dayCount = dayCount;
    _firstJulianDay = firstJulianDay;
    _index = index;
    _zhiIndex = (index - 1 + LunarUtil.BASE_MONTH_ZHI_INDEX) % 12;
  }

  static LunarMonth? fromYm(int lunarYear, int lunarMonth) {
    return LunarYear.fromYear(lunarYear).getMonth(lunarMonth);
  }

  int getYear() => _year;

  int getMonth() => _month;

  int getDayCount() => _dayCount;

  double getFirstJulianDay() => _firstJulianDay;

  int getIndex() => _index;

  int getZhiIndex() => _zhiIndex;

  int getGanIndex() {
    int offset = (LunarYear.fromYear(_year).getGanIndex() + 1) % 5 * 2;
    return (_index - 1 + offset) % 10;
  }

  String getGan() => LunarUtil.GAN[getGanIndex() + 1];

  String getZhi() => LunarUtil.ZHI[_zhiIndex + 1];

  String getGanZhi() => '${getGan()}${getZhi()}';

  String getPositionXi() => LunarUtil.POSITION_XI[getGanIndex() + 1];

  String getPositionXiDesc() => LunarUtil.POSITION_DESC[getPositionXi()]!;

  String getPositionYangGui() => LunarUtil.POSITION_YANG_GUI[getGanIndex() + 1];

  String getPositionYangGuiDesc() =>
      LunarUtil.POSITION_DESC[getPositionYangGui()]!;

  String getPositionYinGui() => LunarUtil.POSITION_YIN_GUI[getGanIndex() + 1];

  String getPositionYinGuiDesc() =>
      LunarUtil.POSITION_DESC[getPositionYinGui()]!;

  String getPositionFu([int sect = 2]) => (1 == sect
      ? LunarUtil.POSITION_FU
      : LunarUtil.POSITION_FU_2)[getGanIndex() + 1];

  String getPositionFuDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getPositionFu(sect)]!;

  String getPositionCai() => LunarUtil.POSITION_CAI[getGanIndex() + 1];

  String getPositionCaiDesc() => LunarUtil.POSITION_DESC[getPositionCai()]!;

  bool isLeap() => _month < 0;

  /// Lấy phương vị Thái Tuế của Tháng (Nguyệt Thái Tuế)
  /// Tính toán dựa trên số tháng Âm lịch và Can của tháng.
  String getPositionTaiSui() {
    String p; // Biến lưu trữ phương vị
    // Lấy số tháng Âm lịch (1-12). Sử dụng abs() phòng trường hợp tháng nhuận có thể được biểu diễn bằng số âm.
    int m = _month.abs();
    // Xác định phương vị dựa trên Tam Hợp cục của tháng
    switch (m) {
      case 1: // Tháng 1 (Dần)
      case 5: // Tháng 5 (Ngọ)
      case 9: // Tháng 9 (Tuất)
        // Các tháng Dần, Ngọ, Tuất (Tam Hợp Hỏa cục) -> Thái Tuế ở Cấn
        p = 'Cấn'; // 艮
        break;
      case 3: // Tháng 3 (Thìn)
      case 7: // Tháng 7 (Thân)
      case 11: // Tháng 11 (Tý)
        // Các tháng Thân, Tý, Thìn (Tam Hợp Thủy cục) -> Thái Tuế ở Khôn
        p = 'Khôn'; // 坤
        break;
      case 4: // Tháng 4 (Tỵ)
      case 8: // Tháng 8 (Dậu)
      case 12: // Tháng 12 (Sửu)
        // Các tháng Tỵ, Dậu, Sửu (Tam Hợp Kim cục) -> Thái Tuế ở Tốn
        p = 'Tốn'; // 巽
        break;
      default: // Các tháng còn lại: 2 (Mão), 6 (Mùi), 10 (Hợi) (Tam Hợp Mộc cục)
        // Phương vị Thái Tuế lấy theo phương vị của Thiên Can tháng.
        // Lấy ngày Julian của ngày đầu tiên trong tháng, chuyển sang Solar, rồi lấy Lunar để lấy Can tháng.
        p = LunarUtil.POSITION_GAN[Solar.fromJulianDay(this.getFirstJulianDay())
            .getLunar()
            .getMonthGanIndex()];
    }
    // Trả về phương vị đã xác định
    return p;
  }

  String getPositionTaiSuiDesc() =>
      LunarUtil.POSITION_DESC[getPositionTaiSui()]!;

  NineStar getNineStar() {
    int index = LunarYear.fromYear(_year).getZhiIndex() % 3;
    int m = _month.abs();
    int monthZhiIndex = (13 + m) % 12;
    int n = 27 - (index * 3);
    if (monthZhiIndex < LunarUtil.BASE_MONTH_ZHI_INDEX) {
      n -= 3;
    }
    int offset = (n - monthZhiIndex) % 9;
    return NineStar.fromIndex(offset);
  }

  @override
  String toString() {
    String month = LunarUtil.MONTH[_month.abs()];
    return '{$_year}Năm${isLeap() ? 'Nhuận' : ''}{$month}Tháng($_dayCount)ngày';
  }

  LunarMonth next(int n) {
    if (0 == n) {
      return LunarMonth.fromYm(_year, _month)!;
    } else if (n > 0) {
      int rest = n;
      int ny = _year;
      int iy = ny;
      int im = _month;
      int index = 0;
      List<LunarMonth> months = LunarYear.fromYear(ny).getMonths();
      while (true) {
        int size = months.length;
        for (int i = 0; i < size; i++) {
          LunarMonth m = months[i];
          if (m.getYear() == iy && m.getMonth() == im) {
            index = i;
            break;
          }
        }
        int more = size - index - 1;
        if (rest < more) {
          break;
        }
        rest -= more;
        LunarMonth lastMonth = months[size - 1];
        iy = lastMonth.getYear();
        im = lastMonth.getMonth();
        ny++;
        months = LunarYear.fromYear(ny).getMonths();
      }
      return months[index + rest];
    } else {
      int rest = -n;
      int ny = _year;
      int iy = ny;
      int im = _month;
      int index = 0;
      List<LunarMonth> months = LunarYear.fromYear(ny).getMonths();
      while (true) {
        int size = months.length;
        for (int i = 0; i < size; i++) {
          LunarMonth m = months[i];
          if (m.getYear() == iy && m.getMonth() == im) {
            index = i;
            break;
          }
        }
        if (rest <= index) {
          break;
        }
        rest -= index;
        LunarMonth firstMonth = months[0];
        iy = firstMonth.getYear();
        im = firstMonth.getMonth();
        ny--;
        months = LunarYear.fromYear(ny).getMonths();
      }
      return months[index - rest];
    }
  }
}
