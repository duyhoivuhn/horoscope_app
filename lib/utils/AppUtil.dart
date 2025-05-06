import 'package:horoscope_app/lunar/calendar/EightChar.dart';
import 'package:horoscope_app/lunar/calendar/Lunar.dart';
import 'package:horoscope_app/lunar/calendar/Solar.dart';
import 'package:horoscope_app/lunar/calendar/eightchar/Yun.dart';
import 'package:horoscope_app/lunar/calendar/util/LunarUtil.dart';

class AppUtil {
  final DateTime solarDateTime;

  AppUtil({required this.solarDateTime});

  static Map<String, List<String>> canThangTable = {
    'Giáp': [
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
    ],
    'Kỷ': [
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
    ],
    'Ất': [
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
    ],
    'Canh': [
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
    ],
    'Bính': [
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
    ],
    'Tân': [
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
    ],
    'Đinh': [
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
    ],
    'Nhâm': [
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
    ],
    'Mậu': [
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
    ],
    'Quý': [
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
    ],
  };

  String getThienCanGio() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getTimeGan();
  }

  String getThienCanNgay() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getDayGan();
  }

  String getThienCanThang({required int thang}) {
    if (!canThangTable.containsKey(getThienCanNam())) {
      throw ArgumentError('Thiên can năm không hợp lệ: $getThienCanNam');
    }
    if (thang < 1 || thang > 12) {
      throw ArgumentError('Tháng âm lịch phải từ 1 đến 12');
    }
    return canThangTable[getThienCanNam()]![thang - 1];
  }

  String getThienCanNam() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getYearGan();
  }

  String getDiaChiGio() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getTimeZhi();
  }

  String getDiaChiNgay() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getDayZhi();
  }

  String getDiaChiThang() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getDayZhi();
  }

  String getDiaChiNam() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    return lunarDate.getYearZhi();
  }

  List<String> getTangCanGio() {
    final list = LunarUtil.ZHI_HIDE_GAN[getDiaChiGio()];
    return (list ?? []);
  }

  List<String> getTangCanNgay() {
    final list = LunarUtil.ZHI_HIDE_GAN[getDiaChiNgay()];
    return (list ?? []);
  }

  List<String> getTangCanThang() {
    final list = LunarUtil.ZHI_HIDE_GAN[getDiaChiThang()];
    return (list ?? []);
  }

  List<String> getTangCanNam() {
    final list = LunarUtil.ZHI_HIDE_GAN[getDiaChiNam()];
    return (list ?? []);
  }

  String getTruongSinhGio() {
    try {
      final lunarDate = Lunar.fromDate(solarDateTime);
      final eightChar = EightChar.fromLunar(lunarDate);
      final truongSinhGio = eightChar.getTimeDiShi();
      return truongSinhGio;
    } catch (e) {
      return '';
    }
  }

  String getTruongSinhNgay() {
    try {
      final lunarDate = Lunar.fromDate(solarDateTime);
      final eightChar = EightChar.fromLunar(lunarDate);
      final truongSinhDay = eightChar.getDayDiShi();
      return truongSinhDay;
    } catch (e) {
      return '';
    }
  }

  String getTruongSinhThang() {
    try {
      final lunarDate = Lunar.fromDate(solarDateTime);
      final eightChar = EightChar.fromLunar(lunarDate);
      final truongSinhDay = eightChar.getMonthDiShi();
      return truongSinhDay;
    } catch (e) {
      return '';
    }
  }

  String getTruongSinhNam() {
    try {
      final lunarDate = Lunar.fromDate(solarDateTime);
      final eightChar = EightChar.fromLunar(lunarDate);
      final truongSinhDay = eightChar.getYearDiShi();
      return truongSinhDay;
    } catch (e) {
      return '';
    }
  }

  String getThapThanGio() {
    final day = getThienCanNgay();
    final hour = getThienCanGio();
    return LunarUtil.SHI_SHEN['$day$hour'] ?? '';
  }

  String getThapThanNgay() {
    return 'Nhật Chủ';
  }

  String getThapThanThang() {
    final day = getThienCanNgay();
    final hour = getThienCanThang(thang: solarDateTime.month);
    return LunarUtil.SHI_SHEN['$day$hour'] ?? '';
  }

  String getThapThanNam() {
    final day = getThienCanNgay();
    final hour = getThienCanNam();
    return LunarUtil.SHI_SHEN['$day$hour'] ?? '';
  }

  String getNapAmNam() {
    final key = '${getThienCanNam()}${getDiaChiNam()}';
    return LunarUtil.NAYIN[key] ?? '';
  }

  String getNapAmThang() {
    final key =
        '${getThienCanThang(thang: solarDateTime.month)}${getDiaChiThang()}';
    return LunarUtil.NAYIN[key] ?? '';
  }

  String getNapAmNgay() {
    final key = '${getThienCanNgay()}${getDiaChiNgay()}';
    return LunarUtil.NAYIN[key] ?? '';
  }

  String getNapAmGio() {
    final key = '${getThienCanGio()}${getDiaChiGio()}';
    return LunarUtil.NAYIN[key] ?? '';
  }

  /// Trả về tuổi khởi vận dựa trên ngày sinh và tiết khí kế tiếp (hoặc trước)
  String tinhTuoiKhoiVan({
    required DateTime ngaySinh,
    required DateTime tietKhi,
    required bool laNam, // true nếu là nam, false nếu là nữ
  }) {
    // Nếu là nam, tính đến tiết khí kế tiếp
    // Nếu là nữ, tính từ tiết khí trước
    Duration diff =
        laNam ? tietKhi.difference(ngaySinh) : ngaySinh.difference(tietKhi);

    int totalDays = diff.inDays;

    // Mỗi ngày tương đương 1/3 tháng, 3 ngày = 1 tháng
    int totalMonths = (totalDays / 3).round();
    int years = totalMonths ~/ 12;
    int months = totalMonths % 12;

    // Phần lẻ ngày còn lại (ví dụ 0.7 tháng = 21 ngày)
    int remainingDays = ((totalDays / 3) - totalMonths) * 30 ~/ 1;

    return 'Bắt đầu từ: $years tuổi $months tháng $remainingDays ngày';
  }

  int getTuoiKhoiVan({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    required int second,
    required bool isMale,
    int sectYun = 1, // Thường dùng sect=1 cho khởi Đại Vận
    int sectEightChar = 2, // Thường dùng sect=2 cho Can Chi ngày
  }) {
    try {
      final solarBirth = Solar.fromYmdHms(
        year,
        month,
        day,
        hour,
        minute,
        second,
      );
      final lunarBirth = Lunar.fromSolar(solarBirth);
      final eightCharBirth = EightChar.fromLunar(lunarBirth);
      eightCharBirth.setSect(sectEightChar);
      final int gender = isMale ? 1 : 0;
      final yun = Yun(eightCharBirth, gender, sectYun);
      final int startAge = yun.getStartYear();
      return startAge;
    } catch (e) {
      return 5;
    }
  }

  DaiVanResult? tinhDaiVan({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    required int second,
    required bool isMale,
    int sectYun = 1, // Thường dùng sect=1 cho khởi Đại Vận
    int sectEightChar = 2, // Thường dùng sect=2 cho Can Chi ngày
  }) {
    try {
      // 1. Tạo đối tượng Solar từ ngày giờ sinh Dương lịch đầy đủ
      final solarBirth = Solar.fromYmdHms(
        year,
        month,
        day,
        hour,
        minute,
        second,
      );

      // 2. Tạo đối tượng Lunar từ Solar
      final lunarBirth = Lunar.fromSolar(solarBirth);

      // 3. Tạo đối tượng EightChar từ Lunar
      final eightCharBirth = EightChar.fromLunar(lunarBirth);
      // Đặt cách tính Can Chi ngày (quan trọng cho giờ Tý)
      eightCharBirth.setSect(sectEightChar);

      // 4. Xác định giới tính dạng số (1=Nam, 0=Nữ) theo yêu cầu của lớp Yun
      final int gender = isMale ? 1 : 0;

      // 5. Tạo đối tượng Yun (Đại Vận)
      // Truyền eightChar, gender, và sectYun
      final yun = Yun(eightCharBirth, gender, sectYun);

      // 6. Lấy kết quả tuổi khởi vận (số nguyên)
      final int startAge = yun.getStartYear();

      // 7. Lấy ngày Dương lịch khởi vận
      final Solar? startSolar = yun.getStartSolar();

      // 8. Tạo mô tả kết quả
      String dateStr =
          startSolar != null
              ? '${startSolar.getDay()}/${startSolar.getMonth()}/${startSolar.getYear()}'
              : 'Không xác định';
      String description = 'Khởi Vận lúc: $startAge tuổi (khoảng $dateStr)';

      // 9. Trả về kết quả dưới dạng đối tượng DaiVanResult
      return DaiVanResult(
        startAge: startAge,
        startSolarDate: startSolar,
        description: description,
      );
    } catch (e) {
      // Ghi lại lỗi nếu có vấn đề trong quá trình tính toán
      print("Lỗi khi tính Đại Vận: $e");
      // Trả về null nếu có lỗi
      return null;
    }
  }

  String getTietKhiHienTaiCuaNgay() {
    try {
      // Tạo đối tượng Lunar từ solarDateTime của AppUtil
      final lunarDate = Lunar.fromDate(solarDateTime);
      // Gọi hàm getJieQi()
      return lunarDate.getJieQi(); // Hàm này trả về '' nếu không tìm thấy
    } catch (e) {
      return ''; // Trả về chuỗi rỗng nếu có lỗi
    }
  }

  // String getThaiCung() {
  //   final _solar = Solar.fromDate(solarDateTime);
  //   Solar? start = null; // Khởi tạo thời điểm bắt đầu khoảng Tiết Khí
  //   Solar end; // Thời điểm kết thúc khoảng Tiết Khí (là Tiết tiếp theo)
  //   String time =
  //       _solar.toYmdHms(); // Thời gian hiện tại dạng YYYY-MM-DD HH:MM:SS
  //   int size = JIE_QI_IN_USE.length; // Số lượng Tiết + Khí
  //   Lunar lunarDate = Lunar.fromDate(solarDateTime);
  //   // Lấy chỉ số Can và Chi của tháng (tính theo Tiết Khí)
  //   int monthGanIndex = lunarDate.getMonthGanIndex();
  //   // Xác định index của khoảng Tiết Khí hiện tại
  //   int index = -3; // Bắt đầu từ -3 (trước Đại Tuyết)
  //   for (int i = 0; i < size; i += 2) {
  //     // Lặp qua các Tiết (bỏ qua các Khí)
  //     end =
  //         _jieQi[JIE_QI_IN_USE[i]]!; // Lấy thời điểm của Tiết hiện tại trong vòng lặp
  //     // Lấy thời điểm bắt đầu của khoảng (là Tiết trước đó, hoặc thời gian hiện tại nếu là lần lặp đầu)
  //     String stime = null == start ? time : start!.toYmdHms();
  //     // Kiểm tra xem 'time' có nằm trong khoảng [stime, end) không
  //     if (time.compareTo(stime) >= 0 && time.compareTo(end.toYmdHms()) < 0) {
  //       break; // Tìm thấy khoảng, thoát vòng lặp
  //     }
  //     start = end; // Cập nhật thời điểm bắt đầu cho khoảng tiếp theo
  //     index++; // Tăng index lên
  //   }

  //   // Tính Can tháng chính xác (không liên quan trực tiếp đến getMonthZhiIndexExact)
  //   int offset =
  //       (((_yearGanIndexExact + (index < 0 ? 1 : 0)) % 5 + 1) * 2) % 10;
  //   _monthGanIndexExact = ((index < 0 ? index + 10 : index) + offset) % 10;
  //   // Tính Can Thái Cung: Tiến 1 Can
  //   int thaiCungGanIndex = (monthGanIndex + 1) % 10;
  //   // Tính Chi Thái Cung: Tiến 3 Chi
  //   int thaiCungZhiIndex = (monthZhiIndex + 3) % 12;

  //   // Lấy tên Can Chi từ chỉ số (Lưu ý: LunarUtil.GAN/ZHI là 1-based)
  //   String thaiCungCan = LunarUtil.GAN[thaiCungGanIndex + 1];
  //   String thaiCungChi = LunarUtil.ZHI[thaiCungZhiIndex + 1];

  //   return '$thaiCungCan$thaiCungChi';
  // }
}

class DaiVanResult {
  final int startAge; // Tuổi khởi vận (số nguyên)
  final Solar?
  startSolarDate; // Ngày dương lịch khởi vận (có thể null nếu tính toán lỗi)
  final String description; // Mô tả kết quả

  DaiVanResult({
    required this.startAge,
    this.startSolarDate,
    required this.description,
  });

  @override
  String toString() {
    return '($description)';
  }
}
