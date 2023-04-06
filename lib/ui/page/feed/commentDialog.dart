import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:plant_disease_identification_app/utils/logger.dart';

import '../../../config/my_icon.dart';
import '../../../net/BaseBean.dart';
import '../../../net/NetRequester.dart';
import '../../../net/UploadUtils.dart';
import '../../../state/global.dart';
import '../../../utils/specialText/emoji_text.dart';
import '../../../utils/specialText/special_textspan.dart';
import '../../../utils/toast.dart';

class CommentDialog extends StatefulWidget {
  int? postId;
  int? commentId;
  String? beReplyName;
  final LoadingMoreBase list;

   CommentDialog(
      {Key? key,
        this.postId,
        this.commentId,
      required this.list,
        this.beReplyName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _textController = TextEditingController();

  //键盘高度
  late double _keyboardHeight;

  //表情
  late bool _showEmoji;
  final FocusNode _focusNode = FocusNode();
  List<Asset> images = <Asset>[];

  @override
  void initState() {
    _showEmoji = false;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.unfocus();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight > 0) {
      _keyboardHeight = keyboardHeight;
      _showEmoji = false;
    }else{
      _keyboardHeight = keyboardHeight;
      _showEmoji = true;
    }
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                Navigator.pop(context);
              },
            ),
          ),
          _buildTextFiled(),
          _inputBar(),
        ],
      ),
    );
  }

  _inputBar() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        height: ScreenUtil().setHeight(110),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil().setWidth(160),
                  child: TextButton(
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                    ),
                    onPressed: () {
                    },
                    child: Icon(
                      _showEmoji ? FontAwesomeIcons.keyboard : MyIcons.smile,
                      color: const Color(0xff757575),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(160),
                  child: TextButton(
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                    ),
                    onPressed: loadAssets,
                    child: const Icon(MyIcons.image, color: Color(0xff757575)),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: ScreenUtil().setWidth(170),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                ),
                onPressed: () {
                  _sendHandler();
                },
                child: const Icon(MyIcons.send, color: Color(0xff757575)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeRow() {
    _textController.text += '\n';
  }

  _buildTextFiled() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(ScreenUtil().setWidth(39)),
        topRight: Radius.circular(ScreenUtil().setWidth(39)),
      )),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(42),
            vertical: ScreenUtil().setHeight(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('发表评论', style: TextStyle(color: Colors.grey)),
            const Divider(color: Colors.grey),
            ExtendedTextField(
              specialTextSpanBuilder:
                  MySpecialTextSpanBuilder(context: context),
              focusNode: _focusNode,
              controller: _textController,
              autofocus: true,
              style: TextStyle(fontSize: ScreenUtil().setSp(46)),
              keyboardType: TextInputType.multiline,
              onEditingComplete: _changeRow,
              maxLines: 5,
              decoration: const InputDecoration.collapsed(hintText: "说点啥(❁´◡`❁)"),
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    final currentColorValue =
        '#${Theme.of(context).primaryColor.value.toRadixString(16).substring(2, 8)}';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: currentColorValue,
          takePhotoIcon: 'chat',
        ),
        materialOptions: MaterialOptions(
          statusBarColor: currentColorValue,
          actionBarColor: currentColorValue,
          actionBarTitle: "选取图片",
          allViewTitle: "所有图片",
          selectCircleStrokeColor: currentColorValue,
          selectionLimitReachedText: '已达到最大张数限制',
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  _buildImage() {
    if (images.isNotEmpty) {
      return Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().setWidth(365)),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          mainAxisSpacing: ScreenUtil().setWidth(18),
          crossAxisSpacing: ScreenUtil().setWidth(18),
          crossAxisCount: 3,
          children: <Widget>[
            AssetThumb(
              asset: images.first,
              width: 300,
              height: 300,
            )
          ],
        ),
      );
    }
    return const SizedBox(height: 0);
  }

  Future<void> _sendHandler() async {
    if (_textController.text == '' && images.isEmpty) {
      Toast.popToast('请输入文字或选择图片');
      return;
    }
    if (images.isNotEmpty) {
      Toast.popLoading('图片上传中...', 20);
    }
    String text = '';
    String imageUrl = '';
    if (images.isNotEmpty) {
      var asset = images.first;
      var name = asset.name;
      var type = name?.substring(name.lastIndexOf('.', name.length));
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      var filename = "1$timeStamp${type!}";
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      try {
        var res = await UpLoad.upLoad(imageData, filename);
        if (res.statusCode == 400) {
          Toast.popToast('上传失败请重试');
        } else {
          imageUrl = res.data['data'];
        }
      } catch (e) {
        print(e.toString());
      }
      if (_textController.text == '') {
        text = '图片评论';
      } else {
        text = _textController.text;
      }
    } else {
      text = _textController.text;
    }
    var now = DateTime.now();
    String url;
    Map<String, Object?> map;

    map = {
        'userId': Global.profile.user!.id,
        'text': text,
        'imageUrl': imageUrl,
        'date': now.toString().substring(0, 19),
        'postId': widget.postId
      };
      url = '/comments/addComments';
    var response = await NetRequester.request(url, data: map);
    var result = BaseBean.fromJson(response.data);
    if (result.status == 200) {
      Toast.popToast('评论成功');
      Navigator.pop(context);
      widget.list.refresh();
    } else {
      Toast.popToast('评论失败，请检查网络重试');
    }
  }
}
