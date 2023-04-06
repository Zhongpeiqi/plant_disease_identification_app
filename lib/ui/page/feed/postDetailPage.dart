import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:plant_disease_identification_app/model/comment.dart';
import 'package:plant_disease_identification_app/state/global.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../../config/my_icon.dart';
import '../../../listRepository/commentRepository.dart';
import '../../../listRepository/postRepository.dart';
import '../../../listRepository/userRepository.dart';
import '../../../model/post.dart';
import '../../../model/user.dart';
import '../../../net/Api.dart';
import '../../../net/BaseBean.dart';
import '../../../net/NetRequester.dart';
import '../../../state/profileChangeNotifier.dart';
import '../../../utils/buildDate.dart';
import '../../../utils/specialText/special_textspan.dart';
import '../../../utils/toast.dart';
import '../../../widgets/itemBuilder.dart';
import '../../../widgets/listIndicator.dart';
import '../../../widgets/myListTile.dart';
import '../profilePage.dart';
import '../viewImgPage.dart';
import 'commentDialog.dart';

class PostDetailPage extends StatefulWidget {
  final int? postId;
  final int offset;

  const PostDetailPage({Key? key, required this.postId, required this.offset})
      : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with TickerProviderStateMixin {
  String textSend = '';
  late Future _future;
  late Post _post;
  late TabController _tabController;
  late PageController _pageController;
  late final ScrollController _scrollController = ScrollController();
  late UserRepository _userRepository;
  late PostRepository _postRepository;
  late CommentRepository _commentRepository;

  @override
  void initState() {
    _future = _getPost();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    _userRepository.dispose();
    _postRepository.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getPost() async {
    var response = await NetRequester.request(Api.getPostByPostId(widget.postId!));
    var res = BaseBean.fromJson(response.data);
    if (res.status == 200 && res.data != null) {
      _post = Post.fromJson(res.data);
      _pageController = PageController(initialPage: 1);
      _postRepository = PostRepository(Global.profile.user!.id, 4);
      _userRepository = UserRepository(Global.profile.user!.id!, 2,"",_post.id);
      _commentRepository = CommentRepository(_post.id!);
    } else {
      Toast.popToast('内容不见了');
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
      throw '内容不见了';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context,snap){
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasError) {
              return Center(
                child: Text('加载失败请重试!',style: TextStyle(fontSize: ScreenUtil().setSp(48))),
              );
            }else{
              return Stack(
                children: <Widget>[
                  _buildBody(),
                  _buildInputBar()
                ],
              );
            }
          }else{
            return Center(
              child: SpinKitRing(
                lineWidth: 3,
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        },
      ),
    );
  }

  _buildBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight + 120.w;
    return extended.ExtendedNestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: _headerSliverBuilder,
        pinnedHeaderSliverHeightBuilder: () {
          return pinnedHeaderHeight;
        },
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            LoadingMoreList(
              ListConfig<User>(
                  itemBuilder: (BuildContext context, User user, int index){
                    return ItemBuilder.buildUserRow(context,user);
                  },
                  sourceList: _userRepository,
                  indicatorBuilder: _buildIndicator,
                  lastChildLayoutType: LastChildLayoutType.none,
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90))
              ),
            ),
            LoadingMoreList(
              ListConfig<Comment>(
                  itemBuilder: (BuildContext context, Comment comment, int index){
                    return ItemBuilder.buildComment(context,comment,_commentRepository,index);
                  },
                  sourceList: _commentRepository,
                  indicatorBuilder: _buildIndicator,
                  lastChildLayoutType: LastChildLayoutType.none,
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90))
              ),
            ),
          ],
        ));
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      const SliverAppBar(
        pinned: true,
        elevation: 0,
        title: Text('笔记'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(-8),
          child: SizedBox(),
        ),
      ),
      _postInfo(),
      _content(),
      SliverToBoxAdapter(child: SizedBox(height: 20.w)),
      _tabBar()
    ];
  }

  //导航
  _tabBar() {
    return SliverToBoxAdapter(
      child: StickyHeader(
        header: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0))),
          elevation: 1,
          margin: const EdgeInsets.all(0),
          child: Consumer<ThemeModel>(
              builder: (BuildContext context, themeModel, _) {
            return Container(
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(300)),
              child: TabBar(
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor:
                    themeModel.isDark ? Colors.white : Colors.grey,
                tabs: <Widget>[
                  Tab(text: '赞 ${_post.likeNum}'),
                  Tab(text: '评论 ${_post.commentNum}'),
                ],
              ),
            );
          }),
        ),
        content: const SizedBox(height: 0),
      ),
    );
  }

  _content() {
    return SliverToBoxAdapter(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0))),
        elevation: 0,
        margin: const EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(42),
              vertical: ScreenUtil().setHeight(15)),
          child: _buildContent(),
        ),
      ),
    );
  }

  _postInfo() {
    return SliverToBoxAdapter(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0))),
        margin: const EdgeInsets.all(0),
        elevation: 0,
        child: MyListTile(
          top: 22,
          bottom: ScreenUtil().setWidth(20),
          left: 42,
          right: 24,
          useScreenUtil: false,
          leading: SizedBox(
            width: ScreenUtil().setWidth(115),
            child: InkWell(
              onTap: () async{
                var res = await NetRequester.request(Api.info(_post.userId!));
                Get.to(() => ProfilePage(user: User.fromJson(res.data['data'])));
              },
              child: SizedBox(
                height: ScreenUtil().setWidth(115),
                child: ClipOval(
                  child: ExtendedImage.network(_post.icon!,
                      cache: true),
                ),
              ),
            ),
          ),
          center: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(_post.name!,
                  style: TextStyle(fontSize: ScreenUtil().setSp(52))),
              Text(buildDate(_post.date!),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(34), color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  //文章内容
  _buildContent() {
    var text = _post.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text == '' ? Container() : _postText(text!),
        _buildImage(),
      ],
    );
  }

  //文章正文
  _postText(String text) {
    return ExtendedText(
      text,
      style: TextStyle(fontSize: ScreenUtil().setSp(44)),
      specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
      onSpecialTextTap: (dynamic parameter) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewImgPage(
                      images: [parameter],
                      index: 0,
                      postId: _post.id.toString(),
                    )));
      },
    );
  }

  //图片
  _buildImage() {
    var url = _post.imageUrl;
    List images = url!.split(',');
    if (images[0] == '') {
      return Container();
    } else if (images.length == 1) {
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewImgPage(
                        images: images,
                        index: 0,
                        postId: _post.id.toString())));
          },
          child: Hero(
              tag: '${_post.id.toString() + images[0]}0',
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: ScreenUtil().setHeight(800),
                    maxWidth: ScreenUtil().setWidth(700)),
                child: ExtendedImage.network(images[0],
                    cache: true,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(21))),
              )));
    } else {
      return GridView.count(
        // physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        mainAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisCount: images.length < 3 ? 2 : 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(images.length, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewImgPage(
                          images: images,
                          index: index,
                          postId: _post.id.toString())));
            },
            child: Hero(
              tag: _post.id.toString() + images[index] + index.toString(),
              child: ExtendedImage.network(
                images[index],
                fit: BoxFit.cover,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25)),
                cache: true,
              ),
            ),
          );
        }),
      );
    }
  }

  //输入框
  _buildInputBar() {
    return Positioned(
      bottom: 0,
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: SizedBox(
          height: 120.h,
          width: ScreenUtil().setWidth(1080),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CommentDialog(
                                postId: _post.id!, list: _commentRepository);
                          });
                    },
                    icon: const Icon(
                      Icons.mode_edit_outlined,
                      color: Colors.grey,
                      size: 15,
                    ),
                    label: Text('说点什么吧...                             ',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(40),
                            color: Colors.grey))),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(160),
                child: TextButton(
                  child: Icon(
                      _post.isLiked == true ? MyIcons.like_fill : MyIcons.like,
                      color: _post.isLiked == true
                          ? Theme.of(context).primaryColor
                          : Colors.grey),
                  onPressed: () async {},
                ),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(160),
                child: TextButton(
                  child: const Icon(MyIcons.retweet, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _userRepository);
  }
}
