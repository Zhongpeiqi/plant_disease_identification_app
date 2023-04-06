import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:plant_disease_identification_app/listRepository/postRepository.dart';
import 'package:plant_disease_identification_app/widgets/listIndicator.dart';
import 'package:plant_disease_identification_app/widgets/postCard.dart';

import '../../../model/post.dart';

class ArticlePage extends StatefulWidget {
  final int? type;
  final int? userId;
  const ArticlePage({Key? key, this.type, this.userId}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with AutomaticKeepAliveClientMixin {
  late PostRepository _postRepository;
  final _scrollController = ScrollController();
  var _showBackTop = false;

  @override
  void initState() {
    super.initState();
    _postRepository = PostRepository(widget.userId, widget.type!);
    // 对 scrollController 进行监听
    _scrollController.addListener(() {
      // _scrollController.position.pixels 获取当前滚动部件滚动的距离
      // 当滚动距离大于 800 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.offset >= 800);
    });
  }

  @override
  void dispose() {
    _postRepository.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("文章"),
        elevation: 1,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-10),
          child: Container(),
        ),
      ),
      body: Scrollbar(
        child: RefreshIndicator(
          onRefresh: _postRepository.refresh,
          child: LoadingMoreList(
            ListConfig<Post>(
              itemBuilder: (BuildContext context, Post item, int index) {
                return PostCard(
                    post: item, list: _postRepository, index: index);
              },
              controller: _scrollController,
              sourceList: _postRepository,
              indicatorBuilder: _buildIndicator,
              padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(5),
                  left: ScreenUtil().setWidth(5),
                  right: ScreenUtil().setWidth(5)),
            ),
          ),
        ),
      ),
      floatingActionButton: _showBackTop
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              },
              child: const Icon(Icons.vertical_align_top),
            )
          : null,
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _postRepository);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
