import 'package:flutter/cupertino.dart';

class TextStyleUtils {
  static double getFixedFontSize(BuildContext context, double? fontSize,
      {bool isFixedFontSize = true, bool isInTextSpanOfRichText = false}) {
    fontSize = fontSize ?? 13.0;
    if (!isFixedFontSize) {
      return fontSize;
    }
    try {
      MediaQueryData mediaQuery = MediaQuery.of(context);
      double fontSizeTemp = isInTextSpanOfRichText
          ? (fontSize * (mediaQuery.size.width / 375))
          : (fontSize * (mediaQuery.size.width / 375) / mediaQuery.textScaleFactor); //375是效果图的宽度分辨率
      if (fontSizeTemp <= 0) {
        return fontSize;
      }
      return fontSizeTemp;
    } catch (e) {
      return fontSize;
    }
  }
}