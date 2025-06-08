import 'package:edge_swipe/enums/swipe_direction.dart';
import 'package:flutter/material.dart';

class MiddleArcLinePainter extends CustomPainter {
  final double curveAmountPercent; // Độ cong (0 - 100)
  final double curveHeightPercent; // Chiều cao đoạn cong (0 - 100)
  final double arcCenterPercent; // Vị trí đỉnh cong theo Y (0 - 100)
  final double maxCurveRatio; // Tối đa cong bao nhiêu phần chiều rộng
  final double screenWidth;
  final Color color;
  final Color shadowColor;
  final bool blur;
  final double blurSigma;
  final SwipeDirection swipeDirection;

  MiddleArcLinePainter({
    required this.curveAmountPercent,
    required this.curveHeightPercent,
    required this.arcCenterPercent,
    required this.maxCurveRatio,
    required this.screenWidth,
    required this.color,
    required this.shadowColor,
    this.blur = true,
    this.blurSigma = 10,
    this.swipeDirection = SwipeDirection.leftToRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double startX = -80;
    const double topY = -80;
    final double bottomY = size.height + 100;

    // Tính chiều cao đoạn cong
    final double arcHeight =
        ((bottomY - topY) * (curveHeightPercent.clamp(0, 100) / 100))
            .clamp(10, bottomY - topY);

    // Tính độ cong theo tỉ lệ tối đa (1/3 chiều rộng màn hình)
    final double maxCurve = screenWidth * maxCurveRatio;
    final double arcRadius =
        (curveAmountPercent.clamp(0, 100) / 100) * maxCurve;

    // Tính vị trí của đoạn cong theo arcCenterPercent
    final double availableHeight = bottomY - topY - arcHeight;
    double arcTop =
        topY + (arcCenterPercent.clamp(0, 100) / 100) * availableHeight;
    double arcBottom = arcTop + arcHeight;
    if (swipeDirection == SwipeDirection.rightToLeft) {
      // Đảo ngược vị trí cong nếu kéo từ phải sang trái
      arcTop =
          bottomY - (arcCenterPercent.clamp(0, 100) / 100) * availableHeight;
      arcBottom = arcTop - arcHeight;
    }

    // ===== Vẽ bóng trước =====
    final Path path = Path();
    path.moveTo(startX, topY);
    path.lineTo(startX, arcTop);
    path.quadraticBezierTo(
      startX + arcRadius,
      (arcTop + arcBottom) / 2,
      startX,
      arcBottom,
    );
    path.lineTo(startX, bottomY);

    // Shadow path
    final Path shadowPath = path.shift(const Offset(22, 0));
    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = blur ? MaskFilter.blur(BlurStyle.outer, blurSigma) : null
      ..style = PaintingStyle.stroke
      ..strokeWidth = 110;

    canvas.drawPath(shadowPath, shadowPaint);

    // ===== Vẽ đường chính =====
    final Paint mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 155;

    canvas.drawPath(path, mainPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
