import '../../lunar.dart'; // Giữ lại import này

/// Vận (Tính toán khởi điểm Đại Vận)
/// @author 6tail
class Yun {
  /// Giới tính (1 nam, 0 nữ)
  int _gender = 0;

  /// Số năm khởi vận
  int _startYear = 0;

  /// Số tháng khởi vận
  int _startMonth = 0;

  /// Số ngày khởi vận
  int _startDay = 0;

  /// Số giờ khởi vận (chỉ dùng khi sect = 2)
  int _startHour = 0;

  /// Có phải là đẩy thuận hay không (true = thuận, false = nghịch)
  bool _forward = false;

  /// Âm lịch của ngày sinh
  Lunar? _lunar;

  /// Khởi tạo đối tượng Vận.
  ///
  /// [eightChar] Đối tượng Bát Tự (Tứ Trụ).
  /// [gender] Giới tính (1 = nam, 0 = nữ).
  /// [sect] Cách tính (mặc định là 1, có thể là 2).
  ///        Cách 1: 3 ngày = 1 năm, 1 ngày = 4 tháng, 1 giờ = 10 ngày.
  ///        Cách 2: 1 ngày = 1 năm. (Ít dùng hơn)
  Yun(EightChar eightChar, int gender, [int sect = 1]) {
    _lunar = eightChar.getLunar();
    _gender = gender;
    // Kiểm tra năm sinh là Dương hay Âm dựa vào Can năm
    bool isYearYang =
        _lunar!.getYearGanIndexExact() % 2 == 0; // Can chẵn là Dương
    // Kiểm tra giới tính là Nam hay Nữ
    bool isMale = 1 == gender;
    // Nam Dương Nữ Âm thì đẩy thuận, Nam Âm Nữ Dương thì đẩy nghịch
    _forward = (isYearYang && isMale) || (!isYearYang && !isMale);
    _computeStart(sect);
  }

  /// Tính toán thời gian khởi vận (năm, tháng, ngày, giờ).
  ///
  /// [sect] Cách tính (1 hoặc 2).
  void _computeStart(int sect) {
    // Lấy Tiết Khí (Jie) trước ngày sinh
    JieQi prevJie = _lunar!.getPrevJie();
    // Lấy Tiết Khí (Jie) sau ngày sinh
    JieQi nextJie = _lunar!.getNextJie();
    // Ngày sinh Dương lịch
    Solar current = _lunar!.getSolar();

    // Xác định ngày bắt đầu và kết thúc khoảng thời gian tính toán
    // Nếu đẩy thuận (forward = true): từ ngày sinh đến Tiết sau
    // Nếu đẩy nghịch (forward = false): từ Tiết trước đến ngày sinh
    Solar start = _forward ? current : prevJie.getSolar();
    Solar end = _forward ? nextJie.getSolar() : current;

    int year;
    int month;
    int day;
    int hour = 0; // Giờ khởi vận chỉ tính ở cách 2

    if (2 == sect) {
      // Cách tính 2: 1 ngày = 1 năm, 1 giờ = 5 ngày (12 phút = 1 ngày)
      int minutes = end.subtractMinute(start); // Tổng số phút chênh lệch
      year = (minutes / (60 * 24)).floor(); // 1 ngày = 1 năm
      minutes -= year * (60 * 24);
      month =
          (minutes / (60 * 2)).floor(); // 2 giờ = 1 tháng (120 phút = 1 tháng)
      minutes -= month * (60 * 2);
      day = (minutes / 12).floor(); // 12 phút = 1 ngày
      minutes -= day * 12;
      hour = (minutes / 0.5)
          .floor(); // 0.5 phút = 1 giờ khởi vận? (Logic này cần xem lại)
      // Hoặc có thể là: 1 phút = 2 giờ khởi vận
      // Gốc tiếng Trung: hour = minutes * 2;
      hour = minutes * 2; // Theo code gốc
    } else {
      // Cách tính 1 (phổ biến): 3 ngày = 1 năm, 1 ngày = 4 tháng, 1 giờ (Can Chi) = 10 ngày
      // Lấy giờ Can Chi của ngày kết thúc
      int endTimeZhiIndex = (end.getHour() == 23)
          ? 11 // Giờ Tý (23h-1h) tính là index 11 (Hợi) trong cách tính này? Cần xem lại LunarUtil
          : LunarUtil.getTimeZhiIndex(end.toYmdHms().substring(11, 16));
      // Lấy giờ Can Chi của ngày bắt đầu
      int startTimeZhiIndex = (start.getHour() == 23)
          ? 11
          : LunarUtil.getTimeZhiIndex(start.toYmdHms().substring(11, 16));

      // Chênh lệch số giờ Can Chi (mỗi giờ Can Chi = 2 tiếng)
      int hourDiff = endTimeZhiIndex - startTimeZhiIndex;
      // Chênh lệch số ngày
      int dayDiff = end.subtract(start);

      // Nếu giờ kết thúc nhỏ hơn giờ bắt đầu (qua ngày mới), giảm ngày đi 1 và cộng 12 giờ Can Chi
      if (hourDiff < 0) {
        hourDiff += 12;
        dayDiff--;
      }

      // Quy đổi: 1 giờ Can Chi = 10 ngày khởi vận
      // Quy đổi: 1 ngày = 4 tháng khởi vận (120 ngày khởi vận)
      // Quy đổi: 3 ngày = 1 năm khởi vận (360 ngày khởi vận)
      int totalDaysFromHours = hourDiff * 10; // Tổng số ngày khởi vận từ giờ
      int totalMonthsFromDays = dayDiff * 4; // Tổng số tháng khởi vận từ ngày

      // Tính tổng số tháng khởi vận (làm tròn xuống từ ngày quy đổi từ giờ)
      int monthFromHours = (totalDaysFromHours / 30).floor();
      month = totalMonthsFromDays + monthFromHours;

      // Tính số ngày khởi vận còn lại (sau khi đã trừ đi phần quy ra tháng)
      day = totalDaysFromHours - monthFromHours * 30;

      // Quy đổi tháng ra năm
      year = (month / 12).floor();
      // Số tháng khởi vận còn lại (sau khi đã trừ đi phần quy ra năm)
      month = month - year * 12;
    }
    _startYear = year;
    _startMonth = month;
    _startDay = day;
    _startHour = hour; // Chỉ có giá trị nếu sect = 2
  }

  /// Lấy giới tính (1 = nam, 0 = nữ).
  int getGender() => _gender;

  /// Lấy số năm khởi vận.
  int getStartYear() => _startYear;

  /// Lấy số tháng khởi vận.
  int getStartMonth() => _startMonth;

  /// Lấy số ngày khởi vận.
  int getStartDay() => _startDay;

  /// Lấy số giờ khởi vận (chỉ có giá trị nếu dùng cách tính 2).
  int getStartHour() => _startHour;

  /// Kiểm tra hướng đẩy vận (true = thuận, false = nghịch).
  bool isForward() => _forward;

  /// Lấy đối tượng Âm lịch của ngày sinh.
  Lunar getLunar() => _lunar!;

  /// Lấy ngày Dương lịch chính xác bắt đầu Đại Vận đầu tiên.
  Solar getStartSolar() {
    Solar solar = _lunar!.getSolar();
    // Cộng thêm số năm, tháng, ngày, giờ khởi vận vào ngày sinh Dương lịch
    solar = solar.nextYear(_startYear);
    solar = solar.nextMonth(_startMonth);
    solar = solar.nextDay(_startDay);
    // Giờ chỉ cộng nếu dùng cách tính 2 (vì cách 1 không tính giờ khởi vận)
    if (_startHour > 0) {
      solar = solar.nextHour(_startHour);
    }
    return solar;
  }

  /// Lấy 10 vòng Đại Vận đầu tiên.
  List<DaYun> getDaYun() {
    return getDaYunBy(10);
  }

  /// Lấy danh sách các vòng Đại Vận.
  ///
  /// [n] Số vòng Đại Vận muốn lấy (mỗi vòng 10 năm).
  List<DaYun> getDaYunBy(int n) {
    List<DaYun> l = <DaYun>[];
    // Vòng 0 đại diện cho thời gian trước khi vào Đại Vận đầu tiên
    // Các vòng tiếp theo là các Đại Vận 10 năm
    for (int i = 0; i < n; i++) {
      l.add(DaYun(this, i));
    }
    return l;
  }
}
