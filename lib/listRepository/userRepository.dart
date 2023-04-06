import 'package:loading_more_list/loading_more_list.dart';
import '../model/user.dart';
import '../net/Api.dart';
import '../net/NetRequester.dart';

class UserRepository extends LoadingMoreBase<User> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int id;
  int? postId;
  //1:查粉丝2：查关注3:点赞记录
  int type;
  String? key;
  UserRepository(this.id,this.type, [this.key,this.postId]);

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
    String url = '';
    switch (type){
      case 1:
        url = Api.searchUser(pageIndex,key!);
        break;
      case 2:
        url = Api.queryPostLikes(pageIndex-1,postId!);
        break;
    }
    try {
      var result = await NetRequester.request(url);
      print(result);
      var baseBean = result.data['data'];
      if(baseBean != null){
        if (pageIndex == 1) {
          clear();
        }
        if(baseBean.isNotEmpty){
          for (var item in baseBean) {
            var user = User.fromJson(item);
            if (!contains(user) && hasMore) add(user);
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