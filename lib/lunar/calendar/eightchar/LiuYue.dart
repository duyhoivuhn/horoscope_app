import '../../lunar.dart'; // Giữ lại import này
import '../util/LunarUtil.dart'; // Giữ lại import này
import 'LiuNian.dart'; // Giữ lại import này

/// Lưu Nguyệt (Vòng Vận Hàng Tháng)
/// @author 6tail
class LiuYue {
  /// Số thứ tự của tháng trong năm Lưu Niên, 0-11
  int _index;

  /// Lưu Niên (Vòng Vận Hàng Năm) chứa Lưu Nguyệt này
  LiuNian _liuNian;

  /// Khởi tạo một đối tượng Lưu Nguyệt.
  ///
  /// [_liuNian] Lưu Niên chứa tháng này.
  /// [_index] Chỉ số của tháng (0 = tháng 1, 1 = tháng 2, ..., 11 = tháng 12).
  LiuYue(this._liuNian, this._index);

  /// Lấy tên tháng theo tiếng Trung (từ LunarUtil.MONTH).
  /// Để có tiếng Việt, cần sửa đổi LunarUtil.MONTH hoặc thêm logic dịch.
  String getMonthInChinese() => LunarUtil.MONTH[_index + 1];

  /// Lấy số thứ tự của tháng trong năm Lưu Niên (0-11).
  int getIndex() => _index;

  /// Lấy Can Chi của tháng Lưu Nguyệt.
  String getGanZhi() {
    int offset = 0;
    // Lấy Can của năm Lưu Niên
    String yearGan = _liuNian.getGanZhi().substring(0, 1);

    // Xác định giá trị độ lệch (offset) dựa trên Thiên Can của năm (yearGan)
    if ('Giáp' == yearGan || 'Kỷ' == yearGan) {
      // Nếu Thiên Can của năm là Giáp hoặc Kỷ
      offset = 2; // thì độ lệch là 2
    } else if ('Ất' == yearGan || 'Canh' == yearGan) {
      // Ngược lại, nếu Thiên Can của năm là Ất hoặc Canh
      offset = 4; // thì độ lệch là 4
    } else if ('Bính' == yearGan || 'Tân' == yearGan) {
      // Ngược lại, nếu Thiên Can của năm là Bính hoặc Tân
      offset = 6; // thì độ lệch là 6
    } else if ('Đinh' == yearGan || 'Nhâm' == yearGan) {
      // Ngược lại, nếu Thiên Can của năm là Đinh hoặc Nhâm
      offset = 8; // thì độ lệch là 8
    }
    // Tính Can tháng
    String gan = LunarUtil.GAN[(_index + offset) % 10 + 1];
    // Tính Chi tháng (Chi tháng bắt đầu từ Dần - index 3)
    String zhi =
        LunarUtil.ZHI[(_index + LunarUtil.BASE_MONTH_ZHI_INDEX) % 12 + 1];
    return gan + zhi;
  }

  /// Lấy Tuần (Xun) của Can Chi tháng Lưu Nguyệt (tiếng Trung).
  String getXun() => LunarUtil.getXun(getGanZhi());

  /// Lấy Tuần Không (Xun Kong) của Can Chi tháng Lưu Nguyệt (tiếng Trung).
  String getXunKong() => LunarUtil.getXunKong(getGanZhi());
}
