/// 节假日
/// @author 6tail
class Holiday {
  /// 日期，YYYY-MM-DD格式
  String? _day;

  /// 名称，如：国庆
  String? _name;

  /// 是否调休，即是否要上班
  bool _work = false;

  /// 关联的节日，YYYY-MM-DD格式
  String? _target;

  Holiday(String day, String name, bool work, String target) {
    if (!day.contains('-')) {
      _day =
          day.substring(0, 4) +
          '-' +
          day.substring(4, 6) +
          '-' +
          day.substring(6);
    } else {
      _day = day;
    }
    _name = name;
    _work = work;
    if (!target.contains('-')) {
      _target =
          target.substring(0, 4) +
          '-' +
          target.substring(4, 6) +
          '-' +
          target.substring(6);
    } else {
      _target = target;
    }
  }

  String getDay() => _day!;

  void setDay(String day) {
    _day = day;
  }

  String getName() => _name!;

  void setName(String name) {
    _name = name;
  }

  bool isWork() => _work;

  void setWork(bool work) {
    _work = work;
  }

  String getTarget() => _target!;

  void setTarget(String target) {
    _target = target;
  }

  @override
  String toString() {
    // Trả về chuỗi biểu thị ngày, tên lễ hội, thông tin làm bù (nếu có) và ngày nghỉ gốc được bù
    // Ví dụ: "Ngày 28: Quốc Khánh (Làm bù cho ngày 10-1)"
    return 'Ngày $_day: $_name${_work ? ' (Làm bù cho ngày $_target)' : ''}';
    // '调休' (Điếu Hưu): Làm bù (thường là làm vào cuối tuần để nghỉ bù vào ngày lễ)
  }
}
