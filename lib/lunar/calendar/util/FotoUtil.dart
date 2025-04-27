import '../../lunar.dart'; // Giữ lại import này

import '../FotoFestival.dart'; // Giữ lại import này

/// Công cụ Phật lịch
/// @author 6tail
class FotoUtil {
  /// 27 Tú (Nhị Thập Bát Tú trừ sao Ngưu)
  static final List<String> XIU_27 = [
    'Giác', // 角
    'Cang', // 亢
    'Đê', // 氐
    'Phòng', // 房
    'Tâm', // 心
    'Vĩ', // 尾
    'Cơ', // 箕
    'Đẩu', // 斗
    'Nữ', // 女
    'Hư', // 虚
    'Nguy', // 危
    'Thất', // 室
    'Bích', // 壁
    'Khuê', // 奎
    'Lâu', // 娄
    'Vị', // 胃
    'Mão', // 昴
    'Tất', // 毕
    'Chủy', // 觜
    'Sâm', // 参
    'Tỉnh', // 井
    'Quỷ', // 鬼
    'Liễu', // 柳
    'Tinh', // 星
    'Trương', // 张
    'Dực', // 翼
    'Chẩn', // 轸
  ];

  /// Độ lệch của 27 Tú vào ngày mùng 1 mỗi tháng
  static const List<int> XIU_OFFSET = [
    11,
    13,
    15,
    17,
    19,
    21,
    24,
    0,
    2,
    4,
    7,
    9
  ];

  /// Ngày chay Quan Âm
  static const List<String> DAY_ZHAI_GUAN_YIN = [
    '1-8',
    '2-7',
    '2-9',
    '2-19',
    '3-3',
    '3-6',
    '3-13',
    '4-22',
    '5-3',
    '5-17',
    '6-16',
    '6-18',
    '6-19',
    '6-23',
    '7-13',
    '8-16',
    '9-19',
    '9-23',
    '10-2',
    '11-19',
    '11-24',
    '12-25'
  ];

  // Các biến lưu trữ thông điệp phạm kỵ
  static String _DJ = 'Phạm phải bị giảm tuổi thọ'; // Đoạt Kỷ
  static String _JS = 'Phạm phải giảm thọ'; // Giảm Thọ
  static String _SS = 'Phạm phải tổn thọ'; // Tổn Thọ
  static String _XL = 'Phạm phải bị tước lộc giảm thọ'; // Tước Lộc Đoạt Kỷ
  static String _JW =
      'Phạm phải trong 3 năm vợ chồng đều mất'; // Phu Phụ Câu Vong

  // Các đối tượng lễ hội thường dùng
  static final FotoFestival _Y = FotoFestival('Dương Công Kỵ');
  static final FotoFestival _T =
      FotoFestival('Tứ Thiên Vương tuần hành', '', true);
  static final FotoFestival _D =
      FotoFestival('Đẩu giáng', _DJ, true); // Sao Đẩu giáng trần
  static final FotoFestival _S =
      FotoFestival('Nguyệt sóc', _DJ, true); // Mùng 1 Âm lịch
  static final FotoFestival _W =
      FotoFestival('Nguyệt vọng', _DJ, true); // Rằm Âm lịch
  static final FotoFestival _H =
      FotoFestival('Nguyệt hối', _JS, true); // Ngày cuối tháng
  static final FotoFestival _L =
      FotoFestival('Ngày chay Sấm', _JS, true); // Lôi Trai Nhật
  static final FotoFestival _J = FotoFestival('Cửu độc nhật',
      'Phạm phải chết yểu, tai họa khôn lường'); // Ngày Chín Độc
  static final FotoFestival _R = FotoFestival(
      'Thần Người ở cõi Âm',
      'Phạm phải mắc bệnh',
      true,
      'Nên kiêng trước một ngày'); // Nhân Thần Tại Âm
  static final FotoFestival _M = FotoFestival('Tư Mệnh tấu sự', _JS, true,
      'Nếu là tháng thiếu, thì kiêng ngày 29'); // Táo Quân báo cáo
  static final FotoFestival _HH = FotoFestival('Nguyệt hối', _JS, true,
      'Nếu là tháng thiếu, thì kiêng ngày 29'); // Ngày cuối tháng (cho tháng thiếu)

  /// Phạm Kỵ Nhân Quả (Lễ hội và ngày kỵ trong Phật lịch)
  static final Map<String, List<FotoFestival>> FESTIVAL = {
    '1-1': [
      FotoFestival('Thiên Lạp, Ngọc Đế xét thần khí lộc mệnh người đời', _XL),
      _S
    ],
    '1-3': [FotoFestival('Vạn thần đô hội', _DJ), _D],
    '1-5': [FotoFestival('Ngũ hư kỵ')],
    '1-6': [FotoFestival('Lục hao kỵ'), _L],
    '1-7': [FotoFestival('Thượng hội nhật', _SS)],
    '1-8': [FotoFestival('Ngũ Điện Diêm La Thiên Tử đản', _DJ), _T],
    '1-9': [FotoFestival('Ngọc Hoàng Thượng Đế đản', _DJ)],
    '1-13': [_Y],
    '1-14': [FotoFestival('Tam Nguyên giáng', _JS), _T],
    '1-15': [
      FotoFestival('Tam Nguyên giáng', _JS),
      FotoFestival('Thượng Nguyên thần hội', _DJ),
      _W,
      _T
    ],
    '1-16': [FotoFestival('Tam Nguyên giáng', _JS)],
    '1-19': [FotoFestival('Trường Xuân Chân Nhân đản')],
    '1-23': [FotoFestival('Tam Thi Thần tấu sự'), _T],
    '1-25': [
      _H,
      FotoFestival(
          'Ngày mở kho Trời Đất', 'Phạm phải tổn thọ, con cái mang bệnh')
    ],
    '1-27': [_D],
    '1-28': [_R],
    '1-29': [_T],
    '1-30': [_HH, _M, _T],
    '2-1': [FotoFestival('Nhất Điện Tần Quảng Vương đản', _DJ), _S],
    '2-2': [
      FotoFestival('Vạn thần đô hội', _DJ),
      FotoFestival('Phúc Đức Thổ Địa Chính Thần đản', 'Phạm phải gặp họa')
    ],
    '2-3': [FotoFestival('Văn Xương Đế Quân đản', _XL), _D],
    '2-6': [FotoFestival('Đông Hoa Đế Quân đản'), _L],
    '2-8': [
      FotoFestival('Thích Ca Mâu Ni Phật xuất gia', _DJ),
      FotoFestival('Tam Điện Tống Đế Vương đản', _DJ),
      FotoFestival('Trương Đại Đế đản', _DJ),
      _T
    ],
    '2-11': [_Y],
    '2-14': [_T],
    '2-15': [
      FotoFestival('Thích Ca Mâu Ni Phật niết bàn', _XL),
      FotoFestival('Thái Thượng Lão Quân đản', _XL),
      FotoFestival('Nguyệt vọng', _XL, true),
      _T
    ],
    '2-17': [FotoFestival('Đông Phương Đỗ Tướng Quân đản')],
    '2-18': [
      FotoFestival('Tứ Điện Ngũ Quan Vương đản', _XL),
      FotoFestival('Ngày kỵ của Khổng Tử', _XL)
    ],
    '2-19': [FotoFestival('Quan Âm Đại Sĩ đản', _DJ)],
    '2-21': [FotoFestival('Phổ Hiền Bồ Tát đản')],
    '2-23': [_T],
    '2-25': [_H],
    '2-27': [_D],
    '2-28': [_R],
    '2-29': [_T],
    '2-30': [_HH, _M, _T],
    '3-1': [FotoFestival('Nhị Điện Sở Giang Vương đản', _DJ), _S],
    '3-3': [FotoFestival('Huyền Thiên Thượng Đế đản', _DJ), _D],
    '3-6': [_L],
    '3-8': [FotoFestival('Lục Điện Biện Thành Vương đản', _DJ), _T],
    '3-9': [FotoFestival('Ngưu quỷ thần xuất', 'Phạm phải sinh ác thai'), _Y],
    '3-12': [FotoFestival('Trung Ương Ngũ Đạo đản')],
    '3-14': [_T],
    '3-15': [
      FotoFestival('Hạo Thiên Thượng Đế đản', _DJ),
      FotoFestival('Huyền Đàn đản', _DJ),
      _W,
      _T
    ],
    '3-16': [FotoFestival('Chuẩn Đề Bồ Tát đản', _DJ)],
    '3-19': [
      FotoFestival('Trung Nhạc Đại Đế đản'),
      FotoFestival('Hậu Thổ Nương Nương đản'),
      FotoFestival('Tam Mao giáng')
    ],
    '3-20': [
      FotoFestival('Ngày mở kho Trời Đất', _SS),
      FotoFestival('Tử Tôn Nương Nương đản')
    ],
    '3-23': [_T],
    '3-25': [_H],
    '3-27': [FotoFestival('Thất Điện Thái Sơn Vương đản'), _D],
    '3-28': [
      _R,
      FotoFestival('Thương Hiệt Chí Thánh Tiên Sư đản', _XL),
      FotoFestival('Đông Nhạc Đại Đế đản')
    ],
    '3-29': [_T],
    '3-30': [_HH, _M, _T],
    '4-1': [FotoFestival('Bát Điện Đô Thị Vương đản', _DJ), _S],
    '4-3': [_D],
    '4-4': [
      FotoFestival('Vạn thần thiện hội', 'Phạm phải động thai, thai chết yểu'),
      FotoFestival('Văn Thù Bồ Tát đản')
    ],
    '4-6': [_L],
    '4-7': [FotoFestival('Nam Đẩu, Bắc Đẩu, Tây Đẩu đồng giáng', _JS), _Y],
    '4-8': [
      FotoFestival('Thích Ca Mâu Ni Phật đản', _DJ),
      FotoFestival('Vạn thần thiện hội', 'Phạm phải động thai, thai chết yểu'),
      FotoFestival('Thiện Ác Đồng Tử giáng', 'Phạm phải chết vì máu'),
      FotoFestival('Cửu Điện Bình Đẳng Vương đản'),
      _T
    ],
    '4-14': [FotoFestival('Thuần Dương Tổ Sư đản', _JS), _T],
    '4-15': [_W, FotoFestival('Chung Ly Tổ Sư đản'), _T],
    '4-16': [FotoFestival('Ngày mở kho Trời Đất', _SS)],
    '4-17': [FotoFestival('Thập Điện Chuyển Luân Vương đản', _DJ)],
    '4-18': [
      FotoFestival('Ngày mở kho Trời Đất', _SS),
      FotoFestival('Tử Vi Đại Đế đản', _SS)
    ],
    '4-20': [FotoFestival('Nhãn Quang Thánh Mẫu đản')],
    '4-23': [_T],
    '4-25': [_H],
    '4-27': [_D],
    '4-28': [_R],
    '4-29': [_T],
    '4-30': [_HH, _M, _T],
    '5-1': [FotoFestival('Nam Cực Trường Sinh Đại Đế đản', _DJ), _S],
    '5-3': [_D],
    '5-5': [
      FotoFestival('Địa Lạp', _XL),
      FotoFestival('Ngũ Đế xét định quan tước người sống', _XL),
      _J,
      _Y
    ],
    '5-6': [_J, _L],
    '5-7': [_J],
    '5-8': [FotoFestival('Nam Phương Ngũ Đạo đản'), _T],
    '5-11': [
      FotoFestival('Ngày mở kho Trời Đất', _SS),
      FotoFestival('Thiên Hạ Đô Thành Hoàng đản')
    ],
    '5-12': [FotoFestival('Bỉnh Linh Công đản')],
    '5-13': [FotoFestival('Quan Thánh giáng', _XL)],
    '5-14': [FotoFestival('Giờ Tý đêm là lúc trời đất giao hòa', _JW), _T],
    '5-15': [_W, _J, _T],
    '5-16': [
      FotoFestival('Cửu độc nhật', _JW),
      FotoFestival('Lúc nguyên khí trời đất tạo hóa vạn vật', _JW)
    ],
    '5-17': [_J],
    '5-18': [FotoFestival('Trương Thiên Sư đản')],
    '5-22': [FotoFestival('Hiếu Nga Thần đản', _DJ)],
    '5-23': [_T],
    '5-25': [_J, _H],
    '5-26': [_J],
    '5-27': [_J, _D],
    '5-28': [_R],
    '5-29': [_T],
    '5-30': [_HH, _M, _T],
    '6-1': [_S],
    '6-3': [FotoFestival('Vi Đà Bồ Tát thánh đản'), _D, _Y],
    '6-5': [FotoFestival('Nam Thiệm Bộ Châu chuyển đại luân', _SS)],
    '6-6': [FotoFestival('Ngày mở kho Trời Đất', _SS), _L],
    '6-8': [_T],
    '6-10': [FotoFestival('Kim Túc Như Lai đản')],
    '6-14': [_T],
    '6-15': [_W, _T],
    '6-19': [FotoFestival('Quan Thế Âm Bồ Tát thành đạo', _DJ)],
    '6-23': [
      FotoFestival('Nam Phương Hỏa Thần đản', 'Phạm phải gặp hỏa hoạn'),
      _T
    ],
    '6-24': [FotoFestival('Lôi Tổ đản', _XL), FotoFestival('Quan Đế đản', _XL)],
    '6-25': [_H],
    '6-27': [_D],
    '6-28': [_R],
    '6-29': [_T],
    '6-30': [_HH, _M, _T],
    '7-1': [_S, _Y],
    '7-3': [_D],
    '7-5': [FotoFestival('Trung hội nhật', _SS, false, 'Có thuyết là mùng 7')],
    '7-6': [_L],
    '7-7': [
      FotoFestival('Đạo Đức Lạp', _XL),
      FotoFestival('Ngũ Đế xét thiện ác người sống', _XL),
      FotoFestival('Khôi Tinh đản', _XL)
    ],
    '7-8': [_T],
    '7-10': [FotoFestival('Âm độc nhật', '', false, 'Đại kỵ')],
    '7-12': [FotoFestival('Trường Chân Đàm Chân Nhân đản')],
    '7-13': [FotoFestival('Đại Thế Chí Bồ Tát đản', _JS)],
    '7-14': [FotoFestival('Tam Nguyên giáng', _JS), _T],
    '7-15': [
      _W,
      FotoFestival('Tam Nguyên giáng', _DJ),
      FotoFestival('Địa Quan xét sổ sách', _DJ),
      _T
    ],
    '7-16': [FotoFestival('Tam Nguyên giáng', _JS)],
    '7-18': [FotoFestival('Tây Vương Mẫu đản', _DJ)],
    '7-19': [FotoFestival('Thái Tuế đản', _DJ)],
    '7-22': [FotoFestival('Tăng Phúc Tài Thần đản', _XL)],
    '7-23': [_T],
    '7-25': [_H],
    '7-27': [_D],
    '7-28': [_R],
    '7-29': [_Y, _T],
    '7-30': [FotoFestival('Địa Tạng Bồ Tát đản', _DJ), _HH, _M, _T],
    '8-1': [_S, FotoFestival('Hứa Chân Quân đản')],
    '8-3': [
      _D,
      FotoFestival('Bắc Đẩu đản', _XL),
      FotoFestival('Tư Mệnh Táo Quân đản', 'Phạm phải gặp hỏa hoạn')
    ],
    '8-5': [FotoFestival('Lôi Thanh Đại Đế đản', _DJ)],
    '8-6': [_L],
    '8-8': [_T],
    '8-10': [FotoFestival('Bắc Đẩu Đại Đế đản')],
    '8-12': [FotoFestival('Tây Phương Ngũ Đạo đản')],
    '8-14': [_T],
    '8-15': [
      _W,
      FotoFestival('Thái Minh triều nguyên', 'Phạm phải chết đột ngột', false,
          'Nên đốt hương thức đêm'),
      _T
    ],
    '8-16': [
      FotoFestival('Thiên Tào Lược Loát Chân Quân giáng', 'Phạm phải nghèo yểu')
    ],
    '8-18': [
      FotoFestival('Lúc trời người ban phúc', '', false,
          'Nên trai giới, tưởng nghĩ việc tốt lành')
    ],
    '8-23': [FotoFestival('Hán Hằng Hầu Trương Hiển Vương đản'), _T],
    '8-24': [FotoFestival('Táo Quân Phu Nhân đản')],
    '8-25': [_H],
    '8-27': [_D, FotoFestival('Chí Thánh Tiên Sư Khổng Tử đản', _XL), _Y],
    '8-28': [_R, FotoFestival('Tứ thiên hội sự')],
    '8-29': [_T],
    '8-30': [
      FotoFestival('Chư thần khảo xét', 'Phạm phải bị giảm tuổi thọ'),
      _HH,
      _M,
      _T
    ],
    '9-1': [
      _S,
      FotoFestival('Nam Đẩu đản', _XL),
      FotoFestival('Bắc Đẩu Cửu Tinh giáng thế', _DJ, false,
          'Chín ngày này đều nên trai giới')
    ],
    '9-3': [_D, FotoFestival('Ngũ Ôn Thần đản')],
    '9-6': [_L],
    '9-8': [_T],
    '9-9': [
      FotoFestival('Đẩu Mẫu đản', _XL),
      FotoFestival('Phong Đô Đại Đế đản'),
      FotoFestival('Huyền Thiên Thượng Đế phi thăng')
    ],
    '9-10': [FotoFestival('Đẩu Mẫu giáng', _DJ)],
    '9-11': [FotoFestival('Nên kiêng')],
    '9-13': [FotoFestival('Mạnh Bà Tôn Thần đản')],
    '9-14': [_T],
    '9-15': [_W, _T],
    '9-17': [
      FotoFestival('Kim Long Tứ Đại Vương đản', 'Phạm phải gặp nạn sông nước')
    ],
    '9-19': [
      FotoFestival('Nhật cung Nguyệt cung hội hợp', _JS),
      FotoFestival('Quan Thế Âm Bồ Tát đản', _JS)
    ],
    '9-23': [_T],
    '9-25': [_H, _Y],
    '9-27': [_D],
    '9-28': [_R],
    '9-29': [_T],
    '9-30': [
      FotoFestival('Dược Sư Lưu Ly Quang Phật đản', 'Phạm phải bệnh nguy kịch'),
      _HH,
      _M,
      _T
    ],
    '10-1': [
      _S,
      FotoFestival('Dân Tuế Lạp', _DJ),
      FotoFestival('Tứ Thiên Vương giáng', 'Phạm phải trong một năm sẽ chết')
    ],
    '10-3': [_D, FotoFestival('Tam Mao đản')],
    '10-5': [
      FotoFestival('Hạ hội nhật', _JS),
      FotoFestival('Đạt Ma Tổ Sư đản', _JS)
    ],
    '10-6': [_L, FotoFestival('Thiên Tào khảo sát', _DJ)],
    '10-8': [
      FotoFestival('Phật Niết Bàn nhật', '', false, 'Đại kỵ sắc dục'),
      _T
    ],
    '10-10': [
      FotoFestival('Tứ Thiên Vương giáng', 'Phạm phải trong một năm sẽ chết')
    ],
    '10-11': [FotoFestival('Nên kiêng')],
    '10-14': [FotoFestival('Tam Nguyên giáng', _JS), _T],
    '10-15': [
      _W,
      FotoFestival('Tam Nguyên giáng', _DJ),
      FotoFestival('Hạ Nguyên Thủy Phủ xét sổ sách', _DJ),
      _T
    ],
    '10-16': [FotoFestival('Tam Nguyên giáng', _JS), _T],
    '10-23': [_Y, _T],
    '10-25': [_H],
    '10-27': [_D, FotoFestival('Bắc Cực Tử Vi Đại Đế giáng')],
    '10-28': [_R],
    '10-29': [_T],
    '10-30': [_HH, _M, _T],
    '11-1': [_S],
    '11-3': [_D],
    '11-4': [FotoFestival('Chí Thánh Tiên Sư Khổng Tử đản', _XL)],
    '11-6': [FotoFestival('Tây Nhạc Đại Đế đản')],
    '11-8': [_T],
    '11-11': [
      FotoFestival('Ngày mở kho Trời Đất', _DJ),
      FotoFestival('Thái Ất Cứu Khổ Thiên Tôn đản', _DJ)
    ],
    '11-14': [_T],
    '11-15': [
      FotoFestival('Nguyệt vọng',
          'Nửa đêm trước phạm nam chết, nửa đêm sau phạm nữ chết'),
      FotoFestival('Tứ Thiên Vương tuần hành',
          'Nửa đêm trước phạm nam chết, nửa đêm sau phạm nữ chết')
    ],
    '11-17': [FotoFestival('A Di Đà Phật đản')],
    '11-19': [
      FotoFestival('Thái Dương Nhật Cung đản', 'Phạm phải gặp tai họa lạ')
    ],
    '11-21': [_Y],
    '11-23': [FotoFestival('Trương Tiên đản', 'Phạm phải tuyệt tự'), _T],
    '11-25': [
      FotoFestival('Lược Loát Đại Phu giáng', 'Phạm phải gặp đại hung'),
      _H
    ],
    '11-26': [FotoFestival('Bắc Phương Ngũ Đạo đản')],
    '11-27': [_D],
    '11-28': [_R],
    '11-29': [_T],
    '11-30': [_HH, _M, _T],
    '12-1': [_S],
    '12-3': [_D],
    '12-6': [FotoFestival('Ngày mở kho Trời Đất', _JS), _L],
    '12-7': [FotoFestival('Lược Loát Đại Phu giáng', 'Phạm phải mắc bệnh ác')],
    '12-8': [
      FotoFestival('Vương Hầu Lạp', _DJ),
      FotoFestival('Lúc Thích Ca Như Lai thành Phật'),
      _T,
      FotoFestival('Ngày Mậu trong thượng tuần, cũng gọi là Vương Hầu Lạp', _DJ)
    ],
    '12-12': [FotoFestival('Thái Tố Tam Nguyên Quân triều chân')],
    '12-14': [_T],
    '12-15': [_W, _T],
    '12-16': [FotoFestival('Nam Nhạc Đại Đế đản')],
    '12-19': [_Y],
    '12-20': [FotoFestival('Thiên địa giao đạo', 'Phạm phải bị giảm thọ')],
    '12-21': [
      FotoFestival('Thiên猷 Thượng Đế đản')
    ], // Giữ nguyên 猷 nếu không chắc chắn
    '12-23': [FotoFestival('Ngũ Nhạc đản giáng'), _T],
    '12-24': [
      FotoFestival(
          'Táo Quân chầu trời tâu việc thiện ác', 'Phạm phải gặp đại họa')
    ],
    '12-25': [
      FotoFestival('Tam Thanh Ngọc Đế đồng giáng, khảo sát thiện ác',
          'Phạm phải gặp tai họa lạ'),
      _H
    ],
    '12-27': [_D],
    '12-28': [_R],
    '12-29': [FotoFestival('Hoa Nghiêm Bồ Tát đản'), _T],
    '12-30': [
      FotoFestival(
          'Chư thần hạ giáng, dò xét thiện ác', 'Phạm phải nam nữ đều mất')
    ]
  };

  /// Các lễ hội Phật giáo khác (chủ yếu là ngày vía)
  static Map<String, List<String>> OTHER_FESTIVAL = {
    '1-1': ['Di Lặc Bồ Tát thánh đản'],
    '1-6': ['Định Quang Phật thánh đản'],
    '2-8': ['Thích Ca Mâu Ni Phật xuất gia'],
    '2-15': ['Thích Ca Mâu Ni Phật niết bàn'],
    '2-19': ['Quan Thế Âm Bồ Tát thánh đản'],
    '2-21': ['Phổ Hiền Bồ Tát thánh đản'],
    '3-16': ['Chuẩn Đề Bồ Tát thánh đản'],
    '4-4': ['Văn Thù Bồ Tát thánh đản'],
    '4-8': ['Thích Ca Mâu Ni Phật thánh đản'],
    '4-15': ['Phật cát tường nhật'],
    '4-28': ['Dược Vương Bồ Tát thánh đản'],
    '5-13': ['Già Lam Bồ Tát thánh đản'],
    '6-3': ['Vi Đà Bồ Tát thánh đản'],
    '6-19': ['Quan Âm Bồ Tát thành đạo'],
    '7-13': ['Đại Thế Chí Bồ Tát thánh đản'],
    '7-15': ['Phật hoan hỷ nhật'],
    '7-24': ['Long Thọ Bồ Tát thánh đản'],
    '7-30': ['Địa Tạng Bồ Tát thánh đản'],
    '8-15': ['Nguyệt Quang Bồ Tát thánh đản'],
    '8-22': ['Nhiên Đăng Phật thánh đản'],
    '9-9': ['Ma Lợi Chi Thiên Bồ Tát thánh đản'],
    '9-19': ['Quan Thế Âm Bồ Tát xuất gia'],
    '9-30': ['Dược Sư Lưu Ly Quang Phật thánh đản'],
    '10-5': ['Đạt Ma Tổ Sư thánh đản'],
    '10-20': ['Văn Thù Bồ Tát xuất gia'],
    '11-17': ['A Di Đà Phật thánh đản'],
    '11-19': ['Nhật Quang Bồ Tát thánh đản'],
    '12-8': ['Thích Ca Mâu Ni Phật thành đạo'],
    '12-23': ['Giám Trai Bồ Tát thánh đản'],
    '12-29': ['Hoa Nghiêm Bồ Tát thánh đản']
  };

  /// Lấy 27 Tú
  /// @param month Tháng Phật lịch (giá trị tuyệt đối từ 1-12)
  /// @param day Ngày Phật lịch
  /// @return Tú (Tên sao)
  static String getXiu(int month, int day) {
    // Đảm bảo tháng nằm trong khoảng 1-12
    int monthIndex = month.abs();
    if (monthIndex < 1 || monthIndex > 12) {
      // Có thể throw lỗi hoặc trả về giá trị mặc định/rỗng
      return ''; // Hoặc throw ArgumentError('Tháng không hợp lệ: $month');
    }
    // Tính toán index dựa trên offset của tháng và ngày
    int index = (XIU_OFFSET[monthIndex - 1] + day - 1) % XIU_27.length;
    return XIU_27[index];
  }
}
