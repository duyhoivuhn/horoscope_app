import 'package:flutter/material.dart';
import 'package:horoscope_app/bang_dai_van.dart';
import 'package:horoscope_app/data_model.dart';
import 'package:horoscope_app/gen/assets.gen.dart';
import 'package:horoscope_app/utils/AppUtil.dart';
import 'package:horoscope_app/lunar/lunar.dart';
import 'package:horoscope_app/main.dart';
import 'package:horoscope_app/styles.dart';
import 'package:horoscope_app/thiencan.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key, required this.model});
  final DataModel model;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  var text = '';

  Lunar? lunar;
  DateTime? solarDate;

  DateTime? _date; //Ngày Âm Lịch

  @override
  void initState() {
    super.initState();

    solarDate = DateTime(
      widget.model.year ?? 2025,
      widget.model.month ?? 12,
      widget.model.day ?? 25,
      widget.model.hour ?? 23, // Giờ Dương lịch
      widget.model.minute ?? 0, // Phút Dương lịch
      widget.model.second ?? 0, // Giây Dương lịch
    );

    // 2. Tạo đối tượng Lunar từ DateTime
    Lunar lunarDate = Lunar.fromDate(solarDate!);

    _date = DateTime(
      lunarDate.getYear(),
      lunarDate.getMonth(),
      lunarDate.getDay(),
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
    setState(() {
      text = lunar?.toFullString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.transparent),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.imgBackground.provider(),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildContent1(),
                      SizedBox(height: 16),

                      _buidContent3(),
                      SizedBox(height: 16),
                      _buidContent4(),
                      SizedBox(height: 16),
                      _buildContent5(),
                      SizedBox(height: 16),
                      _buildContent7(),

                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          navigator.currentState?.pop();
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: Text(
        'Thông tin thẻ bài',
        style: AppStyle.t20B.apply(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            navigator.currentState?.pushNamedAndRemoveUntil(
              'home_page',
              (route) => true,
            );
          },
          icon: Icon(Icons.add_card, color: Colors.white),
        ),
      ],
    );
  }

  _buildHeader() {
    DateTime solarDate = DateTime(
      widget.model.year ?? 2025,
      widget.model.month ?? 12,
      widget.model.day ?? 25,
    );

    // 2. Tạo đối tượng Lunar từ DateTime
    Lunar lunarDate = Lunar.fromDate(solarDate);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.orangeAccent.withValues(alpha: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.icons.icLogo.image(width: 40, height: 40),

          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HỌ VÀ TÊN: ${widget.model.fullName ?? ''}',
                  style: AppStyle.t14B.apply(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'GIƠI TÍNH: ${widget.model.generate}',
                  style: AppStyle.t14B.apply(color: Colors.white),
                ),

                const SizedBox(height: 4),
                Text(
                  'Dương lịch: ${widget.model.day}/${widget.model.month}/${widget.model.year}',
                  style: AppStyle.t14B.apply(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Âm lịch: ${lunarDate.getDay()}/${lunarDate.getMonth()}/${lunarDate.getYear()}',
                  style: AppStyle.t14B.apply(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContent1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(value: 'Giờ', bg: Colors.orangeAccent),
                tb(value: 'Ngày', bg: Colors.orangeAccent),
                tb(value: 'Tháng', bg: Colors.orangeAccent),
                tb(value: 'Năm', bg: Colors.orangeAccent),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(value: widget.model.hour.toString()),
                tb(value: solarDate?.day.toString() ?? ''),
                tb(value: solarDate?.month.toString() ?? ''),
                tb(value: solarDate?.year.toString() ?? ''),
              ],
            ),
          ),

          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('Xuất Can')),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(value: AppUtil(solarDateTime: solarDate!).getThapThanGio()),
                tb(value: AppUtil(solarDateTime: solarDate!).getThapThanNgay()),
                tb(
                  value: AppUtil(solarDateTime: solarDate!).getThapThanThang(),
                ),
                tb(value: AppUtil(solarDateTime: solarDate!).getThapThanNam()),
              ],
            ),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('Thiên Can')),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('Địa chi')),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiGio()),
                tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiNgay()),
                tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiThang()),
                tb(value: AppUtil(solarDateTime: solarDate!).getDiaChiNam()),
              ],
            ),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('Tàng Can')),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(
                  value:
                      AppUtil(solarDateTime: _date!).getTangCanGio().toString(),
                ),
                tb(
                  value:
                      AppUtil(
                        solarDateTime: _date!,
                      ).getTangCanNgay().toString(),
                ),
                tb(
                  value:
                      AppUtil(
                        solarDateTime: _date!,
                      ).getTangCanThang().toString(),
                ),
                tb(
                  value:
                      AppUtil(solarDateTime: _date!).getTangCanNam().toString(),
                ),
              ],
            ),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('Trường sinh')),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(
                  value: AppUtil(solarDateTime: solarDate!).getTruongSinhGio(),
                ),
                tb(
                  value: AppUtil(solarDateTime: solarDate!).getTruongSinhNgay(),
                ),
                tb(
                  value:
                      AppUtil(solarDateTime: solarDate!).getTruongSinhThang(),
                ),
                tb(
                  value: AppUtil(solarDateTime: solarDate!).getTruongSinhNam(),
                ),
              ],
            ),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('Nạp Âm')),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tb(value: AppUtil(solarDateTime: solarDate!).getNapAmGio()),
                tb(value: AppUtil(solarDateTime: solarDate!).getNapAmNgay()),
                tb(value: AppUtil(solarDateTime: solarDate!).getNapAmThang()),
                tb(value: AppUtil(solarDateTime: solarDate!).getNapAmNam()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tb({
    Color? bg,
    required String value,
    TextStyle? style,
    double? height,
  }) {
    return Expanded(
      child: Container(
        height: height ?? 50,
        decoration: BoxDecoration(
          color: bg ?? Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(value, style: style, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  _buidContent3() {
    Yun? yun;
    if (lunar != null) {
      yun = Yun(EightChar(lunar!), widget.model.generate == 'Nam' ? 1 : 0);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(child: Text('Tiết Khí')),
              ),
              tb(
                value:
                    AppUtil(
                      solarDateTime: solarDate!,
                    ).getTietKhiHienTaiCuaNgay(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(child: Text('Đại Vận')),
              ),
              tb(
                value:
                    AppUtil(solarDateTime: solarDate!)
                        .tinhDaiVan(
                          year: widget.model.year ?? 1995,
                          month: widget.model.month ?? 12,
                          day: widget.model.day ?? 25,
                          hour: widget.model.hour ?? 23,
                          minute: widget.model.minute ?? 0,
                          second: widget.model.second ?? 0,
                          isMale: widget.model.generate == 'Nam' ? true : false,
                        )
                        .toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buidContent4() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('Bành Tổ Bách Kỵ(Can ngày)')),
                ),
                tb(value: lunar?.getPengZuGan() ?? ''),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('Bành Tổ Bách Kỵ(Chi ngày)')),
                ),
                tb(value: lunar?.getPengZuZhi() ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContent5() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                tb(
                  value: 'Phương Hỷ Thần',
                  height: 80,
                  bg: Colors.orangeAccent,
                ),
                tb(
                  value: 'Phương Dương Quý Nhân',
                  height: 80,
                  bg: Colors.orangeAccent,
                ),
                tb(
                  value: 'Phương Âm Quý Nhân',
                  height: 80,
                  bg: Colors.orangeAccent,
                ),
                tb(
                  value: 'Phương Phúc Thần',
                  height: 80,
                  bg: Colors.orangeAccent,
                ),
                tb(
                  value: 'Phương Tài Thần',
                  height: 80,
                  bg: Colors.orangeAccent,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                tb(value: lunar?.getDayPositionXi() ?? ''),
                tb(value: lunar?.getDayPositionYangGui() ?? ''),
                tb(value: lunar?.getDayPositionYinGui() ?? ''),
                tb(value: lunar?.getDayPositionFu() ?? ''),
                tb(value: lunar?.getDayPositionCai() ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContent6() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                tb(value: 'Xung', bg: Colors.orangeAccent),
                tb(value: 'Sát', bg: Colors.orangeAccent),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                tb(value: lunar?.getDayChong() ?? ''),
                tb(value: lunar?.getDaySha() ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContent7() {
    final tuoi = AppUtil(solarDateTime: solarDate!).getTuoiKhoiVan(
      year: widget.model.year ?? 1995,
      month: widget.model.month ?? 12,
      day: widget.model.day ?? 25,
      hour: widget.model.hour ?? 23,
      minute: widget.model.minute ?? 0,
      second: widget.model.second ?? 0,
      isMale: widget.model.generate == 'Nam' ? true : false,
    );
    return DaiVanTable(startDaiVanYear: tuoi);
  }
}
