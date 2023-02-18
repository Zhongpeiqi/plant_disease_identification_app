import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plant_disease_identification_app/config/net_config.dart';

class ViewImgPage extends StatefulWidget{
  final String images;
  final int index;
  final String postId;
  const ViewImgPage({Key? key, required this.images, required this.index, required this.postId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ViewImgPageState();
  }

}

class _ViewImgPageState extends State<ViewImgPage> {
  late int currentIndex;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    currentIndex = widget.index;
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        return Future.value(true);
      },
      child: Material(
          color: Colors.black,
          child:Stack(
            children: <Widget>[
              ExtendedImageGesturePageView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.images;
                  Widget image = ExtendedImage.network(
                    item,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                  );
                  image = Container(
                    padding: const EdgeInsets.all(5.0),
                    child: image,
                  );
                    return InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                          },
                          child: Hero(
                                tag: widget.postId +item + index.toString(),
                                child: image,
                              ),
                        );
                },
                itemCount: widget.images.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                controller: ExtendedPageController(initialPage: currentIndex,),
                scrollDirection: Axis.horizontal,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${currentIndex+1}/${widget.images.length}",
                      style: const TextStyle(color: Colors.white),),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }


}