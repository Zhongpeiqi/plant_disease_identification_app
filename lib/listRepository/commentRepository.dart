import 'package:loading_more_list/loading_more_list.dart';
import 'package:plant_disease_identification_app/model/comment.dart';

import '../net/Api.dart';
import '../net/NetRequester.dart';

class CommentRepository extends LoadingMoreBase<Comment> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int postId;
  CommentRepository(this.postId);

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
  Future<bool> loadData([bool isloadMoreAction = false]) async{
    bool isSuccess = false;
    try {
      var result = await NetRequester.request(Api.queryCommentsByPostId(postId, pageIndex));
      var baseBean = result.data['data'];
      if(baseBean != null){
        if (pageIndex == 1) {
          clear();
        }
        if(baseBean.isNotEmpty){
          for (var item in baseBean) {
            var comment = Comment.fromJson(item);
            if (!contains(comment) && hasMore) add(comment);
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