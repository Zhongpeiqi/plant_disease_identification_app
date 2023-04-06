import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../../listRepository/postRepository.dart';
import '../../../model/post.dart';
import '../../../widgets/listIndicator.dart';
import '../../../widgets/postCard.dart';

class CommonPostPage extends StatefulWidget {
  final int type;
  final String str;
  String? orderBy;
  CommonPostPage({Key? key, required this.type, required this.str,this.orderBy}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CommonPostPageState();
  }
}

class _CommonPostPageState extends State<CommonPostPage> {
  late PostRepository _postRepository;
  @override
  void initState() {
    super.initState();
    _postRepository =  PostRepository(1,widget.type,widget.str);
  }

  @override
  void dispose() {
    _postRepository.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _postRepository.refresh,
        child: LoadingMoreList(
          ListConfig<Post>(
            itemBuilder: (BuildContext context, Post item, int index){
              return PostCard(post: item,list: _postRepository,index: index);
            },
            sourceList: _postRepository,
            indicatorBuilder: _buildIndicator,
            padding: EdgeInsets.only(
                top:ScreenUtil().setWidth(20),
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _postRepository);
  }
}
