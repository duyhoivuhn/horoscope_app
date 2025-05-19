import 'dart:math';
import 'package:flutter/material.dart';
import 'package:horoscope_app/data_model.dart';
import 'package:horoscope_app/gen/assets.gen.dart';
import 'package:horoscope_app/pdf_preview.dart';
import 'package:horoscope_app/picker_util.dart';
import 'package:horoscope_app/styles.dart';
import 'package:horoscope_app/ticket_page.dart';
import 'package:horoscope_app/widgets/app_input.dart';
// import 'package:horoscope_app/widgets/tutru.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;
  var dataModel = DataModel();
  final enableButtonNoti = ValueNotifier(false);
  final generateNoti = ValueNotifier('');

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: 0.9,
                  child: Assets.images.imgBackground.image(
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildAppBar(),
                  _buildInput(context),
                  const SizedBox(height: 24),
                  _builInputDate(),
                  SizedBox(height: 24),
                  _buildGenerate(),

                  SizedBox(height: 60),

                  _buildButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar() {
    return SafeArea(
      child: Row(
        children: [
          Hero(
            tag: 'appLogo',
            child: Assets.icons.icLogo.image(width: 50, height: 50),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Thông tin cá nhân',
              style: AppStyle.t26B.apply(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền trắng cho Container
        borderRadius: BorderRadius.circular(12.0), // Bo góc cho Container
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2), // Màu bóng đổ
            spreadRadius: 1, // Độ lan rộng của bóng
            blurRadius: 5, // Độ mờ của bóng
            offset: const Offset(0, 3), // Vị trí đổ bóng (x, y) - đổ xuống dưới
          ),
        ],
      ),
      child: TextField(
        controller: _nameController,
        textAlign: TextAlign.center,
        style: AppStyle.t20B.apply(color: Colors.black),
        onChanged: (value) {
          enableButtonNoti.value =
              _nameController.text.isNotEmpty && _selectedDate != null;
        },

        decoration: InputDecoration(
          hintText: 'Họ & Tên', // Hint text

          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 12.0,
          ),
          border: OutlineInputBorder(
            // Border mặc định (và khi không focus)
            borderRadius: BorderRadius.circular(
              12.0,
            ), // Bo góc phải khớp với Container
            borderSide: BorderSide(
              // Style cho đường viền
              color: Colors.grey[400]!, // Màu viền xám nhạt
              width: 1.0, // Độ dày viền
            ),
          ),
          enabledBorder: OutlineInputBorder(
            // Border khi TextField enable (trạng thái thường)
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            // Border khi TextField được focus (đang nhập)
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color:
                  Theme.of(
                    context,
                  ).primaryColor, // Màu viền khi focus (thường là màu chính của app)
              width: 1.5, // Làm viền dày hơn một chút khi focus
            ),
          ),
          // Có thể thêm các border khác như errorBorder nếu cần xử lý lỗi validation
        ),
        cursorColor: Theme.of(context).primaryColor, // Màu con trỏ nhập liệu
      ),
    );
  }

  _builInputDate() {
    String? birthdate;
    if (_selectedDate != null) {
      birthdate = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      dataModel.year = _selectedDate?.year;
      dataModel.month = _selectedDate?.month;
      dataModel.day = _selectedDate?.day;
    }
    return InkWell(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              PickerUtil.selectDate(
                context: context,
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    enableButtonNoti.value =
                        _nameController.text.isNotEmpty &&
                        _selectedDate != null;
                  });
                },
              );
            },
            child: AppInput(title: 'Ngày sinh', value: birthdate),
          ),

          SizedBox(height: 24),

          InkWell(
            onTap: () {
              PickerUtil.selectTime(
                context: context,
                initialHour: dataModel.hour,
                initialMinute: dataModel.minute,
                initialSecond: dataModel.second,
                onTimeSelected: (h, m, s) {
                  dataModel.hour = h;
                  dataModel.minute = m;
                  dataModel.second = s;
                  setState(() {
                    enableButtonNoti.value =
                        _nameController.text.isNotEmpty &&
                        _selectedDate != null;
                  });
                },
              );
            },
            child: AppInput(
              title: 'Giờ sinh',
              value:
                  dataModel.hour == null
                      ? ''
                      : 'Giờ ${dataModel.hour} phút ${dataModel.minute} giây ${dataModel.second}',
            ),
          ),
        ],
      ),
    );
  }

  _buildButton() {
    return ValueListenableBuilder(
      valueListenable: enableButtonNoti,
      builder: (context, value, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                enableButtonNoti.value ? Colors.amber : Colors.grey,
            fixedSize: Size(250, 48),
          ),
          onPressed: () {
            if (!enableButtonNoti.value) {
              return;
            }
            dataModel.fullName = _nameController.text;
            dataModel.generate = generateNoti.value;
            Navigator.push(
              context,
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) {
                  // return PdfPreviewScreen(model: dataModel);
                  return TicketPage(
                    model: dataModel,
                  ); // Trả về trang bạn muốn đến
                },
                transitionDuration: const Duration(
                  milliseconds: 700,
                ), // Tăng thời gian để thấy rõ hiệu ứng lật
                reverseTransitionDuration: const Duration(milliseconds: 700),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut, // Curve làm hiệu ứng mượt hơn
                    reverseCurve: Curves.easeInOut.flipped,
                  );

                  final rotateAnimation = Tween<double>(
                    begin: pi / 2,
                    end: 0.0,
                  ).animate(curvedAnimation);
                  return Transform(
                    transform:
                        Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(rotateAnimation.value),
                    alignment: Alignment.center,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text('Xem thẻ bài', style: AppStyle.t16B),
        );
      },
    );
  }

  _buildGenerate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giới tính', style: AppStyle.t16B.apply(color: Colors.white)),
        ValueListenableBuilder(
          valueListenable: generateNoti,
          builder: (context, value, child) {
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    if (generateNoti.value == '') {
                      generateNoti.value = 'Nam';
                      return;
                    }
                    if (generateNoti.value == 'Nữ') {
                      generateNoti.value = 'Nam';
                    } else {
                      generateNoti.value = 'Nữ';
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: generateNoti.value == 'Nam',
                        onChanged: (value) {
                          if (generateNoti.value == '') {
                            generateNoti.value = 'Nam';
                            return;
                          }
                          if (generateNoti.value == 'Nữ') {
                            generateNoti.value = 'Nam';
                          } else {
                            generateNoti.value = 'Nữ';
                          }
                        },
                      ),
                      Text(
                        'Nam',
                        style: AppStyle.t16B.apply(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    if (generateNoti.value == '') {
                      generateNoti.value = 'Nữ';
                      return;
                    }
                    if (generateNoti.value == 'Nữ') {
                      generateNoti.value = 'Nam';
                    } else {
                      generateNoti.value = 'Nữ';
                    }
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: generateNoti.value == 'Nữ',
                        onChanged: (value) {
                          if (generateNoti.value == '') {
                            generateNoti.value = 'Nữ';
                            return;
                          }
                          if (generateNoti.value == 'Nữ') {
                            generateNoti.value = 'Nam';
                          } else {
                            generateNoti.value = 'Nữ';
                          }
                        },
                      ),
                      Text(
                        'Nữ',
                        style: AppStyle.t16B.apply(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
