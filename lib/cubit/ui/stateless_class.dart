import 'package:flutter/widgets.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextStyle style;

  MyText(this.text, this.style);

  @override
  Widget build(BuildContext context) {


    return Text(
      text,
      style: style,
    );
  }
}