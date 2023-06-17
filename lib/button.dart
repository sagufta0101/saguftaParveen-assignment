import 'package:flutter/material.dart';
import 'package:vivatech/colors.dart';

class MyButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? sizeHieght;
  final double? sizeWidth;
  final double? fontSize;
  final double? borderRadius;
  final double? elevation;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;

  const MyButton({
    this.title,
    this.color,
    this.onTap,
    this.sizeHieght,
    this.sizeWidth,
    this.fontSize,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.textColor,
    this.fontWeight,
    this.padding,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 0,
        disabledBackgroundColor: color ?? primaryColor,
        enableFeedback: false,
        backgroundColor: color ?? primaryColor,
        padding: padding,
        maximumSize: Size(
          sizeWidth ?? MediaQuery.of(context).size.width,
          sizeHieght ?? 45,
        ),
        minimumSize: Size(
          sizeWidth ?? MediaQuery.of(context).size.width,
          sizeHieght ?? 45,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
          side: BorderSide(
            color: borderColor ?? color ?? Colors.transparent,
            width: borderWidth ?? 1,
          ),
        ),
        fixedSize: Size(
          sizeWidth ?? MediaQuery.of(context).size.width,
          sizeHieght ?? 45,
        ),
      ),
      onPressed: onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "$title",
          style: TextStyle(
            fontSize: fontSize ?? 16,
            color: color != null ? textColor ?? Colors.white : Colors.white,
            fontFamily: "Poppins",
            fontWeight: fontWeight ?? FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
