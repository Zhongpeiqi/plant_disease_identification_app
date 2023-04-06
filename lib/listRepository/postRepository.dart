import 'package:loading_more_list/loading_more_list.dart';
import 'package:plant_disease_identification_app/model/post.dart';
import 'package:plant_disease_identification_app/state/global.dart';

import '../net/Api.dart';
import '../net/NetRequester.dart';

class PostRepository extends LoadingMoreBase<Post> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int? userId;
  int? id;
  String? key;
  int type;
  PostRepository(this.userId,this.type,[this.key,this.id]);

  @override
  bool get hasMore => _hasMore || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async{
    String url = '';
    switch(type){
      case 1:
        url = Api.getAllPostsByDate(pageIndex);
        break;
      case 2:
        url = Api.queryPostByText(pageIndex, key!);
        break;
      case 3:
        url = Api.queryPostLikes(pageIndex,id!);
        break;
      case 4:
        url = Api.queryLikedPost(pageIndex,Global.profile.user!.id!);
        break;
      case 5:
        url = Api.queryByUserId(pageIndex,userId!);
        break;
    }
    bool isSuccess = false;
    try {
      var result = await NetRequester.request(url);
      var baseBean = result.data['data'];
      if(baseBean != null){
        if (pageIndex == 1) {
          clear();
        }
        if(baseBean.isNotEmpty){
          for (var item in baseBean) {
            var post = Post.fromJson(item);
            if (!contains(post) && hasMore) add(post);
          }
        }
        _hasMore = pageIndex < result.data['total'];
        pageIndex++;
        isSuccess = true;
      }
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack.toString());
    }
    return isSuccess;
  }

}