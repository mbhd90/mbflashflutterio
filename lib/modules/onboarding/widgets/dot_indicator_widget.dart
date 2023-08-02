import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class DotIndicatiorWidget extends StatelessWidget {
  const DotIndicatiorWidget({
    Key? key,
    required this.currentIndex,
    required this.dotNumber,
  }) : super(key: key);

  final int currentIndex;
  final int dotNumber;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < dotNumber; i++) {
      list.add(_singleDot(i == currentIndex));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget _singleDot(bool isActive) {
    return AnimatedContainer(
      duration: kDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: isActive
            ? lightningYellowColor
            : lightningYellowColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
