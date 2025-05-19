import 'package:flutter/material.dart';

// final gray = Color.from(
//   red: 147 / 255,
//   green: 149 / 255,
//   blue: 152 / 255,
//   alpha: 1,
// );
// final blue = Color.from(
//   red: 96 / 255,
//   green: 157 / 255,
//   blue: 248 / 255,
//   alpha: 1,
// );
// final green = Color.from(
//   red: 125 / 255,
//   green: 183 / 255,
//   blue: 78 / 255,
//   alpha: 1,
// );
// final red = Color.from(
//   red: 230 / 255,
//   green: 0 / 255,
//   blue: 10 / 255,
//   alpha: 1,
// );
// final brow = Color.from(
//   red: 111 / 255,
//   green: 78 / 255,
//   blue: 48 / 255,
//   alpha: 1,
// );

final gray = Color.from(
  red: 147 / 255,
  green: 149 / 255,
  blue: 152 / 255,
  alpha: 1,
);
final blue = Colors.blue;
final green = Colors.green;
final red = Colors.red;
final brow = Color.from(
  red: 111 / 255,
  green: 78 / 255,
  blue: 48 / 255,
  alpha: 1,
);

extension StringExt on String {
  Color toColor() {
    switch (this) {
      // --- Kim (Metal) ---
      case 'Canh':
      case 'Tân':
      case 'Thân':
      case 'Dậu':
        return gray; // Màu xám cho Kim

      // --- Mộc (Wood) ---
      case 'Giáp':
      case 'Ất':
      case 'Dần':
      case 'Mão':
        return green; // Màu xanh lá cho Mộc

      // --- Thủy (Water) ---
      case 'Nhâm':
      case 'Quý':
      case 'Hợi':
      case 'Tý':
        return blue; // Màu xanh dương cho Thủy

      // --- Hỏa (Fire) ---
      case 'Bính':
      case 'Đinh':
      case 'Tỵ':
      case 'Ngọ':
        return red; // Màu đỏ cho Hỏa

      // --- Thổ (Earth) ---
      case 'Mậu':
      case 'Kỷ':
      case 'Thìn':
      case 'Tuất':
      case 'Sửu':
      case 'Mùi':
        return brow; // Màu nâu cho Thổ

      // --- Mặc định ---
      default:
        return Colors.black;
    }
  }

  String get format {
    if (this == '') {
      return '';
    }
    List<String> parts = this.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return this;
    }
    String firstInitial = parts.first[0] + '.';
    String rest = parts.skip(1).join('');

    return firstInitial + rest;
  }
}
