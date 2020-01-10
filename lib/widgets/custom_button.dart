import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    this.label,
    this.onPressed,
    this.borderRadius,
    this.height,
    this.width,
    this.fontSize,
  });

  @required final String label;
  final Function onPressed;
  final double height;
  final double width;
  final double borderRadius;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius == null ? 30 : borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(190, 46, 221,1.0),
              Color.fromRGBO(83, 82, 237,1.0),
            ]
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: width,
        height: height,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize == null ? 20 : fontSize
            ),
          ),
        ),
      ),
    );
  }
}