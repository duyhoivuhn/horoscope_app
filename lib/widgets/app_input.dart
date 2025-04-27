import 'package:flutter/material.dart';
import 'package:horoscope_app/styles.dart';

class AppInput extends StatelessWidget {
  const AppInput({super.key, this.title, this.value, this.icon});

  final String? title;
  final String? value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? '', style: AppStyle.t16B.apply(color: Colors.white)),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 48,
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            value ?? '',
            style: AppStyle.t20B.apply(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
