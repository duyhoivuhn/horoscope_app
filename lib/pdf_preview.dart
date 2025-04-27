// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horoscope_app/data_model.dart';
import 'package:horoscope_app/gen/assets.gen.dart';
import 'package:horoscope_app/lunar/calendar/Lunar.dart';
import 'package:horoscope_app/lunar/calendar/util/AppUtil.dart';
import 'package:horoscope_app/thiencan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';

import 'package:pdfx/src/renderer/interfaces/document.dart' as pdfx;

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({super.key, required this.model});

  final DataModel model;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  File? pdfFile;

  var text = '';

  Lunar? lunar;
  Lunar? lunarDate;
  DateTime? solarDate;

  pw.TextStyle? baseTextStyle;

  DateTime? _date; //Ngày Âm Lịch

  @override
  void initState() {
    super.initState();
    createBeautifulFixedPdf();
  }

  Future<void> createBeautifulFixedPdf() async {
    solarDate = DateTime(
      widget.model.year ?? 2025,
      widget.model.month ?? 12,
      widget.model.day ?? 25,
      widget.model.hour ?? 23, // Giờ Dương lịch
      widget.model.minute ?? 0, // Phút Dương lịch
      widget.model.second ?? 0, // Giây Dương lịch
    );

    // 2. Tạo đối tượng Lunar từ DateTime
    lunarDate = Lunar.fromDate(solarDate!);

    _date = DateTime(
      lunarDate?.getYear() ?? 2025,
      lunarDate?.getMonth() ?? 1,
      lunarDate?.getDay() ?? 1,
      widget.model.hour ?? 23,
      widget.model.minute ?? 0,
      widget.model.second ?? 0,
    );

    lunar = Lunar.fromYmdHms(
      widget.model.year ?? 2025,
      widget.model.month ?? 12,
      widget.model.day ?? 25,
      widget.model.hour ?? 23, // Giờ Dương lịch
      widget.model.minute ?? 0, // Phút Dương lịch
      widget.model.second ?? 0, // Giây Dương lịch
    );

    final pdf = pw.Document();

    final font = await rootBundle.load(Assets.fonts.robotoMono);
    final ttf = pw.Font.ttf(font);

    baseTextStyle = pw.TextStyle(fontSize: 12, font: ttf);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(16),
        build:
            (context) => [
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(2),
                  border: pw.Border.all(color: PdfColors.red),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    pw.SizedBox(height: 16),
                    _buildContent1(),

                    pw.SizedBox(height: 20),
                    pw.Text(
                      'ĐẠI VẬN',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.5),
                      children: [
                        pw.TableRow(
                          children: List.generate(
                            8,
                            (index) => pw.Center(
                              child: pw.Text(
                                'Năm ${2020 + index * 10}',
                                style: baseTextStyle,
                              ),
                            ),
                          ),
                        ),
                        pw.TableRow(
                          children: List.generate(
                            8,
                            (index) => pw.Center(
                              child: pw.Text('Đinh Sửu', style: baseTextStyle),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'LƯU NIÊN',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.5),
                      children: [
                        pw.TableRow(
                          children: List.generate(
                            6,
                            (index) => pw.Center(
                              child: pw.Text(
                                'Năm ${2020 + index}',
                                style: baseTextStyle,
                              ),
                            ),
                          ),
                        ),
                        pw.TableRow(
                          children: List.generate(
                            6,
                            (index) => pw.Center(
                              child: pw.Text('Can Chi', style: baseTextStyle),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'LƯU NGUYỆT (2025)',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.5),
                      children: [
                        pw.TableRow(
                          children: List.generate(
                            6,
                            (index) => pw.Center(
                              child: pw.Text(
                                'Tháng ${index + 1}',
                                style: baseTextStyle,
                              ),
                            ),
                          ),
                        ),
                        pw.TableRow(
                          children: List.generate(
                            6,
                            (index) => pw.Center(
                              child: pw.Text(
                                'Thiên can địa chi',
                                style: baseTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'THÔNG TIN KHÁC',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Thập Thần: Chính Tài', style: baseTextStyle),
                    pw.Text('Mệnh Cục: Kim sinh Thuỷ', style: baseTextStyle),
                    pw.Text(
                      'Tiết Khí: Thanh Minh - 05/04/1995 (13:08)',
                      style: baseTextStyle,
                    ),
                  ],
                ),
              ),
            ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/lenh_bai_bat_tu_beautiful.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfFile = file;
    });
  }

  pw.Widget coloredCell({required String text, PdfColor? color, bool? isBold}) {
    return pw.SizedBox(
      height: 48,
      child: pw.Center(
        child: pw.Text(
          text,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem File PDF')),
      body:
          pdfFile == null
              ? const Center(child: CircularProgressIndicator())
              : PdfView(
                controller: PdfController(document: createPdfDocument()),
              ),
    );
  }

  Future<pdfx.PdfDocument> createPdfDocument() async {
    return pdfx.PdfDocument.openFile(pdfFile!.path);
  }

  _buildHeader() {
    return pw.Container(
      decoration: pw.BoxDecoration(color: PdfColors.amber),
      padding: pw.EdgeInsets.all(12),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Lệnh bài bát tự MANH PHÁI',
            style: baseTextStyle?.apply(color: PdfColors.red),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Họ và Tên: ', style: baseTextStyle),
                      pw.TextSpan(
                        text: widget.model.fullName ?? '',
                        style: baseTextStyle?.copyWith(
                          color: PdfColors.red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Giới tính: ', style: baseTextStyle),
                      pw.TextSpan(
                        text: widget.model.generate ?? '',
                        style: baseTextStyle?.copyWith(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Dương Lịch: ', style: baseTextStyle),
                      pw.TextSpan(
                        text:
                            '${widget.model.day}/${widget.model.month}/${widget.model.year}',
                        style: baseTextStyle?.copyWith(
                          color: PdfColors.red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Âm Lịch: ', style: baseTextStyle),
                      pw.TextSpan(
                        text:
                            '${lunarDate?.getDay()}/${lunarDate?.getMonth()}/${lunarDate?.getYear()}',
                        style: baseTextStyle?.copyWith(
                          color: PdfColors.red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContent1() {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.amber),
          children: [
            tb(value: 'Giờ', bg: PdfColors.amber, isBold: true),
            tb(value: 'Ngày', bg: PdfColors.amber, isBold: true),
            tb(value: 'Tháng', bg: PdfColors.amber, isBold: true),
            tb(value: 'Năm', bg: PdfColors.amber, isBold: true),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.amber),
          children: [
            tb(
              value: widget.model.hour?.toString() ?? '',
              bg: PdfColors.amber,
              isBold: true,
              titleColor: PdfColors.red,
            ),
            tb(
              value: widget.model.day?.toString() ?? '',
              bg: PdfColors.amber,
              isBold: true,
              titleColor: PdfColors.red,
            ),
            tb(
              value: widget.model.month?.toString() ?? '',
              bg: PdfColors.amber,
              isBold: true,
              titleColor: PdfColors.red,
            ),
            tb(
              value: widget.model.year?.toString() ?? '',
              bg: PdfColors.amber,
              isBold: true,
              titleColor: PdfColors.red,
            ),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.amber),
          children: [
            tb(value: AppUtil(solarDateTime: solarDate!).getThapThanGio()),
            tb(value: AppUtil(solarDateTime: solarDate!).getThapThanNgay()),
            tb(value: AppUtil(solarDateTime: solarDate!).getThapThanThang()),
            tb(value: AppUtil(solarDateTime: solarDate!).getThapThanNam()),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.amber),
          children: [
            tb(value: AppUtil(solarDateTime: solarDate!).getThienCanGio()),
            tb(value: AppUtil(solarDateTime: solarDate!).getThienCanNgay()),
            tb(
              value: ThienCan.getThienCanThang(
                year: widget.model.year ?? 2025,
                month: widget.model.month ?? 1,
              ),
            ),
            tb(value: AppUtil(solarDateTime: solarDate!).getThienCanNam()),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.amber),
          children: [
            tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiGio()),
            tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiGio()),
            tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiThang()),
            tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiNam()),
          ],
        ),
        // pw.TableRow(
        //   children: [
        //     coloredCell('MẬU', PdfColors.blue),
        //     coloredCell('CANH', PdfColors.red),
        //     coloredCell('CANH', PdfColors.red),
        //     coloredCell('ẤT', PdfColors.orange),
        //   ],
        // ),
        // pw.TableRow(
        //   children: [
        //     coloredCell('TÝ', PdfColors.blue),
        //     coloredCell('THÌN', PdfColors.red),
        //     coloredCell('THÌN', PdfColors.red),
        //     coloredCell('HỢI', PdfColors.orange),
        //   ],
        // ),
      ],
    );
  }

  pw.Widget tb({
    PdfColor? bg,
    PdfColor? titleColor,
    required String value,
    double? size,
    double? height,
    bool? isBold,
  }) {
    return pw.Expanded(
      child: pw.Container(
        height: height ?? 40,
        decoration: pw.BoxDecoration(
          color: bg ?? PdfColors.white,
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Center(
          child: pw.Text(
            value,
            style: baseTextStyle?.copyWith(
              color: titleColor ?? PdfColors.black,
              fontWeight:
                  (isBold ?? false) ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: size ?? 12,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ),
    );
  }
}
