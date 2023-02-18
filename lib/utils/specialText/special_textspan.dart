import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/utils/specialText/view_img_text.dart';

import 'at_text.dart';
import 'emoji_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  /// whether show background for @somebody
  final bool showAtBackground;
  final BuildContext context;
  MySpecialTextSpanBuilder({required this.context,this.showAtBackground: false});

  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, required int index}) {
    if (flag == "") return null;

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, AtText.flag)) {
      return AtText(
        textStyle!,
        onTap!,
        start: index - (AtText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle!, start: index - (EmojiText.flag.length - 1));
    }else if (isStart(flag, ViewImgText.flag)) {
      return ViewImgText(
          textStyle!,
          onTap!,
          color:Theme.of(context).primaryColor,
          start: index - (ViewImgText.flag.length - 1)
      );
    }
    return null;
  }

}