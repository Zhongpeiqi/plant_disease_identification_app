import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plant_disease_identification_app/config/my_icon.dart';
import 'package:plant_disease_identification_app/listRepository/postRepository.dart';
import 'package:plant_disease_identification_app/model/post.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:plant_disease_identification_app/ui/page/feed/postDetailPage.dart';
import 'package:plant_disease_identification_app/ui/page/minePage.dart';
import 'package:plant_disease_identification_app/ui/page/viewImgPage.dart';
import 'package:plant_disease_identification_app/utils/buildDate.dart';
import 'package:plant_disease_identification_app/utils/specialText/special_textspan.dart';
import 'package:plant_disease_identification_app/widgets/myListTile.dart';


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
            Get.to(() => PostDetailPage(postId: widget.post.postId,offset: 0,));
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
                      width: ScreenUtil().setWidth(740),
                      height: ScreenUtil().setHeight(widget.post.userId != Global.profile.user?.userId?400 :500),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(60),
                          vertical: ScreenUtil().setHeight(40)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          MyListTile(
                            onTap: () async {
                            },
                            leading:Text(widget.post.isLiked == true?'点赞':'取消点赞'),
                          ),
                          MyListTile(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            leading:const Text('复制'),
                          ),
                          MyListTile(
                            onTap: (){},
                            leading:const Text('举报'),
                          ),
                          Offstage(
                            offstage: widget.post.userId != Global.profile.user?.userId,
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
          onTap: (){
            Get.to(() => MinePage(userId:widget.post.userId));
          },
          child: SizedBox(
            height: ScreenUtil().setWidth(115),
            child:  widget.post.imageUrl==''|| widget.post.imageUrl == null
                ?const Image(image: AssetImage("assets/img/author.png"))
                :const ClipOval(child:Image(image: AssetImage("assets/img/author.png"))),
            //ClipOval(child: ExtendedImage.network('${NetConfig.ip}/images/${widget.post.imageUrl!}',cache: true),)
          ),
        ),
      ),
      center: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("张三",style: TextStyle(fontSize: ScreenUtil().setSp(52))),
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
      var index = text?.indexOf('//@');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text ==''? Container(): _postText(text!),
          SizedBox(height: ScreenUtil().setHeight(10),),
          _buildImage(),
        ],
      );
      // if(widget.post.imageUrl!=''){
      //   switch(index){
      //     case -1:
      //       text ='$text ￥-${widget.post.imageUrl}-￥';
      //       break;
      //     case 0:
      //       text =' ￥-${widget.post.imageUrl}-￥$text';
      //       break;
      //     default:
      //       text='${widget.post.imageUrl}';
      //   }
      // }
      // textSend= text!;
      // return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     text==''? Container(): _postText(text),
      //     SizedBox(height: ScreenUtil().setHeight(10),),
      //     InkWell(
      //       onTap: (){
      //         // Get.to(() => const PostDetailPage(offset: 0,postId: 1,));
      //       },
      //       child: Container(
      //         padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(20),
      //             vertical: ScreenUtil().setHeight(10)),
      //         decoration: BoxDecoration(
      //             color: Colors.black.withOpacity(0.06),
      //             borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
      //         ),
      //         child: Container(),
      //       ),
      //     ),
      //   ],
      // );
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
                ViewImgPage(images: str,
                  index: 0,postId: widget.post.postId.toString(),)));
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
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) =>
              //         SendPostPage(type: 2,post: widget.post,text: textSend,)));
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.share,color: Colors.grey,size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
                Text(widget.post.likeNum.toString(),
                  style: const TextStyle(color: Colors.grey),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //图片
  _buildImage() {
    var images = widget.post.imageUrl;
    if(images == ''){
      return Container();
    }else if(images?.length == 1){
      return InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewImgPage(
                    images: images,index: 0,postId: widget.post.postId.toString())));
          },
          child: Hero(
              tag: '${widget.post.postId.toString()+images!}0',
              child: Container(
                constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(800),
                    maxWidth: ScreenUtil().setWidth(700)),
                child: ExtendedImage.network(
                    images,
                    cache: true,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12,width: 1),
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
                ),
              ))
      );
    }else{
      print("image:  ${images!.length}");
      int len = 1;
      return GridView.count(
        // physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        mainAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisCount: 3,
        shrinkWrap:true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(len, (index) {
          return InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewImgPage(
                      images: images,index: index,postId: widget.post.postId.toString())));
            },
            child: Hero(
              tag: widget.post.postId.toString()+images +index.toString(),
              child: ExtendedImage.network(
                images,
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
    //TODO
  }


}
