// ignore_for_file: deprecated_member_use

import 'package:edge_swipe/enums/swipe_direction.dart';
import 'package:edge_swipe/src/middle_arc_line_painter.dart';
import 'package:edge_swipe/src/midle_button.dart';
import 'package:flutter/material.dart';

class EdgeSwipe extends StatefulWidget {
  final Widget child;

  /// Callback function when the left swipe is invoked.
  final Function? onSwipeLeft;

  /// Callback function when the right swipe is invoked.
  final Function? onSwipeRight;

  /// Color for the curved line.
  final Color? curvedLineColor;

  /// Shadow color for the curved line.
  final Color? curvedLineShadowColor;

  /// Minimum 0, maximum 1
  /// The percentage of curve amount to invoke the swipe action.
  /// Default is 0.3, meaning the swipe action will be invoked when the curve amount reaches 30%.
  final double percentToInvoke;

  /// The height of the curve as a percentage of the screen height.
  /// Default is 30.0, meaning the curve height will be 30% of the screen height.
  /// This value should be between 0 and 100.
  /// If the value is less than 0 or greater than 100, it will default to 30.0.
  final double curveHeightPercent;

  /// A builder function to create a widget that appears at the edge during the swipe.
  /// The function receives the current context and a boolean indicating if the swipe action has been invoked.
  final Widget Function(BuildContext context, bool onSwipeInvoked)?
      edgeChildBuilder;
  const EdgeSwipe({
    Key? key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.edgeChildBuilder,
    this.percentToInvoke = .3,
    this.curveHeightPercent = 30.0,
    this.curvedLineColor,
    this.curvedLineShadowColor,
  }) : super(key: key);

  @override
  State<EdgeSwipe> createState() => _CurvedLineExampleState();
}

class _CurvedLineExampleState extends State<EdgeSwipe> {
  double minimumCurveAmountPercent = 10; // Giới hạn độ cong tối thiểu
  double curveAmountPercent = 0;
  double arcCenterPercent = 50; // Vị trí đỉnh cong theo Y (0 - 100)
  double curveHeightPercent = 30; // Chiều cao đoạn cong (0 - 100)
  double maxCurveRatio = 1 / 3; // Tối đa cong bao nhiêu phần chiều rộng
  SwipeDirection? swipeDirection;
  ChildrenSwipeDirection childrenSwipeDirection =
      ChildrenSwipeDirection.leftToRight; // Hướng của widget con
  double percentToInvoke = 30; // Tỷ lệ cong để kích hoạt hành động
  double blurSigma = 10; // Độ mờ của bóng

  @override
  void initState() {
    percentToInvoke = widget.percentToInvoke * 100; // Chuyển đổi sang phần trăm
    if (percentToInvoke < 0 || percentToInvoke > 100) {
      percentToInvoke = 30; // Giới hạn từ 0 đến 100
    }

    curveHeightPercent = widget.curveHeightPercent; // Chiều cao đoạn cong
    if (curveHeightPercent < 0 || curveHeightPercent > 100) {
      curveHeightPercent = 30; // Giới hạn từ 0 đến 100
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = 450;

          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (details) {
              // Xác định hướng kéo
              if (swipeDirection == null) {
                if (details.delta.dx < 0) {
                  if (widget.onSwipeRight != null) {
                    swipeDirection = SwipeDirection.rightToLeft;
                    childrenSwipeDirection = ChildrenSwipeDirection
                        .rightToLeft; // Hướng của widget con
                  }
                } else {
                  if (widget.onSwipeLeft != null) {
                    swipeDirection = SwipeDirection.leftToRight;
                    childrenSwipeDirection = ChildrenSwipeDirection
                        .leftToRight; // Hướng của widget con
                  }
                }
              }

              // Cập nhật độ cong khi người dùng kéo
              double newCurveAmount = curveAmountPercent +
                  (swipeDirection == SwipeDirection.leftToRight
                          ? details.delta.dx
                          : -details.delta.dx) /
                      width *
                      100;
              curveAmountPercent =
                  newCurveAmount.clamp(0, 100); // Giới hạn từ 0 đến 100
              arcCenterPercent =
                  (details.localPosition.dy / constraints.maxHeight * 100)
                      .clamp(0, 100);
              if (mounted == false) return;
              setState(() {});
            },
            onPointerUp: (details) async {
              // Xử lý khi người dùng kết thúc kéo
              if (curveAmountPercent >= percentToInvoke) {
                if (widget.onSwipeLeft != null || widget.onSwipeRight != null) {
                  if (swipeDirection == SwipeDirection.leftToRight) {
                    widget.onSwipeLeft?.call();
                  }
                  if (swipeDirection == SwipeDirection.rightToLeft) {
                    widget.onSwipeRight?.call();
                  }
                }
              }

              swipeDirection = null; // Reset hướng kéo khi kết thúc

              // arcCenterPercent = 50; // Reset vị trí đỉnh cong về giữa
              for (int i = 0; i < 10; i++) {
                // Giảm dần độ cong về 0 khi kết thúc kéo
                if (mounted == false) return;
                setState(() {
                  curveAmountPercent -= 10;
                  if (curveAmountPercent < 0) {
                    curveAmountPercent = 0;
                  }
                });
                await Future.delayed(const Duration(
                    milliseconds: 20)); // Delay để thấy hiệu ứng giảm dần
              }
            },
            onPointerDown: (details) {
              // Reset độ cong khi bắt đầu kéo
              curveAmountPercent = 0; // Giới hạn ban đầu
              arcCenterPercent = 50; // Reset vị trí đỉnh cong về giữa
              if (mounted == false) return;
              setState(() {});
            }, // Giới hạn ban đầu
            child: Stack(
              children: [
                widget.child, // Hiển thị widget con
                swipeDirection == null ||
                        curveAmountPercent <= minimumCurveAmountPercent
                    ? const SizedBox.shrink()
                    : Positioned.fill(
                        top: 0,
                        left: swipeDirection == SwipeDirection.leftToRight
                            ? 0
                            : null,
                        right: swipeDirection == SwipeDirection.rightToLeft
                            ? 0
                            : null,
                        child: Transform.rotate(
                          angle: swipeDirection == SwipeDirection.leftToRight
                              ? 0
                              : 3.14, // Xoay 180 độ nếu kéo từ phải sang trái
                          child: CustomPaint(
                            painter: MiddleArcLinePainter(
                              color: widget.curvedLineColor ??
                                  Theme.of(context).primaryColor,
                              shadowColor: widget.curvedLineShadowColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.2),
                              blurSigma: blurSigma,
                              curveAmountPercent: curveAmountPercent, // độ cong
                              curveHeightPercent:
                                  curveHeightPercent, // chiều cao đoạn cong
                              arcCenterPercent: arcCenterPercent,
                              maxCurveRatio:
                                  maxCurveRatio, // tối đa 1/3 chiều rộng màn hình
                              screenWidth: width,
                              swipeDirection: swipeDirection!,
                            ),
                            child:
                                curveAmountPercent > minimumCurveAmountPercent
                                    ? Container(
                                        color: Colors.transparent,
                                      )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                curveAmountPercent > minimumCurveAmountPercent &&
                        swipeDirection != null
                    ? Positioned(
                        top: arcCenterPercent *
                            constraints.maxHeight *
                            .95 /
                            100, // vị trí widget của bạn
                        left: swipeDirection == SwipeDirection.leftToRight
                            ? (childrenSwipeDirection ==
                                    ChildrenSwipeDirection.rightToLeft
                                ? -(curveAmountPercent * width * .05 / 100)
                                : (curveAmountPercent * width * .1125 / 100))
                            : null, // vị trí widget của bạn
                        right: swipeDirection == SwipeDirection.rightToLeft
                            ? -(childrenSwipeDirection ==
                                    ChildrenSwipeDirection.rightToLeft
                                ? -(curveAmountPercent * width * .05 / 100)
                                : (curveAmountPercent * width * .1125 / 100))
                            : null,
                        child: widget.edgeChildBuilder != null
                            ? widget.edgeChildBuilder!(
                                context,
                                curveAmountPercent >= percentToInvoke,
                              )
                            : Transform.rotate(
                                angle: swipeDirection ==
                                        SwipeDirection.leftToRight
                                    ? 0
                                    : 3.14, // Xoay 180 độ nếu kéo từ phải sang trái
                                child: MidleButton(
                                  curveAmountPercent: curveAmountPercent,
                                  percentToInvoke: percentToInvoke,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                                  shadowColor: Colors.black.withOpacity(0.2),
                                  iconColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                      )
                    : const SizedBox.shrink(), // Hiển thị widget khi có độ cong
              ],
            ),
          );
        },
      ),
    );
  }
}
