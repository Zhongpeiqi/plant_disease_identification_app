import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:plant_disease_identification_app/listRepository/postRepository.dart';
import 'package:plant_disease_identification_app/model/fakeData.dart';
import 'package:plant_disease_identification_app/model/post.dart';
import 'package:plant_disease_identification_app/widgets/listIndicator.dart';
import 'package:plant_disease_identification_app/widgets/postCard.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> with AutomaticKeepAliveClientMixin{
  late PostRepository _postRepository;

  @override
  void initState() {
    super.initState();
    _postRepository =  PostRepository(1,2);
  }

  @override
  void dispose() {
    _postRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Scaffold(
      appBar: AppBar(
        title: const Text("文章"),
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(-10),
          child: Container(),
        ),
      ),
      body: ListView(
        children: [
          PostCard(post: FakeData.posts[0],list: _postRepository,index: 1),
          PostCard(post: FakeData.posts[1],list: _postRepository,index: 1),
          PostCard(post: FakeData.posts[2],list: _postRepository,index: 1),
        ],
      )
      // LoadingMoreList(
      //   ListConfig<Post>(
      //     itemBuilder: (BuildContext context, Post item, int index){
      //       return PostCard(post: item,list: _postRepository,index: index);
      //     },
      //     sourceList: _postRepository,
      //     indicatorBuilder: _buildIndicator,
      //     padding: EdgeInsets.only(
      //         top:20.w,
      //         left: 20.w,
      //         right: 20.w
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _postRepository);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
