
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///emoji/image text
class EmojiText extends SpecialText {
  static const String flag = "[";
  final int start;
  EmojiText(TextStyle textStyle, {required this.start})
      : super(EmojiText.flag, "]", textStyle);

  @override
  InlineSpan finishText() {
    var key = toString();

    ///https://github.com/flutter/flutter/issues/42086
    /// widget span is not working on web
    if (EmoticonUtils.emoticonMap.containsKey(key) && !kIsWeb) {
      //fontsize id define image height
      //size = 30.0/26.0 * fontSize
      const double size = 20.0;

      ///fontSize 26 and text height =30.0
      //final double fontSize = 26.0;
      return ImageSpan(
          AssetImage(
            EmoticonUtils.emoticonMap[key]!,
          ),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start,
          fit: BoxFit.fill,
          margin: const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmoticonUtils {
  static const String _emoticonFilePath = 'assets/img/emotionIcons';
  static final Map<String, String> emoticonMap = {
    '[微笑2]': '$_emoticonFilePath/weixiao2.png',
    '[撇嘴1]': '$_emoticonFilePath/piezui1.png',
    '[色4]': '$_emoticonFilePath/se4.png',
    '[发呆2]': '$_emoticonFilePath/fadai2.png',
    '[得意1]': '$_emoticonFilePath/deyi1.png',
    '[流泪2]': '$_emoticonFilePath/liulei2.png',
    '[害羞5]': '$_emoticonFilePath/haixiu5.png',
    '[闭嘴1]': '$_emoticonFilePath/bizui1.png',
    '[睡]': '$_emoticonFilePath/shui.png',
    '[大哭7]': '$_emoticonFilePath/daku7.png',
    '[尴尬1]': '$_emoticonFilePath/ganga1.png',
    '[发怒]': '$_emoticonFilePath/fanu.png',
    '[调皮1]': '$_emoticonFilePath/tiaopi1.png',
    '[呲牙]': '$_emoticonFilePath/ciya.png',
    '[惊讶4]': '$_emoticonFilePath/jingya4.png',
    '[难过]': '$_emoticonFilePath/nanguo.png',
    '[酷]': '$_emoticonFilePath/ku.png',
    '[冷汗]': '$_emoticonFilePath/lenghan.png',
    '[抓狂]': '$_emoticonFilePath/zhuakuang.png',
    '[吐]': '$_emoticonFilePath/tu.png',
    '[偷笑2]': '$_emoticonFilePath/touxiao2.png',
    '[可爱1]': '$_emoticonFilePath/keai1.png',
    '[白眼1]': '$_emoticonFilePath/baiyan1.png',
    '[傲慢]': '$_emoticonFilePath/aoman.png',
    '[饥饿2]': '$_emoticonFilePath/jie2.png',
    '[困]': '$_emoticonFilePath/kun.png',
    '[惊恐1]': '$_emoticonFilePath/jingkong1.png',
    '[流汗2]': '$_emoticonFilePath/liuhan2.png',
    '[憨笑]': '$_emoticonFilePath/hanxiao.png',
    '[大兵]': '$_emoticonFilePath/dabing.png',
    // 奋斗1
    '[咒骂]': '$_emoticonFilePath/zhouma.png',
    '[疑问2]': '$_emoticonFilePath/yiwen2.png',
    '[嘘]': '$_emoticonFilePath/xu.png',
    '[晕3]': '$_emoticonFilePath/yun3.png',
    '[折磨1]': '$_emoticonFilePath/zhemo1.png',
    '[衰1]': '$_emoticonFilePath/shuai1.png',
    '[骷髅]': '$_emoticonFilePath/kulou.png',
    // 敲打
    '[再见]': '$_emoticonFilePath/zaijian.png',
    // 擦汗
    // 抠鼻
    '[鼓掌1]': '$_emoticonFilePath/guzhang1.png',
    '[糗大了]': '$_emoticonFilePath/qiudale.png',
    '[坏笑1]': '$_emoticonFilePath/huaixiao1.png',
    // 左哼哼
    // 右哼哼
    '[哈欠]': '$_emoticonFilePath/haqian.png',
    '[鄙视2]': '$_emoticonFilePath/bishi2.png',
    '[委屈1]': '$_emoticonFilePath/weiqu1.png',
    '[快哭了]': '$_emoticonFilePath/kuaikule.png',
    '[阴险]': '$_emoticonFilePath/yinxian.png',
    '[亲亲]': '$_emoticonFilePath/qinqin.png',
    '[吓]': '$_emoticonFilePath/xia.png',
    '[可怜2]': '$_emoticonFilePath/kelian2.png',
    '[菜刀]': '$_emoticonFilePath/caidao.png',
    '[西瓜]': '$_emoticonFilePath/xigua.png',
    '[啤酒]': '$_emoticonFilePath/pijiu.png',
    '[篮球]': '$_emoticonFilePath/lanqiu.png',
    '[乒乓]': '$_emoticonFilePath/pingpang.png',
    '[咖啡]': '$_emoticonFilePath/kafei.png',
    '[饭]': '$_emoticonFilePath/fan.png',
    '[猪头]': '$_emoticonFilePath/zhutou.png',
    '[玫瑰]': '$_emoticonFilePath/meigui.png',
    '[凋谢]': '$_emoticonFilePath/diaoxie.png',
    '[示爱]': '$_emoticonFilePath/shiai.png',
    '[爱心]': '$_emoticonFilePath/aixin.png',
    '[心碎]': '$_emoticonFilePath/xinsui.png',
    '[蛋糕]': '$_emoticonFilePath/dangao.png',
    '[闪电]': '$_emoticonFilePath/shandian.png',
    '[炸弹]': '$_emoticonFilePath/zhadan.png',
    '[刀]': '$_emoticonFilePath/dao.png',
    '[足球]': '$_emoticonFilePath/zuqiu.png',
    '[瓢虫]': '$_emoticonFilePath/piaochong.png',
    '[便便]': '$_emoticonFilePath/bianbian.png',
    '[月亮]': '$_emoticonFilePath/yueliang.png',
    '[太阳]': '$_emoticonFilePath/taiyang.png',
    '[礼物]': '$_emoticonFilePath/liwu.png',
    '[拥抱]': '$_emoticonFilePath/yongbao.png',
    '[强]': '$_emoticonFilePath/qiang.png',
    '[弱]': '$_emoticonFilePath/ruo.png',
    '[握手]': '$_emoticonFilePath/woshou.png',
    '[胜利]': '$_emoticonFilePath/shengli.png',
    '[抱拳]': '$_emoticonFilePath/baoquan.png',
    // 勾引
    '[拳头]': '$_emoticonFilePath/quantou.png',
    '[差劲]': '$_emoticonFilePath/chajin.png',
    '[爱你]': '$_emoticonFilePath/aini.png',
    '[NO]': '$_emoticonFilePath/NO.png',
    '[OK]': '$_emoticonFilePath/OK.png',
    '[爱情]': '$_emoticonFilePath/aiqing.png',
    '[飞吻1]': '$_emoticonFilePath/feiwen1.png',
    // 跳跳
    // 发抖
    '[怄火]': '$_emoticonFilePath/ouhuo.png',
    '[转圈]': '$_emoticonFilePath/zhuanquan.png',
    '[磕头]': '$_emoticonFilePath/ketou.png',
    // 回头
    // 跳绳
    '[挥手]': '$_emoticonFilePath/zaijian.png',
    '[激动3]': '$_emoticonFilePath/jidong3.png',
    '[街舞]': '$_emoticonFilePath/jiewu.png',
    // 献舞
    // 左太极
    // 右太极
  };
}
class EmotionPad extends StatelessWidget {
  final bool active;
  final double height;
  final TextEditingController controller;

  const EmotionPad({
    Key? key,
    required this.active,
    required this.height,
    required this.controller,
  }) : super(key: key);

  static double get emoticonPadDefaultHeight => ScreenUtil().setHeight(260.0);

  void insertText(String text) {
    final value = controller.value;
    final start = value.selection.baseOffset;
    final end = value.selection.extentOffset;

    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
      }
      controller.value = value.copyWith(
        text: newText,
        selection: value.selection.copyWith(
          baseOffset: end + text.length,
          extentOffset: end + text.length,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = height;
    return Offstage(
      offstage: !active,
      child: Container(
        width: double.infinity,
        height: active ? _height : 0.0,
        color: Theme.of(context).canvasColor,
        child: GridView.builder(
              padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(ScreenUtil().setWidth(6.0)),
                child: IconButton(
                  icon: Image.asset(
                    EmoticonUtils.emoticonMap.values.elementAt(index),
                    fit: BoxFit.contain,
                  ),
                  onPressed: () {
                    insertText(EmoticonUtils.emoticonMap.keys.elementAt(index));
                  },
                ),
              ),
              itemCount: EmoticonUtils.emoticonMap.values.length,
            ),

      ),
    );
  }
}