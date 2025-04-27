import 'util/LunarUtil.dart';

/// 九星
/// <p>玄空九星、奇门九星都来源于北斗九星，九数、七色、五行、后天八卦方位都是相通的。</p>
/// @author 6tail
class NineStar {
  /// Cửu Số (Số từ 1 đến 9)
  static const List<String> NUMBER = [
    'Một', // 一
    'Hai', // 二
    'Ba', // 三
    'Bốn', // 四
    'Năm', // 五
    'Sáu', // 六
    'Bảy', // 七
    'Tám', // 八
    'Chín' // 九
  ];

  /// Thất Sắc (7 màu sắc tương ứng với Cửu Tinh - có lặp lại)
  static const List<String> COLOR = [
    'Trắng', // 白 (Nhất Bạch)
    'Đen', // 黑 (Nhị Hắc)
    'Xanh Biếc', // 碧 (Tam Bích)
    'Xanh Lục', // 绿 (Tứ Lục)
    'Vàng', // 黄 (Ngũ Hoàng)
    'Trắng', // 白 (Lục Bạch)
    'Đỏ', // 赤 (Thất Xích)
    'Trắng', // 白 (Bát Bạch)
    'Tím' // 紫 (Cửu Tử)
  ];

  /// Ngũ Hành (Ngũ hành tương ứng với Cửu Tinh)
  static const List<String> WU_XING = [
    'Thủy', // 水 (Nhất Bạch)
    'Thổ', // 土 (Nhị Hắc)
    'Mộc', // 木 (Tam Bích)
    'Mộc', // 木 (Tứ Lục)
    'Thổ', // 土 (Ngũ Hoàng)
    'Kim', // 金 (Lục Bạch)
    'Kim', // 金 (Thất Xích)
    'Thổ', // 土 (Bát Bạch)
    'Hỏa' // 火 (Cửu Tử)
  ];

  /// Phương vị Hậu Thiên Bát Quái (Tương ứng với Cửu Tinh)
  static const List<String> POSITION = [
    'Khảm', // 坎 (Nhất Bạch)
    'Khôn', // 坤 (Nhị Hắc)
    'Chấn', // 震 (Tam Bích)
    'Tốn', // 巽 (Tứ Lục)
    'Trung', // 中 (Ngũ Hoàng - Trung Cung)
    'Càn', // 乾 (Lục Bạch)
    'Đoài', // 兑 (Thất Xích)
    'Cấn', // 艮 (Bát Bạch)
    'Ly' // 离 (Cửu Tử)
  ];

  /// Bắc Đẩu Cửu Tinh (Tên các sao trong chòm Bắc Đẩu + 2 sao phụ)
  static const List<String> NAME_BEI_DOU = [
    'Thiên Xu', // 天枢 (Tham Lang)
    'Thiên Toàn', // 天璇 (Cự Môn)
    'Thiên Cơ', // 天玑 (Lộc Tồn)
    'Thiên Quyền', // 天权 (Văn Khúc)
    'Ngọc Hành', // 玉衡 (Liêm Trinh)
    'Khai Dương', // 开阳 (Vũ Khúc)
    'Dao Quang', // 摇光 (Phá Quân)
    'Động Minh', // 洞明 (Tả Phù - sao phụ)
    'Ẩn Nguyên' // 隐元 (Hữu Bật - sao phụ)
  ];

  /// Huyền Không Cửu Tinh (Huyền Không Phi Tinh trong Phong Thủy)
  static const List<String> NAME_XUAN_KONG = [
    'Tham Lang', // 贪狼 (Nhất Bạch)
    'Cự Môn', // 巨门 (Nhị Hắc)
    'Lộc Tồn', // 禄存 (Tam Bích)
    'Văn Khúc', // 文曲 (Tứ Lục)
    'Liêm Trinh', // 廉贞 (Ngũ Hoàng)
    'Vũ Khúc', // 武曲 (Lục Bạch)
    'Phá Quân', // 破军 (Thất Xích)
    'Tả Phù', // 左辅 (Bát Bạch)
    'Hữu Bật' // 右弼 (Cửu Tử)
  ];

  /// Kỳ Môn Cửu Tinh (Kỳ Môn Độn Giáp, còn gọi là Thiên Bàn Cửu Tinh)
  static const List<String> NAME_QI_MEN = [
    'Thiên Bồng', // 天蓬
    'Thiên Nhuế', // 天芮
    'Thiên Xung', // 天冲
    'Thiên Phụ', // 天辅
    'Thiên Cầm', // 天禽
    'Thiên Tâm', // 天心
    'Thiên Trụ', // 天柱
    'Thiên Nhậm', // 天任
    'Thiên Anh' // 天英
  ];

  /// Bát Môn (Kỳ Môn Độn Giáp - 8 cửa ứng với 8 cung, trừ Trung cung)
  static const List<String> BA_MEN_QI_MEN = [
    'Hưu', // 休 (Cửa Hưu - Khảm)
    'Tử', // 死 (Cửa Tử - Khôn)
    'Thương', // 伤 (Cửa Thương - Chấn)
    'Đỗ', // 杜 (Cửa Đỗ - Tốn)
    '', // Trung cung không có cửa riêng
    'Khai', // 开 (Cửa Khai - Càn)
    'Kinh', // 惊 (Cửa Kinh - Đoài)
    'Sinh', // 生 (Cửa Sinh - Cấn)
    'Cảnh' // 景 (Cửa Cảnh - Ly)
  ];

  /// Thái Ất Cửu Thần (Thái Ất Thần Số)
  static const List<String> NAME_TAI_YI = [
    'Thái Ất', // 太乙
    'Nhiếp Đề', // 摄提
    'Hiên Viên', // 轩辕
    'Chiêu Diêu', // 招摇
    'Thiên Phù', // 天符
    'Thanh Long', // 青龙
    'Hàm Trì', // 咸池
    'Thái Âm', // 太阴
    'Thiên Ất' // 天乙
  ];

  /// Loại hình Thái Ất Cửu Thần
  static const List<String> TYPE_TAI_YI = [
    'Cát Thần', // 吉神 (Thần tốt)
    'Hung Thần', // 凶神 (Thần xấu)
    'An Thần', // 安神 (Thần bình hòa)
    'An Thần', // 安神
    'Hung Thần', // 凶神
    'Cát Thần', // 吉神
    'Hung Thần', // 凶神
    'Cát Thần', // 吉神
    'Cát Thần' // 吉神
  ];

  /// Ca quyết Thái Ất Cửu Thần (Thái Ất Thần Số)
  static const List<String> SONG_TAI_YI = [
    'Trong cửa Thái Ất sáng, Tinh quan hiệu Tham Lang, Đánh bạc tài lộc vượng, Hôn nhân đại cát tường, Ra vào không trở ngại, Tham yết gặp hiền lương, Chuyến này ba năm dặm, Áo đen biệt âm dương.', // Thái Ất
    'Trước cửa gặp Nhiếp Đề, Trăm việc ắt lo nghi, Tương sinh còn tạm được, Tương khắc họa tất nguy, Cửa Tử cùng tương hội, Bà lão khóc bi ai, Mưu cầu cùng việc tốt, Đều là chẳng tương nghi, Chỉ có thể ẩn náu, Nếu động tổn thân nguy.', // Nhiếp Đề
    'Ra vào hội Hiên Viên, Mọi việc ắt triền miên, Tương sinh đều chẳng đẹp, Tương khắc càng ưu phiền, Đi xa nhiều bất lợi, Đánh bạc sạch túi tiền, Cửu Thiên Huyền Nữ pháp, Câu câu chẳng hư ngôn.', // Hiên Viên
    'Chiêu Diêu hiệu Mộc tinh, Gặp phải việc chớ hành, Tương khắc người đi bị chặn, Người âm khẩu thiệt nghênh, Nằm mơ nhiều kinh sợ, Nhà kêu búa tự vang, Âm dương tiêu tức lý, Vạn pháp chẳng trái tình.', // Chiêu Diêu
    'Ngũ Quỷ là Thiên Phù, Gặp cửa gái âm mưu, Tương khắc không việc tốt, Đi đường trở giữa途 (đường), Mất mát khó tìm kiếm, Đường gặp có ni cô, Sao này gặp cửa đến, Vạn sự có tai trừ.', // Thiên Phù
    'Thần quang vọt Thanh Long, Tài khí mừng trùng trùng, Đến nơi có rượu thịt, Đánh bạc rất thịnh long, Lại gặp tương sinh vượng, Thôi bàn khắc phá hung, Gặp quý an doanh trại, Vạn sự tổng cát đồng.', // Thanh Long
    'Ta sắp là Hàm Trì, Gặp phải đều chẳng nghi, Ra vào nhiều bất lợi, Tương khắc có tai nguy, Đánh bạc thua sạch hết, Cầu tài tay trắng về, Tiên nhân lời thật diệu, Kẻ ngu chớ cho hay, Động dụng hư kinh lui, Lặp lại ngược gió thổi.', // Hàm Trì
    'Ngồi lâm sao Thái Âm, Trăm họa chẳng tương xâm, Mưu cầu đều thành tựu, Bạn bè có kiếm tìm, Gió về đường trở lại, E có họa ngầm sinh, Lời mật trong lòng nhớ, Cẩn thận chớ khinh hành.', // Thái Âm
    'Đón rước sao Thiên Ất, Gặp gỡ trăm việc hưng, Vận dụng hòa hợp mừng, Trà rượu mừng đón nghênh, Mưu cầu cùng cưới gả, Tốt hợp có trời thành, Họa phúc như thần nghiệm, Tốt xấu rất phân minh.' // Thiên Ất
  ];

  /// Cát Hung (Huyền Không Phi Tinh)
  static const List<String> LUCK_XUAN_KONG = [
    'Cát', // 吉 (Tốt)
    'Hung', // 凶 (Xấu)
    'Hung', // 凶
    'Cát', // 吉
    'Hung', // 凶
    'Cát', // 吉
    'Hung', // 凶
    'Cát', // 吉
    'Cát' // 吉
  ];

  /// Cát Hung (Kỳ Môn Độn Giáp)
  static const List<String> LUCK_QI_MEN = [
    'Đại Hung', // 大凶 (Rất xấu)
    'Đại Hung', // 大凶
    'Tiểu Cát', // 小吉 (Hơi tốt)
    'Đại Cát', // 大吉 (Rất tốt)
    'Đại Cát', // 大吉
    'Đại Cát', // 大吉
    'Tiểu Hung', // 小凶 (Hơi xấu)
    'Tiểu Cát', // 小吉
    'Tiểu Hung' // 小凶
  ];

  /// Âm Dương (Kỳ Môn Độn Giáp)
  static const List<String> YIN_YANG_QI_MEN = [
    'Dương', // 阳
    'Âm', // 阴
    'Dương', // 阳
    'Dương', // 阳
    'Dương', // 阳
    'Âm', // 阴
    'Âm', // 阴
    'Dương', // 阳
    'Âm' // 阴
  ];

  /// 序号，0到8
  int _index = 0;

  NineStar(this._index);

  static NineStar fromIndex(int index) {
    return new NineStar(index);
  }

  String getNumber() => NUMBER[_index];

  String getColor() => COLOR[_index];

  String getWuXing() => WU_XING[_index];

  String getPosition() => POSITION[_index];

  String? getPositionDesc() => LunarUtil.POSITION_DESC[getPosition()];

  String getNameInXuanKong() => NAME_XUAN_KONG[_index];

  String getNameInBeiDou() => NAME_BEI_DOU[_index];

  String getNameInQiMen() => NAME_QI_MEN[_index];

  String getNameInTaiYi() => NAME_TAI_YI[_index];

  String getLuckInQiMen() => LUCK_QI_MEN[_index];

  String getLuckInXuanKong() => LUCK_XUAN_KONG[_index];

  String getYinYangInQiMen() => YIN_YANG_QI_MEN[_index];

  String getTypeInTaiYi() => TYPE_TAI_YI[_index];

  String getBaMenInQiMen() => BA_MEN_QI_MEN[_index];

  String getSongInTaiYi() => SONG_TAI_YI[_index];

  int getIndex() => _index;

  @override
  String toString() =>
      '${getNumber()}${getColor()}${getWuXing()}${getNameInBeiDou()}';

  /// Trả về chuỗi đầy đủ thông tin chi tiết của Cửu Tinh
  String toFullString() {
    String s =
        '${getNumber()}${getColor()}${getWuXing()} ${getPosition()}(${getPositionDesc()})${getNameInBeiDou()} Huyền Không[${getNameInXuanKong()} ${getLuckInXuanKong()}] Kỳ Môn[${getNameInQiMen()} ${getLuckInQiMen()}';
    // '玄空[' -> 'Huyền Không['
    // '奇门[' -> 'Kỳ Môn['

    // Nếu có thông tin Bát Môn
    if (getBaMenInQiMen().isNotEmpty) {
      s += ' ${getBaMenInQiMen()} Cửa'; // '门' -> ' Cửa' (Thêm dấu cách)
    }
    s +=
        ' ${getYinYangInQiMen()}] Thái Ất[${getNameInTaiYi()} ${getTypeInTaiYi()}]';
    // '太乙[' -> 'Thái Ất['
    return s;
  }
}
