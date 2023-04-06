import 'package:extended_image/extended_image.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:plant_disease_identification_app/ui/homePage.dart';
import 'package:provider/provider.dart';
import '../../config/my_icon.dart';
import '../../net/BaseBean.dart';
import '../../net/NetRequester.dart';
import '../../net/UploadUtils.dart';
import '../../state/global.dart';
import '../../state/profileChangeNotifier.dart';
import '../../utils/specialText/emoji_text.dart';
import '../../utils/specialText/special_textspan.dart';
import '../../utils/toast.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotePageState();
  }
}

class _NotePageState extends State<NotePage> {
  List<Asset> images = <Asset>[];
  final TextEditingController _textController = TextEditingController();
  late double _keyboardHeight;
  late bool _showEmoji;
  final FocusNode _focusNode = FocusNode();
  late int _maxImgNum;

  @override
  void initState() {
    _showEmoji = false;
    _maxImgNum = 9;
    _textController.selection = const TextSelection.collapsed(offset: 0);
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
    _keyboardHeight = keyboardHeight;
    if (keyboardHeight > 0) {
      _showEmoji = false;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        title: const Text("分享记录"),
        actions: <Widget>[
          Consumer<UserModel>(builder: (BuildContext context, model, _) {
            return IconButton(
              icon: const Icon(MyIcons.send),
              onPressed: () {
                _sendHandler(model);
              },
            );
          })
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(-8), child: Container()),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                //输入框
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(33)),
                  height: ScreenUtil().setHeight(300),
                  child: ExtendedTextField(
                    specialTextSpanBuilder:
                        MySpecialTextSpanBuilder(context: context),
                    focusNode: _focusNode,
                    controller: _textController,
                    autofocus: true,
                    style: TextStyle(fontSize: ScreenUtil().setSp(46)),
                    keyboardType: TextInputType.multiline,
                    onEditingComplete: _changeRow,
                    maxLines: 5,
                    decoration:
                        const InputDecoration.collapsed(hintText: "分享你的记录"),
                  ),
                ),
                //图片
                buildGridView(),
              ],
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  _changeRow() {
    _textController.text += '\n';
  }

  buildGridView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
      constraints: BoxConstraints(
          maxHeight: ScreenUtil().setWidth(_getHeight(images.length))),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
        mainAxisSpacing: ScreenUtil().setWidth(18),
        crossAxisSpacing: ScreenUtil().setWidth(18),
        crossAxisCount: 3,
        children:
            List.generate(images.length < 9 ? images.length + 1 : 9, (index) {
          if (images.length < 9 && index == images.length) {
            return _buildAdd();
          } else {
            Asset asset = images[index];
            return Stack(
              children: <Widget>[
                AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
                deleteButton(index)
              ],
            );
          }
        }),
      ),
    );
  }

  deleteButton(int index) => Positioned(
        right: 0.0,
        top: 0.0,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              images.removeAt(index);
            });
            print(images.length);
          },
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(4.0)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(ScreenUtil().setWidth(10.0)),
              ),
              color: Colors.black54,
            ),
            child: Center(
              child: Icon(
                Icons.delete,
                size: ScreenUtil().setWidth(45.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    final currentColorValue =
        '#${Theme.of(context).primaryColor.value.toRadixString(16).substring(2, 8)}';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: _maxImgNum,
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

  _buildAdd() {
    return Container(
      color: Colors.black.withOpacity(0.05),
      width: ScreenUtil().setWidth(330),
      height: ScreenUtil().setWidth(330),
      child: InkWell(
        onTap: loadAssets,
        child: Icon(
          MyIcons.plus,
          size: ScreenUtil().setWidth(100),
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _sendHandler(UserModel model) async {

    if (images.isEmpty && _textController.text.isEmpty) {
      Toast.popToast('请输入笔记内容或选择图片');
      return;
    }
    if (images.isNotEmpty) {
      Toast.popLoading('图片上传中...', 20);
    }
    var flag = 1;
    String imageUrl = '';
    for (var asset in images) {
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
          flag = 0;
        } else {
          imageUrl += "${res.data['data']},";
        }
      } catch (e) {
        flag = 0;
        print(e.toString());
      }
    }
    if (flag == 1) {
      var now = DateTime.now();
      var response;
      String text = _textController.text;
      if (images.isNotEmpty) {
        imageUrl = imageUrl.substring(0, imageUrl.length - 1);
      }
      Map<String,dynamic> map = {};
      map['text'] = text;
      map['imageUrl'] = imageUrl;
      map['date'] = now.toString().substring(0, 19);
      map['userId'] = Global.profile.user!.id;
      response = await NetRequester.request('/post/savePost', data: map);
      var res = BaseBean.fromJson(response.data);
      if (res.status == 200) {
        Toast.popToast('发布成功');
        setState(() {
          _textController.text = '';
          images = [];
        });
        Get.to(() => const HomePage());
        model.notifyListeners();
      } else {
        Toast.popToast('发布失败，请检查网络重试');
      }
    }
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
          ],
        ),
      ),
    );
  }

  num _getHeight(int length) {
    if (length < 3) {
      return 365;
    } else if (length < 6) {
      return 705;
    } else {
      return 1040;
    }
  }

  void manualDelete() {
    //delete by code
    final _value = _textController.value;
    final selection = _value.selection;
    if (!selection.isValid) return;

    TextEditingValue value;
    final actualText = _value.text;
    if (selection.isCollapsed && selection.start == 0) return;
    final int start =
        selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;

    value = TextEditingValue(
      text: actualText.replaceRange(start, end, ""),
      selection: TextSelection.collapsed(offset: start),
    );
    MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
        MySpecialTextSpanBuilder(context: context);
    final oldTextSpan = _mySpecialTextSpanBuilder.build(_value.text);

    value = handleSpecialTextSpanDelete(value, _value, oldTextSpan, null);

    _textController.value = value;
  }

  _buildSingleImg() {
    return images.isNotEmpty
        ? Stack(
            children: <Widget>[
              AssetThumb(
                asset: images[0],
                width: 50,
                height: 50,
              ),
              deleteButton(0)
            ],
          )
        : const SizedBox(height: 0);
  }
}
