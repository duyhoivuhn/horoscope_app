import '../Solar.dart'; // Giữ lại import này

/// Công cụ Dương lịch
/// @author 6tail
class SolarUtil {
  /// Tuần (Thứ trong tuần)
  static List<String> WEEK = [
    'Chủ Nhật', // 日
    'Thứ Hai', // 一
    'Thứ Ba', // 二
    'Thứ Tư', // 三
    'Thứ Năm', // 四
    'Thứ Sáu', // 五
    'Thứ Bảy', // 六
  ];

  /// Số ngày trong mỗi tháng (không tính năm nhuận)
  static const List<int> DAYS_OF_MONTH = [
    31, // Tháng 1
    28, // Tháng 2
    31, // Tháng 3
    30, // Tháng 4
    31, // Tháng 5
    30, // Tháng 6
    31, // Tháng 7
    31, // Tháng 8
    30, // Tháng 9
    31, // Tháng 10
    30, // Tháng 11
    31, // Tháng 12
  ];

  /// Cung Hoàng Đạo
  static List<String> XING_ZUO = [
    'Bạch Dương', // 白羊
    'Kim Ngưu', // 金牛
    'Song Tử', // 双子
    'Cự Giải', // 巨蟹
    'Sư Tử', // 狮子
    'Xử Nữ', // 处女
    'Thiên Bình', // 天秤
    'Thiên Yết', // 天蝎 (Bọ Cạp)
    'Nhân Mã', // 射手
    'Ma Kết', // 摩羯
    'Bảo Bình', // 水瓶
    'Song Ngư', // 双鱼
  ];

  /// Lễ hội tương ứng với ngày cố định (Dương lịch)
  static Map<String, String> FESTIVAL = {
    '1-1': 'Tết Dương lịch', // 元旦节
    '2-14': 'Lễ Tình Nhân (Valentine)', // 情人节
    '3-8': 'Quốc tế Phụ nữ', // 妇女节
    '3-12': 'Tết trồng cây (Trung Quốc)', // 植树节
    '3-15': 'Ngày Quyền của Người tiêu dùng', // 消费者权益日
    '4-1': 'Ngày Cá tháng Tư', // 愚人节
    '5-1': 'Quốc tế Lao động', // 劳动节
    '5-4': 'Ngày Thanh niên (Trung Quốc)', // 青年节
    '6-1': 'Quốc tế Thiếu nhi', // 儿童节
    '7-1': 'Ngày thành lập Đảng Cộng sản Trung Quốc', // 建党节
    '8-1': 'Ngày thành lập Quân Giải phóng Nhân dân Trung Quốc', // 建军节
    '9-10': 'Ngày Nhà giáo (Trung Quốc)', // 教师节
    '10-1': 'Quốc khánh Trung Quốc', // 国庆节
    '10-31': 'Đêm Halloween', // 万圣节前夜
    '11-1': 'Lễ Halloween', // 万圣节
    '12-24': 'Đêm Giáng Sinh', // 平安夜
    '12-25': 'Lễ Giáng Sinh', // 圣诞节
  };

  /// Lễ hội tương ứng với ngày thứ X của tuần thứ Y trong tháng Z
  /// Định dạng key: "Tháng-TuầnThứ-NgàyThứ" (0=Chủ Nhật, 1=Thứ Hai, ..., 6=Thứ Bảy)
  static Map<String, String> WEEK_FESTIVAL = {
    '3-1-1': // Thứ Hai đầu tiên của tháng 3 (Quy tắc gốc ghi 3-0-1 có thể nhầm lẫn, 0 thường là CN)
        'Ngày Giáo dục An toàn cho Học sinh Tiểu học và Trung học Toàn quốc (TQ)', // 全国中小学生安全教育日
    '5-2-0': 'Ngày của Mẹ', // 母亲节 (Chủ Nhật thứ 2 của tháng 5)
    '5-3-0':
        'Ngày Quốc gia Giúp đỡ Người khuyết tật (TQ)', // 全国助残日 (Chủ Nhật thứ 3 của tháng 5)
    '6-3-0': 'Ngày của Cha', // 父亲节 (Chủ Nhật thứ 3 của tháng 6)
    '9-3-6':
        'Ngày Giáo dục Quốc phòng Toàn dân (TQ)', // 全民国防教育日 (Thứ Bảy thứ 3 của tháng 9)
    '10-1-1': 'Ngày Nhà ở Thế giới', // 世界住房日 (Thứ Hai đầu tiên của tháng 10)
    '11-4-4': 'Lễ Tạ Ơn', // 感恩节 (Thứ Năm thứ 4 của tháng 11)
  };

  /// Các ngày lễ/kỷ niệm không chính thức khác tương ứng với ngày cố định (Dương lịch)
  static Map<String, List<String>> OTHER_FESTIVAL = {
    '1-8': ['Ngày mất Chu Ân Lai'], // 周恩来逝世纪念日
    '1-10': ['Ngày Cảnh sát Nhân dân Trung Quốc'], // 中国人民警察节
    '1-14': ['Valentine Nhật ký'], // 日记情人节
    '1-21': ['Ngày mất Lenin'], // 列宁逝世纪念日
    '1-26': ['Ngày Hải quan Quốc tế'], // 国际海关日
    '1-27': ['Ngày Quốc tế Tưởng niệm Nạn nhân Holocaust'], // 国际大屠杀纪念日
    '2-2': ['Ngày Đất ngập nước Thế giới'], // 世界湿地日
    '2-4': ['Ngày Thế giới Phòng chống Ung thư'], // 世界抗癌日
    '2-7': ['Ngày kỷ niệm cuộc đình công đường sắt Kinh-Hán'], // 京汉铁路罢工纪念日
    '2-10': ['Ngày Khí tượng Quốc tế'], // 国际气象节
    '2-19': ['Ngày mất Đặng Tiểu Bình'], // 邓小平逝世纪念日
    '2-20': ['Ngày Công bằng Xã hội Thế giới'], // 世界社会公正日
    '2-21': ['Ngày Tiếng mẹ đẻ Quốc tế'], // 国际母语日
    '2-24': ['Ngày Thanh niên Thế giới thứ ba'], // 第三世界青年日
    '3-1': ['Ngày Hải cẩu Quốc tế'], // 国际海豹日
    '3-3': [
      'Ngày Sinh vật hoang dã Thế giới',
      'Ngày Chăm sóc Thính giác Toàn quốc (TQ)',
    ], // 世界野生动植物日, 全国爱耳日
    '3-5': [
      'Ngày sinh Chu Ân Lai',
      'Ngày Tình nguyện viên Trẻ Trung Quốc',
    ], // 周恩来诞辰纪念日, 中国青年志愿者服务日
    '3-6': ['Ngày Glaucoma Thế giới'], // 世界青光眼日
    '3-7': ['Ngày Con gái (TQ)'], // 女生节
    '3-12': ['Ngày mất Tôn Trung Sơn'], // 孙中山逝世纪念日
    '3-14': ['Ngày mất Karl Marx', 'Valentine Trắng'], // 马克思逝世纪念日, 白色情人节
    '3-17': ['Ngày Hàng hải Quốc tế'], // 国际航海日
    '3-18': [
      'Ngày Hoạt động Nhân tài Khoa học Kỹ thuật Toàn quốc (TQ)',
      'Ngày Chăm sóc Gan Toàn quốc (TQ)',
    ], // 全国科技人才活动日, 全国爱肝日
    '3-20': ['Ngày Quốc tế Hạnh phúc'], // 国际幸福日
    '3-21': [
      'Ngày Rừng Thế giới',
      'Ngày Giấc ngủ Thế giới',
      'Ngày Quốc tế Xóa bỏ Phân biệt Chủng tộc',
    ], // 世界森林日, 世界睡眠日, 国际消除种族歧视日
    '3-22': ['Ngày Nước Thế giới'], // 世界水日
    '3-23': ['Ngày Khí tượng Thế giới'], // 世界气象日
    '3-24': ['Ngày Thế giới Phòng chống Lao'], // 世界防治结核病日
    '3-29': ['Ngày Kỷ niệm 72 Liệt sĩ Hoàng Hoa Cương (TQ)'], // 中国黄花岗七十二烈士殉难纪念日
    '4-2': [
      'Ngày Sách Thiếu nhi Quốc tế',
      'Ngày Thế giới Nhận thức về Tự kỷ',
    ], // 国际儿童图书日, 世界自闭症日
    '4-4': ['Ngày Quốc tế Nhận thức Bom mìn'], // 国际地雷行动日
    '4-7': ['Ngày Sức khỏe Thế giới'], // 世界卫生日
    '4-8': ['Ngày Bảo vệ Động vật Quý hiếm Quốc tế'], // 国际珍稀动物保护日
    '4-12': ['Ngày Du hành Vũ trụ Quốc tế'], // 世界航天日
    '4-14': ['Valentine Đen'], // 黑色情人节
    '4-15': ['Ngày Giáo dục An ninh Quốc gia Toàn dân (TQ)'], // 全民国家安全教育日
    '4-22': ['Ngày Trái Đất', 'Ngày sinh Lenin'], // 世界地球日, 列宁诞辰纪念日
    '4-23': ['Ngày Sách và Bản quyền Thế giới'], // 世界读书日
    '4-24': ['Ngày Hàng không Vũ trụ Trung Quốc'], // 中国航天日
    '4-25': [
      'Ngày Tuyên truyền Tiêm chủng Phòng bệnh cho Trẻ em (TQ)',
    ], // 儿童预防接种宣传日
    '4-26': [
      'Ngày Sở hữu Trí tuệ Thế giới',
      'Ngày Sốt rét Toàn quốc (TQ)',
    ], // 世界知识产权日, 全国疟疾日
    '4-28': [
      'Ngày Thế giới về An toàn và Sức khỏe tại nơi làm việc',
    ], // 世界安全生产与健康日
    '4-30': ['Ngày Quốc gia Nhìn lại An toàn Giao thông (TQ)'], // 全国交通安全反思日
    '5-2': ['Ngày Cá ngừ Thế giới'], // 世界金枪鱼日
    '5-3': ['Ngày Tự do Báo chí Thế giới'], // 世界新闻自由日
    '5-5': ['Ngày sinh Karl Marx'], // 马克思诞辰纪念日
    '5-8': ['Ngày Chữ thập đỏ và Trăng lưỡi liềm đỏ Quốc tế'], // 世界红十字日
    '5-11': ['Ngày Béo phì Thế giới'], // 世界肥胖日
    '5-12': [
      'Ngày Phòng chống và Giảm nhẹ Thiên tai Toàn quốc (TQ)',
      'Ngày Quốc tế Điều dưỡng',
    ], // 全国防灾减灾日, 护士节
    '5-14': ['Valentine Hoa hồng'], // 玫瑰情人节
    '5-15': ['Ngày Quốc tế Gia đình'], // 国际家庭日
    '5-19': ['Ngày Du lịch Trung Quốc'], // 中国旅游日
    '5-20': ['Ngày Tình nhân Online (520)'], // 网络情人节
    '5-22': ['Ngày Quốc tế Đa dạng Sinh học'], // 国际生物多样性日
    '5-25': ['Ngày Sức khỏe Tâm thần 525 (TQ)'], // 525心理健康节
    '5-27': ['Ngày Giải phóng Thượng Hải'], // 上海解放日
    '5-29': ['Ngày Quốc tế Lực lượng Gìn giữ Hòa bình LHQ'], // 国际维和人员日
    '5-30': ['Ngày Kỷ niệm Phong trào Ngũ Tứ (TQ)'], // 中国五卅运动纪念日
    '5-31': ['Ngày Thế giới Không Thuốc lá'], // 世界无烟日
    '6-3': ['Ngày Xe đạp Thế giới'], // 世界自行车日
    '6-5': ['Ngày Môi trường Thế giới'], // 世界环境日
    '6-6': ['Ngày Chăm sóc Mắt Toàn quốc (TQ)'], // 全国爱眼日
    '6-8': ['Ngày Đại dương Thế giới'], // 世界海洋日
    '6-11': ['Ngày Dân số Trung Quốc'], // 中国人口日
    '6-14': ['Ngày Hiến Máu Thế giới', 'Valentine Nụ hôn'], // 世界献血日, 亲亲情人节
    '6-17': ['Ngày Thế giới Chống Sa mạc hóa và Hạn hán'], // 世界防治荒漠化与干旱日
    '6-20': ['Ngày Người tị nạn Thế giới'], // 世界难民日
    '6-21': ['Ngày Quốc tế Yoga'], // 国际瑜伽日
    '6-25': ['Ngày Đất đai Toàn quốc (TQ)'], // 全国土地日
    '6-26': [
      'Ngày Quốc tế Phòng chống Ma túy',
      'Ngày Hiến chương Liên hợp quốc',
    ], // 国际禁毒日, 联合国宪章日
    '7-1': ['Ngày Kỷ niệm Hồng Kông trở về Trung Quốc'], // 香港回归纪念日
    '7-6': ['Ngày Quốc tế Nụ hôn', 'Ngày mất Chu Đức'], // 国际接吻日, 朱德逝世纪念日
    '7-7': ['Ngày Kỷ niệm Sự biến Lư Câu Kiều (7/7)'], // 七七事变纪念日
    '7-11': [
      'Ngày Dân số Thế giới',
      'Ngày Hàng hải Trung Quốc',
    ], // 世界人口日, 中国航海日
    '7-14': ['Valentine Bạc'], // 银色情人节
    '7-18': ['Ngày Quốc tế Nelson Mandela'], // 曼德拉国际日
    '7-30': ['Ngày Quốc tế Tình bạn'], // 国际友谊日
    '8-3': ['Ngày Đàn ông (TQ)'], // 男人节
    '8-5': ['Ngày mất Engels'], // 恩格斯逝世纪念日
    '8-6': ['Ngày Điện ảnh Quốc tế'], // 国际电影节
    '8-8': ['Ngày Thể dục Thể thao Toàn dân (TQ)'], // 全民健身日
    '8-9': ['Ngày Quốc tế Người bản địa Thế giới'], // 国际土著人日
    '8-12': ['Ngày Quốc tế Thanh Thiếu niên'], // 国际青年节
    '8-14': ['Valentine Xanh lá'], // 绿色情人节
    '8-19': [
      'Ngày Nhân đạo Thế giới',
      'Ngày Thầy thuốc Trung Quốc',
    ], // 世界人道主义日, 中国医师节
    '8-22': ['Ngày sinh Đặng Tiểu Bình'], // 邓小平诞辰纪念日
    '8-29': [
      'Ngày Tuyên truyền Luật Đo đạc và Bản đồ Toàn quốc (TQ)',
    ], // 全国测绘法宣传日
    '9-3': [
      'Ngày Kỷ niệm Chiến thắng Kháng chiến chống Nhật (TQ)',
    ], // 中国抗日战争胜利纪念日
    '9-5': ['Ngày Từ thiện Trung Hoa'], // 中华慈善日
    '9-8': ['Ngày Quốc tế Xóa nạn mù chữ'], // 世界扫盲日
    '9-9': [
      'Ngày mất Mao Trạch Đông',
      'Ngày Quốc gia Nói không với Lái xe sau khi uống rượu (TQ)',
    ], // 毛泽东逝世纪念日, 全国拒绝酒驾日
    '9-14': [
      'Ngày Làm sạch Trái đất Thế giới',
      'Valentine Ảnh',
    ], // 世界清洁地球日, 相片情人节
    '9-15': ['Ngày Quốc tế Dân chủ'], // 国际民主日
    '9-16': ['Ngày Quốc tế Bảo vệ Tầng Ozone'], // 国际臭氧层保护日
    '9-17': ['Ngày Đạp xe Thế giới'], // 世界骑行日
    '9-18': ['Ngày Kỷ niệm Sự biến Mãn Châu (18/9)'], // 九一八事变纪念日
    '9-20': ['Ngày Chăm sóc Răng miệng Toàn quốc (TQ)'], // 全国爱牙日
    '9-21': ['Ngày Quốc tế Hòa bình'], // 国际和平日
    '9-27': ['Ngày Du lịch Thế giới'], // 世界旅游日
    '9-30': ['Ngày Liệt sĩ Trung Quốc'], // 中国烈士纪念日
    '10-1': ['Ngày Quốc tế Người cao tuổi'], // 国际老年人日
    '10-2': ['Ngày Quốc tế Bất bạo động'], // 国际非暴力日
    '10-4': ['Ngày Động vật Thế giới'], // 世界动物日
    '10-11': ['Ngày Quốc tế Trẻ em gái'], // 国际女童日
    '10-10': ['Ngày Kỷ niệm Cách mạng Tân Hợi'], // 辛亥革命纪念日
    '10-13': [
      'Ngày Quốc tế Giảm nhẹ Thiên tai',
      'Ngày thành lập Đội Thiếu niên Tiền phong Trung Quốc',
    ], // 国际减轻自然灾害日, 中国少年先锋队诞辰日
    '10-14': ['Valentine Rượu vang'], // 葡萄酒情人节
    '10-16': ['Ngày Lương thực Thế giới'], // 世界粮食日
    '10-17': ['Ngày Quốc gia Xóa đói Giảm nghèo (TQ)'], // 全国扶贫日
    '10-20': ['Ngày Thống kê Thế giới'], // 世界统计日
    '10-24': [
      'Ngày Thông tin Phát triển Thế giới',
      'Ngày Lập trình viên', // (Thường là ngày thứ 256 của năm)
    ], // 世界发展信息日, 程序员节
    '10-25': ['Ngày Kỷ niệm Kháng Mỹ Viện Triều (TQ)'], // 抗美援朝纪念日
    '11-5': ['Ngày Thế giới Nhận thức về Sóng thần'], // 世界海啸日
    '11-8': ['Ngày Nhà báo (TQ)'], // 记者节
    '11-9': ['Ngày Phòng cháy Chữa cháy Toàn quốc (TQ)'], // 全国消防日
    '11-11': ['Ngày Độc thân (TQ)'], // 光棍节
    '11-12': ['Ngày sinh Tôn Trung Sơn'], // 孙中山诞辰纪念日
    '11-14': ['Valentine Điện ảnh'], // 电影情人节
    '11-16': ['Ngày Quốc tế Khoan dung'], // 国际宽容日
    '11-17': ['Ngày Quốc tế Sinh viên'], // 国际大学生节
    '11-19': ['Ngày Nhà vệ sinh Thế giới'], // 世界厕所日
    '11-28': ['Ngày sinh Engels'], // 恩格斯诞辰纪念日
    '11-29': ['Ngày Quốc tế Đoàn kết với Nhân dân Palestine'], // 国际声援巴勒斯坦人民日
    '12-1': ['Ngày Thế giới phòng chống AIDS'], // 世界艾滋病日
    '12-2': ['Ngày An toàn Giao thông Toàn quốc (TQ)'], // 全国交通安全日
    '12-3': ['Ngày Quốc tế Người khuyết tật'], // 世界残疾人日
    '12-4': ['Ngày Tuyên truyền Pháp luật Toàn quốc (TQ)'], // 全国法制宣传日
    '12-5': [
      'Ngày Người khuyết tật Thế giới', // (Có sự trùng lặp với 12-3, cần kiểm tra lại)
      'Ngày Tình nguyện viên Quốc tế',
    ], // 世界弱能人士日, 国际志愿人员日
    '12-7': ['Ngày Hàng không Dân dụng Quốc tế'], // 国际民航日
    '12-9': [
      'Ngày Bóng đá Thế giới',
      'Ngày Quốc tế Chống tham nhũng',
    ], // 世界足球日, 国际反腐败日
    '12-10': ['Ngày Nhân quyền Quốc tế'], // 世界人权日
    '12-11': ['Ngày Núi Quốc tế'], // 国际山岳日
    '12-12': ['Ngày Kỷ niệm Sự biến Tây An'], // 西安事变纪念日
    '12-13': ['Ngày Tưởng niệm Quốc gia (TQ - Thảm sát Nam Kinh)'], // 国家公祭日
    '12-14': ['Valentine Ôm'], // 拥抱情人节
    '12-18': ['Ngày Di dân Quốc tế'], // 国际移徙者日
    '12-26': ['Ngày sinh Mao Trạch Đông'], // 毛泽东诞辰纪念日
  };

  /// Kiểm tra năm nhuận (Dương lịch)
  /// @param year Năm
  /// @return true/false Năm nhuận/Năm không nhuận
  static bool isLeapYear(int year) {
    // Trước năm 1582, lịch Julian: chia hết cho 4 là nhuận
    if (year < 1582) {
      return year % 4 == 0;
    }
    // Sau năm 1582, lịch Gregorian: chia hết cho 4 nhưng không chia hết cho 100, hoặc chia hết cho 400 là nhuận
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Lấy số ngày của một tháng trong một năm cụ thể (Dương lịch)
  ///
  /// @param year  Năm
  /// @param month Tháng (1-12)
  /// @return Số ngày trong tháng
  static int getDaysOfMonth(int year, int month) {
    // Xử lý trường hợp đặc biệt của tháng 10 năm 1582 khi chuyển đổi lịch
    if (1582 == year && 10 == month) {
      return 21; // Tháng 10/1582 chỉ có 21 ngày (bỏ 10 ngày)
    }
    int m = month - 1; // Chuyển tháng về index (0-11)
    if (m < 0 || m >= DAYS_OF_MONTH.length) {
      throw ArgumentError('Tháng không hợp lệ: $month');
    }
    int d = DAYS_OF_MONTH[m];
    // Năm Dương lịch nhuận tháng 2 có thêm 1 ngày
    if (m == 1 && isLeapYear(year)) {
      d++;
    }
    return d;
  }

  /// Lấy số ngày của một năm (Năm thường 365 ngày, năm nhuận 366 ngày)
  ///
  /// @param year Năm
  /// @return Số ngày trong năm
  static int getDaysOfYear(int year) {
    // Xử lý năm đặc biệt 1582
    if (1582 == year) {
      return 355; // Năm 1582 bị mất 10 ngày
    }
    return isLeapYear(year) ? 366 : 365;
  }

  /// Lấy ngày thứ mấy trong năm của một ngày cụ thể (Dương lịch)
  ///
  /// @param year Năm
  /// @param month Tháng (1-12)
  /// @param day Ngày (1-31)
  /// @return Ngày thứ mấy trong năm
  static int getDaysInYear(int year, int month, int day) {
    int days = 0;
    for (int i = 1; i < month; i++) {
      days += getDaysOfMonth(year, i);
    }
    int d = day;
    // Xử lý trường hợp đặc biệt của tháng 10 năm 1582
    if (1582 == year && 10 == month) {
      if (day >= 15) {
        d -= 10; // Các ngày từ 15 trở đi bị trừ đi 10
      } else if (day > 4) {
        // Các ngày từ 5 đến 14 không tồn tại trong tháng 10/1582
        throw ArgumentError('Ngày không hợp lệ trong tháng 10/1582: $day');
      }
    }
    days += d;
    return days;
  }

  /// Lấy số tuần của một tháng trong một năm cụ thể (Dương lịch)
  ///
  /// @param year  Năm
  /// @param month Tháng (1-12)
  /// @param start Ngày bắt đầu tuần (0=Chủ Nhật, 1=Thứ Hai, ..., 6=Thứ Bảy)
  /// @return Số tuần trong tháng
  static int getWeeksOfMonth(int year, int month, int start) {
    // Lấy thứ của ngày đầu tiên trong tháng (0-6)
    int firstDayWeek = Solar.fromYmd(year, month, 1).getWeek();
    // Tính số ngày từ ngày bắt đầu tuần `start` đến ngày đầu tiên của tháng
    int offset = firstDayWeek - start;
    if (offset < 0) {
      offset += 7; // Nếu ngày đầu tháng nhỏ hơn ngày bắt đầu tuần, cộng thêm 7
    }
    // Tổng số ngày cần tính = số ngày trong tháng + offset
    // Số tuần = ceil((tổng số ngày) / 7)
    return ((getDaysOfMonth(year, month) + offset) / WEEK.length).ceil();
  }

  /// Lấy số ngày chênh lệch giữa hai ngày (Dương lịch)
  /// (nếu ngày a nhỏ hơn ngày b, kết quả dương; nếu ngày a lớn hơn ngày b, kết quả âm)
  ///
  /// @param ay Năm a
  /// @param am Tháng a
  /// @param ad Ngày a
  /// @param by Năm b
  /// @param bm Tháng b
  /// @param bd Ngày b
  /// @return Số ngày chênh lệch
  static int getDaysBetween(int ay, int am, int ad, int by, int bm, int bd) {
    int days;
    int i;
    if (ay == by) {
      // Cùng năm: lấy hiệu số ngày trong năm
      days = getDaysInYear(by, bm, bd) - getDaysInYear(ay, am, ad);
    } else if (ay > by) {
      // Năm a lớn hơn năm b: tính số ngày còn lại của năm b + số ngày các năm ở giữa + số ngày đã qua của năm a
      days = getDaysOfYear(by) - getDaysInYear(by, bm, bd);
      for (i = by + 1; i < ay; i++) {
        days += getDaysOfYear(i);
      }
      days += getDaysInYear(ay, am, ad);
      days = -days; // Kết quả âm vì a > b
    } else {
      // Năm a nhỏ hơn năm b: tính số ngày còn lại của năm a + số ngày các năm ở giữa + số ngày đã qua của năm b
      days = getDaysOfYear(ay) - getDaysInYear(ay, am, ad);
      for (i = ay + 1; i < by; i++) {
        days += getDaysOfYear(i);
      }
      days += getDaysInYear(by, bm, bd);
      // Kết quả dương vì a < b
    }
    return days;
  }
}
