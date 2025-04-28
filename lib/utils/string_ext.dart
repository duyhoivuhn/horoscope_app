import 'package:pdf/pdf.dart';

final gray = PdfColorHsl.fromRgb(147 / 255, 149 / 255, 152 / 255);
final blue = PdfColorHsl.fromRgb(96 / 255, 157 / 255, 248 / 255);
final green = PdfColorHsl.fromRgb(125 / 255, 183 / 255, 78 / 255);
final red = PdfColorHsl.fromRgb(230 / 255, 0 / 255, 10 / 255);
final brow = PdfColorHsl.fromRgb(111 / 255, 78 / 255, 48 / 255);

extension StringExt on String {
  PdfColor toColor() {
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
        return PdfColors.black;
    }
  }
}
