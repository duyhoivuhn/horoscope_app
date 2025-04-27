import 'Lunar.dart';
import 'LunarMonth.dart';
import 'NineStar.dart';
import 'Solar.dart';
import 'util/LunarUtil.dart';
import 'util/ShouXingUtil.dart';

/// 农历年
/// @author 6tail
class LunarYear {
  /// Nguyên (Tam Nguyên: Thượng, Trung, Hạ)
  static const List<String> YUAN = ['Hạ', 'Thượng', 'Trung'];
  // Lưu ý: Thứ tự thông thường là Thượng, Trung, Hạ. Cần kiểm tra lại logic sử dụng.

  /// Vận (Cửu Vận: 1-9)
  static const List<String> YUN = [
    'Bảy',
    'Tám',
    'Chín',
    'Một',
    'Hai',
    'Ba',
    'Bốn',
    'Năm',
    'Sáu'
  ];
  // Lưu ý: Đây là thứ tự các Vận (Vận 7, Vận 8, Vận 9, Vận 1, ...).

  /// 闰冬月年份
  static const List<int> LEAP_11 = [
    75,
    94,
    170,
    265,
    322,
    398,
    469,
    553,
    583,
    610,
    678,
    735,
    754,
    773,
    849,
    887,
    936,
    1050,
    1069,
    1126,
    1145,
    1164,
    1183,
    1259,
    1278,
    1308,
    1373,
    1403,
    1441,
    1460,
    1498,
    1555,
    1593,
    1612,
    1631,
    1642,
    2033,
    2128,
    2147,
    2242,
    2614,
    2728,
    2910,
    3062,
    3244,
    3339,
    3616,
    3711,
    3730,
    3825,
    4007,
    4159,
    4197,
    4322,
    4341,
    4379,
    4417,
    4531,
    4599,
    4694,
    4713,
    4789,
    4808,
    4971,
    5085,
    5104,
    5161,
    5180,
    5199,
    5294,
    5305,
    5476,
    5677,
    5696,
    5772,
    5791,
    5848,
    5886,
    6049,
    6068,
    6144,
    6163,
    6258,
    6402,
    6440,
    6497,
    6516,
    6630,
    6641,
    6660,
    6679,
    6736,
    6774,
    6850,
    6869,
    6899,
    6918,
    6994,
    7013,
    7032,
    7051,
    7070,
    7089,
    7108,
    7127,
    7146,
    7222,
    7271,
    7290,
    7309,
    7366,
    7385,
    7404,
    7442,
    7461,
    7480,
    7491,
    7499,
    7594,
    7624,
    7643,
    7662,
    7681,
    7719,
    7738,
    7814,
    7863,
    7882,
    7901,
    7939,
    7958,
    7977,
    7996,
    8034,
    8053,
    8072,
    8091,
    8121,
    8159,
    8186,
    8216,
    8235,
    8254,
    8273,
    8311,
    8330,
    8341,
    8349,
    8368,
    8444,
    8463,
    8474,
    8493,
    8531,
    8569,
    8588,
    8626,
    8664,
    8683,
    8694,
    8702,
    8713,
    8721,
    8751,
    8789,
    8808,
    8816,
    8827,
    8846,
    8884,
    8903,
    8922,
    8941,
    8971,
    9036,
    9066,
    9085,
    9104,
    9123,
    9142,
    9161,
    9180,
    9199,
    9218,
    9256,
    9294,
    9313,
    9324,
    9343,
    9362,
    9381,
    9419,
    9438,
    9476,
    9514,
    9533,
    9544,
    9552,
    9563,
    9571,
    9582,
    9601,
    9639,
    9658,
    9666,
    9677,
    9696,
    9734,
    9753,
    9772,
    9791,
    9802,
    9821,
    9886,
    9897,
    9916,
    9935,
    9954,
    9973,
    9992
  ];

  /// 闰腊月年份
  static const List<int> LEAP_12 = [
    37,
    56,
    113,
    132,
    151,
    189,
    208,
    227,
    246,
    284,
    303,
    341,
    360,
    379,
    417,
    436,
    458,
    477,
    496,
    515,
    534,
    572,
    591,
    629,
    648,
    667,
    697,
    716,
    792,
    811,
    830,
    868,
    906,
    925,
    944,
    963,
    982,
    1001,
    1020,
    1039,
    1058,
    1088,
    1153,
    1202,
    1221,
    1240,
    1297,
    1335,
    1392,
    1411,
    1422,
    1430,
    1517,
    1525,
    1536,
    1574,
    3358,
    3472,
    3806,
    3988,
    4751,
    4941,
    5066,
    5123,
    5275,
    5343,
    5438,
    5457,
    5495,
    5533,
    5552,
    5715,
    5810,
    5829,
    5905,
    5924,
    6421,
    6535,
    6793,
    6812,
    6888,
    6907,
    7002,
    7184,
    7260,
    7279,
    7374,
    7556,
    7746,
    7757,
    7776,
    7833,
    7852,
    7871,
    7966,
    8015,
    8110,
    8129,
    8148,
    8224,
    8243,
    8338,
    8406,
    8425,
    8482,
    8501,
    8520,
    8558,
    8596,
    8607,
    8615,
    8645,
    8740,
    8778,
    8835,
    8865,
    8930,
    8960,
    8979,
    8998,
    9017,
    9055,
    9074,
    9093,
    9112,
    9150,
    9188,
    9237,
    9275,
    9332,
    9351,
    9370,
    9408,
    9427,
    9446,
    9457,
    9465,
    9495,
    9560,
    9590,
    9628,
    9647,
    9685,
    9715,
    9742,
    9780,
    9810,
    9818,
    9829,
    9848,
    9867,
    9905,
    9924,
    9943,
    9962,
    10000
  ];

  static const List<int> YMC = [11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  static LunarYear? _cacheYear;

  /// 农历年
  int _year = 0;

  /// 天干下标
  int _ganIndex = 0;

  /// 地支下标
  int _zhiIndex = 0;

  /// 农历月们
  List<LunarMonth> _months = <LunarMonth>[];

  /// 节气儒略日们
  List<double> _jieQiJulianDays = <double>[];

  LunarYear(int lunarYear) {
    _year = lunarYear;
    int offset = lunarYear - 4;
    int yearGanIndex = offset % 10;
    int yearZhiIndex = offset % 12;
    if (yearGanIndex < 0) {
      yearGanIndex += 10;
    }
    if (yearZhiIndex < 0) {
      yearZhiIndex += 12;
    }
    _ganIndex = yearGanIndex;
    _zhiIndex = yearZhiIndex;
    _compute();
  }

  static LunarYear fromYear(int lunarYear) {
    LunarYear y;
    if (null == _cacheYear || _cacheYear!.getYear() != lunarYear) {
      y = new LunarYear(lunarYear);
      _cacheYear = y;
    } else {
      y = _cacheYear!;
    }
    return y;
  }

  void _compute() {
    // 节气
    List<double> jq = <double>[];
    // 合朔，即每月初一
    List<double> hs = <double>[];
    // 每月天数
    List<int> dayCounts = <int>[];
    List<int> months = <int>[];

    int currentYear = _year;

    double jd = ((currentYear - 2000) * 365.2422 + 180).floorToDouble();
    // 355是2000.12冬至，得到较靠近jd的冬至估计值
    double w = ((jd - 355 + 183) / 365.2422).floorToDouble() * 365.2422 + 355;
    if (ShouXingUtil.calcQi(w) > jd) {
      w -= 365.2422;
    }
    // 25个节气时刻(北京时间)，从冬至开始到下一个冬至以后
    for (int i = 0; i < 26; i++) {
      jq.add(ShouXingUtil.calcQi(w + 15.2184 * i));
    }
    // 从上年的大雪到下年的立春
    for (int i = 0, j = Lunar.JIE_QI_IN_USE.length; i < j; i++) {
      if (i == 0) {
        jd = ShouXingUtil.qiAccurate2(jq[0] - 15.2184);
      } else if (i <= 26) {
        jd = ShouXingUtil.qiAccurate2(jq[i - 1]);
      } else {
        jd = ShouXingUtil.qiAccurate2(jq[25] + 15.2184 * (i - 26));
      }
      _jieQiJulianDays.add(jd + Solar.J2000);
    }

    // 冬至前的初一，今年首朔的日月黄经差w
    w = ShouXingUtil.calcShuo(jq[0]);
    if (w > jq[0]) {
      w -= 29.53;
    }
    // 递推每月初一
    for (int i = 0; i < 16; i++) {
      hs.add(ShouXingUtil.calcShuo(w + 29.5306 * i));
    }
    // 每月
    for (int i = 0; i < 15; i++) {
      dayCounts.add((hs[i + 1] - hs[i]).floor());
      months.add(i);
    }

    int prevYear = currentYear - 1;
    int leapIndex = 16;
    if (LEAP_11.contains(currentYear)) {
      leapIndex = 13;
    } else if (LEAP_12.contains(currentYear)) {
      leapIndex = 14;
    } else if (hs[13] <= jq[24]) {
      int i = 1;
      while (hs[i + 1] > jq[2 * i] && i < 13) {
        i++;
      }
      leapIndex = i;
    }
    for (int i = leapIndex; i < 15; i++) {
      months[i] -= 1;
    }

    int fm = -1;
    int index = -1;
    int y = prevYear;
    for (int i = 0; i < 15; i++) {
      double dm = hs[i] + Solar.J2000;
      int v2 = months[i];
      int mc = YMC[v2 % 12];
      if (1724360 <= dm && dm < 1729794) {
        mc = YMC[(v2 + 1) % 12];
      } else if (1807724 <= dm && dm < 1808699) {
        mc = YMC[(v2 + 1) % 12];
      } else if (dm == 1729794 || dm == 1808699) {
        mc = 12;
      }
      if (fm == -1) {
        fm = mc;
        index = mc;
      }
      if (mc < fm) {
        y += 1;
        index = 1;
      }
      fm = mc;
      if (i == leapIndex) {
        mc = -mc;
      } else if (dm == 1729794 || dm == 1808699) {
        mc = -11;
      }
      _months
          .add(new LunarMonth(y, mc, dayCounts[i], hs[i] + Solar.J2000, index));
      index++;
    }
  }

  int getYear() => _year;

  int getGanIndex() => _ganIndex;

  int getZhiIndex() => _zhiIndex;

  String getGan() => LunarUtil.GAN[_ganIndex + 1];

  String getZhi() => LunarUtil.ZHI[_zhiIndex + 1];

  String getGanZhi() => getGan() + getZhi();

  List<LunarMonth> getMonths() => _months;

  List<double> getJieQiJulianDays() => _jieQiJulianDays;

  int getDayCount() {
    int n = 0;
    for (LunarMonth m in _months) {
      if (m.getYear() == _year) {
        n += m.getDayCount();
      }
    }
    return n;
  }

  LunarMonth? getMonth(int lunarMonth) {
    for (LunarMonth m in _months) {
      if (m.getYear() == _year && m.getMonth() == lunarMonth) {
        return m;
      }
    }
    return null;
  }

  List<LunarMonth> getMonthsInYear() {
    List<LunarMonth> l = [];
    for (LunarMonth m in _months) {
      if (m.getYear() == _year) {
        l.add(m);
      }
    }
    return l;
  }

  int getLeapMonth() {
    for (LunarMonth m in _months) {
      if (m.getYear() == _year && m.isLeap()) {
        return m.getMonth().abs();
      }
    }
    return 0;
  }

  @override
  String toString() {
    return '$_year';
  }

  /// Trả về chuỗi biểu thị năm, ví dụ: "Năm 2023"
  String toFullString() {
    return 'Năm $_year'; // '年' nghĩa là "Năm"
  }

  /// Tính toán giá trị "Táo" dựa trên Thiên Can của ngày đầu năm
  /// index: Chỉ số Can mục tiêu (0=Giáp, 1=Ất, ...)
  /// name: Chuỗi mẫu chứa ký tự '几' (mấy)
  String _getZaoByGan(int index, String name) {
    // Lấy Can của ngày mùng 1 Tết
    int firstDayGanIndex = Solar.fromJulianDay(getMonth(1)!.getFirstJulianDay())
        .getLunar()
        .getDayGanIndex();
    // Tính độ lệch từ Can ngày mùng 1 đến Can mục tiêu
    int offset = index - firstDayGanIndex;
    if (offset < 0) {
      offset += 10; // Đảm bảo offset không âm
    }
    // Thay thế '几' bằng số tiếng Việt tương ứng (từ 1 đến 10)
    // Giả sử LunarUtil.NUMBER chứa ['Không', 'Một', 'Hai', ..., 'Mười']
    return name.replaceFirst('几', LunarUtil.NUMBER[offset + 1]);
  }

  /// Tính toán giá trị "Táo" dựa trên Địa Chi của ngày đầu năm
  /// index: Chỉ số Chi mục tiêu (0=Tý, 1=Sửu, ...)
  /// name: Chuỗi mẫu chứa ký tự '几' (mấy)
  String _getZaoByZhi(int index, String name) {
    // Lấy Chi của ngày mùng 1 Tết
    int firstDayZhiIndex = Solar.fromJulianDay(getMonth(1)!.getFirstJulianDay())
        .getLunar()
        .getDayZhiIndex();
    // Tính độ lệch từ Chi ngày mùng 1 đến Chi mục tiêu
    int offset = index - firstDayZhiIndex;
    if (offset < 0) {
      offset += 12; // Đảm bảo offset không âm
    }
    // Thay thế '几' bằng số tiếng Việt tương ứng (từ 1 đến 12)
    // Giả sử LunarUtil.NUMBER chứa ['Không', 'Một', ..., 'Mười hai']
    return name.replaceFirst('几', LunarUtil.NUMBER[offset + 1]);
  }

  /// Lấy thông tin "Chuột trộm lương" (dự đoán mùa màng dựa vào ngày Tý đầu năm)
  String getTouLiang() {
    // '几鼠偷粮' -> Mấy chuột trộm lương
    return _getZaoByZhi(0, '几 Chuột Trộm Lương');
  }

  /// Lấy thông tin "Thảo tử" (dự đoán mùa màng)
  String getCaoZi() {
    // '草子几分' -> Thảo tử mấy phần
    return _getZaoByZhi(0, 'Thảo Tử 几 Phần');
  }

  /// Lấy thông tin "Trâu cày ruộng" (dự đoán mùa màng dựa vào ngày Sửu đầu năm)
  String getGengTian() {
    // '几牛耕田' -> Mấy trâu cày ruộng
    return _getZaoByZhi(1, '几 Trâu Cày Ruộng');
  }

  /// Lấy thông tin "Hoa thu" (dự đoán mùa màng)
  String getHuaShou() {
    // '花收几分' -> Hoa thu mấy phần
    return _getZaoByZhi(3, 'Hoa Thu 几 Phần');
  }

  /// Lấy thông tin "Rồng cai quản nước" (dự đoán lượng mưa dựa vào ngày Thìn đầu năm)
  String getZhiShui() {
    // '几龙治水' -> Mấy rồng cai quản nước
    return _getZaoByZhi(4, '几 Rồng Cai Quản Nước');
  }

  /// Lấy thông tin "Ngựa chở lúa" (dự đoán mùa màng dựa vào ngày Ngọ đầu năm)
  String getTuoGu() {
    // '几马驮谷' -> Mấy ngựa chở lúa
    return _getZaoByZhi(6, '几 Ngựa Chở Lúa');
  }

  /// Lấy thông tin "Gà tranh gạo" (dự đoán mùa màng dựa vào ngày Dậu đầu năm)
  String getQiangMi() {
    // '几鸡抢米' -> Mấy gà tranh gạo
    return _getZaoByZhi(9, '几 Gà Tranh Gạo');
  }

  /// Lấy thông tin "Cô chăm tằm" (dự đoán nghề tằm dựa vào ngày Dậu đầu năm)
  String getKanCan() {
    // '几姑看蚕' -> Mấy cô chăm tằm
    return _getZaoByZhi(9, '几 Cô Chăm Tằm');
  }

  /// Lấy thông tin "Đồ tể chung lợn" (dự đoán chăn nuôi dựa vào ngày Hợi đầu năm)
  String getGongZhu() {
    // '几屠共猪' -> Mấy đồ tể chung lợn
    return _getZaoByZhi(11, '几 Đồ Tể Chung Lợn');
  }

  /// Lấy thông tin "Giáp điền" (dự đoán mùa màng)
  String getJiaTian() {
    // '甲田几分' -> Giáp điền mấy phần
    return _getZaoByGan(0, 'Giáp Điền 几 Phần');
  }

  /// Lấy thông tin "Người chia bánh" (dự đoán mùa màng/kinh tế dựa vào ngày Bính đầu năm)
  String getFenBing() {
    // '几人分饼' -> Mấy người chia bánh
    return _getZaoByGan(2, '几 Người Chia Bánh');
  }

  /// Lấy thông tin "Ngày được vàng" (dự đoán kinh tế dựa vào ngày Tân đầu năm)
  String getDeJin() {
    // '几日得金' -> Mấy ngày được vàng
    return _getZaoByGan(7, '几 Ngày Được Vàng');
  }

  /// Lấy thông tin "Người Bính" (kết hợp dự đoán theo Can Bính và Chi Dần)
  String getRenBing() {
    // '几人几丙' -> Mấy người mấy Bính
    return _getZaoByGan(2, _getZaoByZhi(2, '几 Người 几 Bính'));
  }

  /// Lấy thông tin "Người Cuốc" (kết hợp dự đoán theo Can Đinh và Chi Dần)
  String getRenChu() {
    // '几人几锄' -> Mấy người mấy cuốc
    return _getZaoByGan(3, _getZaoByZhi(2, '几 Người 几 Cuốc'));
  }

  /// Lấy Nguyên của năm (Thượng/Trung/Hạ Nguyên)
  String getYuan() {
    // Giả sử YUAN đã được dịch là ['Hạ', 'Thượng', 'Trung']
    // '元' -> 'Nguyên'
    return YUAN[((_year + 2696) / 60).floor() % 3] + ' Nguyên';
  }

  /// Lấy Vận của năm (1-9)
  String getYun() {
    // Giả sử YUN đã được dịch là ['Bảy', 'Tám', 'Chín', 'Một', 'Hai', 'Ba', 'Bốn', 'Năm', 'Sáu']
    // '运' -> 'Vận'
    return YUN[((_year + 2696) / 20).floor() % 9] + ' Vận';
  }

  NineStar getNineStar() {
    int index = LunarUtil.getJiaZiIndex(getGanZhi()) + 1;
    int yuan = ((_year + 2696) / 60).floor() % 3;
    int offset = (62 + yuan * 3 - index) % 9;
    if (0 == offset) {
      offset = 9;
    }
    return NineStar.fromIndex(offset - 1);
  }

  String getPositionXi() => LunarUtil.POSITION_XI[_ganIndex + 1];

  String getPositionXiDesc() => LunarUtil.POSITION_DESC[getPositionXi()]!;

  String getPositionYangGui() => LunarUtil.POSITION_YANG_GUI[_ganIndex + 1];

  String getPositionYangGuiDesc() =>
      LunarUtil.POSITION_DESC[getPositionYangGui()]!;

  String getPositionYinGui() => LunarUtil.POSITION_YIN_GUI[_ganIndex + 1];

  String getPositionYinGuiDesc() =>
      LunarUtil.POSITION_DESC[getPositionYinGui()]!;

  String getPositionFu([int sect = 2]) => (1 == sect
      ? LunarUtil.POSITION_FU
      : LunarUtil.POSITION_FU_2)[_ganIndex + 1];

  String getPositionFuDesc([int sect = 2]) =>
      LunarUtil.POSITION_DESC[getPositionFu(sect)]!;

  String getPositionCai() => LunarUtil.POSITION_CAI[_ganIndex + 1];

  String getPositionCaiDesc() => LunarUtil.POSITION_DESC[getPositionCai()]!;

  String getPositionTaiSui() => LunarUtil.POSITION_TAI_SUI_YEAR[_zhiIndex];

  String getPositionTaiSuiDesc() =>
      LunarUtil.POSITION_DESC[getPositionTaiSui()]!;

  LunarYear next(int n) => LunarYear.fromYear(_year + n);
}
