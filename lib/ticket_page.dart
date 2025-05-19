// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:horoscope_app/data_model.dart';
import 'package:horoscope_app/lunar/calendar/Lunar.dart';
import 'package:horoscope_app/utils/AppUtil.dart';
import 'package:horoscope_app/thiencan.dart';
import 'package:horoscope_app/utils/string_ext.dart';

import 'package:pdfx/src/renderer/interfaces/document.dart' as pdfx;
import 'package:widget_zoom/widget_zoom.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key, required this.model});

  final DataModel model;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  File? pdfFile;

  var text = '';

  Lunar? lunar;
  Lunar? lunarDate;
  DateTime? solarDate;

  TextStyle? baseTextStyle;

  DateTime? _date; //Ngày Âm Lịch

  var isLoading = true;

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

    await Future.delayed(Duration(seconds: 1));

    // final pdf = Document();

    // // Load the font
    // final fontData = await rootBundle.load(Assets.fonts.robotoMono);
    // final ttf = Font.ttf(fontData);

    // // Define base text style using the loaded font
    baseTextStyle = TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.bold,
    ); // Reduced font size slightly

    setState(() {
      isLoading = false;
    });
  }

  // Removed coloredCell as tb function handles styling

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem Lệnh Bài Bát Tự')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : WidgetZoom(
                heroAnimationTag: 'tag',
                zoomWidget: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(), // Pass font
                        const SizedBox(height: 4),
                        _buildContent1(),
                        const SizedBox(height: 4),
                        _buildContent2(),
                        const SizedBox(height: 4),
                        _buildContent3(),
                        const SizedBox(height: 4),
                        _buildContent4(),
                        const SizedBox(height: 4),
                        _buildContent5(),
                        const SizedBox(height: 4),
                        _buildContent7(),
                      ],
                    ),
                  ),
                ),
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

  Widget _buildHeader() {
    // Use the passed font
    final headerTextStyle = baseTextStyle?.copyWith();
    final boldRedStyle = headerTextStyle?.copyWith(
      color: Colors.red,
      fontWeight: FontWeight.w700,
    );
    final boldBlackStyle = headerTextStyle?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );

    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber, // Lighter amber
          border: Border.all(color: Colors.amber),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Consider adding a logo if you have one as Image
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lệnh bài bát tự',
                    style: boldRedStyle?.copyWith(fontSize: 10), // Larger title
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Họ và Tên: ', style: headerTextStyle),
                        TextSpan(
                          text: widget.model.fullName ?? '',
                          style: boldRedStyle?.copyWith(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Giới tính: ', style: headerTextStyle),
                        TextSpan(
                          text: widget.model.generate ?? '',
                          style: boldBlackStyle,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Dương Lịch: ', style: headerTextStyle),
                        TextSpan(
                          text:
                              '${widget.model.day}/${widget.model.month}/${widget.model.year} (Giờ ${widget.model.hour}:${widget.model.minute})', // Added time
                          style: boldRedStyle,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'Âm Lịch: ', style: headerTextStyle),
                        TextSpan(
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
      ),
    );
  }

  //MARK: build content 1
  Widget _buildContent1() {
    // Use the passed font
    baseTextStyle = baseTextStyle?.copyWith();

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //table1
        Expanded(
          flex: 5, // Adjusted flex
          child: Table(
            // columnWidths: baziColumnWidths, // Apply equal widths
            border: TableBorder.all(width: 0.1, color: Colors.black),
            children: [
              // Header Row 1: Titles
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ), // Header color
                children: [
                  tb(value: 'Giờ', isBold: true, bg: Colors.yellow, size: 7),
                  tb(value: 'Ngày', isBold: true, bg: Colors.yellow, size: 7),
                  tb(value: 'Tháng', isBold: true, bg: Colors.yellow, size: 7),
                  tb(value: 'Năm', isBold: true, bg: Colors.yellow, size: 7),
                ],
              ),
              // Header Row 2: Solar Date/Time
              TableRow(
                decoration: BoxDecoration(color: Colors.blueGrey),
                children: [
                  tb(
                    value: widget.model.hour?.toString() ?? '',
                    isBold: true,
                    titleColor: Colors.red,
                    bg: Colors.yellow,
                    size: 6,
                  ),
                  tb(
                    value: widget.model.day?.toString() ?? '',
                    isBold: true,
                    titleColor: Colors.red,
                    bg: Colors.yellow,
                    size: 6,
                  ),
                  tb(
                    value: widget.model.month?.toString() ?? '',
                    isBold: true,
                    titleColor: Colors.red,
                    bg: Colors.yellow,
                    size: 6,
                  ),
                  tb(
                    value: widget.model.year?.toString() ?? '',
                    isBold: true,
                    titleColor: Colors.red,
                    bg: Colors.yellow,
                    size: 6,
                  ),
                ],
              ),
              // Row 3: Thập Thần (Ten Gods)
              TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThapThanGio(),
                    isBold: false,
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.w400),
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThapThanNgay(),
                    isBold: false,
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.w400),
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getThapThanThang(),
                    isBold: false,
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.w400),
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThapThanNam(),
                    isBold: false,
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              // Row 4: Thiên Can (Heavenly Stems)
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green,
                ), // Highlight Can row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThienCanGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getThienCanGio().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThienCanNgay(),
                    isBold: true,
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getThienCanNgay().toColor(), // Highlight Day Master
                    size: 12,
                    height: 30,
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
                    size: 12,
                    height: 30,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getThienCanNam(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getThienCanNam().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ),
                ],
              ),
              // Row 5: Địa Chi (Earthly Branches)
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ), // Highlight Chi row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiGio().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiNgay(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiNgay().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ), // Corrected to getDiaChiNgay
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiThang(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiThang().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getDiaChiNam(),
                    titleColor:
                        AppUtil(
                          solarDateTime: solarDate!,
                        ).getDiaChiNam().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ),
                ],
              ),
              // Row 6: Tàng Can (Hidden Stems)
              TableRow(
                children: [
                  Container(
                    // Use Container to manage the Row within the cell
                    height: 16, // Match default tb height if needed
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: 2,
                    //   vertical: 4,
                    // ), // Match tb padding
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // Add border to match tb
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children:
                          AppUtil(solarDateTime: _date!).getTangCanGio().map((
                            e,
                          ) {
                            return Expanded(
                              child: tb(
                                value: e,
                                style: TextStyle(
                                  color: e.toColor(),
                                  fontSize: 4,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  Container(
                    // Use Container to manage the Row within the cell
                    height: 16, // Match default tb height if needed

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // Add border to match tb
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanNgay()
                              .map(
                                (e) => Expanded(
                                  child: tb(
                                    value: e,
                                    style: TextStyle(
                                      color: e.toColor(),
                                      fontSize: 5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  Container(
                    // Use Container to manage the Row within the cell
                    height: 16, // Match default tb height if needed

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // Add border to match tb
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanThang()
                              .map(
                                (e) => Expanded(
                                  child: tb(
                                    value: e,
                                    style: TextStyle(
                                      color: e.toColor(),
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  Container(
                    // Use Container to manage the Row within the cell
                    height: 16, // Match default tb height if needed

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // Add border to match tb
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanNam()
                              .map(
                                (e) => Expanded(
                                  child: tb(
                                    value: e,
                                    style: TextStyle(
                                      color: e.toColor(),
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),

              // Row 7: Trường Sinh (Life Cycle Phases)
              TableRow(
                children: [
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                ],
              ),
              TableRow(
                children: [
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                  tb(value: ''),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhGio(),
                    size: 6,
                    bg: Colors.grey.shade200,
                    titleColor: Colors.grey,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhNgay(),
                    size: 6,
                    bg: Colors.grey.shade200,
                    titleColor: Colors.grey,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhThang(),
                    size: 6,
                    bg: Colors.grey.shade200,
                    titleColor: Colors.grey,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: solarDate!).getTruongSinhNam(),
                    size: 6,
                    bg: Colors.grey.shade200,
                    titleColor: Colors.grey,
                  ),
                ],
              ),
              // Row 8: Nạp Âm (Na Yin)
              TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmGio(),
                    bg: Colors.grey.shade200,
                    size: 6,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmNgay(),
                    bg: Colors.grey.shade200,
                    size: 6,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmThang(),
                    bg: Colors.grey.shade200,
                    size: 6,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: solarDate!).getNapAmNam(),
                    bg: Colors.grey.shade200,
                    size: 6,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 4), // Reduced spacing
        //table2
        Expanded(
          flex: 3, // Adjusted flex
          child: Table(
            border: TableBorder.all(width: 0.1, color: Colors.black),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.blueGrey),
                children: [
                  // Combined Đại Vận Header
                  tb(
                    value: 'Đại Vận',
                    isBold: true,
                    bg: Colors.yellow,
                    size: 7,
                  ),
                  // Combined Tuổi Header
                  tb(
                    value: 'Lưu Niên',
                    isBold: true,
                    bg: Colors.yellow,
                    size: 7,
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Colors.blueGrey),
                children: [
                  // Combined Đại Vận Header
                  tb(
                    value: ((widget.model.year ?? 0) + yearStart).toString(),
                    isBold: true,
                    bg: Colors.yellow,
                    size: 7,
                  ),
                  // Combined Tuổi Header
                  tb(
                    value: DateTime.now().year.toString(),
                    isBold: true,
                    bg: Colors.yellow,
                    size: 7,
                  ),
                ],
              ),

              // Row 3: Thập Thần (Ten Gods)
              TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getThapThanGio(),
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.w500),
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: DateTime.now()).getThapThanGio(),
                    style: TextStyle(fontSize: 6, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              // Row 4: Thiên Can (Heavenly Stems)
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.green,
                ), // Highlight Can row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getThienCanGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: dateDaVan,
                        ).getThienCanGio().toColor(),
                    isBold: true,
                    size: 10,
                    height: 30,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: DateTime.now()).getThienCanGio(),

                    isBold: true,
                    titleColor:
                        AppUtil(
                          solarDateTime: DateTime.now(),
                        ).getThienCanGio().toColor(), // Highlight Day Master
                    size: 10,
                    height: 30,
                  ),
                ],
              ),
              // Row 5: Địa Chi (Earthly Branches)
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ), // Highlight Chi row
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getDiaChiGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: dateDaVan,
                        ).getDiaChiGio().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ),
                  tb(
                    value:
                        AppUtil(solarDateTime: DateTime.now()).getDiaChiGio(),
                    titleColor:
                        AppUtil(
                          solarDateTime: DateTime.now(),
                        ).getDiaChiGio().toColor(),
                    isBold: true,
                    size: 12,
                    height: 30,
                  ), // Corrected to getDiaChiNgay
                ],
              ),
              // Row 6: Tàng Can (Hidden Stems)
              TableRow(
                children: [
                  // Giờ Tàng Can
                  Container(
                    // Use Container to manage the Row within the cell
                    height: 16, // Match default tb height if needed

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // Add border to match tb
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children:
                          AppUtil(solarDateTime: _date!)
                              .getTangCanNam()
                              .map(
                                (e) => Expanded(
                                  child: tb(
                                    value: e,
                                    style: TextStyle(
                                      color: e.toColor(),
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  Container(
                    // Use Container to manage the Row within the cell
                    height: 16, // Match default tb height if needed

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // Add border to match tb
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children:
                          AppUtil(solarDateTime: DateTime.now())
                              .getTangCanNam()
                              .map(
                                (e) => Expanded(
                                  child: tb(
                                    value: e,
                                    style: TextStyle(
                                      color: e.toColor(),
                                      fontSize: 5,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),

              // Row 8: Nạp Âm (Na Yin)
              TableRow(children: [tb(value: ''), tb(value: '')]),
              TableRow(children: [tb(value: ''), tb(value: '')]),
              // Row 7: Trường Sinh (Life Cycle Phases)
              TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getTruongSinhGio(),
                    size: 6,
                    bg: Colors.grey.shade200,
                    titleColor: Colors.grey,
                  ),
                  tb(
                    value:
                        AppUtil(
                          solarDateTime: DateTime.now(),
                        ).getTruongSinhGio(),
                    size: 6,
                    bg: Colors.grey.shade200,
                    titleColor: Colors.grey,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: AppUtil(solarDateTime: dateDaVan).getNapAmGio(),
                    bg: Colors.grey.shade200,
                    size: 6,
                    isBold: true,
                  ),
                  tb(
                    value: AppUtil(solarDateTime: DateTime.now()).getNapAmGio(),
                    bg: Colors.grey.shade200,
                    size: 6,
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(width: 1, color: Colors.black),
        Expanded(
          flex: 1, // Adjusted flex
          child: Table(
            border: TableBorder.all(width: 0.5, color: Colors.grey.shade200),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.blueGrey),
                children: [
                  tb(
                    value: 'Dương \nLịch',
                    isBold: true,
                    bg: Colors.yellow,
                    height: 36,
                    size: 7,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'Xuất Can',
                    isBold: true,
                    bg: Colors.grey.shade200,
                    size: 5,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'Thiên Can',
                    isBold: true,
                    bg: Colors.grey.shade200,
                    height: 30,
                    size: 5,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'Địa Chi',
                    isBold: true,
                    bg: Colors.grey.shade200,
                    height: 30,
                    size: 5,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'Tàng Can',
                    isBold: true,
                    bg: Colors.grey.shade200,
                    size: 5,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'Thần sát\n đặt biệt',
                    isBold: true,
                    bg: Colors.grey.shade200,
                    height: 34,
                    size: 5,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'TrườngSinh',
                    size: 5,
                    isBold: true,
                    bg: Colors.grey.shade200,
                  ),
                ],
              ),
              TableRow(
                children: [
                  tb(
                    value: 'Nạp Âm',
                    isBold: true,
                    bg: Colors.grey.shade200,
                    size: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildContent5(Font ttf) {
  //   return Column(
  //     children: [
  //       Text(
  //         'THÔNG TIN KHÁC',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold,
  //           font: ttf,
  //         ),
  //       ),
  //       SizedBox(height: 8),
  //       Text('Thập Thần: Chính Tài', style: baseTextStyle), // Example data
  //       Text(
  //         'Mệnh Cục: Kim sinh Thuỷ',
  //         style: baseTextStyle,
  //       ), // Example data
  //       Text(
  //         'Tiết Khí: ${AppUtil(solarDateTime: solarDate!).getTietKhiHienTaiCuaNgay()}', // Use actual data
  //         style: baseTextStyle,
  //       ),
  //       Text(
  //         'Bành Tổ Bách Kỵ (Can ngày): ${lunar?.getPengZuGan() ?? ''}',
  //         style: baseTextStyle,
  //       ),
  //       Text(
  //         'Bành Tổ Bách Kỵ (Chi ngày): ${lunar?.getPengZuZhi() ?? ''}',
  //         style: baseTextStyle,
  //       ),
  //       SizedBox(height: 10),
  //     ],
  //   );
  // }

  // Helper function for creating table cells (tb = table box)
  Widget tb({
    Color? bg,
    Color? titleColor,
    required String value,
    TextStyle? style,
    double? size,
    double? height,
    bool? isBold,
    bool? isAutoScale = false,
  }) {
    // Ensure baseTextStyle is initialized
    final effectiveTextStyle = (baseTextStyle ?? TextStyle(fontSize: 9))
        .copyWith(
          color: titleColor ?? Colors.black,
          fontWeight: (isBold ?? false) ? FontWeight.w600 : FontWeight.normal,
          fontSize: size ?? 9, // Use provided size or default
        );

    return Material(
      child: Container(
        height: height ?? 18, // Default height, adjust as needed
        padding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ), // Add padding
        decoration: BoxDecoration(
          color: bg ?? Colors.white,
          border: Border.all(color: Colors.black, width: 0.1), // Thinner border
        ),
        child: Center(
          child:
              (isAutoScale ?? false)
                  ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: style ?? effectiveTextStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2, // Allow text wrapping
                      overflow: TextOverflow.clip, // Clip if still too long
                    ),
                  )
                  : Text(
                    value,
                    style: style ?? effectiveTextStyle,
                    textAlign: TextAlign.center,
                    maxLines: 2, // Allow text wrapping
                    overflow: TextOverflow.clip, // Clip if still too long
                  ),
        ),
      ),
    );
  }

  //MARK: build table Dai van
  _buildContent2() {
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

    return Column(
      children: [
        tb(
          value: 'Đại Vận',
          isBold: true,
          bg: Colors.yellow,
          height: 18,
          size: 7,
        ),
        SizedBox(
          // height: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Table(
                  border: TableBorder.all(width: 0.1, color: Colors.black),
                  children: [
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: 'Năm ${yearStart + index * 10}',

                          size: 5,
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors
                                      .grey
                                      .shade300, // Light grey background for header
                        ),
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThapThanNam(),
                          size: 5,
                        ), // Example data
                      ),
                    ),

                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
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
                          size: 8,
                          isBold: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
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
                          size: 8,
                          isBold: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) {
                          final items =
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getTangCanNam();
                          return SizedBox(
                            height: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children:
                                  items.map((e) {
                                    return Expanded(
                                      child: tb(
                                        value: e,
                                        style: TextStyle(
                                          color: e.toColor(),
                                          fontSize: 4.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          );
                        }, // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: '',
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: '',
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.grey.shade200,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getTruongSinhNam(),
                          size: 6,
                          isBold: false,
                          titleColor: Colors.grey,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              (yearStart + index * 10) == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.grey.shade200,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getNapAmNam(),
                          size: 5,
                          isBold: false,
                        ), // Example data
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Table(
                  border: TableBorder.all(
                    width: 0.5,
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    TableRow(
                      children: [
                        tb(value: '', isBold: true, bg: Colors.grey.shade200),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Xuất Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Thiên Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Địa Chi',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Tàng Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 5,
                          height: 16,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Thần sát\nđặt biệt',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          height: 36,
                          size: 5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'TrườngSinh',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 5,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Nạp Âm',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 5,
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

  //MARK: table Lưu Niên
  _buildContent3() {
    final yearStart = DateTime.now().year - 4;
    return Column(
      children: [
        tb(
          value: 'Lưu Niên',
          isBold: true,
          bg: Colors.yellow,
          height: 18,
          size: 8,
        ),
        SizedBox(
          // height: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 11,
                child: Table(
                  // columnWidths: columnWidths8, // Apply equal widths
                  border: TableBorder.all(width: 0.1, color: Colors.black),
                  children: [
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          value: 'Năm ${yearStart + index}',
                          size: 5,
                          // isBold: true,
                          bg:
                              Colors
                                  .grey
                                  .shade300, // Light grey background for header
                        ),
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getThapThanNam(),
                          size: 5,
                        ), // Example data
                      ),
                    ),

                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
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
                          size: 8,
                          isBold: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
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
                          size: 8,
                          isBold: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => Container(
                          // Use Container to manage the Row within the cell
                          height: 16, // Match default tb height if needed

                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // Add border to match tb
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                            color:
                                yearStart + index == DateTime.now().year
                                    ? Colors.yellow
                                    : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,

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
                                      (e) => Expanded(
                                        child: tb(
                                          value: e,

                                          style: TextStyle(
                                            color: e.toColor(),
                                            fontSize: 4,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.grey.shade200,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getTruongSinhNam(),
                          size: 6,
                          titleColor: Colors.grey,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        8,
                        (index) => tb(
                          bg:
                              yearStart + index == DateTime.now().year
                                  ? Colors.yellow
                                  : Colors.grey.shade200,

                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  yearStart + index * 10,
                                  1,
                                  1,
                                ),
                              ).getNapAmNam(),
                          size: 5,
                        ), // Example data
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1),
              Expanded(
                child: Table(
                  border: TableBorder.all(
                    width: 0.5,
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    TableRow(
                      children: [
                        tb(value: '', isBold: true, bg: Colors.grey.shade200),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Xuất Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Thiên Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Địa Chi',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Tàng Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                          height: 16,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Thần sát\nđặt biệt',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          height: 36,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Trường Sinh',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Nạp Âm',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
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

  //MARK: build table Luu Nguyet
  _buildContent4() {
    final date = DateTime.now();
    return Column(
      children: [
        tb(
          value: 'Lưu Nguyệt(${date.year})',
          isBold: true,
          bg: Colors.yellow,
          height: 24,
          size: 10,
        ),
        SizedBox(
          // height: 240,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: Table(
                  // columnWidths: columnWidths8, // Apply equal widths
                  border: TableBorder.all(width: 0.1, color: Colors.black),
                  children: [
                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          value: 'Tháng ${index + 1}',
                          // isBold: true,
                          bg:
                              Colors
                                  .grey
                                  .shade300, // Light grey background for header
                          size: 5,
                          titleColor: Colors.black,
                        ),
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          bg:
                              index + 1 == (widget.model.month ?? -1)
                                  ? Colors.yellow
                                  : Colors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  index + 1,
                                  1,
                                ),
                              ).getThapThanThang(),
                          size: 5,
                          isAutoScale: true,
                        ), // Example data
                      ),
                    ),

                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          bg:
                              index + 1 == (widget.model.month ?? -1)
                                  ? Colors.yellow
                                  : Colors.white,
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
                          size: 7,
                          isBold: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? Colors.yellow
                                  : Colors.white,
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
                          size: 7,
                          isBold: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      // decoration:,
                      children: List.generate(
                        12,
                        (index) => Container(
                          // Use Container to manage the Row within the cell
                          height: 18, // Match default tb height if needed

                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // Add border to match tb
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                            color:
                                1 + index == (widget.model.month ?? -1)
                                    ? Colors.yellow
                                    : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
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
                                      (e) => Expanded(
                                        child: tb(
                                          value: e,
                                          titleColor: e.toColor(),
                                          size: 4,
                                          isAutoScale: true,
                                          isBold: true,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? Colors.yellow
                                  : Colors.white,
                          value: '',
                        ), // Example data
                      ),
                    ),

                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          // height: 30,
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? Colors.yellow
                                  : Colors.white,
                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  1 + index,
                                  1,
                                ),
                              ).getTruongSinhThang(),
                          size: 5,
                          isAutoScale: true,
                        ), // Example data
                      ),
                    ),
                    TableRow(
                      children: List.generate(
                        12,
                        (index) => tb(
                          // height: 40,
                          bg:
                              1 + index == (widget.model.month ?? -1)
                                  ? Colors.yellow
                                  : Colors.grey.shade200,

                          value:
                              AppUtil(
                                solarDateTime: DateTime(
                                  date.year,
                                  1 + index,
                                  1,
                                ),
                              ).getNapAmNam(),
                          size: 5,
                          isAutoScale: true,
                        ), // Example data
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Table(
                  border: TableBorder.all(
                    width: 0.5,
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    TableRow(
                      children: [
                        tb(value: '', isBold: true, bg: Colors.grey.shade200),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Xuất Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Thiên Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Địa Chi',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Tàng Can',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          height: 18,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Thần sát\nđặt biệt',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          // height: 2,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Trường\nSinh',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          // height: 30,
                          size: 4.2,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: 'Nạp Âm',
                          isBold: true,
                          bg: Colors.grey.shade200,
                          // height: 40,
                          size: 4.2,
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

    return SizedBox(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 12,
            child: Row(
              children:
                  List.generate(12, (index) {
                    return Expanded(
                      child: Column(
                        children: [
                          tb(
                            value: chars[index].toString(),
                            isBold: true,
                            bg: Colors.grey.shade200,
                            size: 6,
                            height: 24,
                          ),
                          tb(value: fullChars[index], size: 6, height: 24),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: tb(
              value: 'Vòng\nTrường Sinh',
              // height: 24,
              bg: Colors.yellow,
              size: 6,
              isAutoScale: true,
            ),
          ),
        ],
      ),
    );
  }

  //MARK: build table tai cung
  _buildContent5() {
    final thaicung = AppUtil(solarDateTime: solarDate!).getThaiCung();
    final menhcung = AppUtil(solarDateTime: solarDate!).getMenhCung();
    final thaituc = AppUtil(solarDateTime: solarDate!).getThaiTuc();
    final truphuc = AppUtil(solarDateTime: solarDate!).getTruPhuc();

    return SizedBox(
      // height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Table(
                  border: TableBorder.all(width: 0.1, color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        tb(value: 'Thái Cung', bg: Colors.yellow, size: 4),
                        tb(value: 'Mệnh Cung', bg: Colors.yellow, size: 4),
                        tb(value: 'Thai Tức', bg: Colors.yellow, size: 4),
                        tb(value: 'Trụ Phút', bg: Colors.yellow, size: 4),
                      ], // Example data
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: thaicung.first,
                          size: 6,
                          isBold: true,
                          titleColor: thaicung.first.toColor(),
                        ),
                        tb(
                          value: menhcung.first,
                          size: 6,
                          isBold: true,
                          titleColor: menhcung.first.toColor(),
                        ),
                        tb(
                          value: thaituc.first,
                          size: 6,
                          isBold: true,
                          titleColor: thaituc.first.toColor(),
                        ),
                        tb(
                          value: truphuc.first,
                          size: 6,
                          isBold: true,
                          titleColor: truphuc.first.toColor(),
                        ),
                      ], // Example data
                    ),
                    TableRow(
                      children: [
                        tb(
                          value: thaicung.last,
                          size: 6,
                          isBold: true,
                          titleColor: thaicung.last.toColor(),
                        ),
                        tb(
                          value: menhcung.last,
                          size: 6,
                          isBold: true,
                          titleColor: menhcung.last.toColor(),
                        ),
                        tb(
                          value: thaituc.last,
                          size: 6,
                          isBold: true,
                          titleColor: thaituc.last.toColor(),
                        ),
                        tb(
                          value: truphuc.last,
                          size: 6,
                          isBold: true,
                          titleColor: truphuc.last.toColor(),
                        ),
                      ], // Example data
                    ),
                  ],
                ),
                SizedBox(height: 2),
                SizedBox(
                  // width: 200,
                  child: Table(
                    // columnWidths: columnWidths6, // Apply equal widths
                    border: TableBorder.all(width: 0.1, color: Colors.black),
                    children: [
                      TableRow(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 30,
                            child: tb(
                              value: 'Đại Vận',
                              bg: Colors.yellow,
                              size: 5,
                            ),
                          ),
                          SizedBox(
                            // width: 160,
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
                              size: 5,
                            ),
                          ),
                        ], // Example data
                      ),
                      TableRow(
                        children: [
                          tb(
                            value: 'Tiết Khí',
                            bg: Colors.yellow,
                            size: 5,
                            height: 24,
                          ),
                          tb(
                            height: 24,
                            value:
                                AppUtil(
                                  solarDateTime: solarDate!,
                                ).getTietKhiHienTaiCuaNgay(),
                            // height: 30,
                            size: 5,
                          ),
                        ], // Example data
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                SizedBox(
                  child: Table(
                    // columnWidths: columnWidths6, // Apply equal widths
                    border: TableBorder.all(width: 0.1, color: Colors.black),
                    children: [
                      TableRow(
                        children: [
                          SizedBox(width: 40, child: tb(value: 'Kim', size: 6)),
                          SizedBox(
                            width: 40,
                            child: tb(value: 'Thuỷ', size: 6),
                          ),
                          SizedBox(width: 40, child: tb(value: 'Mộc', size: 6)),
                          SizedBox(width: 40, child: tb(value: 'Hoả', size: 6)),
                          SizedBox(width: 40, child: tb(value: 'Thổ', size: 6)),
                        ], // Example data
                      ),
                      TableRow(
                        children: [
                          tb(
                            value: '',
                            bg: Color.from(
                              red: 147 / 255,
                              green: 149 / 255,
                              blue: 152 / 255,
                              alpha: 1,
                            ),
                            height: 14,
                          ),
                          tb(
                            value: '',
                            bg: Color.from(
                              red: 96 / 255,
                              green: 157 / 255,
                              blue: 248 / 255,
                              alpha: 1,
                            ),
                            height: 14,
                          ),
                          tb(
                            value: '',
                            bg: Color.from(
                              red: 125 / 255,
                              green: 183 / 255,
                              blue: 78 / 255,
                              alpha: 1,
                            ),
                            height: 14,
                          ),
                          tb(
                            value: '',
                            bg: Color.from(
                              red: 230 / 255,
                              green: 0 / 255,
                              blue: 10 / 255,
                              alpha: 1,
                            ),
                            height: 14,
                          ),
                          tb(
                            value: '',
                            bg: Color.from(
                              red: 111 / 255,
                              green: 78 / 255,
                              blue: 48 / 255,
                              alpha: 1,
                            ),
                            height: 14,
                          ),
                        ], // Example data
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2),
          Expanded(flex: 2, child: _buildTableThapThan()),
          SizedBox(width: 2),
          Expanded(flex: 3, child: _buildTableThanSat()),
        ],
      ),
    );
  }

  _buildTableThapThan() {
    return SizedBox(
      height: 144,
      child: Column(
        children: [
          SizedBox(
            height: 18,
            child: tb(
              value: 'Thập Thần',
              bg: Colors.yellow,
              // height: 24,
              size: 8,
            ),
          ),

          Expanded(
            child: Table(
              border: TableBorder.all(width: 0.1, color: Colors.black),
              children: [
                TableRow(
                  children: [
                    SizedBox(width: 30, child: tb(value: 'TK', size: 5)),
                    SizedBox(width: 60, child: tb(value: 'Tỷ Kiên', size: 5)),
                    SizedBox(width: 30, child: tb(value: 'KT', size: 5)),
                    SizedBox(width: 60, child: tb(value: 'Kiếp Tài', size: 5)),
                  ], // Example data
                ),
                TableRow(
                  children: [
                    SizedBox(width: 30, child: tb(value: 'TH', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(value: 'Thực Thần', isAutoScale: true),
                    ),
                    SizedBox(width: 30, child: tb(value: 'TQ', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(
                        value: 'Thương Quan',
                        size: 4.5,
                        isAutoScale: true,
                      ),
                    ),
                  ], // Example data
                ),
                TableRow(
                  children: [
                    SizedBox(width: 30, child: tb(value: 'CA', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(value: 'Chính Ấn', size: 5, isAutoScale: true),
                    ),
                    SizedBox(width: 30, child: tb(value: 'TA', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(value: 'Thiên Ấn', size: 5, isAutoScale: true),
                    ),
                  ], // Example data
                ),
                TableRow(
                  children: [
                    SizedBox(width: 30, child: tb(value: 'CT', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(value: 'Chính Tài', size: 5, isAutoScale: true),
                    ),
                    SizedBox(width: 30, child: tb(value: 'TT', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(value: 'Thiên Tài', size: 5, isAutoScale: true),
                    ),
                  ], // Example data
                ),
                TableRow(
                  children: [
                    SizedBox(width: 30, child: tb(value: 'CQ', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(
                        value: 'Chính Quan',
                        size: 5,
                        isAutoScale: true,
                      ),
                    ),
                    SizedBox(width: 30, child: tb(value: 'TS', size: 5)),
                    SizedBox(
                      width: 60,
                      child: tb(value: 'Thất Sát', size: 5, isAutoScale: true),
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

  //MARK: build table than sat
  _buildTableThanSat() {
    Map<String, List<String>> thanSat =
        AppUtil(solarDateTime: solarDate!).getThanSat();
    return SizedBox(
      height: 144,
      child: Column(
        children: [
          SizedBox(
            height: 18,
            child: tb(
              value: 'Thần Sát Nguyên Cục',
              bg: Colors.yellow,
              height: 18,
              size: 8,
            ),
          ),

          Expanded(
            child: Table(
              border: TableBorder.all(width: 0.1, color: Colors.black),
              children: [
                TableRow(
                  children: [
                    SizedBox(
                      width: 60,
                      child: tb(
                        value: 'Giờ',
                        bg: Colors.grey.shade200,
                        size: 6,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: tb(
                        value: 'Ngày',
                        bg: Colors.grey.shade200,
                        size: 6,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: tb(
                        value: 'Tháng',
                        bg: Colors.grey.shade200,
                        size: 6,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: tb(
                        value: 'Năm',
                        bg: Colors.grey.shade200,
                        size: 6,
                      ),
                    ),
                  ], // Example data
                ),
                ...List.generate(6, (index) {
                  final gio =
                      (thanSat['gio']?.length ?? -1) > index
                          ? (thanSat['gio']?[index] ?? '')
                          : '';
                  final ngay =
                      (thanSat['ngay']?.length ?? -1) > index
                          ? (thanSat['ngay']?[index] ?? '')
                          : '';
                  final thang =
                      (thanSat['thang']?.length ?? -1) > index
                          ? (thanSat['thang']?[index] ?? '')
                          : '';
                  final nam =
                      (thanSat['nam']?.length ?? -1) > index
                          ? (thanSat['nam']?[index] ?? '')
                          : '';
                  return TableRow(
                    children: [
                      SizedBox(width: 60, child: tb(value: gio, size: 4.2)),
                      SizedBox(width: 60, child: tb(value: ngay, size: 4.2)),
                      SizedBox(width: 60, child: tb(value: thang, size: 4.2)),
                      SizedBox(width: 60, child: tb(value: nam, size: 4.2)),
                    ], // Example data
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
