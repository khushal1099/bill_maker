import 'package:flutter/material.dart';
import 'package:invoice_generator/Utils/SizeUtil.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? style;
  final String? hintText;
  final double? width;
  final String? title;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final void Function()? onTap;
  final bool isEnable;

  const AppTextFormField({
    super.key,
    this.controller,
    this.style,
    this.hintText,
    this.width,
    this.title,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        title != null ? title!.titleText() : SizedBox(),
        25.width,
        TextFormField(
          controller: controller,
          style: style,
          enabled: isEnable,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            hintText: hintText,
            constraints:
                BoxConstraints(maxHeight: 30, maxWidth: (width ?? 100)),
            fillColor: Colors.white,
            filled: true,
            contentPadding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            suffixIcon: suffixIcon,
          ),
          onTap: onTap,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
