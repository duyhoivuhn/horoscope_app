import '../TaoFestival.dart';

/// Công cụ Đạo lịch
/// @author 6tail
class TaoUtil {
  /// Bát Hội Nhật (Tám ngày Hội - theo Can Chi)
  static Map<String, String> BA_HUI = {
    'Bính Ngọ': 'Thiên Hội', // Bính Ngọ: Thiên Hội
    'Nhâm Ngọ': 'Địa Hội', // Nhâm Ngọ: Địa Hội
    'Nhâm Tý': 'Nhân Hội', // Nhâm Tý: Nhân Hội
    'Canh Ngọ': 'Nhật Hội', // Canh Ngọ: Nhật Hội
    'Canh Thân': 'Nguyệt Hội', // Canh Thân: Nguyệt Hội
    'Tân Dậu': 'Tinh Thần Hội', // Tân Dậu: Tinh Thần Hội
    'Giáp Thìn': 'Ngũ Hành Hội', // Giáp Thìn: Ngũ Hành Hội
    'Giáp Tuất': 'Tứ Thời Hội', // Giáp Tuất: Tứ Thời Hội
  };

  /// Bát Tiết Nhật (Tám ngày Tiết) - Ngày các Thiên Tôn hạ giáng (theo Đạo giáo)
  static Map<String, String> BA_JIE = {
    'Lập Xuân':
        'Đông Bắc phương Độ Tiên Thượng Thánh Thiên Tôn cùng Phạn Khí Thủy Thanh Thiên Quân hạ giáng', // Lập Xuân
    'Xuân Phân':
        'Đông phương Ngọc Bảo Tinh Thượng Thiên Tôn cùng Thanh Đế Cửu Khí Thiên Quân hạ giáng', // Xuân Phân
    'Lập Hạ':
        'Đông Nam phương Hảo Sinh Độ Mệnh Thiên Tôn cùng Phạn Khí Thủy Đan Thiên Quân hạ giáng', // Lập Hạ
    'Hạ Chí':
        'Nam phương Huyền Chân Vạn Phúc Thiên Tôn cùng Xích Đế Tam Khí Thiên Quân hạ giáng', // Hạ Chí
    'Lập Thu':
        'Tây Nam phương Thái Linh Hư Hoàng Thiên Tôn cùng Phạn Khí Thủy Tố Thiên Quân hạ giáng', // Lập Thu
    'Thu Phân':
        'Tây phương Thái Diệu Chí Cực Thiên Tôn cùng Bạch Đế Thất Khí Thiên Quân hạ giáng', // Thu Phân
    'Lập Đông':
        'Tây Bắc phương Vô Lượng Thái Hoa Thiên Tôn cùng Phạn Khí Thủy Huyền Thiên Quân hạ giáng', // Lập Đông
    'Đông Chí':
        'Bắc phương Huyền Thượng Ngọc Thần Thiên Tôn cùng Hắc Đế Ngũ Khí Thiên Quân hạ giáng',
    // Đông Chí
  };

  /// Tam Hội Nhật (Ba ngày Hội - theo Âm lịch)
  static const List<String> SAN_HUI = [
    '1-7',
    '7-7',
    '10-15',
  ]; // Mùng 7 tháng Giêng, Mùng 7 tháng 7, Rằm tháng 10

  /// Tam Nguyên Nhật (Ba ngày Nguyên - Rằm các tháng 1, 7, 10 Âm lịch)
  static const List<String> SAN_YUAN = [
    '1-15',
    '7-15',
    '10-15',
  ]; // Thượng Nguyên, Trung Nguyên, Hạ Nguyên

  /// Ngũ Lạp Nhật (Năm ngày Lạp - theo Âm lịch)
  static const List<String> WU_LA = [
    '1-1',
    '5-5',
    '7-7',
    '10-1',
    '12-8',
  ]; // Tết Nguyên Đán, Tết Đoan Ngọ, Thất Tịch, Tết Hàn Y, Lạp Bát

  /// Ám Mậu (Ngày Mậu ẩn - Ngày có Địa Chi tương ứng với Địa Chi của tháng, kỵ động thổ)
  /// Index 0-11 tương ứng tháng 1-12 Âm lịch (Dần-Sửu)
  static List<String> AN_WU = [
    'Mùi', // Tháng Dần (1) -> Ngày Mùi
    'Tuất', // Tháng Mão (2) -> Ngày Tuất
    'Thìn', // Tháng Thìn (3) -> Ngày Thìn
    'Dần', // Tháng Tỵ (4) -> Ngày Dần
    'Ngọ', // Tháng Ngọ (5) -> Ngày Ngọ
    'Tý', // Tháng Mùi (6) -> Ngày Tý
    'Dậu', // Tháng Thân (7) -> Ngày Dậu
    'Thân', // Tháng Dậu (8) -> Ngày Thân
    'Tỵ', // Tháng Tuất (9) -> Ngày Tỵ
    'Hợi', // Tháng Hợi (10) -> Ngày Hợi
    'Mão', // Tháng Tý (11) -> Ngày Mão
    'Sửu', // Tháng Sửu (12) -> Ngày Sửu
  ];

  /// Lễ hội Đạo lịch
  static final Map<String, List<TaoFestival>> FESTIVAL = {
    '1-1': [
      TaoFestival(
        'Thiên Lạp Chi Thần',
        'Thiên Lạp, ngày này Ngũ Đế hội tại Đông phương Cửu Khí Thanh Thiên',
      ),
    ],
    '1-3': [
      TaoFestival('Hác Chân Nhân thánh đản'),
      TaoFestival('Tôn Chân Nhân thánh đản'),
    ],
    '1-5': [TaoFestival('Tôn Tổ Thanh Tĩnh Nguyên Quân đản')],
    '1-7': [
      TaoFestival(
        'Cử Thiên Thưởng Hội',
        'Ngày này Thượng Nguyên ban phúc, Thiên Quan cùng Địa Thủy nhị quan khảo xét tội phúc',
      ),
    ],
    '1-9': [TaoFestival('Ngọc Hoàng Thượng Đế thánh đản')],
    '1-13': [TaoFestival('Quan Thánh Đế Quân phi thăng')],
    '1-15': [
      TaoFestival('Thượng Nguyên Thiên Quan thánh đản'),
      TaoFestival('Lão Tổ Thiên Sư thánh đản'),
    ],
    '1-19': [TaoFestival('Trường Xuân Khâu Chân Nhân (Khâu Xứ Cơ) thánh đản')],
    '1-28': [TaoFestival('Hứa Chân Quân (Hứa Tốn Thiên Sư) thánh đản')],
    '2-1': [
      TaoFestival('Câu Trần Thiên Hoàng Đại Đế thánh đản'),
      TaoFestival('Trường Xuân Lưu Chân Nhân (Lưu Uyên Nhiên) thánh đản'),
    ],
    '2-2': [
      TaoFestival('Thổ Địa Chính Thần đản'),
      TaoFestival('Khương Thái Công thánh đản'),
    ],
    '2-3': [TaoFestival('Văn Xương Tử Đồng Đế Quân thánh đản')],
    '2-6': [TaoFestival('Đông Hoa Đế Quân thánh đản')],
    '2-13': [TaoFestival('Độ Nhân Vô Lượng Cát Chân Quân thánh đản')],
    '2-15': [
      TaoFestival(
        'Thái Thanh Đạo Đức Thiên Tôn (Thái Thượng Lão Quân) thánh đản',
      ),
    ],
    '2-19': [
      TaoFestival('Từ Hàng Chân Nhân thánh đản'),
    ], // Thường được đồng hóa với Quan Âm
    '3-1': [
      TaoFestival('Đàm Tổ (Đàm Xứ Đoan) Trường Chân Chân Nhân thánh đản'),
    ],
    '3-3': [TaoFestival('Huyền Thiên Thượng Đế thánh đản')],
    '3-6': [TaoFestival('Nhãn Quang Nương Nương thánh đản')],
    '3-15': [
      TaoFestival('Thiên Sư Trương Đại Chân Nhân thánh đản'),
      TaoFestival('Tài Thần Triệu Công Nguyên Soái thánh đản'),
    ],
    '3-16': [
      TaoFestival('Tam Mao Chân Quân đắc đạo chi thần'),
      TaoFestival('Trung Nhạc Đại Đế thánh đản'),
    ],
    '3-18': [
      TaoFestival('Vương Tổ (Vương Xứ Nhất) Ngọc Dương Chân Nhân thánh đản'),
      TaoFestival('Hậu Thổ Nương Nương thánh đản'),
    ],
    '3-19': [TaoFestival('Thái Dương Tinh Quân thánh đản')],
    '3-20': [TaoFestival('Tử Tôn Nương Nương thánh đản')],
    '3-23': [TaoFestival('Thiên Hậu Ma Tổ thánh đản')],
    '3-26': [TaoFestival('Quỷ Cốc Tiên Sư đản')],
    '3-28': [TaoFestival('Đông Nhạc Đại Đế thánh đản')],
    '4-1': [TaoFestival('Trường Sinh Đàm Chân Quân thành đạo chi thần')],
    '4-10': [TaoFestival('Hà Tiên Cô thánh đản')],
    '4-14': [TaoFestival('Lữ Tổ Thuần Dương Tổ Sư thánh đản')],
    '4-15': [TaoFestival('Chung Ly Tổ Sư thánh đản')],
    '4-18': [
      TaoFestival('Bắc Cực Tử Vi Đại Đế thánh đản'),
      TaoFestival('Thái Sơn Thánh Mẫu Bích Hà Nguyên Quân đản'),
      TaoFestival('Hoa Đà Thần Y Tiên Sư đản'),
    ],
    '4-20': [TaoFestival('Nhãn Quang Thánh Mẫu Nương Nương đản')],
    '4-28': [TaoFestival('Thần Nông Tiên Đế đản')],
    '5-1': [TaoFestival('Nam Cực Trường Sinh Đại Đế thánh đản')],
    '5-5': [
      TaoFestival(
        'Địa Lạp Chi Thần',
        'Địa Lạp, ngày này Ngũ Đế hội tại Nam phương Tam Khí Đan Thiên',
      ),
      TaoFestival('Nam phương Lôi Tổ thánh đản'),
      TaoFestival('Địa Kỳ Ôn Nguyên Soái thánh đản'),
      TaoFestival('Lôi Đình Đặng Thiên Quân thánh đản'),
    ],
    '5-11': [TaoFestival('Thành Hoàng Gia thánh đản')],
    '5-13': [
      TaoFestival('Quan Thánh Đế Quân giáng thần'),
      TaoFestival('Quan Bình Thái Tử thánh đản'),
    ],
    '5-18': [TaoFestival('Trương Thiên Sư thánh đản')],
    '5-20': [TaoFestival('Mã Tổ Đan Dương Chân Nhân thánh đản')],
    '5-29': [TaoFestival('Tử Thanh Bạch Tổ Sư thánh đản')],
    '6-1': [TaoFestival('Nam Đẩu Tinh Quân hạ giáng')],
    '6-2': [TaoFestival('Nam Đẩu Tinh Quân hạ giáng')],
    '6-3': [TaoFestival('Nam Đẩu Tinh Quân hạ giáng')],
    '6-4': [TaoFestival('Nam Đẩu Tinh Quân hạ giáng')],
    '6-5': [TaoFestival('Nam Đẩu Tinh Quân hạ giáng')],
    '6-6': [TaoFestival('Nam Đẩu Tinh Quân hạ giáng')],
    '6-10': [TaoFestival('Lưu Hải Thiềm Tổ Sư thánh đản')],
    '6-15': [TaoFestival('Linh Quan Vương Thiên Quân thánh đản')],
    '6-19': [TaoFestival('Từ Hàng (Quan Âm) thành đạo nhật')],
    '6-23': [TaoFestival('Hỏa Thần thánh đản')],
    '6-24': [
      TaoFestival('Nam Cực Đại Đế Trung phương Lôi Tổ thánh đản'),
      TaoFestival('Quan Thánh Đế Quân thánh đản'),
    ],
    '6-26': [TaoFestival('Nhị Lang Chân Quân thánh đản')],
    '7-7': [
      TaoFestival(
        'Đạo Đức Lạp Chi Thần',
        'Đạo Đức Lạp, ngày này Ngũ Đế hội tại Tây phương Thất Khí Tố Thiên',
      ),
      TaoFestival(
        'Khánh Sinh Trung Hội',
        'Ngày này Trung Nguyên xá tội, Địa Quan cùng Thiên Thủy nhị quan khảo xét tội phúc',
      ),
    ],
    '7-12': [TaoFestival('Tây phương Lôi Tổ thánh đản')],
    '7-15': [TaoFestival('Trung Nguyên Địa Quan Đại Đế thánh đản')],
    '7-18': [TaoFestival('Vương Mẫu Nương Nương thánh đản')],
    '7-20': [
      TaoFestival('Lưu Tổ (Lưu Xứ Huyền) Trường Sinh Chân Nhân thánh đản'),
    ],
    '7-22': [
      TaoFestival(
        'Tài Bạch Tinh Quân Văn Tài Thần Tăng Phúc Tướng Công Lý Quỷ Tổ thánh đản',
      ),
    ],
    '7-26': [TaoFestival('Trương Tam Phong Tổ Sư thánh đản')],
    '8-1': [TaoFestival('Hứa Chân Quân phi thăng nhật')],
    '8-3': [TaoFestival('Cửu Thiên Tư Mệnh Táo Quân đản')],
    '8-5': [TaoFestival('Bắc phương Lôi Tổ thánh đản')],
    '8-10': [TaoFestival('Bắc Nhạc Đại Đế đản thần')],
    '8-15': [TaoFestival('Thái Âm Tinh Quân đản')],
    '9-1': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-2': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-3': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-4': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-5': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-6': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-7': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-8': [TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần')],
    '9-9': [
      TaoFestival('Bắc Đẩu Cửu Hoàng giáng thế chi thần'),
      TaoFestival('Đẩu Mẫu Nguyên Quân thánh đản'),
      TaoFestival('Trùng Dương Đế Quân thánh đản'),
      TaoFestival('Huyền Thiên Thượng Đế phi thăng'),
      TaoFestival('Phong Đô Đại Đế thánh đản'),
    ],
    '9-22': [TaoFestival('Tăng Phúc Tài Thần đản')],
    '9-23': [TaoFestival('Tát Ông Chân Quân thánh đản')],
    '9-28': [TaoFestival('Ngũ Hiển Linh Quan Mã Nguyên Soái thánh đản')],
    '10-1': [
      TaoFestival(
        'Dân Tuế Lạp Chi Thần',
        'Dân Tuế Lạp, ngày này Ngũ Đế hội tại Bắc phương Ngũ Khí Hắc Thiên',
      ),
      TaoFestival('Đông Hoàng Đại Đế thánh đản'),
    ],
    '10-3': [TaoFestival('Tam Mao Ứng Hóa Chân Quân thánh đản')],
    '10-6': [TaoFestival('Thiên Tào Chư Ty Ngũ Nhạc Ngũ Đế thánh đản')],
    '10-15': [
      TaoFestival('Hạ Nguyên Thủy Quan Đại Đế thánh đản'),
      TaoFestival(
        'Kiến Sinh Đại Hội',
        'Ngày này Hạ Nguyên giải ách, Thủy Quan cùng Thiên Địa nhị quan khảo xét tội phúc',
      ),
    ],
    '10-18': [TaoFestival('Địa Mẫu Nương Nương thánh đản')],
    '10-19': [TaoFestival('Trường Xuân Khâu Chân Quân phi thăng')],
    '10-20': [
      TaoFestival(
        'Hư Tĩnh Thiên Sư (tức Tam thập đại Thiên Sư Hoằng Ngộ Trương Chân Nhân) đản',
      ),
    ],
    '11-6': [TaoFestival('Tây Nhạc Đại Đế thánh đản')],
    '11-9': [TaoFestival('Tương Tử Hàn Tổ thánh đản')],
    '11-11': [TaoFestival('Thái Ất Cứu Khổ Thiên Tôn thánh đản')],
    '11-26': [TaoFestival('Bắc phương Ngũ Đạo thánh đản')],
    '12-8': [
      TaoFestival(
        'Vương Hầu Lạp Chi Thần',
        'Vương Hầu Lạp, ngày này Ngũ Đế hội tại Thượng phương Huyền Đô Ngọc Kinh',
      ),
    ],
    '12-16': [
      TaoFestival('Nam Nhạc Đại Đế thánh đản'),
      TaoFestival('Phúc Đức Chính Thần đản'),
    ],
    '12-20': [TaoFestival('Lỗ Ban Tiên Sư thánh đản')],
    '12-21': [TaoFestival('Thiên Du Thượng Đế thánh đản')],
    '12-22': [TaoFestival('Trùng Dương Tổ Sư thánh đản')],
    '12-23': [
      TaoFestival(
        'Tế Táo Vương',
        'Thích hợp nhất để tạ Thái Tuế năm cũ, bắt đầu bái Thái Tuế năm mới',
      ),
    ], // Cúng Táo Quân
    '12-25': [
      TaoFestival('Ngọc Đế tuần thiên'),
      TaoFestival('Thiên Thần hạ giáng'),
    ],
    '12-29': [TaoFestival('Thanh Tĩnh Tôn Chân Quân (Tôn Bất Nhị) thành đạo')],
  };
}
