import 'Lunar.dart';
import 'TaoFestival.dart';
import 'util/LunarUtil.dart';
import 'util/TaoUtil.dart';

/// 道历
/// @author 6tail
class Tao {
  static const int BIRTH_YEAR = -2697;

  /// 阴历
  Lunar? _lunar;

  Tao(this._lunar);

  static Tao fromLunar(Lunar lunar) {
    return new Tao(lunar);
  }

  static Tao fromYmdHms(
      int year, int month, int day, int hour, int minute, int second) {
    return fromLunar(
        Lunar.fromYmdHms(year + BIRTH_YEAR, month, day, hour, minute, second));
  }

  static Tao fromYmd(int year, int month, int day) {
    return fromYmdHms(year, month, day, 0, 0, 0);
  }

  Lunar getLunar() => _lunar!;

  int getYear() => _lunar!.getYear() - BIRTH_YEAR;

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

  /// Lấy danh sách các lễ hội Đạo giáo (TaoFestival) của ngày
  List<TaoFestival> getFestivals() {
    // Khởi tạo danh sách rỗng để chứa các lễ hội
    List<TaoFestival> l = <TaoFestival>[];
    // Lấy danh sách lễ hội cố định theo ngày tháng Âm lịch (ví dụ: '1-15') từ TaoUtil.FESTIVAL
    // Giả sử TaoUtil.FESTIVAL chứa các lễ hội Đạo giáo cố định theo ngày tháng Âm lịch
    List<TaoFestival>? fs = TaoUtil.FESTIVAL['${getMonth()}-${getDay()}'];
    // Nếu tìm thấy danh sách lễ hội cho ngày tháng này
    if (null != fs) {
      // Thêm tất cả các lễ hội tìm được vào danh sách `l`
      l.addAll(fs);
    }
    // Lấy Tiết Khí của ngày Âm lịch hiện tại
    String jq = _lunar!.getJieQi();
    // Kiểm tra các ngày Tiết đặc biệt
    if ('Đông Chí' == jq) {
      // '冬至' là Đông Chí
      // Thêm lễ Vía Nguyên Thủy Thiên Tôn
      l.add(TaoFestival('Nguyên Thủy Thiên Tôn Thánh Đản')); // '元始天尊圣诞'
    } else if ('Hạ Chí' == jq) {
      // '夏至' là Hạ Chí
      // Thêm lễ Vía Linh Bảo Thiên Tôn
      l.add(TaoFestival('Linh Bảo Thiên Tôn Thánh Đản')); // '灵宝天尊圣诞'
    }
    // Kiểm tra Bát Tiết Nhật (Tám ngày Tiết)
    // Giả sử TaoUtil.BA_JIE chứa thông tin các Thiên Tôn hạ giáng vào Bát Tiết
    String? f = TaoUtil.BA_JIE[jq];
    // Nếu ngày hiện tại là một trong Bát Tiết
    if (null != f) {
      // Thêm thông tin Thiên Tôn hạ giáng vào danh sách lễ hội
      l.add(TaoFestival(f));
    }
    // Kiểm tra Bát Hội Nhật (Tám ngày Hội)
    // Giả sử TaoUtil.BA_HUI chứa tên các ngày Hội theo Can Chi
    f = TaoUtil.BA_HUI[_lunar!.getDayInGanZhi()]; // Lấy Can Chi của ngày
    // Nếu ngày hiện tại là một trong Bát Hội
    if (null != f) {
      // Thêm tên ngày Hội vào danh sách lễ hội
      l.add(TaoFestival(f));
    }
    // Trả về danh sách các lễ hội Đạo giáo tìm được
    return l;
  }

  bool _isDayIn(List<String> days) {
    String md = '${getMonth()}-${getDay()}';
    for (String d in days) {
      if (md == d) {
        return true;
      }
    }
    return false;
  }

  bool isDaySanHui() => _isDayIn(TaoUtil.SAN_HUI);

  bool isDaySanYuan() => _isDayIn(TaoUtil.SAN_YUAN);

  bool isDayBaJie() => TaoUtil.BA_JIE.containsKey(_lunar!.getJieQi());

  bool isDayWuLa() => _isDayIn(TaoUtil.WU_LA);

  bool isDayBaHui() => TaoUtil.BA_HUI.containsKey(_lunar!.getDayInGanZhi());

  /// Kiểm tra xem có phải là ngày Minh Mậu (ngày có Can Mậu) hay không
  bool isDayMingWu() {
    // '戊' là Mậu
    return 'Mậu' == _lunar!.getDayGan();
  }

  /// Kiểm tra xem có phải là ngày Ám Mậu (ngày có Chi tương ứng với Chi tháng theo quy tắc Ám Mậu) hay không
  bool isDayAnWu() {
    // So sánh Chi của ngày với Chi Ám Mậu tương ứng của tháng
    // Giả sử TaoUtil.AN_WU đã được dịch và chứa các Chi Ám Mậu
    return _lunar!.getDayZhi() == TaoUtil.AN_WU[getMonth().abs() - 1];
  }

  /// Kiểm tra xem có phải là ngày Mậu (Minh Mậu hoặc Ám Mậu) hay không
  bool isDayWu() {
    return isDayMingWu() || isDayAnWu();
  }

  /// Kiểm tra xem có phải là ngày Thiên Xá (ngày tốt để giải trừ) hay không
  bool isDayTianShe() {
    bool ret = false; // Biến kết quả, mặc định là false
    String mz = _lunar!.getMonthZhi(); // Lấy Địa Chi của tháng
    String dgz = _lunar!.getDayInGanZhi(); // Lấy Can Chi của ngày

    // Kiểm tra theo mùa (dựa vào Chi tháng) và Can Chi ngày
    if ('DầnMãoThìn'.contains(mz)) {
      // Mùa Xuân (Tháng Dần, Mão, Thìn)
      if ('Mậu Dần' == dgz) {
        // Nếu là ngày Mậu Dần
        ret = true;
      }
    } else if ('TỵNgọMùi'.contains(mz)) {
      // Mùa Hạ (Tháng Tỵ, Ngọ, Mùi)
      if ('Giáp Ngọ' == dgz) {
        // Nếu là ngày Giáp Ngọ
        ret = true;
      }
    } else if ('ThânDậuTuất'.contains(mz)) {
      // Mùa Thu (Tháng Thân, Dậu, Tuất)
      if ('Mậu Thân' == dgz) {
        // Nếu là ngày Mậu Thân
        ret = true;
      }
    } else if ('HợiTýSửu'.contains(mz)) {
      // Mùa Đông (Tháng Hợi, Tý, Sửu)
      if ('Giáp Tý' == dgz) {
        // Nếu là ngày Giáp Tý
        ret = true;
      }
    }
    // Trả về kết quả kiểm tra
    return ret;
  }

  @override
  String toString() {
    // Trả về chuỗi Năm Tháng Ngày bằng tiếng Việt
    // Ví dụ: "Năm Quý Mão Tháng Chín Ngày Mười Lăm"
    return 'Năm ${getYearInChinese()} Tháng ${getMonthInChinese()} Ngày ${getDayInChinese()}';
    // '年' -> 'Năm '
    // '月' -> ' Tháng '
    // '日' -> ' Ngày '
  }

  /// Trả về chuỗi đầy đủ thông tin theo lịch Đạo giáo
  String toFullString() {
    // Ví dụ: "Đạo lịch 4720 năm, Thiên vận Quý Mão năm, Nhâm Tuất tháng, Mậu Thìn ngày. Tháng Chín Ngày Mười Lăm, giờ Tý."
    return 'Đạo lịch ${getYearInChinese()} năm, Thiên vận ${_lunar!.getYearInGanZhi()} năm, ${_lunar!.getMonthInGanZhi()} tháng, ${_lunar!.getDayInGanZhi()} ngày. Tháng ${getMonthInChinese()} Ngày ${getDayInChinese()}, giờ ${_lunar!.getTimeZhi()}.';
    // '道歷' -> 'Đạo lịch '
    // '年' -> ' năm'
    // '，天運' -> ', Thiên vận '
    // '年，' -> ' năm, '
    // '月，' -> ' tháng, '
    // '日。' -> ' ngày. '
    // '月' -> ' Tháng '
    // '日，' -> ' Ngày '
    // '時。' -> ' giờ.'
  }
}
