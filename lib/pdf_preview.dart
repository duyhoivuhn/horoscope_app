// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horoscope_app/data_model.dart';
import 'package:horoscope_app/gen/assets.gen.dart';
import 'package:horoscope_app/lunar/calendar/Lunar.dart';
import 'package:horoscope_app/utils/AppUtil.dart';
import 'package:horoscope_app/thiencan.dart';
import 'package:horoscope_app/utils/string_ext.dart';
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

    // Load the font
    final fontData = await rootBundle.load(Assets.fonts.robotoMono);
    final ttf = pw.Font.ttf(fontData);

    // Define base text style using the loaded font
    baseTextStyle = pw.TextStyle(
      fontSize: 10,
      // font: ttf,
      fontWeight: pw.FontWeight.bold,
    ); // Reduced font size slightly
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a3,
        margin: pw.EdgeInsets.all(8),
        build:
            (context) => [
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(2),
                  border: pw.Border.all(
                    color: PdfColors.grey,
                  ), // Changed border color
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildHeader(ttf), // Pass font
                    pw.SizedBox(height: 8),
                    _buildContent1(ttf), // Pass font

                    pw.SizedBox(height: 4),
                    _buildContent2(ttf),
                    pw.SizedBox(height: 4),
                    _buildContent3(ttf),
                    pw.SizedBox(height: 4),
                    _buildContent4(ttf),
                  ],
                ),
              ),
            ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a3,
        margin: pw.EdgeInsets.all(16),
        build:
            (context) => [
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(2),
                  border: pw.Border.all(
                    color: PdfColors.grey,
                  ), // Changed border color
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 4),
                    _buildContent5(ttf),
                    pw.SizedBox(height: 4),
                    _buildContent7(),
                  ],
                ),
              ),
            ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/lenh_bai_bat_tu_v2.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfFile = file;
    });
  }

  // Removed coloredCell as tb function handles styling

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem Lệnh Bài Bát Tự')),
      body:
          pdfFile == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: PdfView(
                      scrollDirection: Axis.vertical,
                      pageSnapping: false,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      controller: PdfController(document: createPdfDocument()),
                    ),
                  ),

                  // SizedBox(height: 20),
                ],
              ),
    );
  }

  Future<pdfx.PdfDocument> createPdfDocument() async {
    // Ensure the file exists before trying to open it
    if (await pdfFile!.exists()) {
      return pdfx.PdfDocument.openFile(pdfFile!.path);
    } else {
      throw Exception("PDF file not found at path: ${pdfFile!.path}");
    }
  }

  pw.Widget _buildHeader(pw.Font ttf) {
    // Use the passed font
    final headerTextStyle = baseTextStyle?.copyWith(font: ttf);
    final boldRedStyle = headerTextStyle?.copyWith(
      color: PdfColors.red,
      fontWeight: pw.FontWeight.bold,
    );
    final boldBlackStyle = headerTextStyle?.copyWith(
      color: PdfColors.black,
      fontWeight: pw.FontWeight.bold,
    );

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.amber100, // Lighter amber
        border: pw.Border.all(color: PdfColors.amber700),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      padding: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Consider adding a logo if you have one as pw.Image
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Lệnh bài bát tự',
                  style: boldRedStyle?.copyWith(fontSize: 14), // Larger title
                ),
                pw.SizedBox(height: 8),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Họ và Tên: ', style: headerTextStyle),
                      pw.TextSpan(
                        text: widget.model.fullName ?? '',
                        style: boldRedStyle,
                      ),
                    ],
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Giới tính: ', style: headerTextStyle),
                      pw.TextSpan(
                        text: widget.model.generate ?? '',
                        style: boldBlackStyle,
                      ),
                    ],
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Dương Lịch: ', style: headerTextStyle),
                      pw.TextSpan(
                        text:
                            '${widget.model.day}/${widget.model.month}/${widget.model.year} (Giờ ${widget.model.hour}:${widget.model.minute})', // Added time
                        style: boldRedStyle,
                      ),
                    ],
                  ),
                ),
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(text: 'Âm Lịch: ', style: headerTextStyle),
                      pw.TextSpan(
                        text:
                            'Ngày ${lunarDate?.getDay()} Tháng ${lunarDate?.getMonth()} Năm ${lunarDate?.getYearGan()} ${lunarDate?.getYearZhi()}', // More detailed Lunar date
                        style: boldRedStyle,
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

  //MARK: build content 1
  pw.Widget _buildContent1(pw.Font ttf) {
    // Use the passed font
    baseTextStyle = baseTextStyle?.copyWith(font: ttf);

    final yearStart = AppUtil(solarDateTime: solarDate!).getTuoiKhoiVan(
      year: widget.model.year ?? 2025,
      month: widget.model.month ?? 12,
      day: widget.model.day ?? 25,
      hour: widget.model.hour ?? 23,
      minute: widget.model.minute ?? 0,
      second: widget.model.second ?? 0,
      isMale: widget.model.generate == 'Nam',
    );

    final dateDaVan = DateTime((widget.model.year ?? 0) + yearStart, 1, 1);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //table1
        pw.Expanded(
          flex: 5, // Adjusted flex
          child: pw.Table(
            // columnWidths: baziColumnWidths, // Apply equal widths
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            children: [
              // Header Row 1: Titles
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.blueGrey50,
                ), // Header color
                children: [
                  tb(value: 'Giờ', isBold: true, bg: PdfColors.yellow),
                  tb(value: 'Ngày', isBold: true, bg: PdfColors.yellow),
                  tb(value: 'Tháng', isBold: true, bg: PdfColors.yellow),
                  tb(value: 'Năm', isBold: true, bg: PdfColors.yellow),
                ],
              ),
              // Header Row 2: Solar Date/Time
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey50),
                children: [
                  tb(
                    value: widget.model.hour?.toString() ?? '',
                    isBold: true,
                    titleColor: PdfColors.red,
                    bg: PdfColors.yellow,
                  ),
                  tb(
                    value: widget.model.day?.toString() ?? '',
                    isBold: true,
                    titleColor: PdfColors.red,
                    bg: PdfColors.yellow,
                  ),
                  tb(
                    value: widget.model.month?.toString() ?? '',
                    isBold: true,
                    titleColor: PdfColors.red,
                    bg: PdfColors.yellow,
                  ),
                  tb(
                    value: widget.model.year?.toString() ?? '',
                    isBold: true,
                    titleColor: PdfColors.red,
                    bg: PdfColors.yellow,
                  ),
                ],
              ),
              // Row 3: Thập Thần (Ten Gods)
              pw.TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThapThanGio(),
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThapThanNgay(),
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getThapThanThang(),
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThapThanNam(),
                  ),
                ],
              ),
              // Row 4: Thiên Can (Heavenly Stems)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.lightGreen50,
                ), // Highlight Can row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThienCanGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getThienCanGio().toColor(),
                    isBold: true,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThienCanNgay(),
                    isBold: true,
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getThienCanNgay().toColor(), // Highlight Day Master
                  ),
                  tb(
                    value: ThienCan.getThienCanThang(
                      year: widget.model.year ?? 2025,
                      month: widget.model.month ?? 1,
                    ),
                    titleColor:
                        ThienCan.getThienCanThang(
                          year: widget.model.year ?? 2025,
                          month: widget.model.month ?? 1,
                        ).toColor(),
                    isBold: true,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThienCanNam(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getThienCanNam().toColor(),
                    isBold: true,
                  ),
                ],
              ),
              // Row 5: Địa Chi (Earthly Branches)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.orange50,
                ), // Highlight Chi row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiGio().toColor(),
                    isBold: true,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiNgay(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiNgay().toColor(),
                    isBold: true,
                  ), // Corrected to getDiaChiNgay
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiThang(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiThang().toColor(),
                    isBold: true,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiNam(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiNam().toColor(),
                    isBold: true,
                  ),
                ],
              ),
              // Row 6: Tàng Can (Hidden Stems)
              pw.TableRow(
                children: [
                  pw.Container(
                    // Use Container to manage the Row within the cell
                    height: 24, // Match default tb height if needed
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ), // Match tb padding
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      // Add border to match tb
                      border: pw.Border.all(
                        color: PdfColors.grey600,
                        width: 0.5,
                      ),
                      color: PdfColors.white,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanGio()
                              .map(
                                (e) => pw.Text(
                                  e,
                                  style: baseTextStyle,
                                  textAlign: pw.TextAlign.center,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  pw.Container(
                    // Use Container to manage the Row within the cell
                    height: 24, // Match default tb height if needed
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ), // Match tb padding
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      // Add border to match tb
                      border: pw.Border.all(
                        color: PdfColors.grey600,
                        width: 0.5,
                      ),
                      color: PdfColors.white,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanNgay()
                              .map(
                                (e) => pw.Text(
                                  e,
                                  style: baseTextStyle,
                                  textAlign: pw.TextAlign.center,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  pw.Container(
                    // Use Container to manage the Row within the cell
                    height: 24, // Match default tb height if needed
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ), // Match tb padding
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      // Add border to match tb
                      border: pw.Border.all(
                        color: PdfColors.grey600,
                        width: 0.5,
                      ),
                      color: PdfColors.white,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanThang()
                              .map(
                                (e) => pw.Text(
                                  e,
                                  style: baseTextStyle,
                                  textAlign: pw.TextAlign.center,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  pw.Container(
                    // Use Container to manage the Row within the cell
                    height: 24, // Match default tb height if needed
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ), // Match tb padding
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      // Add border to match tb
                      border: pw.Border.all(
                        color: PdfColors.grey600,
                        width: 0.5,
                      ),
                      color: PdfColors.white,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanNam()
                              .map(
                                (e) => pw.Text(
                                  e,
                                  style: baseTextStyle,
                                  textAlign: pw.TextAlign.center,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),

              // Row 7: Trường Sinh (Life Cycle Phases)
              pw.TableRow(
                children: [
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhGio(),
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhNgay(),
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhThang(),
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhNam(),
                  ),
                ],
              ),
              // Row 8: Nạp Âm (Na Yin)
              pw.TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmGio(),
                    bg: PdfColors.grey200,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmNgay(),
                    bg: PdfColors.grey200,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmThang(),
                    bg: PdfColors.grey200,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmNam(),
                    bg: PdfColors.grey200,
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 10), // Reduced spacing
        //table2
        pw.Expanded(
          flex: 3, // Adjusted flex
          child: pw.Table(
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey50),
                children: [
                  // Combined Đại Vận Header
                  tb(value: 'Đại Vận', isBold: true, bg: PdfColors.yellow),
                  // Combined Tuổi Header
                  tb(value: 'Lưu Niên', isBold: true, bg: PdfColors.yellow),
                ],
              ),
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey50),
                children: [
                  // Combined Đại Vận Header
                  tb(
                    value: ((widget.model.year ?? 0) + yearStart).toString(),
                    isBold: true,
                    bg: PdfColors.yellow,
                  ),
                  // Combined Tuổi Header
                  tb(
                    value: DateTime.now().year.toString(),
                    isBold: true,
                    bg: PdfColors.yellow,
                  ),
                ],
              ),

              // Row 3: Thập Thần (Ten Gods)
              pw.TableRow(
                children: [
                  tb(value: AppUtil(solarDateTime: dateDaVan).getThapThanGio()),
                  tb(
                    value:
                        AppUtil(solarDateTime: DateTime.now()).getThapThanGio(),
                  ),
                ],
              ),
              // Row 4: Thiên Can (Heavenly Stems)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.lightGreen50,
                ), // Highlight Can row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getThienCanGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: dateDaVan,
                        ).getThienCanGio().toColor(),
                    isBold: true,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: DateTime.now()).getThienCanGio(),

                    isBold: true,
                    titleColor:
                        AppUtil(
                          solarDateTime: DateTime.now(),
                        ).getThienCanGio().toColor(), // Highlight Day Master
                  ),
                ],
              ),
              // Row 5: Địa Chi (Earthly Branches)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.orange50,
                ), // Highlight Chi row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getDiaChiGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: dateDaVan,
                        ).getDiaChiGio().toColor(),
                    isBold: true,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: DateTime.now()).getDiaChiGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: DateTime.now(),
                        ).getDiaChiGio().toColor(),
                    isBold: true,
                  ), // Corrected to getDiaChiNgay
                ],
              ),
              // Row 6: Tàng Can (Hidden Stems)
              pw.TableRow(
                children: [
                  // Giờ Tàng Can
                  pw.Container(
                    // Use Container to manage the Row within the cell
                    height: 24, // Match default tb height if needed
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ), // Match tb padding
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      // Add border to match tb
                      border: pw.Border.all(
                        color: PdfColors.grey600,
                        width: 0.5,
                      ),
                      color: PdfColors.white,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanNam()
                              .map(
                                (e) => pw.Text(
                                  e,
                                  style: baseTextStyle,
                                  textAlign: pw.TextAlign.center,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  pw.Container(
                    // Use Container to manage the Row within the cell
                    height: 24, // Match default tb height if needed
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ), // Match tb padding
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      // Add border to match tb
                      border: pw.Border.all(
                        color: PdfColors.grey600,
                        width: 0.5,
                      ),
                      color: PdfColors.white,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: DateTime.now())
                              .getTangCanNam()
                              .map(
                                (e) => pw.Text(
                                  e,
                                  style: baseTextStyle,
                                  textAlign: pw.TextAlign.center,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),

              // Row 8: Nạp Âm (Na Yin)
              pw.TableRow(children: [tb(value: ''), tb(value: '')]),
              pw.TableRow(children: [tb(value: ''), tb(value: '')]),
              // Row 7: Trường Sinh (Life Cycle Phases)
              pw.TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getTruongSinhGio(),
                  ),
                  tb(value: ''),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getNapAmGio(),
                    bg: PdfColors.grey200,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: DateTime.now()).getNapAmGio(),
                    bg: PdfColors.grey200,
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1, // Adjusted flex
          child: pw.Table(
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey50),
                children: [
                  tb(
                    value: 'Dương Lịch',
                    isBold: true,
                    bg: PdfColors.yellow,
                    height: 48,
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: 'Xuất Can', isBold: true, bg: PdfColors.grey300),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: 'Thiên Can', isBold: true, bg: PdfColors.grey300),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: 'Địa Chi', isBold: true, bg: PdfColors.grey300),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: 'Tàng Can', isBold: true, bg: PdfColors.grey300),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(
                    value: 'Thần sát\n đặt biệt',
                    isBold: true,
                    bg: PdfColors.grey300,
                    height: 48,
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: 'Trường Sinh', isBold: true, bg: PdfColors.grey300),
                ],
              ),
              pw.TableRow(
                children: [
                  tb(value: 'Nạp Âm', isBold: true, bg: PdfColors.grey300),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // pw.Widget _buildContent5(pw.Font ttf) {
  //   return pw.Column(
  //     children: [
  //       pw.Text(
  //         'THÔNG TIN KHÁC',
  //         style: pw.TextStyle(
  //           fontSize: 14,
  //           fontWeight: pw.FontWeight.bold,
  //           font: ttf,
  //         ),
  //       ),
  //       pw.SizedBox(height: 8),
  //       pw.Text('Thập Thần: Chính Tài', style: baseTextStyle), // Example data
  //       pw.Text(
  //         'Mệnh Cục: Kim sinh Thuỷ',
  //         style: baseTextStyle,
  //       ), // Example data
  //       pw.Text(
  //         'Tiết Khí: ${AppUtil(solarDateTime: solarDate!).getTietKhiHienTaiCuaNgay()}', // Use actual data
  //         style: baseTextStyle,
  //       ),
  //       pw.Text(
  //         'Bành Tổ Bách Kỵ (Can ngày): ${lunar?.getPengZuGan() ?? ''}',
  //         style: baseTextStyle,
  //       ),
  //       pw.Text(
  //         'Bành Tổ Bách Kỵ (Chi ngày): ${lunar?.getPengZuZhi() ?? ''}',
  //         style: baseTextStyle,
  //       ),
  //       pw.SizedBox(height: 10),
  //     ],
  //   );
  // }

  // Helper function for creating table cells (tb = table box)
  pw.Widget tb({
    PdfColor? bg,
    PdfColor? titleColor,
    required String value,
    double? size,
    double? height,
    bool? isBold,
  }) {
    // Ensure baseTextStyle is initialized
    final effectiveTextStyle = (baseTextStyle ?? pw.TextStyle(fontSize: 9))
        .copyWith(
          color: titleColor ?? PdfColors.black,
          fontWeight:
              (isBold ?? false) ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: size ?? 9, // Use provided size or default
        );

    return pw.Container(
      height: height ?? 24, // Default height, adjust as needed
      padding: pw.EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 4,
      ), // Add padding
      decoration: pw.BoxDecoration(
        color: bg ?? PdfColors.white,
        border: pw.Border.all(
          color: PdfColors.grey600,
          width: 0.5,
        ), // Thinner border
      ),
      child: pw.Center(
        child: pw.Text(
          value,
          style: effectiveTextStyle,
          textAlign: pw.TextAlign.center,
          maxLines: 2, // Allow text wrapping
          overflow: pw.TextOverflow.clip, // Clip if still too long
        ),
      ),
    );
  }

  //MARK: build table Dai van
  _buildContent2(ttf) {
    var yearStart = AppUtil(solarDateTime: solarDate!).getTuoiKhoiVan(
      year: widget.model.year ?? 2025,
      month: widget.model.month ?? 12,
      day: widget.model.day ?? 25,
      hour: widget.model.hour ?? 23,
      minute: widget.model.minute ?? 0,
      second: widget.model.second ?? 0,
      isMale: widget.model.generate == 'Nam',
    );
    yearStart += widget.model.year ?? 0;

    final dateDaVan = DateTime(yearStart, 1, 1);

    return pw.Column(
      children: [
        tb(value: 'Đại Vận', isBold: true, bg: PdfColors.yellow, height: 24),
        pw.SizedBox(
          height: 240,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 11,
                child: pw.Table(
                  // columnWidths: columnWidths8, // Apply equal widths
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: 'Năm ${yearStart + index * 10}',
                          isBold: true,
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors
                                      .grey200, // Light grey background for header
                        ),
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThapThanNam(),
                        ), // Example data
                      ),
                    ),

                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThienCanNam(),
                          titleColor:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThienCanNam().toColor(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getDiaChiNam(),
                          titleColor:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getDiaChiNam().toColor(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => pw.Container(
                          // Use Container to manage the Row within the cell
                          height: 24, // Match default tb height if needed
                          padding: pw.EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ), // Match tb padding
                          alignment: pw.Alignment.center,
                          decoration: pw.BoxDecoration(
                            // Add border to match tb
                            border: pw.Border.all(
                              color: PdfColors.grey600,
                              width: 0.5,
                            ),
                            color:
                                (yearStart + index * 10) == DateTime.now().year
                                    ? PdfColors.yellow100
                                    : PdfColors.white,
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children:
                                AppUtil(
                                      solarDateTime: DateTime(
                                        yearStart + index * 10,
                                        1,
                                        1,
                                      ),
                                    )
                                    .getTangCanNam()
                                    .map(
                                      (e) => pw.Text(
                                        e,
                                        style: baseTextStyle,
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: '',
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: '',
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getTruongSinhNam(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.grey200,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getNapAmNam(),
                        ), // Example data
                      ),
                    ),
                  ],
                ),
              ),

              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      tb(value: '', isBold: true, bg: PdfColors.grey300),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Xuất Can',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Thiên Can',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(value: 'Địa Chi', isBold: true, bg: PdfColors.grey300),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Tàng Can',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Thần sát\n đặt biệt',
                        isBold: true,
                        bg: PdfColors.grey300,
                        height: 48,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Trường Sinh',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(value: 'Nạp Âm', isBold: true, bg: PdfColors.grey300),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //MARK: table Lưu Niên
  _buildContent3(pw.Font ttf) {
    final yearStart = DateTime.now().year - 4;
    return pw.Column(
      children: [
        tb(value: 'Lưu Niên', isBold: true, bg: PdfColors.yellow, height: 24),
        pw.SizedBox(
          height: 240,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                flex: 11,
                child: pw.Table(
                  // columnWidths: columnWidths8, // Apply equal widths
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: 'Năm ${yearStart + index}',
                          isBold: true,
                          bg:
                              PdfColors
                                  .grey200, // Light grey background for header
                        ),
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThapThanNam(),
                        ), // Example data
                      ),
                    ),

                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThienCanNam(),
                          titleColor:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThienCanNam().toColor(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getDiaChiNam(),
                          titleColor:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getDiaChiNam().toColor(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => pw.Container(
                          // Use Container to manage the Row within the cell
                          height: 24, // Match default tb height if needed
                          padding: pw.EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ), // Match tb padding
                          alignment: pw.Alignment.center,
                          decoration: pw.BoxDecoration(
                            // Add border to match tb
                            border: pw.Border.all(
                              color: PdfColors.grey600,
                              width: 0.5,
                            ),
                            color:
                                yearStart + index == DateTime.now().year
                                    ? PdfColors.yellow100
                                    : PdfColors.white,
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children:
                                AppUtil(
                                      solarDateTime: DateTime(
                                        yearStart + index * 10,
                                        1,
                                        1,
                                      ),
                                    )
                                    .getTangCanNam()
                                    .map(
                                      (e) => pw.Text(
                                        e,
                                        style: baseTextStyle,
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getTruongSinhNam(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? PdfColors.yellow100
                                  : PdfColors.grey200,

                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getNapAmNam(),
                        ), // Example data
                      ),
                    ),
                  ],
                ),
              ),

              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      tb(value: '', isBold: true, bg: PdfColors.grey300),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Xuất Can',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Thiên Can',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(value: 'Địa Chi', isBold: true, bg: PdfColors.grey300),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Tàng Can',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Thần sát\n đặt biệt',
                        isBold: true,
                        bg: PdfColors.grey300,
                        height: 48,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(
                        value: 'Trường Sinh',
                        isBold: true,
                        bg: PdfColors.grey300,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      tb(value: 'Nạp Âm', isBold: true, bg: PdfColors.grey300),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //MARK: build table Luu Nguyet
  _buildContent4(pw.Font ttf) {
    final date = DateTime.now();
    return pw.Column(
      children: [
        tb(
          value: 'Lưu Nguyệt(${date.year})',
          isBold: true,
          bg: PdfColors.yellow,
          height: 24,
        ),
        pw.SizedBox(
          height: 240,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 11,
                child: pw.Table(
                  // columnWidths: columnWidths8, // Apply equal widths
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: 'Tháng ${index + 1}',
                          isBold: true,
                          bg:
                              PdfColors
                                  .grey200, // Light grey background for header
                        ),
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              index + 1 == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  index + 1,
                                  1,
                                ),
                              ).getThapThanThang(),
                        ), // Example data
                      ),
                    ),

                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              index + 1 == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value: AppUtil(
                            solarDateTime: DateTime(date.year, index + 1, 1),
                          ).getThienCanThang(thang: index + 1),
                          titleColor:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  index + 1,
                                  1,
                                ),
                              ).getThienCanThang(thang: index + 1).toColor(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  1 + index,
                                  1,
                                ),
                              ).getDiaChiThang(),
                          titleColor:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  1 + index,
                                  1,
                                ),
                              ).getDiaChiThang().toColor(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => pw.Container(
                          // Use Container to manage the Row within the cell
                          height: 24, // Match default tb height if needed
                          padding: pw.EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ), // Match tb padding
                          alignment: pw.Alignment.center,
                          decoration: pw.BoxDecoration(
                            // Add border to match tb
                            border: pw.Border.all(
                              color: PdfColors.grey600,
                              width: 0.5,
                            ),
                            color:
                                1 + index == (widget.model.month ?? -1)
                                    ? PdfColors.yellow100
                                    : PdfColors.white,
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children:
                                AppUtil(
                                      solarDateTime: DateTime(
                                        date.year,
                                        1 + index,
                                        1,
                                      ),
                                    )
                                    .getTangCanThang()
                                    .map(
                                      (e) => pw.Text(
                                        e,
                                        style: baseTextStyle,
                                        textAlign: pw.TextAlign.center,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  1 + index,
                                  1,
                                ),
                              ).getTruongSinhThang(),
                        ), // Example data
                      ),
                    ),
                    pw.TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? PdfColors.yellow100
                                  : PdfColors.grey200,

                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  1 + index,
                                  1,
                                ),
                              ).getNapAmNam(),
                        ), // Example data
                      ),
                    ),
                  ],
                ),
              ),

              pw.Expanded(
                flex: 1,
                child: pw.Table(
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: [
                        tb(value: '', isBold: true, bg: PdfColors.grey300),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Xuất Can',
                          isBold: true,
                          bg: PdfColors.grey300,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Thiên Can',
                          isBold: true,
                          bg: PdfColors.grey300,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Địa Chi',
                          isBold: true,
                          bg: PdfColors.grey300,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Tàng Can',
                          isBold: true,
                          bg: PdfColors.grey300,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Thần sát\n đặt biệt',
                          isBold: true,
                          bg: PdfColors.grey300,
                          height: 48,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Trường Sinh',
                          isBold: true,
                          bg: PdfColors.grey300,
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        tb(
                          value: 'Nạp Âm',
                          isBold: true,
                          bg: PdfColors.grey300,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildContent7() {
    final chars = [
      'TS',
      'MD',
      'QD',
      'LQ',
      'ĐV',
      'S',
      'B',
      'T',
      'M',
      'TU',
      'TH',
      'D',
    ];
    final fullChars = [
      'Trường Sinh', // 长生 (Tràng Sinh)
      'Mộc Dục', // 沐浴
      'Quan Đới', // 冠带 (Quan Đái)
      'Lâm Quan', // 临官
      'Đế Vượng', // 帝旺
      'Suy', // 衰
      'Bệnh', // 病
      'Tử', // 死
      'Mộ', // 墓
      'Tuyệt', // 绝
      'Thai', // 胎
      'Dưỡng',
    ];

    return pw.SizedBox(
      height: 68,
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 12,
            child: pw.Row(
              children:
                  List.generate(12, (index) {
                    return pw.Expanded(
                      child: pw.Column(
                        children: [
                          tb(
                            value: chars[index].toString(),
                            isBold: true,
                            bg: PdfColors.grey200,
                            size: 8,
                          ),
                          tb(value: fullChars[index], size: 8, height: 44),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.Table(
              // columnWidths: columnWidths6, // Apply equal widths
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(
                  children: [
                    tb(
                      value: 'Vòng\nTrường Sinh',
                      height: 68,
                      bg: PdfColors.yellow,
                    ),
                  ], // Example data
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //MARK: build table tai cung
  _buildContent5(pw.Font ttf) {
    final thaicung = AppUtil(solarDateTime: solarDate!).getThaiCung();
    final menhcung = AppUtil(solarDateTime: solarDate!).getMenhCung();
    final thaituc = AppUtil(solarDateTime: solarDate!).getThaiTuc();
    final truphuc = AppUtil(solarDateTime: solarDate!).getTruPhuc();

    return pw.SizedBox(
      height: 200,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.max,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: [
                        tb(value: 'Thái Cung', bg: PdfColors.yellow),
                        tb(value: 'Mệnh Cung', bg: PdfColors.yellow),
                        tb(value: 'Thai Tức', bg: PdfColors.yellow),
                        tb(value: 'Trụ Phút', bg: PdfColors.yellow),
                      ], // Example data
                    ),
                    pw.TableRow(
                      children: [
                        tb(value: thaicung.first),
                        tb(value: menhcung.first),
                        tb(value: thaituc.first),
                        tb(value: truphuc.first),
                      ], // Example data
                    ),
                    pw.TableRow(
                      children: [
                        tb(value: thaicung.last),
                        tb(value: menhcung.last),
                        tb(value: thaituc.last),
                        tb(value: truphuc.last),
                      ], // Example data
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.SizedBox(
                  width: 200,
                  child: pw.Table(
                    // columnWidths: columnWidths6, // Apply equal widths
                    border: pw.TableBorder.all(
                      width: 0.5,
                      color: PdfColors.grey,
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.SizedBox(
                            width: 60,
                            child: tb(value: 'Đại Vận', bg: PdfColors.yellow),
                          ),
                          pw.SizedBox(
                            width: 160,
                            child: tb(
                              height: 30,
                              value:
                                  AppUtil(solarDateTime: solarDate!)
                                      .tinhDaiVan(
                                        year: widget.model.year ?? 1995,
                                        month: widget.model.month ?? 12,
                                        day: widget.model.day ?? 25,
                                        hour: widget.model.hour ?? 23,
                                        minute: widget.model.minute ?? 0,
                                        second: widget.model.second ?? 0,
                                        isMale:
                                            widget.model.generate == 'Nam'
                                                ? true
                                                : false,
                                      )
                                      .toString(),
                            ),
                          ),
                        ], // Example data
                      ),
                      pw.TableRow(
                        children: [
                          tb(value: 'Tiết Khí', bg: PdfColors.yellow),
                          tb(
                            value:
                                AppUtil(
                                  solarDateTime: solarDate!,
                                ).getTietKhiHienTaiCuaNgay(),
                            height: 30,
                          ),
                        ], // Example data
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.SizedBox(
                  child: pw.Table(
                    // columnWidths: columnWidths6, // Apply equal widths
                    border: pw.TableBorder.all(
                      width: 0.5,
                      color: PdfColors.grey,
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.SizedBox(width: 40, child: tb(value: 'Kim')),
                          pw.SizedBox(width: 40, child: tb(value: 'Thuỷ')),
                          pw.SizedBox(width: 40, child: tb(value: 'Mộc')),
                          pw.SizedBox(width: 40, child: tb(value: 'Hoả')),
                          pw.SizedBox(width: 40, child: tb(value: 'Thổ')),
                        ], // Example data
                      ),
                      pw.TableRow(
                        children: [
                          tb(
                            value: '',
                            bg: PdfColorHsl.fromRgb(
                              147 / 255,
                              149 / 255,
                              152 / 255,
                            ),
                          ),
                          tb(
                            value: '',
                            bg: PdfColorHsl.fromRgb(
                              96 / 255,
                              157 / 255,
                              248 / 255,
                            ),
                          ),
                          tb(
                            value: '',
                            bg: PdfColorHsl.fromRgb(
                              125 / 255,
                              183 / 255,
                              78 / 255,
                            ),
                          ),
                          tb(
                            value: '',
                            bg: PdfColorHsl.fromRgb(
                              230 / 255,
                              0 / 255,
                              10 / 255,
                            ),
                          ),
                          tb(
                            value: '',
                            bg: PdfColorHsl.fromRgb(
                              111 / 255,
                              78 / 255,
                              48 / 255,
                            ),
                          ),
                        ], // Example data
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Expanded(flex: 2, child: _buildTableThapThan()),
          pw.SizedBox(width: 16),
          pw.Expanded(flex: 3, child: _buildTableThanSat()),
        ],
      ),
    );
  }

  _buildTableThapThan() {
    return pw.SizedBox(
      height: 144,
      child: pw.Column(
        children: [
          pw.SizedBox(
            height: 24,
            child: tb(value: 'Thập Thần', bg: PdfColors.yellow, height: 24),
          ),

          pw.Expanded(
            child: pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(
                  children: [
                    pw.SizedBox(width: 30, child: tb(value: 'TK')),
                    pw.SizedBox(width: 60, child: tb(value: 'Tỷ Kiên')),
                    pw.SizedBox(width: 30, child: tb(value: 'KT')),
                    pw.SizedBox(width: 60, child: tb(value: 'Kiếp Tài')),
                  ], // Example data
                ),
                pw.TableRow(
                  children: [
                    pw.SizedBox(width: 30, child: tb(value: 'TH')),
                    pw.SizedBox(width: 60, child: tb(value: 'Thực Thần')),
                    pw.SizedBox(width: 30, child: tb(value: 'TQ')),
                    pw.SizedBox(width: 60, child: tb(value: 'Thương Quan')),
                  ], // Example data
                ),
                pw.TableRow(
                  children: [
                    pw.SizedBox(width: 30, child: tb(value: 'CA')),
                    pw.SizedBox(width: 60, child: tb(value: 'Chính Ấn')),
                    pw.SizedBox(width: 30, child: tb(value: 'TA')),
                    pw.SizedBox(width: 60, child: tb(value: 'Thiên Ấn')),
                  ], // Example data
                ),
                pw.TableRow(
                  children: [
                    pw.SizedBox(width: 30, child: tb(value: 'CT')),
                    pw.SizedBox(width: 60, child: tb(value: 'Chính Tài')),
                    pw.SizedBox(width: 30, child: tb(value: 'TT')),
                    pw.SizedBox(width: 60, child: tb(value: 'Thiên Tài')),
                  ], // Example data
                ),
                pw.TableRow(
                  children: [
                    pw.SizedBox(width: 30, child: tb(value: 'CQ')),
                    pw.SizedBox(width: 60, child: tb(value: 'Chính Quan')),
                    pw.SizedBox(width: 30, child: tb(value: 'TS')),
                    pw.SizedBox(width: 60, child: tb(value: 'Thất Sát')),
                  ], // Example data
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTableThanSat() {
    return pw.SizedBox(
      height: 144,
      child: pw.Column(
        children: [
          pw.SizedBox(
            height: 24,
            child: tb(
              value: 'Thần Sát Nguyên Cục',
              bg: PdfColors.yellow,
              height: 24,
            ),
          ),

          pw.Expanded(
            child: pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              children: [
                pw.TableRow(
                  children: [
                    pw.SizedBox(
                      width: 60,
                      child: tb(value: 'Giờ', bg: PdfColors.grey200),
                    ),
                    pw.SizedBox(
                      width: 60,
                      child: tb(value: 'Ngày', bg: PdfColors.grey200),
                    ),
                    pw.SizedBox(
                      width: 60,
                      child: tb(value: 'Tháng', bg: PdfColors.grey200),
                    ),
                    pw.SizedBox(
                      width: 60,
                      child: tb(value: 'Năm', bg: PdfColors.grey200),
                    ),
                  ], // Example data
                ),
                pw.TableRow(
                  children: [
                    pw.SizedBox(width: 60, child: tb(value: '')),
                    pw.SizedBox(width: 60, child: tb(value: '')),
                    pw.SizedBox(width: 60, child: tb(value: '')),
                    pw.SizedBox(width: 60, child: tb(value: '')),
                  ], // Example data
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
