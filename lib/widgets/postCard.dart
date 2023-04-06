import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/listRepository/postRepository.dart';
import 'package:plant_disease_identification_app/model/post.dart';
import 'package:plant_disease_identification_app/model/profile.dart';
import 'package:plant_disease_identification_app/net/Api.dart';
import 'package:plant_disease_identification_app/net/NetRequester.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/ui/page/feed/postDetailPage.dart';
import 'package:plant_disease_identification_app/ui/page/feedBackPage.dart';
import 'package:plant_disease_identification_app/ui/page/minePage.dart';
import 'package:plant_disease_identification_app/ui/page/profilePage.dart';
import 'package:plant_disease_identification_app/ui/page/viewImgPage.dart';
import 'package:plant_disease_identification_app/utils/buildDate.dart';
import 'package:plant_disease_identification_app/utils/specialText/special_textspan.dart';
import 'package:plant_disease_identification_app/utils/toast.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';

import '../model/user.dart';
import '../state/profileChangeNotifier.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final PostRepository list;
  final int index;
  const PostCard({Key? key, required this.post, required this.list, required this.index}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String textSend = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20),horizontal: ScreenUtil().setHeight(20)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(24),
            vertical: ScreenUtil().setHeight(30)
        ),
        child: InkWell(
          onLongPress: (){
            _showDialog(context);
          },
          onTap: (){
            Get.to(() => PostDetailPage(postId: widget.post.id,offset: 0,));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfo(),
              _buildContent(),
              _likeBar(context)
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context){
          return Material(
            textStyle: TextStyle(fontSize: ScreenUtil().setSp(48),color: Colors.black),
            color: Colors.black12,
            child:Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(1920),),
                ),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
                    child: Container(
                      width: ScreenUtil().setWidth(440),
                      height: ScreenUtil().setHeight(widget.post.userId != Global.profile.user?.id?160 :250),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(60),
                          vertical: ScreenUtil().setHeight(40)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Center(
                            child: MyListTile(
                              onTap: (){
                                Get.to(() => const FeedBackPage("https://support.qq.com/product/536336", "反馈中心"));
                              },
                              leading:const Text('举报'),
                            ),
                          ),
                          Offstage(
                            offstage: widget.post.userId != Global.profile.user?.id,
                            child: MyListTile(
                              onTap: _deletePost,
                              leading:const Text('删除'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  // 用户信息
  _buildInfo() {
    return MyListTile(
      top: 0,
      bottom: ScreenUtil().setWidth(20),
      left: 0,
      right: 0,
      useScreenUtil: false,
      leading: SizedBox(
        width: ScreenUtil().setWidth(115),
        child: InkWell(
          onTap: () async{
            var res = await NetRequester.request(Api.info(widget.post.userId!));
            Get.to(() => ProfilePage(user: User.fromJson(res.data['data'])));
          },
          child: SizedBox(
            height: ScreenUtil().setWidth(115),
            child: ClipOval(child:ExtendedImage.network(widget.post.icon!,cache: true)),
          ),
        ),
      ),
      center: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.post.name!,style: TextStyle(fontSize: ScreenUtil().setSp(52))),
          Text(buildDate(widget.post.date!),style: TextStyle(
              fontSize: ScreenUtil().setSp(34),color: Colors.grey)),
        ],
      ),
      trailing: SizedBox(
        width: ScreenUtil().setWidth(90),
        child: TextButton(
          style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(0))),
          child:const Icon(MyIcons.and_more,color: Colors.grey),
          onPressed: (){
            _showDialog(context);
          },
        ),
      ),
    );
  }

  //文章内容
  _buildContent() {
      var text = widget.post.text;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text ==''? Container(): _postText(text!),
          SizedBox(height: ScreenUtil().setHeight(10),),
          _buildImage(),
        ],
      );
    }

    //文章正文
  _postText(String text) {
    return ExtendedText(text,
      style: TextStyle(fontSize: ScreenUtil().setSp(44)),
      specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
      onSpecialTextTap: (dynamic parameter) {
        String str =parameter.substring(2,parameter.length-3).toString();
        print(str);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                ViewImgPage(images: [str],
                  index: 0,postId: widget.post.id.toString(),)));
      },
      maxLines: 6,
      overflowWidget: TextOverflowWidget(
          child: Text("...查看更多",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),)
      )
    );

  }

  //按钮
  _likeBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      height: ScreenUtil().setHeight(90),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              var result = await NetRequester.dio.post(Api.like(widget.post.id!));
              if (result.data["status"] == 200) {
                print(result.data);
                if(result.data["data"] == "点赞成功"){
                  setState(() {
                    widget.post.isLiked = !widget.post.isLiked!;
                    widget.post.likeNum = (widget.post.likeNum! + 1);
                  });
                }else{
                  setState(() {
                    widget.post.isLiked = !widget.post.isLiked!;
                    widget.post.likeNum = (widget.post.likeNum! - 1);
                  });
                }
                Toast.popToast(result.data["data"]);
              } else {
                Toast.popToast("网络出错");
              }
            },
            child: Row(
              children: <Widget>[
                Icon( widget.post.isLiked == true?MyIcons.like_fill:MyIcons.like,
                    color: widget.post.isLiked == true
                        ? Theme.of(context).colorScheme.secondary:Colors.grey,
                    size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
                Text(widget.post.likeNum.toString(),
                    style: TextStyle(color: widget.post.isLiked == true
                        ? Theme.of(context).colorScheme.secondary:Colors.grey)),
              ],
            ),
          ),
          TextButton(
            onPressed: (){
              Get.to(() => PostDetailPage(postId: widget.post.id,offset: 0,));
            },
            child: Row(
              children: <Widget>[
                Icon(MyIcons.comment,color: Colors.grey,size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
                Text(widget.post.commentNum.toString(),
                  style: const TextStyle(color: Colors.grey),),
              ],
            ),
          ),
          TextButton(
            onPressed: (){
              Get.to(() => const FeedBackPage("https://support.qq.com/product/536336", "反馈中心"));
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.sentiment_dissatisfied_outlined,color: Colors.grey,size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //图片
  _buildImage() {
    var url = widget.post.imageUrl ?? "";
    List image = url.split(',');
    if(image[0] == ''){
      return Container();
    }else if(image.length == 1){
      return InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewImgPage(
                    images: image,index: 0,postId: widget.post.id.toString())));
          },
          child: Hero(
              tag: '${widget.post.id.toString()+image[0]}0',
              child: Container(
                constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(800),
                    maxWidth: ScreenUtil().setWidth(700)),
                child: ExtendedImage.network(
                    image[0],
                    cache: true,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12,width: 1),
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
                ),
              ))
      );
    }else{
      return GridView.count(
        // physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        mainAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisCount: image.length < 3 ? 2 : 3,
        shrinkWrap:true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(image.length, (index) {
          return InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewImgPage(
                      images: image,index: index,postId: widget.post.id.toString())));
            },
            child: Hero(
              tag: widget.post.id.toString()+image[index] +index.toString(),
              child: ExtendedImage.network(
                image[index],
                fit: BoxFit.cover,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black12,width: 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25)),
                cache: true,
              ),
            ),
          );
        }),
      );
    }
  }

  void _deletePost(){
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))),
            title: const Text('确定删除'),
            content: widget.post.text==''
                ?Container(height: ScreenUtil().setHeight(0),)
                :ExtendedText(widget.post.text!,
              style: TextStyle(fontSize: ScreenUtil().setSp(44)),
              specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
              maxLines: 2,
              overflowWidget: const TextOverflowWidget(child: Text("..."))
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('删除'),
                onPressed: () async {
                  var res = await NetRequester.dio.post(Api.deletePost(widget.post.id!));
                  if(res.data["status"] == 200){
                    Toast.popToast('笔记已删除');
                    Navigator.pop(context);
                    widget.list.removeAt(widget.index);
                    widget.list.setState();
                    // Global.profile.user?.postNum = Global.profile.user!.postNum! - 1;
                    UserModel().notifyListeners();
                  }
                },
              ),
            ],
          );
        }
    );
  }


}
