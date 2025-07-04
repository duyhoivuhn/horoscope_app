// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:horoscope_app/lunar/calendar/EightChar.dart';
import 'package:horoscope_app/lunar/calendar/Lunar.dart';
import 'package:horoscope_app/lunar/calendar/Solar.dart';
import 'package:horoscope_app/lunar/calendar/eightchar/Yun.dart';
import 'package:horoscope_app/lunar/calendar/util/LunarUtil.dart';
import 'package:horoscope_app/thiencan.dart';
import 'package:horoscope_app/utils/string_ext.dart';

class AppUtil {
  final DateTime solarDateTime;

  AppUtil({required this.solarDateTime});

  List<String> solarTermNames = [
    "Lập Xuân",
    "Vũ Thủy",
    "Kinh Trập",
    "Xuân Phân",
    "Thanh Minh",
    "Cốc Vũ",
    "Lập Hạ",
    "Tiểu Mãn",
    "Mang Chủng",
    "Hạ Chí",
    "Tiểu Thử",
    "Đại Thử",
    "Lập Thu",
    "Xử Thử",
    "Bạch Lộ",
    "Thu Phân",
    "Hàn Lộ",
    "Sương Giáng",
    "Lập Đông",
    "Tiểu Tuyết",
    "Đại Tuyết",
    "Đông Chí",
    "Tiểu Hàn",
    "Đại Hàn",
  ];

  List<int> solarTermOffsets = [
    315,
    330,
    345,
    0,
    15,
    30,
    45,
    60,
    75,
    90,
    105,
    120,
    135,
    150,
    165,
    180,
    195,
    210,
    225,
    240,
    255,
    270,
    285,
    300,
  ];

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
    // return lunarDate.getMonthZhiExact();
    final thangAmLich = lunarDate.getMonth();
    final diaChiList = [
      'Dần',
      'Mão',
      'Thìn',
      'Tỵ',
      'Ngọ',
      'Mùi',
      'Thân',
      'Dậu',
      'Tuất',
      'Hợi',
      'Tý',
      'Sửu',
    ];

    // thangAmLich từ 1 đến 12
    if (thangAmLich < 1 || thangAmLich > 12) {
      return '';
    }

    return diaChiList[thangAmLich - 1];
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
    return (LunarUtil.SHI_SHEN['$day$hour'] ?? '').format;
  }

  String getNapAmNam() {
    final key = '${getThienCanNam()}${getDiaChiNam()}';
    return (LunarUtil.NAYIN[key] ?? '').format;
  }

  String getNapAmThang() {
    final key =
        '${getThienCanThang(thang: solarDateTime.month)}${getDiaChiThang()}';
    return (LunarUtil.NAYIN[key] ?? '').format;
  }

  String getNapAmNgay() {
    final key = '${getThienCanNgay()}${getDiaChiNgay()}';
    return (LunarUtil.NAYIN[key] ?? '').format;
  }

  String getNapAmGio() {
    final key = '${getThienCanGio()}${getDiaChiGio()}';
    return (LunarUtil.NAYIN[key] ?? '').format;
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

  List<String> getThaiCung() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    final index = lunarDate.getMonthZhiIndex();
    final diachi = LunarUtil.ZHI[(index + 3) % 12];

    final index2 = lunarDate.getMonthGanIndex();
    final thiencan = LunarUtil.GAN[(index2 + 3) % 10];
    return [diachi, thiencan];
  }

  List<String> getMenhCung() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    final indexMonth = lunarDate.getMonthZhiIndex();
    final indexHour = lunarDate.getTimeZhiIndex();
    final chiMenhCungIndex = (14 - indexMonth + indexHour) % 12;

    final diachi = LunarUtil.ZHI[chiMenhCungIndex];
    final index2 = lunarDate.getMonthGanIndex();
    final thiencan = LunarUtil.GAN[(index2 + chiMenhCungIndex) % 10];
    return [diachi, thiencan];
  }

  List<String> getThaiTuc() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    final indexDay = lunarDate.getDayZhiIndex();
    final indexHour = lunarDate.getTimeZhiIndex();
    final chiMenhCungIndex = (14 - indexDay + indexHour) % 12;
    final diachi = LunarUtil.ZHI[chiMenhCungIndex];
    final index2 = lunarDate.getDayGanIndex();
    final thiencan = LunarUtil.GAN[(index2 + chiMenhCungIndex) % 10];
    return [diachi, thiencan];
  }

  List<String> getTruPhuc() {
    Lunar lunarDate = Lunar.fromDate(solarDateTime);
    final indexMonth = lunarDate.getMonthZhiIndex();
    final indexYear = lunarDate.getYearZhiIndex();
    final chiMenhCungIndex = (14 - indexYear + indexMonth) % 12;
    final diachi = LunarUtil.ZHI[chiMenhCungIndex];
    final index2 = lunarDate.getYearGanIndex();
    final thiencan = LunarUtil.GAN[(index2 + chiMenhCungIndex) % 10];
    return [diachi, thiencan];
  }

  getThanSat() {
    // 2. Tạo đối tượng Lunar từ DateTime
    // final lunarDate = Lunar.fromDate(solarDateTime);

    final canChi = {
      'nam': {'can': getThienCanNam(), 'chi': getDiaChiNam()},
      'thang': {
        'can': ThienCan.getThienCanThang(
          year: solarDateTime.year,
          month: solarDateTime.month,
        ),
        'chi': getDiaChiThang(),
      },
      'ngay': {'can': getThienCanNgay(), 'chi': getDiaChiNgay()},
      'gio': {'can': getThienCanGio(), 'chi': getDiaChiGio()},
    };

    final canNgay = canChi['ngay']!['can']!;
    final canThang = canChi['thang']!['can']!;
    final canGio = canChi['gio']!['can']!;
    final canNam = canChi['nam']!['can'];

    final chiNam = canChi['nam']!['chi']!;
    final chiThang = canChi['thang']!['chi']!;
    final chiNgay = canChi['ngay']!['chi']!;
    final chiGio = canChi['gio']!['chi']!;

    final allChi = {
      'nam': chiNam,
      'thang': chiThang,
      'ngay': chiNgay,
      'gio': chiGio,
    };

    Map<String, List<String>> thanSat = {
      'nam': [],
      'thang': [],
      'ngay': [],
      'gio': [],
    };

    // 1. Thái Cực Quý Nhân (Can ngày => 2 chi)
    const thaiCuc = {
      'Giáp': ['Tý', 'Ngọ'],
      'Ất': ['Sửu', 'Mùi'],
      'Bính': ['Dần', 'Thân'],
      'Đinh': ['Mão', 'Dậu'],
      'Mậu': ['Thìn', 'Tuất'],
      'Kỷ': ['Tỵ', 'Hợi'],
      'Canh': ['Tý', 'Ngọ'],
      'Tân': ['Sửu', 'Mùi'],
      'Nhâm': ['Dần', 'Thân'],
      'Quý': ['Mão', 'Dậu'],
    };

    // 2. Đào Hoa Tinh (chi năm)
    const daoHoa = {'Tý': 'Mão', 'Ngọ': 'Dậu', 'Mão': 'Tý', 'Dậu': 'Ngọ'};

    // 3. Tướng Tinh (chi tháng)
    const tuongTinhChi = ['Tý', 'Ngọ', 'Mão', 'Dậu'];

    // 4. Quốc Ấn Quý Nhân (can ngày)
    const quocAn = {
      'Giáp': 'Dần',
      'Ất': 'Mão',
      'Bính': 'Tỵ',
      'Đinh': 'Ngọ',
      'Mậu': 'Thân',
      'Kỷ': 'Dậu',
      'Canh': 'Tuất',
      'Tân': 'Hợi',
      'Nhâm': 'Sửu',
      'Quý': 'Tý',
    };

    // 5. Khôi Canh (can ngày)
    const khoiCanh = {
      'Giáp': 'Tý',
      'Ất': 'Sửu',
      'Bính': 'Dần',
      'Đinh': 'Mão',
      'Mậu': 'Thìn',
      'Kỷ': 'Tỵ',
      'Canh': 'Ngọ',
      'Tân': 'Mùi',
      'Nhâm': 'Thân',
      'Quý': 'Dậu',
    };

    // 6. Văn Xương Quý Nhân (chi năm)
    const vanXuong = {
      'Tý': 'Sửu',
      'Sửu': 'Dần',
      'Dần': 'Mão',
      'Mão': 'Thìn',
      'Thìn': 'Tỵ',
      'Tỵ': 'Ngọ',
      'Ngọ': 'Mùi',
      'Mùi': 'Thân',
      'Thân': 'Dậu',
      'Dậu': 'Tuất',
      'Tuất': 'Hợi',
      'Hợi': 'Tý',
    };

    // 7. Long Đức Quý Nhân (chi năm)
    const longDuc = {
      'Tý': 'Dậu',
      'Sửu': 'Tý',
      'Dần': 'Sửu',
      'Mão': 'Dần',
      'Thìn': 'Mão',
      'Tỵ': 'Thìn',
      'Ngọ': 'Tỵ',
      'Mùi': 'Ngọ',
      'Thân': 'Mùi',
      'Dậu': 'Thân',
      'Tuất': 'Dậu',
      'Hợi': 'Tuất',
    };

    // 8. Lưu Hạ (can ngày)
    const luuHa = {
      'Giáp': 'Ngọ',
      'Ất': 'Tỵ',
      'Bính': 'Tỵ',
      'Đinh': 'Thìn',
      'Mậu': 'Thìn',
      'Kỷ': 'Mão',
      'Canh': 'Mão',
      'Tân': 'Dần',
      'Nhâm': 'Dần',
      'Quý': 'Sửu',
    };

    // 9. Hồng Loan (chi năm)
    const hongLoan = {
      'Tý': 'Ngọ',
      'Sửu': 'Mùi',
      'Dần': 'Thân',
      'Mão': 'Dậu',
      'Thìn': 'Tuất',
      'Tỵ': 'Hợi',
      'Ngọ': 'Tý',
      'Mùi': 'Sửu',
      'Thân': 'Dần',
      'Dậu': 'Mão',
      'Tuất': 'Thìn',
      'Hợi': 'Tỵ',
    };

    // 10. Vong Thần (chi năm)
    const vongThan = {
      'Tý': 'Tỵ',
      'Sửu': 'Ngọ',
      'Dần': 'Mùi',
      'Mão': 'Thân',
      'Thìn': 'Dậu',
      'Tỵ': 'Tuất',
      'Ngọ': 'Hợi',
      'Mùi': 'Tý',
      'Thân': 'Sửu',
      'Dậu': 'Dần',
      'Tuất': 'Mão',
      'Hợi': 'Thìn',
    };

    // Thái Cực
    thaiCuc[canNgay]?.forEach((targetChi) {
      allChi.forEach((tru, chi) {
        if (chi == targetChi) thanSat[tru]!.add('Thái Cực\nQuý Nhân');
      });
    });
    thaiCuc[canThang]?.forEach((targetChi) {
      allChi.forEach((tru, chi) {
        if (chi == targetChi) thanSat[tru]!.add('Thái Cực\nQuý Nhân');
      });
    });

    thaiCuc[canNam]?.forEach((targetChi) {
      allChi.forEach((tru, chi) {
        if (chi == targetChi) thanSat[tru]!.add('Thái Cực\nQuý Nhân');
      });
    });
    thaiCuc[canGio]?.forEach((targetChi) {
      allChi.forEach((tru, chi) {
        if (chi == targetChi) thanSat[tru]!.add('Thái Cực\nQuý Nhân');
      });
    });

    // Đào Hoa
    final daoHoaTarget = daoHoa[chiNam];
    if (daoHoaTarget != null) {
      allChi.forEach((tru, chi) {
        if (chi == daoHoaTarget) thanSat[tru]!.add('Đào Hoa\nTinh');
      });
    }
    final daoHoaTarget2 = daoHoa[chiThang];
    if (daoHoaTarget != null) {
      allChi.forEach((tru, chi) {
        if (chi == daoHoaTarget2) thanSat[tru]!.add('Đào Hoa\nTinh');
      });
    }
    final daoHoaTarget3 = daoHoa[chiNgay];
    if (daoHoaTarget != null) {
      allChi.forEach((tru, chi) {
        if (chi == daoHoaTarget3) thanSat[tru]!.add('Đào Hoa\nTinh');
      });
    }
    final daoHoaTarget4 = daoHoa[chiGio];
    if (daoHoaTarget != null) {
      allChi.forEach((tru, chi) {
        if (chi == daoHoaTarget4) thanSat[tru]!.add('Đào Hoa\nTinh');
      });
    }

    // Tướng Tinh
    allChi.forEach((tru, chi) {
      if (tuongTinhChi.contains(chi)) thanSat[tru]!.add('Tướng Tinh');
    });

    // Quốc Ấn
    final quocAnChi = quocAn[canNgay];
    if (quocAnChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == quocAnChi) thanSat[tru]!.add('Quốc Ấn\nQuý Nhân');
      });
    }

    // Khôi Canh
    final khoiCanhChi = khoiCanh[canNgay];
    if (khoiCanhChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == khoiCanhChi) thanSat[tru]!.add('Khôi Canh');
      });
    }
    final khoiCanhChi2 = khoiCanh[canThang];
    if (khoiCanhChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == khoiCanhChi2) thanSat[tru]!.add('Khôi Canh');
      });
    }
    final khoiCanhChi3 = khoiCanh[canNam];
    if (khoiCanhChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == khoiCanhChi3) thanSat[tru]!.add('Khôi Canh');
      });
    }
    final khoiCanhChi4 = khoiCanh[canGio];
    if (khoiCanhChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == khoiCanhChi4) thanSat[tru]!.add('Khôi Canh');
      });
    }

    // Văn Xương
    final vanXuongChi = vanXuong[chiNam];
    if (vanXuongChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == vanXuongChi) thanSat[tru]!.add('Văn Xương\nQuý Nhân');
      });
    }
    final vanXuongChi2 = vanXuong[chiThang];
    if (vanXuongChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == vanXuongChi2) thanSat[tru]!.add('Văn Xương\nQuý Nhân');
      });
    }
    final vanXuongChi3 = vanXuong[chiNgay];
    if (vanXuongChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == vanXuongChi3) thanSat[tru]!.add('Văn Xương\nQuý Nhân');
      });
    }
    final vanXuongChi4 = vanXuong[chiGio];
    if (vanXuongChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == vanXuongChi4) thanSat[tru]!.add('Văn Xương\nQuý Nhân');
      });
    }

    // Long Đức
    final longDucChi = longDuc[chiNam];
    if (longDucChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == longDucChi) thanSat[tru]!.add('Long Đức\nQuý Nhân');
      });
    }
    final longDucChi2 = longDuc[chiThang];
    if (longDucChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == longDucChi2) thanSat[tru]!.add('Long Đức\nQuý Nhân');
      });
    }
    final longDucChi3 = longDuc[chiNgay];
    if (longDucChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == longDucChi3) thanSat[tru]!.add('Long Đức\nQuý Nhân');
      });
    }
    final longDucChi4 = longDuc[chiGio];
    if (longDucChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == longDucChi4) thanSat[tru]!.add('Long Đức\nQuý Nhân');
      });
    }

    // Lưu Hạ
    final luuHaChi = luuHa[canNgay];
    if (luuHaChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == luuHaChi) thanSat[tru]!.add('Lưu Hạ');
      });
    }

    // Hồng Loan
    final hongLoanChi = hongLoan[chiNam];
    if (hongLoanChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == hongLoanChi) thanSat[tru]!.add('Hồng Loan\nTinh');
      });
    }

    // Vong Thần
    final vongThanChi = vongThan[chiNam];
    if (vongThanChi != null) {
      allChi.forEach((tru, chi) {
        if (chi == vongThanChi) thanSat[tru]!.add('Vong Thần\nTinh');
      });
    }

    if (thanSat['nam']?.isEmpty ?? true) {
      thanSat['nam']?.add('Thái Cực\nQuý Nhân');
    }

    return thanSat;
  }

  /// Tính tiết khí theo ngày sinh
  String getSolarTermByDate(DateTime birthDate) {
    int year = birthDate.year;
    DateTime baseDate = DateTime.utc(1900, 1, 6, 2); // Mốc tính gần đúng

    // Lấy toàn bộ tiết khí trong năm
    List<SolarTerm> terms = [];
    for (int i = 0; i < 24; i++) {
      int days = ((year - 1900) * 365.2422).round() + solarTermOffsets[i];
      DateTime termDate = baseDate.add(Duration(days: days));
      terms.add(SolarTerm(solarTermNames[i], termDate));
    }

    // Xử lý Tiểu Hàn và Đại Hàn của năm tiếp theo
    int daysNextYear = ((year + 1 - 1900) * 365.2422).round();
    terms.add(
      SolarTerm(
        "Tiểu Hàn (năm sau)",
        baseDate.add(Duration(days: daysNextYear + 285)),
      ),
    );
    terms.add(
      SolarTerm(
        "Đại Hàn (năm sau)",
        baseDate.add(Duration(days: daysNextYear + 300)),
      ),
    );

    // Tìm tiết khí ứng với ngày sinh
    for (int i = 0; i < terms.length - 1; i++) {
      if (birthDate.isAfter(terms[i].date) &&
          birthDate.isBefore(terms[i + 1].date)) {
        return terms[i].name;
      } else if (birthDate.isAtSameMomentAs(terms[i].date)) {
        return terms[i].name;
      }
    }

    // Nếu không khớp, có thể là Tiểu Hàn hoặc Đại Hàn đầu năm
    return "Không xác định (có thể đầu năm thuộc Tiểu Hàn/Đại Hàn năm trước)";
  }
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

class SolarTerm {
  final String name;
  final DateTime date;

  SolarTerm(this.name, this.date);
}
