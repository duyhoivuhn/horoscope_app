import 'EightChar.dart';
import 'Foto.dart';
import 'Fu.dart';
import 'JieQi.dart';
import 'LunarMonth.dart';
import 'LunarTime.dart';
import 'LunarYear.dart';
import 'NineStar.dart';
import 'ShuJiu.dart';
import 'Solar.dart';
import 'Tao.dart';
import 'util/LunarUtil.dart';
import 'util/SolarUtil.dart';

/// 阴历日期
/// @author 6tail
class Lunar {
  /// Các Tiết Khí đang được sử dụng (bao gồm cả tên Hán Việt và định danh)
  static const List<String> JIE_QI_IN_USE = [
    'Đại Tuyết', // DA_XUE (Đại Tuyết)
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
    'Đông Chí', // DONG_ZHI (Đông Chí)
    'Tiểu Hàn', // XIAO_HAN (Tiểu Hàn)
    'Đại Hàn', // DA_HAN (Đại Hàn)
    'Lập Xuân', // LI_CHUN (Lập Xuân)
    'Vũ Thủy', // YU_SHUI (Vũ Thủy)
    'Kinh Trập' // JING_ZHE (Kinh Trập)
  ];

  int _year = 0;

  int _month = 0;

  int _day = 0;

  int _hour = 0;

  int _minute = 0;

  int _second = 0;

  int _timeGanIndex = 0;
  int _timeZhiIndex = 0;
  int _dayGanIndex = 0;
  int _dayZhiIndex = 0;
  int _dayGanIndexExact = 0;
  int _dayZhiIndexExact = 0;
  int _dayGanIndexExact2 = 0;
  int _dayZhiIndexExact2 = 0;
  int _monthGanIndex = 0;
  int _monthZhiIndex = 0;
  int _monthGanIndexExact = 0;
  int _monthZhiIndexExact = 0;
  int _yearGanIndex = 0;
  int _yearZhiIndex = 0;
  int _yearGanIndexByLiChun = 0;
  int _yearZhiIndexByLiChun = 0;
  int _yearGanIndexExact = 0;
  int _yearZhiIndexExact = 0;
  int _weekIndex = 0;

  Solar? _solar;

  EightChar? _eightChar;

  Map<String, Solar> _jieQi = {};

  Lunar.fromYmd(int lunarYear, int lunarMonth, int lunarDay)
      : this.fromYmdHms(lunarYear, lunarMonth, lunarDay, 0, 0, 0);

  /// Khởi tạo từ Năm, Tháng, Ngày, Giờ, Phút, Giây Âm lịch
  Lunar.fromYmdHms(int lunarYear, int lunarMonth, int lunarDay, int hour,
      int minute, int second) {
    // Lấy đối tượng Năm Âm lịch từ năm đã cho
    LunarYear y = LunarYear.fromYear(lunarYear);
    // Lấy đối tượng Tháng Âm lịch từ tháng đã cho trong năm đó
    LunarMonth? m = y.getMonth(lunarMonth);
    // Kiểm tra xem tháng có hợp lệ không
    if (null == m) {
      // Ném lỗi nếu tháng không hợp lệ
      throw 'Năm âm lịch $lunarYear tháng $lunarMonth không hợp lệ'; // 'wrong lunar year $lunarYear month $lunarMonth'
    }
    // Kiểm tra xem ngày có hợp lệ không (phải lớn hơn 0)
    if (lunarDay < 1) {
      // Ném lỗi nếu ngày không hợp lệ
      throw 'Ngày âm lịch phải lớn hơn 0'; // 'lunar day must bigger than 0'
    }
    // Lấy tổng số ngày trong tháng âm lịch đã chỉ định
    int days = m.getDayCount();
    // Kiểm tra xem ngày đã cho có vượt quá số ngày trong tháng không
    if (lunarDay > days) {
      // Ném lỗi nếu ngày không hợp lệ cho tháng đó
      throw 'Chỉ có $days ngày trong năm âm lịch $lunarYear tháng $lunarMonth'; // 'only $days days in lunar year $lunarYear month $lunarMonth'
    }
    // Gán các giá trị năm, tháng, ngày, giờ, phút, giây âm lịch
    _year = lunarYear;
    _month = lunarMonth;
    _day = lunarDay;
    _hour = hour;
    _minute = minute;
    _second = second;
    // Tính toán ngày Dương lịch tương ứng với giữa trưa (noon) của ngày Âm lịch đã cho
    Solar noon = Solar.fromJulianDay(m.getFirstJulianDay() + lunarDay - 1);
    // Tạo đối tượng Solar tương ứng với thời gian đã cho
    _solar = Solar.fromYmdHms(
        noon.getYear(), noon.getMonth(), noon.getDay(), hour, minute, second);
    // Nếu năm Dương lịch tính được khác với năm Âm lịch đầu vào (có thể xảy ra gần thời điểm giao thừa)
    if (noon.getYear() != lunarYear) {
      // Lấy lại đối tượng LunarYear cho năm Dương lịch chính xác
      y = LunarYear.fromYear(noon.getYear());
    }
    // Thực hiện các tính toán khác dựa trên LunarYear đã xác định
    _compute(y);
  }

  Lunar.fromSolar(Solar solar) {
    LunarYear ly = LunarYear.fromYear(solar.getYear());
    for (LunarMonth m in ly.getMonths()) {
      int days = solar.subtract(Solar.fromJulianDay(m.getFirstJulianDay()));
      if (days < m.getDayCount()) {
        _year = m.getYear();
        _month = m.getMonth();
        _day = days + 1;
        break;
      }
    }
    _hour = solar.getHour();
    _minute = solar.getMinute();
    _second = solar.getSecond();
    _solar = solar;
    _compute(ly);
  }

  Lunar.fromDate(DateTime date) : this.fromSolar(Solar.fromDate(date));

  void _computeJieQi(LunarYear lunarYear) {
    List<double> julianDays = lunarYear.getJieQiJulianDays();
    for (int i = 0, j = JIE_QI_IN_USE.length; i < j; i++) {
      _jieQi[JIE_QI_IN_USE[i]] = Solar.fromJulianDay(julianDays[i]);
    }
  }

  /// Tính toán các thông tin liên quan đến Năm Âm lịch
  void _computeYear() {
    // Tính toán dựa trên ngày Mùng 1 tháng Giêng làm mốc
    int offset =
        _year - 4; // Tính độ lệch so với năm gốc (thường là năm 4 SCN, Giáp Tý)
    _yearGanIndex =
        offset % 10; // Tính chỉ số Thiên Can của năm (0-9) theo mùng 1 Tết
    _yearZhiIndex =
        offset % 12; // Tính chỉ số Địa Chi của năm (0-11) theo mùng 1 Tết

    // Đảm bảo chỉ số Can không âm
    if (_yearGanIndex < 0) {
      _yearGanIndex += 10;
    }

    // Đảm bảo chỉ số Chi không âm
    if (_yearZhiIndex < 0) {
      _yearZhiIndex += 12;
    }

    // Tính toán Can Chi của năm dựa trên ngày Lập Xuân làm mốc bắt đầu năm mới
    int g = _yearGanIndex; // Can ban đầu (tính theo mùng 1 Tết)
    int z = _yearZhiIndex; // Chi ban đầu (tính theo mùng 1 Tết)

    // Tính toán Can Chi chính xác của năm, dựa vào thời điểm giao Lập Xuân
    int gExact = _yearGanIndex; // Can chính xác (tính theo giờ Lập Xuân)
    int zExact = _yearZhiIndex; // Chi chính xác (tính theo giờ Lập Xuân)

    int solarYear = _solar!.getYear(); // Lấy năm Dương lịch của ngày đang xét
    String solarYmd = _solar!.toYmd(); // Lấy ngày Dương lịch dạng YYYY-MM-DD
    String solarYmdHms =
        _solar!.toYmdHms(); // Lấy ngày giờ Dương lịch dạng YYYY-MM-DD HH:MM:SS

    // Lấy thời điểm Dương lịch của tiết Lập Xuân
    Solar liChun = _jieQi[
        'Lập Xuân']!; // Lấy thông tin Lập Xuân từ map _jieQi (dựa trên năm âm lịch _year)
    // Nếu năm của Lập Xuân ('立春') lấy ban đầu không khớp với năm Dương lịch đang xét,
    // có nghĩa là ngày đang xét rơi vào đầu năm Dương lịch nhưng trước Lập Xuân của năm đó.
    // Cần lấy Lập Xuân của năm Dương lịch đang xét (thường là Lập Xuân của năm trước đó theo lịch Âm).
    // Giả sử key 'LI_CHUN' lấy đúng Lập Xuân cho `solarYear`.
    if (liChun.getYear() != solarYear) {
      liChun = _jieQi['Lập Xuân']!;
    }
    String liChunYmd = liChun.toYmd(); // Lấy ngày Lập Xuân dạng YYYY-MM-DD
    String liChunYmdHms =
        liChun.toYmdHms(); // Lấy ngày giờ Lập Xuân dạng YYYY-MM-DD HH:MM:SS

    // So sánh ngày/giờ đang xét với thời điểm Lập Xuân để điều chỉnh Can Chi
    // Trường hợp ngày đang xét nằm trong cùng năm Dương lịch với năm Âm lịch (_year)
    // (thường là từ Mùng 1 Tết đến hết 31/12 DL)
    if (_year == solarYear) {
      // Nếu ngày Dương lịch trước ngày Lập Xuân
      if (solarYmd.compareTo(liChunYmd) < 0) {
        g--; // Giảm chỉ số Can (thuộc năm trước theo Lập Xuân)
        z--; // Giảm chỉ số Chi (thuộc năm trước theo Lập Xuân)
      }
      // Nếu thời điểm Dương lịch trước thời điểm Lập Xuân (tính chính xác đến giây)
      if (solarYmdHms.compareTo(liChunYmdHms) < 0) {
        gExact--; // Giảm chỉ số Can chính xác
        zExact--; // Giảm chỉ số Chi chính xác
      }
    }
    // Trường hợp ngày đang xét thuộc năm Dương lịch sau năm Âm lịch (_year)
    // (thường là tháng 1, 2 DL của năm sau, nhưng vẫn thuộc năm Âm lịch _year do chưa đến Tết ÂL mới)
    else if (_year < solarYear) {
      // Nếu ngày Dương lịch bằng hoặc sau ngày Lập Xuân
      if (solarYmd.compareTo(liChunYmd) >= 0) {
        g++; // Tăng chỉ số Can (thuộc năm sau theo Lập Xuân)
        z++; // Tăng chỉ số Chi (thuộc năm sau theo Lập Xuân)
      }
      // Nếu thời điểm Dương lịch bằng hoặc sau thời điểm Lập Xuân
      if (solarYmdHms.compareTo(liChunYmdHms) >= 0) {
        gExact++; // Tăng chỉ số Can chính xác
        zExact++; // Tăng chỉ số Chi chính xác
      }
    }

    // Gán giá trị Can Chi cuối cùng tính theo ngày Lập Xuân
    _yearGanIndexByLiChun =
        (g < 0 ? g + 10 : g) % 10; // Đảm bảo trong khoảng 0-9
    _yearZhiIndexByLiChun =
        (z < 0 ? z + 12 : z) % 12; // Đảm bảo trong khoảng 0-11

    // Gán giá trị Can Chi cuối cùng tính theo thời điểm Lập Xuân chính xác
    _yearGanIndexExact =
        (gExact < 0 ? gExact + 10 : gExact) % 10; // Đảm bảo trong khoảng 0-9
    _yearZhiIndexExact =
        (zExact < 0 ? zExact + 12 : zExact) % 12; // Đảm bảo trong khoảng 0-11
  }

  void _computeMonth() {
    Solar? start;
    Solar end;
    String ymd = _solar!.toYmd();
    String time = _solar!.toYmdHms();
    int size = JIE_QI_IN_USE.length;

    //序号：大雪以前-3，大雪到小寒之间-2，小寒到立春之间-1，立春之后0
    int index = -3;
    for (int i = 0; i < size; i += 2) {
      end = _jieQi[JIE_QI_IN_USE[i]]!;
      String symd = null == start ? ymd : start.toYmd();
      if (ymd.compareTo(symd) >= 0 && ymd.compareTo(end.toYmd()) < 0) {
        break;
      }
      start = end;
      index++;
    }

    //干偏移值（以立春当天起算）
    int offset =
        (((_yearGanIndexByLiChun + (index < 0 ? 1 : 0)) % 5 + 1) * 2) % 10;
    _monthGanIndex = ((index < 0 ? index + 10 : index) + offset) % 10;
    _monthZhiIndex =
        ((index < 0 ? index + 12 : index) + LunarUtil.BASE_MONTH_ZHI_INDEX) %
            12;

    start = null;
    index = -3;
    for (int i = 0; i < size; i += 2) {
      end = _jieQi[JIE_QI_IN_USE[i]]!;
      String stime = null == start ? time : start.toYmdHms();
      if (time.compareTo(stime) >= 0 && time.compareTo(end.toYmdHms()) < 0) {
        break;
      }
      start = end;
      index++;
    }

    //干偏移值（以立春交接时刻起算）
    offset = (((_yearGanIndexExact + (index < 0 ? 1 : 0)) % 5 + 1) * 2) % 10;
    _monthGanIndexExact = ((index < 0 ? index + 10 : index) + offset) % 10;
    _monthZhiIndexExact =
        ((index < 0 ? index + 12 : index) + LunarUtil.BASE_MONTH_ZHI_INDEX) %
            12;
  }

  void _computeDay() {
    Solar noon = Solar.fromYmdHms(
        _solar!.getYear(), _solar!.getMonth(), _solar!.getDay(), 12, 0, 0);
    int offset = noon.getJulianDay().floor() - 11;
    _dayGanIndex = offset % 10;
    _dayZhiIndex = offset % 12;

    int dayGanExact = _dayGanIndex;
    int dayZhiExact = _dayZhiIndex;

    // 八字流派2，晚子时（夜子/子夜）日柱算当天
    _dayGanIndexExact2 = dayGanExact;
    _dayZhiIndexExact2 = dayZhiExact;

    // 八字流派1，晚子时（夜子/子夜）日柱算明天
    String hm = (_hour < 10 ? '0' : '') +
        _hour.toString() +
        ':' +
        (_minute < 10 ? '0' : '') +
        _minute.toString();
    if (hm.compareTo('23:00') >= 0 && hm.compareTo('23:59') <= 0) {
      dayGanExact++;
      if (dayGanExact >= 10) {
        dayGanExact -= 10;
      }
      dayZhiExact++;
      if (dayZhiExact >= 12) {
        dayZhiExact -= 12;
      }
    }

    _dayGanIndexExact = dayGanExact;
    _dayZhiIndexExact = dayZhiExact;
  }

  void _computeTime() {
    String hm = (_hour < 10 ? '0' : '') +
        _hour.toString() +
        ':' +
        (_minute < 10 ? '0' : '') +
        _minute.toString();
    _timeZhiIndex = LunarUtil.getTimeZhiIndex(hm);
    _timeGanIndex = (_dayGanIndexExact % 5 * 2 + _timeZhiIndex) % 10;
  }

  void _computeWeek() {
    _weekIndex = _solar!.getWeek();
  }

  void _compute(LunarYear lunarYear) {
    _computeJieQi(lunarYear);
    _computeYear();
    _computeMonth();
    _computeDay();
    _computeTime();
    _computeWeek();
  }

  int getYear() => _year;

  int getMonth() => _month;

  int getDay() => _day;

  int getHour() => _hour;

  int getMinute() => _minute;

  int getSecond() => _second;

  String getGan() => getYearGan();

  String getYearGan() => LunarUtil.GAN[_yearGanIndex + 1];

  String getYearGanByLiChun() => LunarUtil.GAN[_yearGanIndexByLiChun + 1];

  String getYearGanExact() => LunarUtil.GAN[_yearGanIndexExact + 1];

  String getZhi() => getYearZhi();

  String getYearZhi() => LunarUtil.ZHI[_yearZhiIndex + 1];

  String getYearZhiByLiChun() => LunarUtil.ZHI[_yearZhiIndexByLiChun + 1];

  String getYearZhiExact() => LunarUtil.ZHI[_yearZhiIndexExact + 1];

  String getYearInGanZhi() => '${getYearGan()}${getYearZhi()}';

  String getYearInGanZhiByLiChun() =>
      '${getYearGanByLiChun()}${getYearZhiByLiChun()}';

  String getYearInGanZhiExact() => '${getYearGanExact()}${getYearZhiExact()}';

  String getMonthInGanZhi() => '${getMonthGan()}${getMonthZhi()}';

  String getMonthInGanZhiExact() =>
      '${getMonthGanExact()}${getMonthZhiExact()}';

  String getMonthGan() => LunarUtil.GAN[_monthGanIndex + 1];

  String getMonthGanExact() => LunarUtil.GAN[_monthGanIndexExact + 1];

  String getMonthZhi() => LunarUtil.ZHI[_monthZhiIndex + 1];

  String getMonthZhiExact() => LunarUtil.ZHI[_monthZhiIndexExact + 1];

  String getDayInGanZhi() => '${getDayGan()}${getDayZhi()}';

  String getDayInGanZhiExact() => '${getDayGanExact()}${getDayZhiExact()}';

  String getDayInGanZhiExact2() => '${getDayGanExact2()}${getDayZhiExact2()}';

  String getDayGan() => LunarUtil.GAN[_dayGanIndex + 1];

  String getDayGanExact() => LunarUtil.GAN[_dayGanIndexExact + 1];

  String getDayGanExact2() => LunarUtil.GAN[_dayGanIndexExact2 + 1];

  String getDayZhi() => LunarUtil.ZHI[_dayZhiIndex + 1];

  String getDayZhiExact() => LunarUtil.ZHI[_dayZhiIndexExact + 1];

  String getDayZhiExact2() => LunarUtil.ZHI[_dayZhiIndexExact2 + 1];

  @deprecated
  String getShengxiao() => getYearShengXiao();

  String getYearShengXiao() => LunarUtil.SHENGXIAO[_yearZhiIndex + 1];

  String getYearShengXiaoByLiChun() =>
      LunarUtil.SHENGXIAO[_yearZhiIndexByLiChun + 1];

  String getYearShengXiaoExact() => LunarUtil.SHENGXIAO[_yearZhiIndexExact + 1];

  String getMonthShengXiao() => LunarUtil.SHENGXIAO[_monthZhiIndex + 1];

  String getDayShengXiao() => LunarUtil.SHENGXIAO[_dayZhiIndex + 1];

  String getTimeShengXiao() => LunarUtil.SHENGXIAO[_timeZhiIndex + 1];

  String getYearInChinese() {
    String y = _year.toString();
    String s = '';
    for (int i = 0, j = y.length; i < j; i++) {
      s += LunarUtil.NUMBER[y.codeUnitAt(i) - 48];
    }
    return s;
  }

  String getMonthInChinese() =>
      (_month < 0 ? '闰' : '') + LunarUtil.MONTH[_month.abs()];

  String getDayInChinese() => LunarUtil.DAY[_day];

  String getTimeZhi() => LunarUtil.ZHI[_timeZhiIndex + 1];

  String getTimeGan() => LunarUtil.GAN[_timeGanIndex + 1];

  String getTimeInGanZhi() => '${getTimeGan()}${getTimeZhi()}';

  String getSeason() => LunarUtil.SEASON[_month.abs()];

  /// Chuyển đổi định danh Tiết Khí (Pinyin) sang tên Hán Việt
  String _convertJieQi(String name) {
    return name;
    String jq = name; // Biến tạm lưu trữ tên Tiết Khí
    if ('Đông Chí' == jq) {
      // Nếu tên là 'DONG_ZHI'
      jq = 'Đông Chí'; // Chuyển thành 'Đông Chí'
    } else if ('DA_HAN' == jq) {
      // Nếu tên là 'DA_HAN'
      jq = 'Đại Hàn'; // Chuyển thành 'Đại Hàn'
    } else if ('XIAO_HAN' == jq) {
      // Nếu tên là 'XIAO_HAN'
      jq = 'Tiểu Hàn'; // Chuyển thành 'Tiểu Hàn'
    } else if ('LI_CHUN' == jq) {
      // Nếu tên là 'LI_CHUN'
      jq = 'Lập Xuân'; // Chuyển thành 'Lập Xuân'
    } else if ('DA_XUE' == jq) {
      // Nếu tên là 'DA_XUE'
      jq = 'Đại Tuyết'; // Chuyển thành 'Đại Tuyết'
    } else if ('YU_SHUI' == jq) {
      // Nếu tên là 'YU_SHUI'
      jq = 'Vũ Thủy'; // Chuyển thành 'Vũ Thủy'
    } else if ('JING_ZHE' == jq) {
      // Nếu tên là 'JING_ZHE'
      jq = 'Kinh Trập'; // Chuyển thành 'Kinh Trập'
    }
    // Trả về tên Tiết Khí đã được chuyển đổi (hoặc tên gốc nếu không khớp)
    return jq;
  }

  String getJie() {
    for (int i = 0, j = JIE_QI_IN_USE.length; i < j; i += 2) {
      String key = JIE_QI_IN_USE[i];
      Solar? d = _jieQi[key];
      if (d!.getYear() == _solar!.getYear() &&
          d.getMonth() == _solar!.getMonth() &&
          d.getDay() == _solar!.getDay()) {
        return _convertJieQi(key);
      }
    }
    return '';
  }

  String getQi() {
    for (int i = 1, j = JIE_QI_IN_USE.length; i < j; i += 2) {
      String key = JIE_QI_IN_USE[i];
      Solar? d = _jieQi[key];
      if (d!.getYear() == _solar!.getYear() &&
          d.getMonth() == _solar!.getMonth() &&
          d.getDay() == _solar!.getDay()) {
        return _convertJieQi(key);
      }
    }
    return '';
  }

  int getWeek() => _weekIndex;

  String getWeekInChinese() => SolarUtil.WEEK[getWeek()];

  String getXiu() => LunarUtil.XIU['${getDayZhi()}${getWeek()}']!;

  String getXiuLuck() => LunarUtil.XIU_LUCK[getXiu()]!;

  String getXiuSong() => LunarUtil.XIU_SONG[getXiu()]!;

  String getZheng() => LunarUtil.ZHENG[getXiu()]!;

  String getAnimal() => LunarUtil.ANIMAL[getXiu()]!;

  String getGong() => LunarUtil.GONG[getXiu()]!;

  String getShou() => LunarUtil.SHOU[getGong()]!;

  List<String> getFestivals() {
    List<String> l = <String>[];
    String? f = LunarUtil.FESTIVAL['$_month-$_day'];
    if (null != f) {
      l.add(f);
    }
    if (_month.abs() == 12 && _day >= 29 && _year != next(1).getYear()) {
      l.add('Giao thừa'); // '除夕' (Trừ tịch) nghĩa là Đêm Giao thừa (đêm 30 Tết)
    }
    return l;
  }

  /// Lấy danh sách các ngày lễ/kỷ niệm không chính thức khác của ngày Âm lịch
  List<String> getOtherFestivals() {
    // Khởi tạo danh sách rỗng để chứa tên các lễ hội
    List<String> l = <String>[];
    // Lấy danh sách lễ hội cố định theo ngày tháng Âm lịch (ví dụ: '1-7') từ LunarUtil.OTHER_FESTIVAL
    List<String>? fs = LunarUtil.OTHER_FESTIVAL['$_month-$_day'];
    // Nếu tìm thấy danh sách lễ hội cho ngày tháng này
    if (null != fs) {
      // Thêm tất cả các lễ hội tìm được vào danh sách `l`
      l.addAll(fs);
    }
    // Lấy ngày Dương lịch hiện tại dạng YYYY-MM-DD
    String solarYmd = _solar!.toYmd();
    // Kiểm tra xem ngày Dương lịch có phải là ngày trước Tiết Thanh Minh không
    // (Ngày trước Thanh Minh là Tết Hàn Thực)
    if (solarYmd == _jieQi['Thanh Minh']!.next(-1).toYmd()) {
      // Nếu đúng, thêm 'Tết Hàn Thực' vào danh sách
      l.add('Tết Hàn Thực'); // '寒食节' là Tết Hàn Thực
    }

    // Tính ngày Xuân Xã (ngày Mậu thứ 5 sau Lập Xuân)
    Solar jq = _jieQi['Lập Xuân']!; // Lấy thông tin Tiết Lập Xuân
    // Tính độ lệch từ ngày Lập Xuân đến ngày Mậu gần nhất (Can Mậu có index 4)
    int offset = 4 - jq.getLunar().getDayGanIndex();
    if (offset < 0) {
      offset += 10; // Đảm bảo offset không âm
    }
    // Ngày Xuân Xã là ngày Mậu thứ 5 sau Lập Xuân.
    // Công thức `jq.next(offset + 40)` tính ngày thứ 40+offset sau Lập Xuân,
    // cần kiểm tra lại xem có đúng là ngày Mậu thứ 5 hay không.
    // Giả sử công thức này đúng để tính ngày Xuân Xã.
    if (solarYmd == jq.next(offset + 40).toYmd()) {
      // Nếu ngày Dương lịch trùng với ngày Xuân Xã, thêm 'Xuân Xã' vào danh sách
      l.add('Xuân Xã'); // '春社' là Xuân Xã
    }

    // Tính ngày Thu Xã (ngày Mậu thứ 5 sau Lập Thu)
    jq = _jieQi['Lập Thu']!; // Lấy thông tin Tiết Lập Thu
    // Tính độ lệch từ ngày Lập Thu đến ngày Mậu gần nhất
    offset = 4 - jq.getLunar().getDayGanIndex();
    if (offset < 0) {
      offset += 10; // Đảm bảo offset không âm
    }
    // Tương tự Xuân Xã, giả sử công thức này đúng để tính ngày Thu Xã.
    if (solarYmd == jq.next(offset + 40).toYmd()) {
      // Nếu ngày Dương lịch trùng với ngày Thu Xã, thêm 'Thu Xã' vào danh sách
      l.add('Thu Xã'); // '秋社' là Thu Xã
    }
    // Trả về danh sách các lễ hội không chính thức tìm được
    return l;
  }

  String getPengZuGan() => LunarUtil.PENGZU_GAN[_dayGanIndex + 1];

  String getPengZuZhi() => LunarUtil.PENGZU_ZHI[_dayZhiIndex + 1];

  String getPositionXi() => getDayPositionXi();

  String getPositionXiDesc() => getDayPositionXiDesc();

  String getPositionYangGui() => getDayPositionYangGui();

  String getPositionYangGuiDesc() => getDayPositionYangGuiDesc();

  String getPositionYinGui() => getDayPositionYinGui();

  String getPositionYinGuiDesc() => getDayPositionYinGuiDesc();

  String getPositionFu() => getDayPositionFu();

  String getPositionFuDesc() => getDayPositionFuDesc();

  String getPositionCai() => getDayPositionCai();

  String getPositionCaiDesc() => getDayPositionCaiDesc();

  String getDayPositionXi() => LunarUtil.POSITION_XI[_dayGanIndex + 1];

  String getDayPositionXiDesc() => LunarUtil.POSITION_DESC[getDayPositionXi()]!;

  String getDayPositionYangGui() =>
      LunarUtil.POSITION_YANG_GUI[_dayGanIndex + 1];

  String getDayPositionYangGuiDesc() =>
      LunarUtil.POSITION_DESC[getDayPositionYangGui()]!;

  String getDayPositionYinGui() => LunarUtil.POSITION_YIN_GUI[_dayGanIndex + 1];

  String getDayPositionYinGuiDesc() =>
      LunarUtil.POSITION_DESC[getDayPositionYinGui()]!;

  String getDayPositionFu([int sect = 2]) => (1 == sect
      ? LunarUtil.POSITION_FU
      : LunarUtil.POSITION_FU_2)[_dayGanIndex + 1];

  String getDayPositionFuDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getDayPositionFu(sect)]!;

  String getDayPositionCai() => LunarUtil.POSITION_CAI[_dayGanIndex + 1];

  String getDayPositionCaiDesc() =>
      LunarUtil.POSITION_DESC[getDayPositionCai()]!;

  String getTimePositionXi() => LunarUtil.POSITION_XI[_timeGanIndex + 1];

  String getTimePositionXiDesc() =>
      LunarUtil.POSITION_DESC[getTimePositionXi()]!;

  String getTimePositionYangGui() =>
      LunarUtil.POSITION_YANG_GUI[_timeGanIndex + 1];

  String getTimePositionYangGuiDesc() =>
      LunarUtil.POSITION_DESC[getTimePositionYangGui()]!;

  String getTimePositionYinGui() =>
      LunarUtil.POSITION_YIN_GUI[_timeGanIndex + 1];

  String getTimePositionYinGuiDesc() =>
      LunarUtil.POSITION_DESC[getTimePositionYinGui()]!;

  String getTimePositionFu([int sect = 2]) => (1 == sect
      ? LunarUtil.POSITION_FU
      : LunarUtil.POSITION_FU_2)[_timeGanIndex + 1];

  String getTimePositionFuDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getTimePositionFu(sect)]!;

  String getTimePositionCai() => LunarUtil.POSITION_CAI[_timeGanIndex + 1];

  String getTimePositionCaiDesc() =>
      LunarUtil.POSITION_DESC[getTimePositionCai()]!;

  String getYearPositionTaiSui([int sect = 2]) {
    int yearZhiIndex;
    switch (sect) {
      case 1:
        yearZhiIndex = _yearZhiIndex;
        break;
      case 3:
        yearZhiIndex = _yearZhiIndexExact;
        break;
      default:
        yearZhiIndex = _yearZhiIndexByLiChun;
    }
    return LunarUtil.POSITION_TAI_SUI_YEAR[yearZhiIndex];
  }

  String getYearPositionTaiSuiDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getYearPositionTaiSui(sect)]!;

  /// Lấy phương vị Thái Tuế của Tháng (Nguyệt Thái Tuế)
  /// Dựa trên Địa Chi và Thiên Can của tháng.
  String _getMonthPositionTaiSui(int monthZhiIndex, int monthGanIndex) {
    String p; // Biến lưu trữ phương vị
    // Tính toán chỉ số tháng `m` bắt đầu từ Dần = 0 (Dần có index 2)
    int m = monthZhiIndex - LunarUtil.BASE_MONTH_ZHI_INDEX;
    if (m < 0) {
      m += 12; // Đảm bảo m không âm
    }
    // Xác định phương vị dựa trên chỉ số tháng `m` (Tam Hợp cục)
    switch (m) {
      case 0: // Tháng Dần (m=0)
      case 4: // Tháng Ngọ (m=4)
      case 8: // Tháng Tuất (m=8)
        // Các tháng Dần, Ngọ, Tuất (Tam Hợp Hỏa cục) -> Thái Tuế ở Cấn
        p = 'Cấn'; // 艮
        break;
      case 2: // Tháng Thìn (m=2)
      case 6: // Tháng Thân (m=6)
      case 10: // Tháng Tý (m=10)
        // Các tháng Thân, Tý, Thìn (Tam Hợp Thủy cục) -> Thái Tuế ở Khôn
        p = 'Khôn'; // 坤
        break;
      case 3: // Tháng Tỵ (m=3)
      case 7: // Tháng Dậu (m=7)
      case 11: // Tháng Sửu (m=11)
        // Các tháng Tỵ, Dậu, Sửu (Tam Hợp Kim cục) -> Thái Tuế ở Tốn
        p = 'Tốn'; // 巽
        break;
      default: // Các tháng còn lại: Mão (m=1), Mùi (m=5), Hợi (m=9) (Tam Hợp Mộc cục)
        // Phương vị Thái Tuế lấy theo phương vị của Thiên Can tháng
        p = LunarUtil.POSITION_GAN[monthGanIndex];
    }
    // Trả về phương vị đã xác định
    return p;
  }

  String getMonthPositionTaiSui([int sect = 2]) {
    int monthZhiIndex;
    int monthGanIndex;
    switch (sect) {
      case 3:
        monthZhiIndex = _monthZhiIndexExact;
        monthGanIndex = _monthGanIndexExact;
        break;
      default:
        monthZhiIndex = _monthZhiIndex;
        monthGanIndex = _monthGanIndex;
    }
    return _getMonthPositionTaiSui(monthZhiIndex, monthGanIndex);
  }

  String getMonthPositionTaiSuiDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getMonthPositionTaiSui(sect)]!;

  /// Lấy phương vị Thái Tuế của Ngày (Nhật Thái Tuế)
  /// Dựa trên Can Chi của ngày và Địa Chi của năm.
  /// dayInGanZhi: Can Chi của ngày (ví dụ: 'Giáp Tý')
  /// yearZhiIndex: Chỉ số Địa Chi của năm (0-11)
  String _getDayPositionTaiSui(String dayInGanZhi, int yearZhiIndex) {
    String p; // Biến lưu trữ phương vị
    // Kiểm tra xem Can Chi của ngày thuộc nhóm nào
    if ('Giáp Tý,Ất Sửu,Bính Dần,Đinh Mão,Mậu Thìn,Kỷ Tỵ'
        .contains(dayInGanZhi)) {
      // Nếu là các ngày từ Giáp Tý đến Kỷ Tỵ
      p = 'Chấn'; // 震 (Đông)
    } else if ('Bính Tý,Đinh Sửu,Mậu Dần,Kỷ Mão,Canh Thìn,Tân Tỵ'
        .contains(dayInGanZhi)) {
      // Nếu là các ngày từ Bính Tý đến Tân Tỵ
      p = 'Ly'; // 离 (Nam)
    } else if ('Mậu Tý,Kỷ Sửu,Canh Dần,Tân Mão,Nhâm Thìn,Quý Tỵ'
        .contains(dayInGanZhi)) {
      // Nếu là các ngày từ Mậu Tý đến Quý Tỵ
      p = 'Trung'; // 中 (Trung Cung)
    } else if ('Canh Tý,Tân Sửu,Nhâm Dần,Quý Mão,Giáp Thìn,Ất Tỵ'
        .contains(dayInGanZhi)) {
      // Nếu là các ngày từ Canh Tý đến Ất Tỵ
      p = 'Đoài'; // 兑 (Tây)
    } else if ('Nhâm Tý,Quý Sửu,Giáp Dần,Ất Mão,Bính Thìn,Đinh Tỵ'
        .contains(dayInGanZhi)) {
      // Nếu là các ngày từ Nhâm Tý đến Đinh Tỵ
      p = 'Khảm'; // 坎 (Bắc)
    } else {
      // Nếu không thuộc các nhóm trên (thường là các ngày từ Canh Ngọ đến Quý Hợi),
      // thì phương vị Thái Tuế của ngày lấy theo phương vị Thái Tuế của năm.
      p = LunarUtil.POSITION_TAI_SUI_YEAR[yearZhiIndex];
    }
    // Trả về phương vị đã xác định
    return p;
  }

  String getDayPositionTaiSui([int sect = 2]) {
    String dayInGanZhi;
    int yearZhiIndex;
    switch (sect) {
      case 1:
        dayInGanZhi = getDayInGanZhi();
        yearZhiIndex = _yearZhiIndex;
        break;
      case 3:
        dayInGanZhi = getDayInGanZhi();
        yearZhiIndex = _yearZhiIndexExact;
        break;
      default:
        dayInGanZhi = getDayInGanZhiExact2();
        yearZhiIndex = _yearZhiIndexByLiChun;
    }
    return _getDayPositionTaiSui(dayInGanZhi, yearZhiIndex);
  }

  String getDayPositionTaiSuiDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getDayPositionTaiSui(sect)]!;

  @deprecated
  String getChong() => getDayChong();

  @deprecated
  String getChongGan() => getDayChongGan();

  @deprecated
  String getChongGanTie() => getDayChongGanTie();

  @deprecated
  String getChongShengXiao() => getDayChongShengXiao();

  @deprecated
  String getChongDesc() => getDayChongDesc();

  @deprecated
  String getSha() => getDaySha();

  String getYearNaYin() => LunarUtil.NAYIN[getYearInGanZhi()] ?? '';

  String getMonthNaYin() => LunarUtil.NAYIN[getMonthInGanZhi()] ?? '';

  String getDayNaYin() => LunarUtil.NAYIN[getDayInGanZhi()] ?? '';

  String getTimeNaYin() => LunarUtil.NAYIN[getTimeInGanZhi()] ?? '';

  List<String> getBaZi() {
    List<String> l = <String>[];
    EightChar eightChar = getEightChar();
    l.add(eightChar.getYear());
    l.add(eightChar.getMonth());
    l.add(eightChar.getDay());
    l.add(eightChar.getTime());
    return l;
  }

  List<String> getBaZiWuXing() {
    List<String> l = <String>[];
    EightChar eightChar = getEightChar();
    l.add(eightChar.getYearWuXing());
    l.add(eightChar.getMonthWuXing());
    l.add(eightChar.getDayWuXing());
    l.add(eightChar.getTimeWuXing());
    return l;
  }

  List<String> getBaZiNaYin() {
    List<String> l = <String>[];
    EightChar eightChar = getEightChar();
    l.add(eightChar.getYearNaYin());
    l.add(eightChar.getMonthNaYin());
    l.add(eightChar.getDayNaYin());
    l.add(eightChar.getTimeNaYin());
    return l;
  }

  List<String> getBaZiShiShenGan() {
    List<String> l = <String>[];
    EightChar eightChar = getEightChar();
    l.add(eightChar.getYearShiShenGan());
    l.add(eightChar.getMonthShiShenGan());
    l.add(eightChar.getDayShiShenGan());
    l.add(eightChar.getTimeShiShenGan());
    return l;
  }

  List<String> getBaZiShiShenZhi() {
    List<String> l = <String>[];
    EightChar eightChar = getEightChar();
    l.add(eightChar.getYearShiShenZhi()[0]);
    l.add(eightChar.getMonthShiShenZhi()[0]);
    l.add(eightChar.getDayShiShenZhi()[0]);
    l.add(eightChar.getTimeShiShenZhi()[0]);
    return l;
  }

  List<String> getBaZiShiShenYearZhi() => getEightChar().getYearShiShenZhi();

  List<String> getBaZiShiShenMonthZhi() => getEightChar().getMonthShiShenZhi();

  List<String> getBaZiShiShenDayZhi() => getEightChar().getDayShiShenZhi();

  List<String> getBaZiShiShenTimeZhi() => getEightChar().getTimeShiShenZhi();

  String getZhiXing() {
    int offset = _dayZhiIndex - _monthZhiIndex;
    if (offset < 0) {
      offset += 12;
    }
    return LunarUtil.ZHI_XING[offset + 1];
  }

  String getDayTianShen() {
    int offset = LunarUtil.ZHI_TIAN_SHEN_OFFSET[getMonthZhi()]!;
    return LunarUtil.TIAN_SHEN[(_dayZhiIndex + offset) % 12 + 1];
  }

  String getTimeTianShen() {
    int offset = LunarUtil.ZHI_TIAN_SHEN_OFFSET[getDayZhiExact()]!;
    return LunarUtil.TIAN_SHEN[(_timeZhiIndex + offset) % 12 + 1];
  }

  String getDayTianShenType() => LunarUtil.TIAN_SHEN_TYPE[getDayTianShen()]!;

  String getTimeTianShenType() => LunarUtil.TIAN_SHEN_TYPE[getTimeTianShen()]!;

  String getDayTianShenLuck() =>
      LunarUtil.TIAN_SHEN_TYPE_LUCK[getDayTianShenType()]!;

  String getTimeTianShenLuck() =>
      LunarUtil.TIAN_SHEN_TYPE_LUCK[getTimeTianShenType()]!;

  String getDayPositionTai() {
    return LunarUtil
        .POSITION_TAI_DAY[LunarUtil.getJiaZiIndex(getDayInGanZhi())];
  }

  String getMonthPositionTai() =>
      _month < 0 ? '' : LunarUtil.POSITION_TAI_MONTH[_month - 1];

  List<String> getDayYi() =>
      LunarUtil.getDayYi(getMonthInGanZhiExact(), getDayInGanZhi());

  List<String> getDayJi() =>
      LunarUtil.getDayJi(getMonthInGanZhiExact(), getDayInGanZhi());

  List<String> getDayJiShen() =>
      LunarUtil.getDayJiShen(getMonth(), getDayInGanZhi());

  List<String> getDayXiongSha() =>
      LunarUtil.getDayXiongSha(getMonth(), getDayInGanZhi());

  String getDayChong() => LunarUtil.CHONG[_dayZhiIndex];

  String getDaySha() => LunarUtil.SHA[getDayZhi()]!;

  String getDayChongDesc() =>
      '(${getDayChongGan()}${getDayChong()})${getDayChongShengXiao()}';

  String getDayChongShengXiao() {
    String chong = getDayChong();
    for (int i = 0, j = LunarUtil.ZHI.length; i < j; i++) {
      if (LunarUtil.ZHI[i] == chong) {
        return LunarUtil.SHENGXIAO[i];
      }
    }
    return '';
  }

  String getDayChongGan() => LunarUtil.CHONG_GAN[_dayGanIndex];

  String getDayChongGanTie() => LunarUtil.CHONG_GAN_TIE[_dayGanIndex];

  String getTimeChong() => LunarUtil.CHONG[_timeZhiIndex];

  String getTimeSha() => LunarUtil.SHA[getTimeZhi()]!;

  String getTimeChongShengXiao() {
    String chong = getTimeChong();
    for (int i = 0, j = LunarUtil.ZHI.length; i < j; i++) {
      if (LunarUtil.ZHI[i] == chong) {
        return LunarUtil.SHENGXIAO[i];
      }
    }
    return '';
  }

  String getTimeChongDesc() =>
      '(${getTimeChongGan()}${getTimeChong()})${getTimeChongShengXiao()}';

  String getTimeChongGan() => LunarUtil.CHONG_GAN[_timeGanIndex];

  String getTimeChongGanTie() => LunarUtil.CHONG_GAN_TIE[_timeGanIndex];

  List<String> getTimeYi() =>
      LunarUtil.getTimeYi(getDayInGanZhiExact(), getTimeInGanZhi());

  List<String> getTimeJi() =>
      LunarUtil.getTimeJi(getDayInGanZhiExact(), getTimeInGanZhi());

  String getYueXiang() => LunarUtil.YUE_XIANG[_day];

  NineStar _getYearNineStar(String yearInGanZhi) {
    int indexExact = LunarUtil.getJiaZiIndex(yearInGanZhi) + 1;
    int index = LunarUtil.getJiaZiIndex(this.getYearInGanZhi()) + 1;
    int yearOffset = indexExact - index;
    if (yearOffset > 1) {
      yearOffset -= 60;
    } else if (yearOffset < -1) {
      yearOffset += 60;
    }
    int yuan = ((_year + yearOffset + 2696) / 60).floor() % 3;
    int offset = (62 + yuan * 3 - indexExact) % 9;
    if (0 == offset) {
      offset = 9;
    }
    return NineStar.fromIndex(offset - 1);
  }

  NineStar getYearNineStar([int sect = 2]) {
    String yearInGanZhi;
    switch (sect) {
      case 1:
        yearInGanZhi = this.getYearInGanZhi();
        break;
      case 3:
        yearInGanZhi = this.getYearInGanZhiExact();
        break;
      default:
        yearInGanZhi = this.getYearInGanZhiByLiChun();
    }
    return _getYearNineStar(yearInGanZhi);
  }

  NineStar _getMonthNineStar(int yearZhiIndex, int monthZhiIndex) {
    int index = yearZhiIndex % 3;
    int n = 27 - (index * 3);
    if (monthZhiIndex < LunarUtil.BASE_MONTH_ZHI_INDEX) {
      n -= 3;
    }
    int offset = (n - monthZhiIndex) % 9;
    return NineStar.fromIndex(offset);
  }

  NineStar getMonthNineStar([int sect = 2]) {
    int yearZhiIndex;
    int monthZhiIndex;
    switch (sect) {
      case 1:
        yearZhiIndex = _yearZhiIndex;
        monthZhiIndex = _monthZhiIndex;
        break;
      case 3:
        yearZhiIndex = _yearZhiIndexExact;
        monthZhiIndex = _monthZhiIndexExact;
        break;
      default:
        yearZhiIndex = _yearZhiIndexByLiChun;
        monthZhiIndex = _monthZhiIndex;
    }
    return _getMonthNineStar(yearZhiIndex, monthZhiIndex);
  }

  NineStar getDayNineStar() {
    String solarYmd = _solar!.toYmd();
    Solar dongZhi = _jieQi['Đông Chí']!;
    Solar dongZhi2 = _jieQi['Đông Chí']!;
    Solar xiaZhi = _jieQi['Hạ Chí']!;
    int dongZhiIndex =
        LunarUtil.getJiaZiIndex(dongZhi.getLunar().getDayInGanZhi());
    int dongZhiIndex2 =
        LunarUtil.getJiaZiIndex(dongZhi2.getLunar().getDayInGanZhi());
    int xiaZhiIndex =
        LunarUtil.getJiaZiIndex(xiaZhi.getLunar().getDayInGanZhi());
    Solar solarShunBai;
    Solar solarShunBai2;
    Solar solarNiZi;
    if (dongZhiIndex > 29) {
      solarShunBai = dongZhi.next(60 - dongZhiIndex);
    } else {
      solarShunBai = dongZhi.next(-dongZhiIndex);
    }
    String solarShunBaiYmd = solarShunBai.toYmd();
    if (dongZhiIndex2 > 29) {
      solarShunBai2 = dongZhi2.next(60 - dongZhiIndex2);
    } else {
      solarShunBai2 = dongZhi2.next(-dongZhiIndex2);
    }
    String solarShunBaiYmd2 = solarShunBai2.toYmd();
    if (xiaZhiIndex > 29) {
      solarNiZi = xiaZhi.next(60 - xiaZhiIndex);
    } else {
      solarNiZi = xiaZhi.next(-xiaZhiIndex);
    }
    String solarNiZiYmd = solarNiZi.toYmd();
    int offset = 0;
    if (solarYmd.compareTo(solarShunBaiYmd) >= 0 &&
        solarYmd.compareTo(solarNiZiYmd) < 0) {
      offset = _solar!.subtract(solarShunBai) % 9;
    } else if (solarYmd.compareTo(solarNiZiYmd) >= 0 &&
        solarYmd.compareTo(solarShunBaiYmd2) < 0) {
      offset = 8 - (_solar!.subtract(solarNiZi) % 9);
    } else if (solarYmd.compareTo(solarShunBaiYmd2) >= 0) {
      offset = _solar!.subtract(solarShunBai2) % 9;
    } else if (solarYmd.compareTo(solarShunBaiYmd) < 0) {
      offset = (8 + solarShunBai.subtract(_solar!)) % 9;
    }
    return NineStar.fromIndex(offset);
  }

  /// Lấy Cửu Tinh của Giờ (Thời Phi Tinh)
  NineStar getTimeNineStar() {
    // Xác định chiều Thuận/Nghịch của Phi tinh trong ngày
    String solarYmd =
        _solar!.toYmd(); // Lấy ngày Dương lịch hiện tại dạng YYYY-MM-DD
    bool asc = false; // Biến xác định chiều thuận (true) hay nghịch (false)
    // Nếu ngày hiện tại nằm trong khoảng từ Đông Chí đến trước Hạ Chí
    if (solarYmd.compareTo(_jieQi['Đông Chí']!.toYmd()) >= 0 &&
        solarYmd.compareTo(_jieQi['Hạ Chí']!.toYmd()) < 0) {
      asc = true; // Chiều thuận
    }
    // Hoặc nếu ngày hiện tại từ Đông Chí của năm dương lịch tiếp theo trở đi
    // (Xử lý trường hợp qua năm mới dương lịch nhưng vẫn trong chu kỳ Đông Chí cũ)
    else if (solarYmd.compareTo(_jieQi['Đông Chí']!.toYmd()) >= 0) {
      asc = true; // Chiều thuận
    }
    // Xác định sao nhập trung cung (sao khởi đầu) cho giờ Tý
    // Mặc định cho các ngày Dần, Thân, Tỵ, Hợi (Tứ Mạnh/Tứ Sinh)
    int start =
        asc ? 6 : 2; // Thuận khởi từ Lục Bạch (6), Nghịch khởi từ Nhị Hắc (2)
    String dayZhi = getDayZhi(); // Lấy Địa Chi của ngày
    if ('TýNgọMãoDậu'.contains(dayZhi)) {
      // Nếu là ngày Tý, Ngọ, Mão, Dậu (Tứ Chính)
      start =
          asc ? 0 : 8; // Thuận khởi từ Nhất Bạch (0), Nghịch khởi từ Cửu Tử (8)
    } else if ('ThìnTuấtSửuMùi'.contains(dayZhi)) {
      // Nếu là ngày Thìn, Tuất, Sửu, Mùi (Tứ Mộ)
      start = asc
          ? 3
          : 5; // Thuận khởi từ Tứ Lục (3), Nghịch khởi từ Lục Bạch (5) - Lưu ý: Gốc ghi 5, cần kiểm tra lại lý thuyết, có thể là Ngũ Hoàng?
    }
    // Tính chỉ số sao cho giờ hiện tại (_timeZhiIndex là chỉ số Địa Chi của giờ, 0-11)
    int index = asc
        ? (start + _timeZhiIndex)
        : (start +
            9 -
            _timeZhiIndex); // Thuận: cộng tiến, Nghịch: cộng lùi (9 - chỉ số giờ)
    // Trả về đối tượng NineStar tương ứng với chỉ số cuối cùng (lấy dư 9 để đảm bảo trong khoảng 0-8)
    return NineStar.fromIndex(index % 9);
  }

  Map<String, Solar> getJieQiTable() => _jieQi;

  JieQi getNextJie([bool wholeDay = false]) {
    int l = (JIE_QI_IN_USE.length / 2).floor();
    List<String> conditions = <String>[];
    for (int i = 0; i < l; i++) {
      conditions.add(JIE_QI_IN_USE[i * 2]);
    }
    return _getNearJieQi(true, conditions, wholeDay)!;
  }

  JieQi getPrevJie([bool wholeDay = false]) {
    int l = (JIE_QI_IN_USE.length / 2).floor();
    List<String> conditions = <String>[];
    for (int i = 0; i < l; i++) {
      conditions.add(JIE_QI_IN_USE[i * 2]);
    }
    return _getNearJieQi(false, conditions, wholeDay)!;
  }

  JieQi getNextQi([bool wholeDay = false]) {
    int l = (JIE_QI_IN_USE.length / 2).floor();
    List<String> conditions = <String>[];
    for (int i = 0; i < l; i++) {
      conditions.add(JIE_QI_IN_USE[i * 2 + 1]);
    }
    return _getNearJieQi(true, conditions, wholeDay)!;
  }

  JieQi getPrevQi([bool wholeDay = false]) {
    int l = (JIE_QI_IN_USE.length / 2).floor();
    List<String> conditions = <String>[];
    for (int i = 0; i < l; i++) {
      conditions.add(JIE_QI_IN_USE[i * 2 + 1]);
    }
    return _getNearJieQi(false, conditions, wholeDay)!;
  }

  JieQi getNextJieQi([bool wholeDay = false]) =>
      _getNearJieQi(true, null, wholeDay)!;

  JieQi getPrevJieQi([bool wholeDay = false]) =>
      _getNearJieQi(false, null, wholeDay)!;

  JieQi? _getNearJieQi(bool forward, List<String>? conditions, bool wholeDay) {
    String? name;
    Solar? near;
    Set<String> filters = new Set<String>();
    if (null != conditions) {
      filters.addAll(conditions);
    }
    bool filter = filters.isNotEmpty;
    String today = wholeDay ? _solar!.toYmd() : _solar!.toYmdHms();
    for (MapEntry<String, Solar> entry in _jieQi.entries) {
      String jq = _convertJieQi(entry.key);
      if (filter) {
        if (!filters.contains(jq)) {
          continue;
        }
      }
      Solar solar = entry.value;
      String day = wholeDay ? solar.toYmd() : solar.toYmdHms();
      if (forward) {
        if (day.compareTo(today) <= 0) {
          continue;
        }
        if (null == near) {
          name = jq;
          near = solar;
        } else {
          String nearDay = wholeDay ? near.toYmd() : near.toYmdHms();
          if (day.compareTo(nearDay) < 0) {
            name = jq;
            near = solar;
          }
        }
      } else {
        if (day.compareTo(today) > 0) {
          continue;
        }
        if (null == near) {
          name = jq;
          near = solar;
        } else {
          String nearDay = wholeDay ? near.toYmd() : near.toYmdHms();
          if (day.compareTo(nearDay) > 0) {
            name = jq;
            near = solar;
          }
        }
      }
    }
    if (null == near) {
      return null;
    }
    return JieQi(name!, near);
  }

  String getJieQi() {
    for (MapEntry<String, Solar> jq in _jieQi.entries) {
      Solar d = jq.value;
      if (d.getYear() == _solar!.getYear() &&
          d.getMonth() == _solar!.getMonth() &&
          d.getDay() == _solar!.getDay()) {
        return _convertJieQi(jq.key);
      }
    }
    return '';
  }

  JieQi? getCurrentJieQi() {
    for (MapEntry<String, Solar> jq in _jieQi.entries) {
      Solar d = jq.value;
      if (d.getYear() == _solar!.getYear() &&
          d.getMonth() == _solar!.getMonth() &&
          d.getDay() == _solar!.getDay()) {
        return new JieQi(_convertJieQi(jq.key), d);
      }
    }
    return null;
  }

  JieQi? getCurrentJie() {
    for (int i = 0, j = JIE_QI_IN_USE.length; i < j; i += 2) {
      String key = JIE_QI_IN_USE[i];
      Solar? d = _jieQi[key];
      if (d!.getYear() == _solar!.getYear() &&
          d.getMonth() == _solar!.getMonth() &&
          d.getDay() == _solar!.getDay()) {
        return new JieQi(_convertJieQi(key), d);
      }
    }
    return null;
  }

  JieQi? getCurrentQi() {
    for (int i = 1, j = JIE_QI_IN_USE.length; i < j; i += 2) {
      String key = JIE_QI_IN_USE[i];
      Solar? d = _jieQi[key];
      if (d!.getYear() == _solar!.getYear() &&
          d.getMonth() == _solar!.getMonth() &&
          d.getDay() == _solar!.getDay()) {
        return new JieQi(_convertJieQi(key), d);
      }
    }
    return null;
  }

  /// Trả về chuỗi đầy đủ thông tin chi tiết của ngày Âm lịch
  String toFullString() {
    String s = '';
    // Thêm thông tin ngày giờ cơ bản (thường là Dương lịch)
    s += toString();
    s += ' ';
    // Năm
    s += getYearInGanZhi(); // Can Chi năm
    s += '(';
    s += getYearShengXiao(); // Con giáp năm
    s += ') Năm ';
    // Tháng
    s += getMonthInGanZhi(); // Can Chi tháng
    s += '(';
    s += getMonthShengXiao(); // Con giáp tháng
    s += ') Tháng ';
    // Ngày
    s += getDayInGanZhi(); // Can Chi ngày
    s += '(';
    s += getDayShengXiao(); // Con giáp ngày
    s += ') Ngày ';
    // Giờ
    s += getTimeZhi(); // Chi giờ
    s += '(';
    s += getTimeShengXiao(); // Con giáp giờ
    s += ') Giờ ';
    // Nạp Âm
    s += 'Nạp Âm['; // 纳音
    s += getYearNaYin(); // Nạp âm năm
    s += ' ';
    s += getMonthNaYin(); // Nạp âm tháng
    s += ' ';
    s += getDayNaYin(); // Nạp âm ngày
    s += ' ';
    s += getTimeNaYin(); // Nạp âm giờ
    s += '] ';
    // Thứ
    s += 'Thứ '; // 星期
    s +=
        getWeekInChinese(); // Tên thứ bằng tiếng Việt (cần đảm bảo hàm này trả về tiếng Việt)
    // Lễ hội chính
    for (String f in getFestivals()) {
      s += ' (';
      s += f; // Tên lễ hội
      s += ')';
    }
    // Lễ hội khác
    for (String f in getOtherFestivals()) {
      s += ' (';
      s += f; // Tên lễ hội khác
      s += ')';
    }
    // Tiết Khí
    String jq = getJieQi(); // Lấy tên Tiết Khí
    if (jq.isNotEmpty) {
      // Nếu có Tiết Khí trong ngày
      s += ' [';
      s += jq; // Tên Tiết Khí
      s += ']';
    }
    s += ' ';
    // Sao (Tú)
    s += getGong(); // Cung (Phương vị của sao)
    s += ' Phương '; // 方
    s += getShou(); // Thú (Tứ tượng)
    s += ' Sao/Tú['; // 星宿
    s += getXiu(); // Tên sao Tú
    s += getZheng(); // Thuộc tính (Ngũ hành/Âm Dương) của sao Tú
    s += getAnimal(); // Động vật tượng trưng của sao Tú
    s += '](';
    s += getXiuLuck(); // Cát/Hung của sao Tú
    s += ') ';
    // Bành Tổ Bách Kỵ
    s += 'Bành Tổ Bách Kỵ['; // 彭祖百忌
    s += getPengZuGan(); // Kỵ theo Can ngày
    s += ' ';
    s += getPengZuZhi(); // Kỵ theo Chi ngày
    s += '] ';
    // Phương vị Thần Sát trong ngày
    s += 'Phương Hỷ Thần['; // 喜神方位
    s += getDayPositionXi(); // Cung vị
    s += '](';
    s += getDayPositionXiDesc(); // Mô tả phương vị
    s += ') ';
    s += 'Phương Dương Quý Nhân['; // 阳贵神方位
    s += getDayPositionYangGui(); // Cung vị
    s += '](';
    s += getDayPositionYangGuiDesc(); // Mô tả phương vị
    s += ') ';
    s += 'Phương Âm Quý Nhân['; // 阴贵神方位
    s += getDayPositionYinGui(); // Cung vị
    s += '](';
    s += getDayPositionYinGuiDesc(); // Mô tả phương vị
    s += ') ';
    s += 'Phương Phúc Thần['; // 福神方位
    s += getDayPositionFu(); // Cung vị
    s += '](';
    s += getDayPositionFuDesc(); // Mô tả phương vị
    s += ') ';
    s += 'Phương Tài Thần['; // 财神方位
    s += getDayPositionCai(); // Cung vị
    s += '](';
    s += getDayPositionCaiDesc(); // Mô tả phương vị
    s += ') ';
    // Xung và Sát
    s += 'Xung['; // 冲
    s += getDayChongDesc(); // Mô tả con giáp/hướng bị xung
    s += '] ';
    s += 'Sát['; // 煞
    s += getDaySha(); // Hướng Sát
    s += ']';
    // Trả về chuỗi hoàn chỉnh
    return s;
  }

  @override
  String toString() =>
      'Năm ${getYearInChinese()} Tháng ${getMonthInChinese()} Ngày ${getDayInChinese()}';

  int getTimeGanIndex() => _timeGanIndex;

  int getTimeZhiIndex() => _timeZhiIndex;

  int getDayGanIndex() => _dayGanIndex;

  int getDayZhiIndex() => _dayZhiIndex;

  int getMonthGanIndex() => _monthGanIndex;

  int getMonthZhiIndex() => _monthZhiIndex;

  int getYearGanIndex() => _yearGanIndex;

  int getYearZhiIndex() => _yearZhiIndex;

  int getYearGanIndexByLiChun() => _yearGanIndexByLiChun;

  int getYearZhiIndexByLiChun() => _yearZhiIndexByLiChun;

  int getDayGanIndexExact() => _dayGanIndexExact;

  int getDayGanIndexExact2() => _dayGanIndexExact2;

  int getDayZhiIndexExact() => _dayZhiIndexExact;

  int getDayZhiIndexExact2() => _dayZhiIndexExact2;

  int getMonthGanIndexExact() => _monthGanIndexExact;

  int getMonthZhiIndexExact() => _monthZhiIndexExact;

  int getYearGanIndexExact() => _yearGanIndexExact;

  int getYearZhiIndexExact() => _yearZhiIndexExact;

  Solar getSolar() => _solar!;

  EightChar getEightChar() {
    if (null == _eightChar) {
      _eightChar = new EightChar(this);
    }
    return _eightChar!;
  }

  Lunar next(int days) => _solar!.next(days).getLunar();

  String getYearXun() => LunarUtil.getXun(getYearInGanZhi());

  String getYearXunByLiChun() => LunarUtil.getXun(getYearInGanZhiByLiChun());

  String getYearXunExact() => LunarUtil.getXun(getYearInGanZhiExact());

  String getYearXunKong() => LunarUtil.getXunKong(getYearInGanZhi());

  String getYearXunKongByLiChun() =>
      LunarUtil.getXunKong(getYearInGanZhiByLiChun());

  String getYearXunKongExact() => LunarUtil.getXunKong(getYearInGanZhiExact());

  String getMonthXun() => LunarUtil.getXun(getMonthInGanZhi());

  String getMonthXunExact() => LunarUtil.getXun(getMonthInGanZhiExact());

  String getMonthXunKong() => LunarUtil.getXunKong(getMonthInGanZhi());

  String getMonthXunKongExact() =>
      LunarUtil.getXunKong(getMonthInGanZhiExact());

  String getDayXun() => LunarUtil.getXun(getDayInGanZhi());

  String getDayXunExact() => LunarUtil.getXun(getDayInGanZhiExact());

  String getDayXunExact2() => LunarUtil.getXun(getDayInGanZhiExact2());

  String getDayXunKong() => LunarUtil.getXunKong(getDayInGanZhi());

  String getDayXunKongExact() => LunarUtil.getXunKong(getDayInGanZhiExact());

  String getDayXunKongExact2() => LunarUtil.getXunKong(getDayInGanZhiExact2());

  String getTimeXun() => LunarUtil.getXun(getTimeInGanZhi());

  String getTimeXunKong() => LunarUtil.getXunKong(getTimeInGanZhi());

  /// Lấy thông tin Số Cửu (Shu Jiu - Đếm Cửu sau Đông Chí)
  /// Số Cửu là khoảng thời gian 81 ngày sau Đông Chí, chia thành 9 giai đoạn, mỗi giai đoạn 9 ngày (Cửu).
  ShuJiu? getShuJiu() {
    // Lấy ngày Dương lịch hiện tại (chỉ cần Năm, Tháng, Ngày)
    Solar current =
        Solar.fromYmd(_solar!.getYear(), _solar!.getMonth(), _solar!.getDay());
    // Lấy ngày Đông Chí của năm dương lịch tiếp theo (để xử lý trường hợp cuối năm)
    Solar start = _jieQi[
        'Đông Chí']!; // Giả sử 'DONG_ZHI' là Đông Chí của năm dương lịch sau _solar
    // Chỉ lấy thông tin Năm, Tháng, Ngày của ngày bắt đầu (Đông Chí)
    start = Solar.fromYmd(start.getYear(), start.getMonth(), start.getDay());

    // Nếu ngày hiện tại trước ngày Đông Chí của năm dương lịch tiếp theo,
    // thì phải lấy ngày Đông Chí của năm dương lịch hiện tại (hoặc năm trước đó).
    if (current.isBefore(start)) {
      start = _jieQi['Đông Chí']!; // Lấy Đông Chí của năm âm lịch hiện tại
      // Chỉ lấy thông tin Năm, Tháng, Ngày
      start = Solar.fromYmd(start.getYear(), start.getMonth(), start.getDay());
    }

    // Tính ngày kết thúc của giai đoạn Số Cửu (81 ngày sau ngày bắt đầu)
    Solar end = Solar.fromYmd(start.getYear(), start.getMonth(), start.getDay())
        .next(81);

    // Kiểm tra xem ngày hiện tại có nằm trong khoảng thời gian Số Cửu không
    // (Từ ngày Đông Chí đến trước ngày thứ 82)
    if (current.isBefore(start) || !current.isBefore(end)) {
      // Nếu không nằm trong khoảng, trả về null
      return null;
    }

    // Tính số ngày đã trôi qua kể từ ngày Đông Chí
    int days = current.subtract(start);
    // Tạo và trả về đối tượng ShuJiu
    // Tên: Số đếm (Một, Hai,...) + "Cửu" (ví dụ: "Nhất Cửu", "Nhị Cửu")
    // Ngày thứ: Ngày thứ mấy trong giai đoạn 9 ngày đó (1-9)
    return ShuJiu(
        LunarUtil.NUMBER[(days / 9).floor() + 1] + ' Cửu', days % 9 + 1);
  }

  /// Lấy thông tin Tam Phục (Fu - những ngày nóng nhất mùa hè)
  /// Tam Phục bao gồm: Sơ Phục (初伏), Trung Phục (中伏), Mạt Phục (末伏).
  /// Việc tính toán dựa vào ngày Hạ Chí, ngày Lập Thu và các ngày Canh (庚).
  Fu? getFu() {
    // Lấy ngày Dương lịch hiện tại (chỉ cần Năm, Tháng, Ngày)
    Solar current =
        Solar.fromYmd(_solar!.getYear(), _solar!.getMonth(), _solar!.getDay());
    // Lấy ngày Hạ Chí
    Solar haChi = _jieQi['Hạ Chí']!;
    // Lấy ngày Lập Thu
    Solar lapThu = _jieQi['Lập Thu']!;
    // Ngày bắt đầu tính toán, khởi tạo bằng ngày Hạ Chí
    Solar start =
        Solar.fromYmd(haChi.getYear(), haChi.getMonth(), haChi.getDay());

    // Tìm ngày Canh (庚) đầu tiên sau ngày Hạ Chí
    // 6 là chỉ số của Canh (0=Giáp, ..., 6=Canh)
    int add = 6 -
        haChi.getLunar().getDayGanIndex(); // Số ngày từ Can của Hạ Chí đến Canh
    if (add < 0) {
      add += 10; // Đảm bảo số ngày là dương
    }

    // Tìm ngày Canh thứ 3 sau ngày Hạ Chí, đây là ngày bắt đầu Sơ Phục (初伏)
    add += 20; // Thêm 20 ngày (2 chu kỳ 10 Can)
    start = start.next(add); // start bây giờ là ngày đầu tiên của Sơ Phục

    // Nếu ngày hiện tại trước ngày bắt đầu Sơ Phục
    if (current.isBefore(start)) {
      // Chưa vào Tam Phục, trả về null
      return null;
    }

    // Tính số ngày đã trôi qua kể từ đầu Sơ Phục
    int days = current.subtract(start);
    // Sơ Phục kéo dài 10 ngày
    if (days < 10) {
      // Trả về thông tin Sơ Phục và ngày thứ mấy (từ 1 đến 10)
      return Fu('Sơ Phục', days + 1); // 初伏
    }

    // Tìm ngày Canh thứ 4 sau Hạ Chí, đây là ngày bắt đầu Trung Phục (中伏)
    start = start.next(10); // Ngày Canh tiếp theo (10 ngày sau)
    // Tính số ngày đã trôi qua kể từ đầu Trung Phục
    days = current.subtract(start);
    // Trung Phục có thể kéo dài 10 hoặc 20 ngày
    // Nếu trong 10 ngày đầu tiên của Trung Phục
    if (days < 10) {
      // Trả về thông tin Trung Phục và ngày thứ mấy (từ 1 đến 10)
      return Fu('Trung Phục', days + 1); // 中伏
    }

    // Tìm ngày Canh thứ 5 sau Hạ Chí
    start = start.next(10); // Ngày Canh tiếp theo (10 ngày sau)
    // Tính số ngày đã trôi qua kể từ ngày Canh thứ 5
    days = current.subtract(start);

    // Lấy ngày Lập Thu (chỉ cần Năm, Tháng, Ngày)
    Solar lapThuSolar =
        Solar.fromYmd(lapThu.getYear(), lapThu.getMonth(), lapThu.getDay());

    // Kiểm tra xem ngày Lập Thu có đến sau ngày Canh thứ 5 hay không
    // Nếu Lập Thu đến sau ngày Canh thứ 5 -> Trung Phục kéo dài 20 ngày
    if (lapThuSolar.isAfter(start)) {
      // Nếu vẫn trong 10 ngày tiếp theo (ngày 11-20 của Trung Phục)
      if (days < 10) {
        // Trả về thông tin Trung Phục và ngày thứ mấy (từ 11 đến 20)
        return Fu('Trung Phục', days + 11); // 中伏
      }
      // Nếu đã qua 20 ngày Trung Phục, tìm ngày Canh thứ 6 (bắt đầu Mạt Phục)
      start = start.next(10); // Ngày Canh tiếp theo (10 ngày sau)
      // Tính lại số ngày đã trôi qua kể từ đầu Mạt Phục
      days = current.subtract(start);
    }
    // Nếu Lập Thu đến vào hoặc trước ngày Canh thứ 5 -> Trung Phục chỉ kéo dài 10 ngày
    // và ngày Canh thứ 5 là ngày bắt đầu Mạt Phục (末伏)

    // Mạt Phục kéo dài 10 ngày
    if (days < 10) {
      // Trả về thông tin Mạt Phục và ngày thứ mấy (từ 1 đến 10)
      return Fu('Mạt Phục', days + 1); // 末伏
    }

    // Nếu đã qua cả Mạt Phục, trả về null
    return null;
  }

  String getLiuYao() => LunarUtil.LIU_YAO[(_month.abs() - 1 + _day - 1) % 6];

  String getWuHou() {
    JieQi jieQi = getPrevJieQi(true);
    int offset = 0;
    for (int i = 0, j = JieQi.JIE_QI.length; i < j; i++) {
      if (jieQi.getName() == JieQi.JIE_QI[i]) {
        offset = i;
        break;
      }
    }
    int index = (_solar!.subtract(jieQi.getSolar()) / 5).floor();
    if (index > 2) {
      index = 2;
    }
    return LunarUtil.WU_HOU[(offset * 3 + index) % LunarUtil.WU_HOU.length];
  }

  String getHou() {
    JieQi jieQi = getPrevJieQi(true);
    String name = jieQi.getName();
    int max = LunarUtil.HOU.length - 1;
    int offset = (_solar!.subtract(jieQi.getSolar()) / 5).floor();
    if (offset > max) {
      offset = max;
    }
    String hou = LunarUtil.HOU[offset];
    return '$name $hou';
  }

  /// Lấy thông tin Lộc của ngày (Nhật Lộc)
  /// Bao gồm Hỗ Lộc (Lộc của Can ngày) và Tiến Lộc (Lộc của Chi ngày, nếu có).
  String getDayLu() {
    // Lấy Chi là Lộc của Can ngày (ví dụ: Can Giáp -> Chi Dần)
    String ganLuChi = LunarUtil.LU[getDayGan()]!;
    // Lấy Can là Lộc của Chi ngày (ví dụ: Chi Dần -> Can Giáp), có thể không tồn tại (null)
    String? zhiLuCan = LunarUtil.LU[getDayZhi()];
    // Khởi tạo chuỗi với thông tin Hỗ Lộc
    // '命互禄' (Mệnh Hỗ Lộc): Lộc của Can ngày (là Chi này)
    String lu = ganLuChi + ' Hỗ Lộc'; // Ví dụ: "Dần Hỗ Lộc"
    // Nếu tồn tại Can Lộc cho Chi ngày
    if (null != zhiLuCan) {
      // Thêm thông tin Tiến Lộc vào chuỗi
      // '命进禄' (Mệnh Tiến Lộc): Lộc của Chi ngày (là Can này)
      lu += ' ' + zhiLuCan + ' Tiến Lộc'; // Ví dụ: " Giáp Tiến Lộc"
    }
    // Trả về chuỗi kết quả, ví dụ: "Dần Hỗ Lộc Giáp Tiến Lộc"
    return lu;
  }

  LunarTime getTime() =>
      LunarTime.fromYmdHms(_year, _month, _day, _hour, _minute, _second);

  List<LunarTime> getTimes() {
    List<LunarTime> l = <LunarTime>[];
    l.add(LunarTime.fromYmdHms(_year, _month, _day, 0, 0, 0));
    for (int i = 0; i < 12; i++) {
      l.add(LunarTime.fromYmdHms(_year, _month, _day, (i + 1) * 2 - 1, 0, 0));
    }
    return l;
  }

  Foto getFoto() => Foto.fromLunar(this);

  Tao getTao() => Tao.fromLunar(this);
}
