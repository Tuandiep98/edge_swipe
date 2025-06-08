// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MidleButton extends StatelessWidget {
  final double curveAmountPercent;
  final Color color;
  final Color shadowColor;
  final Color iconColor;
  final double iconSize;
  final double buttonSize;
  final double percentToInvoke;

  const MidleButton({
    Key? key,
    this.curveAmountPercent = 0,
    this.color = Colors.white,
    this.shadowColor = Colors.black,
    this.iconColor = Colors.grey,
    this.iconSize = 45,
    this.buttonSize = 50,
    this.percentToInvoke = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonSize + 5,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: curveAmountPercent >= percentToInvoke
              ? buttonSize + 15
              : buttonSize,
          height: curveAmountPercent >= percentToInvoke
              ? buttonSize + 15
              : buttonSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 7,
                spreadRadius: .1,
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Icon(
                Icons.chevron_left_rounded,
                color: curveAmountPercent >= percentToInvoke
                    ? iconColor
                    : iconColor.withOpacity(0.2),
                size: curveAmountPercent >= percentToInvoke
                    ? (iconSize + 5)
                    : iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
