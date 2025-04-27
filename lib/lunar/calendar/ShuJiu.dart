/// 数九
/// @author 6tail
class ShuJiu {
  /// 名称，如一九、二九
  String? _name;

  /// 当前数九第几天，1-9
  int _index = 1;

  ShuJiu(this._name, this._index);

  String getName() => _name!;

  void setName(String name) {
    _name = name;
  }

  int getIndex() => _index;

  void setIndex(int index) {
    _index = index;
  }

  @override
  String toString() {
    return '$_name';
  }

  String toFullString() {
    // Trả về chuỗi biểu thị tên và ngày thứ mấy, ví dụ: "Lễ hội ABC ngày thứ 5"
    return '$_name ngày thứ $_index'; // '第' nghĩa là "thứ", '天' nghĩa là "ngày"
  }
}
