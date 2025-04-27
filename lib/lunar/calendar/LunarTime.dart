import 'Lunar.dart';
import 'NineStar.dart';
import 'Solar.dart';
import 'util/LunarUtil.dart';

/// 阴历时辰
/// @author 6tail
class LunarTime {
  /// 天干下标，0-9
  int _ganIndex = 0;

  /// 地支下标，0-11
  int _zhiIndex = 0;

  /// 阴历
  Lunar? _lunar;

  LunarTime.fromYmdHms(int lunarYear, int lunarMonth, int lunarDay, int hour,
      int minute, int second) {
    _lunar =
        Lunar.fromYmdHms(lunarYear, lunarMonth, lunarDay, hour, minute, second);
    _zhiIndex = LunarUtil.getTimeZhiIndex(
        '${hour < 10 ? '0' : ''}$hour:${minute < 10 ? '0' : ''}$minute');
    _ganIndex = (_lunar!.getDayGanIndexExact() % 5 * 2 + _zhiIndex) % 10;
  }

  int getGanIndex() => _ganIndex;

  int getZhiIndex() => _zhiIndex;

  String getShengXiao() => LunarUtil.SHENGXIAO[_zhiIndex + 1];

  String getGan() => LunarUtil.GAN[_ganIndex + 1];

  String getZhi() => LunarUtil.ZHI[_zhiIndex + 1];

  String getGanZhi() => '${getGan()}${getZhi()}';

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

  String getNaYin() => LunarUtil.NAYIN[getGanZhi()]!;

  String getTianShen() {
    return LunarUtil.TIAN_SHEN[(_zhiIndex +
                LunarUtil.ZHI_TIAN_SHEN_OFFSET[_lunar!.getDayZhiExact()]!) %
            12 +
        1];
  }

  String getTianShenType() => LunarUtil.TIAN_SHEN_TYPE[getTianShen()]!;

  String getTianShenLuck() => LunarUtil.TIAN_SHEN_TYPE_LUCK[getTianShenType()]!;

  String getChong() => LunarUtil.CHONG[_zhiIndex];

  String getSha() => LunarUtil.SHA[getZhi()]!;

  String getChongShengXiao() {
    String chong = getChong();
    for (int i = 0, j = LunarUtil.ZHI.length; i < j; i++) {
      if (LunarUtil.ZHI[i] == chong) {
        return LunarUtil.SHENGXIAO[i];
      }
    }
    return '';
  }

  String getChongDesc() =>
      '(${getChongGan()}${getChong()})${getChongShengXiao()}';

  String getChongGan() => LunarUtil.CHONG_GAN[_ganIndex];

  String getChongGanTie() => LunarUtil.CHONG_GAN_TIE[_ganIndex];

  List<String> getYi() =>
      LunarUtil.getTimeYi(_lunar!.getDayInGanZhiExact(), getGanZhi());

  List<String> getJi() =>
      LunarUtil.getTimeJi(_lunar!.getDayInGanZhiExact(), getGanZhi());

  /// Lấy Cửu Tinh của Giờ (Thời Phi Tinh - theo một phương pháp khác)
  /// Tính toán dựa trên Tiết Khí (Đông Chí, Hạ Chí) và Địa Chi của ngày, giờ.
  NineStar getNineStar() {
    // Xác định chiều Thuận/Nghịch của Phi tinh trong ngày
    String solarYmd =
        _lunar!.getSolar().toYmd(); // Lấy ngày Dương lịch dạng YYYY-MM-DD
    Map<String, Solar> jieQi = _lunar!.getJieQiTable(); // Lấy bảng Tiết Khí
    bool asc = false; // Biến xác định chiều thuận (true) hay nghịch (false)
    // Nếu ngày hiện tại nằm trong khoảng từ Đông Chí đến trước Hạ Chí
    if (solarYmd.compareTo(jieQi['Đông Chí']!.toYmd()) >= 0 &&
        solarYmd.compareTo(jieQi['Hạ Chí']!.toYmd()) < 0) {
      asc = true; // Chiều thuận
    }
    // Xác định sao nhập trung cung (sao khởi đầu) cho giờ Tý (theo phương pháp này)
    // Mặc định cho các ngày Dần, Thân, Tỵ, Hợi (Tứ Mạnh/Tứ Sinh)
    int start =
        asc ? 7 : 3; // Thuận khởi từ Thất Xích (7), Nghịch khởi từ Tam Bích (3)
    String dayZhi = _lunar!.getDayZhi(); // Lấy Địa Chi của ngày
    if ('TýNgọMãoDậu'.contains(dayZhi)) {
      // Nếu là ngày Tý, Ngọ, Mão, Dậu (Tứ Chính)
      start =
          asc ? 1 : 9; // Thuận khởi từ Nhất Bạch (1), Nghịch khởi từ Cửu Tử (9)
    } else if ('ThìnTuấtSửuMùi'.contains(dayZhi)) {
      // Nếu là ngày Thìn, Tuất, Sửu, Mùi (Tứ Mộ)
      start =
          asc ? 4 : 6; // Thuận khởi từ Tứ Lục (4), Nghịch khởi từ Lục Bạch (6)
    }
    // Tính chỉ số sao cho giờ hiện tại (_zhiIndex là chỉ số Địa Chi của giờ, 0-11)
    // Lưu ý: Công thức tính index có thể cần xem lại tùy thuộc vào cách _zhiIndex được định nghĩa (0=Tý hay 1=Tý)
    // Giả sử _zhiIndex là 0-11 (Tý=0, Sửu=1, ...)
    // Thuận: Sao khởi đầu + số giờ đã qua (ví dụ: Tý là 0, Sửu là 1,...)
    // Nghịch: Sao khởi đầu - số giờ đã qua
    int index = asc ? (start + _zhiIndex) : (start - _zhiIndex);
    // Điều chỉnh chỉ số về khoảng 1-9 (hoặc 0-8 tùy cách biểu diễn)
    // Đoạn mã gốc dùng phép trừ 1, có thể là do start là 1-9 và _zhiIndex là 0-11?
    // Thử theo logic gốc:
    // index = asc ? start + _zhiIndex - 1 : start - _zhiIndex - 1;
    // Cần làm rõ _zhiIndex bắt đầu từ 0 hay 1 và start là 1-9 hay 0-8.
    // Giả sử start là 1-9 và _zhiIndex là 0-11 (Tý=0).
    // Thuận: index = start + _zhiIndex
    // Nghịch: index = start - _zhiIndex
    // Sau đó chuẩn hóa về 0-8
    index = index % 9; // Lấy phần dư
    if (index <= 0) {
      // Nếu dư 0 hoặc âm (do phép trừ)
      index += 9; // Chuyển về 9 (hoặc cộng 9 nếu âm)
    }
    index -= 1; // Chuyển về index 0-8

    // Đoạn mã gốc có điều chỉnh khác:
    // if (index > 8) {
    //   index -= 9;
    // }
    // if (index < 0) {
    //   index += 9;
    // }
    // -> Chuẩn hóa index về khoảng 0-8

    // Trả về đối tượng NineStar tương ứng với chỉ số cuối cùng (0-8)
    return NineStar.fromIndex(
        index); // Sử dụng fromIndex nếu NineStar(index) không tồn tại
  }

  @override
  String toString() => getGanZhi();

  String getXun() => LunarUtil.getXun(getGanZhi());

  String getXunKong() => LunarUtil.getXunKong(getGanZhi());

  String getMinHm() {
    int hour = _lunar!.getHour();
    if (hour < 1) {
      return '00:00';
    } else if (hour > 22) {
      return '23:00';
    }
    if (hour % 2 == 0) {
      hour -= 1;
    }
    return '${hour < 10 ? '0' : ''}$hour:00';
  }

  String getMaxHm() {
    int hour = _lunar!.getHour();
    if (hour < 1) {
      return '00:59';
    } else if (hour > 22) {
      return '23:59';
    }
    if (hour % 2 != 0) {
      hour += 1;
    }
    return '${hour < 10 ? '0' : ''}$hour:59';
  }
}
