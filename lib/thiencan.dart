class ThienCan {
  static String getThienCanThang({required int year, required int month}) {
    // Danh sách Thiên Can
    final List<String> thienCan = [
      'Giáp',
      'Ất',
      'Bính',
      'Đinh',
      'Mậu',
      'Kỷ',
      'Canh',
      'Tân',
      'Nhâm',
      'Quý',
    ];

    // Bước 1: Tính chỉ số Thiên Can của năm
    // Năm Giáp Tý gần nhất là 1984. (1984 - 4) % 10 = 0 (Giáp)
    int yearThienCanIndex = (year - 4) % 10;
    if (yearThienCanIndex < 0) {
      yearThienCanIndex += 10; // Đảm bảo kết quả không âm
    }

    // Bước 2: Tính chỉ số Thiên Can của tháng Giêng (tháng Dần)
    // Dựa trên quy luật: Giáp/Kỷ -> Bính (2), Ất/Canh -> Mậu (4), Bính/Tân -> Canh (6), Đinh/Nhâm -> Nhâm (8), Mậu/Quý -> Giáp (0)
    // Chỉ số Thiên Can năm % 5: (0, 5 -> 0), (1, 6 -> 1), (2, 7 -> 2), (3, 8 -> 3), (4, 9 -> 4)
    // Công thức: (2 * (yearThienCanIndex % 5) + 2) % 10
    int firstMonthThienCanIndex = (2 * (yearThienCanIndex % 5) + 2) % 10;

    // Bước 3: Xác định tháng Âm lịch tương ứng với tháng Dương lịch
    // Đây là cách tính GẦN ĐÚNG dựa trên sự tương ứng thông thường
    // Tính chính xác cần dựa vào Tiết Khí
    int lunarMonth;
    if (month == 1 || month == 2) {
      // Tháng 1 và 2 DL thường chứa tháng Dần
      // Tuy nhiên, tháng Dần bắt đầu sau Lập Xuân (khoảng 4/5/2 DL).
      // Để đơn giản, ta dùng ánh xạ phổ biến:
      lunarMonth = 1; // Dần
    } else if (month == 3) {
      lunarMonth = 2; // Mão (bắt đầu sau Kinh Chập ~5/6/3 DL)
    } else if (month == 4) {
      lunarMonth = 3; // Thìn (bắt đầu sau Thanh Minh ~4/5/4 DL)
    } else if (month == 5) {
      lunarMonth = 4; // Tỵ (bắt đầu sau Lập Hạ ~5/6/5 DL)
    } else if (month == 6) {
      lunarMonth = 5; // Ngọ (bắt đầu sau Mang Chủng ~5/6/6 DL)
    } else if (month == 7) {
      lunarMonth = 6; // Mùi (bắt đầu sau Tiểu Thử ~6/7/7 DL)
    } else if (month == 8) {
      lunarMonth = 7; // Thân (bắt đầu sau Lập Thu ~7/8/8 DL)
    } else if (month == 9) {
      lunarMonth = 8; // Dậu (bắt đầu sau Bạch Lộ ~7/8/9 DL)
    } else if (month == 10) {
      lunarMonth = 9; // Tuất (bắt đầu sau Hàn Lộ ~8/9/10 DL)
    } else if (month == 11) {
      lunarMonth = 10; // Hợi (bắt đầu sau Lập Đông ~7/8/11 DL)
    } else if (month == 12) {
      lunarMonth = 11; // Tý (bắt đầu sau Đại Tuyết ~7/8/12 DL)
    } else {
      return "Tháng không hợp lệ"; // Hoặc xử lý lỗi khác
    }

    // Bước 4: Tính chỉ số Thiên Can của tháng cần tìm
    // Chỉ số Thiên Can tháng M = (Chỉ số Thiên Can tháng Giêng + số thứ tự tháng ÂL - 1) % 10
    // Số thứ tự tháng ÂL (Dần=1, Mão=2,...)
    int monthThienCanIndex = (firstMonthThienCanIndex + lunarMonth - 1) % 10;
    if (monthThienCanIndex < 0) {
      monthThienCanIndex += 10; // Đảm bảo kết quả không âm
    }

    // Trả về tên Thiên Can tương ứng
    return thienCan[monthThienCanIndex];
  }
}
