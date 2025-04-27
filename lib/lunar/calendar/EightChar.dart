import 'Lunar.dart';
import 'eightchar/Yun.dart';
import 'util/LunarUtil.dart';

/// Bát Tự (Tứ Trụ)
/// @author 6tail
class EightChar {
  /// Địa Chi của Tháng (Tháng 1 Âm lịch bắt đầu từ Dần)
  static List<String> MONTH_ZHI = [
    '', // Index 0
    'Dần', // 寅 (Tháng 1)
    'Mão', // 卯 (Tháng 2)
    'Thìn', // 辰 (Tháng 3)
    'Tỵ', // 巳 (Tháng 4)
    'Ngọ', // 午 (Tháng 5)
    'Mùi', // 未 (Tháng 6)
    'Thân', // 申 (Tháng 7)
    'Dậu', // 酉 (Tháng 8)
    'Tuất', // 戌 (Tháng 9)
    'Hợi', // 亥 (Tháng 10)
    'Tý', // 子 (Tháng 11)
    'Sửu', // 丑 (Tháng 12)
  ];

  /// 12 Vòng Trường Sinh (Tràng Sinh)
  static List<String> CHANG_SHENG = [
    'Trường Sinh', // 长生 (Tràng Sinh)
    'Mộc Dục', // 沐浴
    'Quan Đới', // 冠带 (Quan Đái)
    'Lâm Quan', // 临官
    'Đế Vượng', // 帝旺
    'Suy', // 衰
    'Bệnh', // 病
    'Tử', // 死
    'Mộ', // 墓
    'Tuyệt', // 绝
    'Thai', // 胎
    'Dưỡng', // 养
  ];

  /// Giá trị độ lệch của 12 Vòng Trường Sinh theo Can ngày, 5 Can Dương đẩy thuận, 5 Can Âm đẩy nghịch
  /// (Dùng để xác định vị trí của các sao trong vòng Trường Sinh dựa trên Can ngày và Địa Chi)
  /// Ghi chú: Cần hiểu rõ cách áp dụng các giá trị offset này trong thuật toán cụ thể.
  static Map<String, int> CHANG_SHENG_OFFSET = {
    'Giáp': 1, // Giáp (Dương Mộc) khởi Trường Sinh tại Hợi
    'Bính': 10, // Bính (Dương Hỏa) khởi Trường Sinh tại Dần
    'Mậu': 10, // Mậu (Dương Thổ) khởi Trường Sinh tại Dần
    'Canh': 7, // Canh (Dương Kim) khởi Trường Sinh tại Tỵ
    'Nhâm': 4, // Nhâm (Dương Thủy) khởi Trường Sinh tại Thân
    'Ất': 6, // Ất (Âm Mộc) khởi Trường Sinh tại Ngọ
    'Đinh': 9, // Đinh (Âm Hỏa) khởi Trường Sinh tại Dậu
    'Kỷ': 9, // Kỷ (Âm Thổ) khởi Trường Sinh tại Dậu
    'Tân': 0, // Tân (Âm Kim) khởi Trường Sinh tại Tý
    'Quý': 3, // Quý (Âm Thủy) khởi Trường Sinh tại Mão
  };

  /// Trường phái tính toán Can Chi ngày:
  /// 2 = Giờ Tý muộn (23h-24h) tính theo Can Chi ngày hiện tại (mặc định).
  /// 1 = Giờ Tý muộn (23h-24h) tính theo Can Chi ngày hôm sau.
  int _sect = 2;

  /// Đối tượng Âm lịch
  Lunar _lunar;

  /// Khởi tạo Bát Tự từ đối tượng Âm lịch.
  EightChar(this._lunar);

  /// Tạo Bát Tự từ đối tượng Âm lịch (phương thức tĩnh).
  static EightChar fromLunar(Lunar lunar) {
    return EightChar(lunar);
  }

  /// Lấy trường phái tính Can Chi ngày (1 hoặc 2).
  int getSect() => _sect;

  /// Thiết lập trường phái tính Can Chi ngày.
  ///
  /// [sect] 1 hoặc 2. Các giá trị khác sẽ được coi là 2.
  void setSect(int sect) {
    _sect = (1 == sect) ? 1 : 2;
  }

  /// Lấy đối tượng Âm lịch gốc.
  Lunar getLunar() => _lunar;

  /// Lấy Can Chi năm (tính chính xác theo Lập Xuân).
  String getYear() => _lunar.getYearInGanZhiExact();

  /// Lấy Can năm (tính chính xác theo Lập Xuân).
  String getYearGan() => _lunar.getYearGanExact();

  /// Lấy Chi năm (tính chính xác theo Lập Xuân).
  String getYearZhi() => _lunar.getYearZhiExact();

  /// Lấy các Can tàng ẩn trong Chi năm (tiếng Trung).
  List<String> getYearHideGan() => LunarUtil.ZHI_HIDE_GAN[getYearZhi()]!;

  /// Lấy Ngũ hành của Can và Chi năm (tiếng Trung).
  String getYearWuXing() =>
      LunarUtil.WU_XING_GAN[getYearGan()]! +
      LunarUtil.WU_XING_ZHI[getYearZhi()]!;

  /// Lấy Nạp Âm của năm (tiếng Trung).
  String getYearNaYin() => LunarUtil.NAYIN[getYear()]!;

  /// Lấy Thập Thần của Can năm so với Can ngày (Nhật Chủ) (tiếng Trung).
  String getYearShiShenGan() =>
      LunarUtil.SHI_SHEN['${getDayGan()}${getYearGan()}']!;

  /// Lấy Thập Thần của các Can tàng ẩn trong Chi [zhi] so với Can ngày (Nhật Chủ) (tiếng Trung).
  List<String> getShiShenZhi(String zhi) {
    List<String> hideGan = LunarUtil.ZHI_HIDE_GAN[zhi]!;
    List<String> l = <String>[];
    for (String gan in hideGan) {
      l.add(LunarUtil.SHI_SHEN['${getDayGan()}$gan']!);
    }
    return l;
  }

  /// Lấy Thập Thần của các Can tàng ẩn trong Chi năm so với Can ngày (Nhật Chủ) (tiếng Trung).
  List<String> getYearShiShenZhi() => getShiShenZhi(getYearZhi());

  /// Lấy index Can ngày (0-9) dựa trên trường phái [_sect].
  int getDayGanIndex() =>
      2 == _sect ? _lunar.getDayGanIndexExact2() : _lunar.getDayGanIndexExact();

  /// Lấy index Chi ngày (0-11) dựa trên trường phái [_sect].
  int getDayZhiIndex() =>
      2 == _sect ? _lunar.getDayZhiIndexExact2() : _lunar.getDayZhiIndexExact();

  /// Lấy trạng thái Vòng Trường Sinh của Chi [zhiIndex] đối với Can ngày (Nhật Chủ) (tiếng Trung).
  String getDiShi(int zhiIndex) {
    int? offset = CHANG_SHENG_OFFSET[getDayGan()];
    int index = offset! + (getDayGanIndex() % 2 == 0 ? zhiIndex : -zhiIndex);
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return CHANG_SHENG[index];
  }

  /// Lấy trạng thái Vòng Trường Sinh của Chi năm đối với Can ngày (Nhật Chủ) (tiếng Trung).
  String getYearDiShi() => getDiShi(_lunar.getYearZhiIndexExact());

  /// Lấy Can Chi tháng (tính chính xác theo Tiết Khí).
  String getMonth() => _lunar.getMonthInGanZhiExact();

  /// Lấy Can tháng (tính chính xác theo Tiết Khí).
  String getMonthGan() => _lunar.getMonthGanExact();

  /// Lấy Chi tháng (tính chính xác theo Tiết Khí).
  String getMonthZhi() => _lunar.getMonthZhiExact();

  /// Lấy các Can tàng ẩn trong Chi tháng (tiếng Trung).
  List<String> getMonthHideGan() => LunarUtil.ZHI_HIDE_GAN[getMonthZhi()]!;

  /// Lấy Ngũ hành của Can và Chi tháng (tiếng Trung).
  String getMonthWuXing() =>
      LunarUtil.WU_XING_GAN[getMonthGan()]! +
      LunarUtil.WU_XING_ZHI[getMonthZhi()]!;

  /// Lấy Nạp Âm của tháng (tiếng Trung).
  String getMonthNaYin() => LunarUtil.NAYIN[getMonth()]!;

  /// Lấy Thập Thần của Can tháng so với Can ngày (Nhật Chủ) (tiếng Trung).
  String getMonthShiShenGan() =>
      LunarUtil.SHI_SHEN['${getDayGan()}${getMonthGan()}']!;

  /// Lấy Thập Thần của các Can tàng ẩn trong Chi tháng so với Can ngày (Nhật Chủ) (tiếng Trung).
  List<String> getMonthShiShenZhi() => getShiShenZhi(getMonthZhi());

  /// Lấy trạng thái Vòng Trường Sinh của Chi tháng đối với Can ngày (Nhật Chủ) (tiếng Trung).
  String getMonthDiShi() => getDiShi(_lunar.getMonthZhiIndexExact());

  /// Lấy Can Chi ngày (dựa trên trường phái [_sect]).
  String getDay() =>
      2 == _sect ? _lunar.getDayInGanZhiExact2() : _lunar.getDayInGanZhiExact();

  /// Lấy Can ngày (Nhật Chủ) (dựa trên trường phái [_sect]).
  String getDayGan() =>
      2 == _sect ? _lunar.getDayGanExact2() : _lunar.getDayGanExact();

  /// Lấy Chi ngày (dựa trên trường phái [_sect]).
  String getDayZhi() =>
      2 == _sect ? _lunar.getDayZhiExact2() : _lunar.getDayZhiExact();

  /// Lấy các Can tàng ẩn trong Chi ngày (tiếng Trung).
  List<String> getDayHideGan() => LunarUtil.ZHI_HIDE_GAN[getDayZhi()]!;

  /// Lấy Ngũ hành của Can và Chi ngày (tiếng Trung).
  String getDayWuXing() =>
      LunarUtil.WU_XING_GAN[getDayGan()]! + LunarUtil.WU_XING_ZHI[getDayZhi()]!;

  /// Lấy Nạp Âm của ngày (tiếng Trung).
  String getDayNaYin() => LunarUtil.NAYIN[getDay()]!;

  /// Lấy Thập Thần của Can ngày (luôn là 'Nhật Chủ').
  String getDayShiShenGan() => 'Nhật Chủ';

  /// Lấy Thập Thần của các Can tàng ẩn trong Chi ngày so với Can ngày (Nhật Chủ) (tiếng Trung).
  List<String> getDayShiShenZhi() => getShiShenZhi(getDayZhi());

  /// Lấy trạng thái Vòng Trường Sinh của Chi ngày đối với Can ngày (Nhật Chủ) (tiếng Trung).
  String getDayDiShi() => getDiShi(getDayZhiIndex());

  /// Lấy Can Chi giờ.
  String getTime() => _lunar.getTimeInGanZhi();

  /// Lấy Can giờ.
  String getTimeGan() => _lunar.getTimeGan();

  /// Lấy Chi giờ.
  String getTimeZhi() => _lunar.getTimeZhi();

  /// Lấy các Can tàng ẩn trong Chi giờ (tiếng Trung).
  List<String> getTimeHideGan() => LunarUtil.ZHI_HIDE_GAN[getTimeZhi()]!;

  /// Lấy Ngũ hành của Can và Chi giờ (tiếng Trung).
  String getTimeWuXing() =>
      LunarUtil.WU_XING_GAN[getTimeGan()]! +
      LunarUtil.WU_XING_ZHI[getTimeZhi()]!;

  /// Lấy Nạp Âm của giờ (tiếng Trung).
  String getTimeNaYin() => LunarUtil.NAYIN[getTime()]!;

  /// Lấy Thập Thần của Can giờ so với Can ngày (Nhật Chủ) (tiếng Trung).
  String getTimeShiShenGan() => LunarUtil.SHI_SHEN[getDayGan() + getTimeGan()]!;

  /// Lấy Thập Thần của các Can tàng ẩn trong Chi giờ so với Can ngày (Nhật Chủ) (tiếng Trung).
  List<String> getTimeShiShenZhi() => getShiShenZhi(getTimeZhi());

  /// Lấy trạng thái Vòng Trường Sinh của Chi giờ đối với Can ngày (Nhật Chủ) (tiếng Trung).
  String getTimeDiShi() => getDiShi(_lunar.getTimeZhiIndex());

  /// Lấy Can Chi của Thai Nguyên.
  String getTaiYuan() {
    int ganIndex = _lunar.getMonthGanIndexExact() + 1;
    if (ganIndex >= 10) {
      ganIndex -= 10;
    }
    int zhiIndex = _lunar.getMonthZhiIndexExact() + 3;
    if (zhiIndex >= 12) {
      zhiIndex -= 12;
    }
    return LunarUtil.GAN[ganIndex + 1] + LunarUtil.ZHI[zhiIndex + 1];
  }

  /// Lấy Nạp Âm của Thai Nguyên (tiếng Trung).
  String getTaiYuanNaYin() => LunarUtil.NAYIN[getTaiYuan()]!;

  /// Lấy Can Chi của Thai Tức.
  String getTaiXi() {
    int ganIndex =
        (2 == _sect)
            ? _lunar.getDayGanIndexExact2()
            : _lunar.getDayGanIndexExact();
    int zhiIndex =
        (2 == _sect)
            ? _lunar.getDayZhiIndexExact2()
            : _lunar.getDayZhiIndexExact();
    return LunarUtil.HE_GAN_5[ganIndex] + LunarUtil.HE_ZHI_6[zhiIndex];
  }

  /// Lấy Nạp Âm của Thai Tức (tiếng Trung).
  String getTaiXiNaYin() => LunarUtil.NAYIN[getTaiXi()]!;

  /// Lấy Can Chi của Mệnh Cung.
  String getMingGong() {
    int monthZhiIndex = 0;
    int timeZhiIndex = 0;
    String monthZhi = getMonthZhi();
    String timeZhi = getTimeZhi();
    for (int i = 0, j = MONTH_ZHI.length; i < j; i++) {
      if (monthZhi == MONTH_ZHI[i]) {
        monthZhiIndex = i;
        break;
      }
    }
    // Sử dụng LunarUtil.ZHI thay vì MONTH_ZHI cho giờ vì MONTH_ZHI bắt đầu từ Dần
    for (int i = 1, j = LunarUtil.ZHI.length; i < j; i++) {
      if (timeZhi == LunarUtil.ZHI[i]) {
        timeZhiIndex = i - 1; // Chuyển về index 0-11
        break;
      }
    }
    // Công thức tính Mệnh Cung: (14 - (Tháng Chi + Giờ Chi)) % 12
    // Tháng Chi index trong MONTH_ZHI (1=Dần, ..., 12=Sửu)
    // Giờ Chi index (0=Tý, ..., 11=Hợi)
    // Cần đồng bộ index: Chuyển tháng về index 0-11 (0=Dần, ..., 11=Sửu)
    int monthIndex0Based = (monthZhiIndex - 1 + 12) % 12;
    int offset =
        (14 - (monthIndex0Based + 1 + timeZhiIndex + 1)) %
        12; // +1 vì index gốc là 1-based? Kiểm tra lại logic gốc
    if (offset < 0) offset += 12;

    // Công thức tính Can Mệnh Cung: (Can Năm + 1) * 2 + Chi Mệnh Cung (index 0-11)
    int ganIndex = (_lunar.getYearGanIndexExact() + 1) * 2 + offset;
    ganIndex = (ganIndex - 1) % 10; // Chuyển về index 0-9

    // Chi Mệnh Cung lấy từ MONTH_ZHI theo offset (index 0-11 -> 1-12)
    return LunarUtil.GAN[ganIndex + 1] + MONTH_ZHI[offset + 1];
  }

  /// Lấy Nạp Âm của Mệnh Cung (tiếng Trung).
  String getMingGongNaYin() => LunarUtil.NAYIN[getMingGong()]!;

  /// Lấy Can Chi của Thân Cung.
  String getShenGong() {
    int monthZhiIndex = 0;
    int timeZhiIndex = 0;
    String monthZhi = getMonthZhi();
    String timeZhi = getTimeZhi();
    for (int i = 0, j = MONTH_ZHI.length; i < j; i++) {
      if (monthZhi == MONTH_ZHI[i]) {
        monthZhiIndex = i;
        break;
      }
    }
    // Sử dụng LunarUtil.ZHI thay vì MONTH_ZHI cho giờ
    for (int i = 1, j = LunarUtil.ZHI.length; i < j; i++) {
      if (timeZhi == LunarUtil.ZHI[i]) {
        timeZhiIndex = i - 1; // Chuyển về index 0-11
        break;
      }
    }
    // Công thức tính Thân Cung: (Tháng Chi + Giờ Chi) % 12
    // Tháng Chi index trong MONTH_ZHI (1=Dần, ..., 12=Sửu)
    // Giờ Chi index (0=Tý, ..., 11=Hợi)
    // Đồng bộ index: Chuyển tháng về index 0-11 (0=Dần, ..., 11=Sửu)
    int monthIndex0Based = (monthZhiIndex - 1 + 12) % 12;
    int offset =
        (monthIndex0Based + 1 + timeZhiIndex + 1) %
        12; // +1 vì index gốc là 1-based? Kiểm tra lại logic gốc
    if (offset < 0) offset += 12;

    // Công thức tính Can Thân Cung: (Can Năm + 1) * 2 + Chi Thân Cung (index 0-11)
    int ganIndex = (_lunar.getYearGanIndexExact() + 1) * 2 + offset;
    ganIndex = (ganIndex - 1) % 10; // Chuyển về index 0-9

    // Chi Thân Cung lấy từ MONTH_ZHI theo offset (index 0-11 -> 1-12)
    return LunarUtil.GAN[ganIndex + 1] + MONTH_ZHI[offset + 1];
  }

  /// Lấy Nạp Âm của Thân Cung (tiếng Trung).
  String getShenGongNaYin() => LunarUtil.NAYIN[getShenGong()]!;

  /// Lấy đối tượng Vận (dùng để tính Đại Vận, Lưu Niên, Tiểu Vận).
  ///
  /// [gender] Giới tính (1 = nam, 0 = nữ).
  /// [sect] Cách tính khởi Vận (1 hoặc 2, mặc định là 1).
  Yun getYun(int gender, [int sect = 1]) => Yun(this, gender, sect);

  /// Lấy Tuần Giáp Tý của năm (tiếng Trung).
  String getYearXun() => _lunar.getYearXunExact();

  /// Lấy Tuần Không (Không Vong) của năm (tiếng Trung).
  String getYearXunKong() => _lunar.getYearXunKongExact();

  /// Lấy Tuần Giáp Tý của tháng (tiếng Trung).
  String getMonthXun() => _lunar.getMonthXunExact();

  /// Lấy Tuần Không (Không Vong) của tháng (tiếng Trung).
  String getMonthXunKong() => _lunar.getMonthXunKongExact();

  /// Lấy Tuần Giáp Tý của ngày (dựa trên trường phái [_sect]) (tiếng Trung).
  String getDayXun() =>
      2 == _sect ? _lunar.getDayXunExact2() : _lunar.getDayXunExact();

  /// Lấy Tuần Không (Không Vong) của ngày (dựa trên trường phái [_sect]) (tiếng Trung).
  String getDayXunKong() =>
      2 == _sect ? _lunar.getDayXunKongExact2() : _lunar.getDayXunKongExact();

  /// Lấy Tuần Giáp Tý của giờ (tiếng Trung).
  String getTimeXun() => _lunar.getTimeXun();

  /// Lấy Tuần Không (Không Vong) của giờ (tiếng Trung).
  String getTimeXunKong() => _lunar.getTimeXunKong();

  /// Trả về chuỗi biểu diễn Bát Tự (Năm Tháng Ngày Giờ).
  @override
  String toString() => '${getYear()} ${getMonth()} ${getDay()} ${getTime()}';
}
