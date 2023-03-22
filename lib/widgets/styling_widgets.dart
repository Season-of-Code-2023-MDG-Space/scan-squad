import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget customText(String text, double fontSize, FontWeight fontWeight,
    Color? color, EdgeInsets? padding) {
  return Container(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
            color: color ?? Colors.black,
            fontSize: fontSize,
            fontWeight: fontWeight),
      ));
}

Widget titleName(String text, double fontSize, FontWeight fontWeight,
    Color color, String? fontFamily, double letterSpacing) {
  return Text(
    text,
    style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing),
  );
}

Widget bigText(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 36, FontWeight.w700, color, padding);
}

Widget bigText2(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 22, FontWeight.w600, color, padding);
}

Widget bigText3(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 20, FontWeight.w600, color, padding);
}

Widget bigText4(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 20, FontWeight.w400, color, padding);
}

Widget title1(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 18, FontWeight.w700, color, padding);
}

Widget title2(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 16, FontWeight.w600, color, padding);
}

Widget button1(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 16, FontWeight.w600, color, padding);
}

Widget title3(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 16, FontWeight.w500, color, padding);
}

Widget button2(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 14, FontWeight.w600, color, padding);
}

Widget heading1(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 14, FontWeight.w500, color, padding);
}

Widget heading2(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 14, FontWeight.w400, color, padding);
}

Widget heading3(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 14, FontWeight.w300, color, padding);
}

Widget heading4(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 12, FontWeight.w600, color, padding);
}

Widget caption(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 12, FontWeight.w500, color, padding);
}

Widget caption2(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 12, FontWeight.w400, color, padding);
}

Widget caption3(String text, Color? color, EdgeInsets? padding) {
  return customText(text, 10, FontWeight.w400, color, padding);
}

Widget editText(
    {TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    TextInputType? keyboardType,
    int? maxLines = 1,
    void Function()? onEditingComplete,
    void Function(String)? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? requireSuffixIcon}) {
  return TextFormField(
    decoration: InputDecoration(
      suffixIcon: requireSuffixIcon,
      suffixIconColor: Colors.white,
      filled: true,
      fillColor: Color.fromRGBO(0, 172, 184, 0.5),
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      hintText: hintText,
      hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 1.2),
    ),
    focusNode: focusNode,
    keyboardType: keyboardType,
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    maxLines: maxLines,
    style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    onEditingComplete: onEditingComplete,
    onChanged: onChanged,
    textCapitalization: textCapitalization,
  );
}

Widget customTextButton({
  required String labelText,
  required void Function() onPressed,
  Widget? child,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      labelText,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(38, 126, 157, 1)),
    ),
  );
}

Widget flexedTextButton(
    String text, EdgeInsets padding, void Function() onPressed) {
  return Container(
    height: 50.0,
    margin: padding,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      color: Color.fromRGBO(69, 177, 200, 1),
    ),
    child: TextButton(
        style: TextButton.styleFrom(minimumSize: const Size.fromHeight(40)),
        onPressed: onPressed,
        child: title2(
            text, Colors.white, const EdgeInsets.symmetric(vertical: 0))),
  );
}

Widget customIconButton(
    String name, void Function() function, double height, double width) {
  return InkWell(
      onTap: function,
      child: Image.asset(
        name,
        height: height,
        width: width,
        fit: BoxFit.contain,
      ));
}

Widget customSpinLoader(double size) {
  return SpinKitFadingCube(
    color: const Color.fromRGBO(69, 177, 200, 1),
    size: size,
  );
}
