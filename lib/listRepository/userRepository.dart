import 'package:loading_more_list/loading_more_list.dart';
import '../model/user.dart';

class UserRepository extends LoadingMoreBase<User> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int id;
  //1:查粉丝2：查关注3:点赞记录
  int type;
  String key;
  UserRepository(this.id,this.type, this.key);

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
  Future<bool> loadData([bool isloadMoreAction = false]) {
    // TODO: implement loadData
    throw UnimplementedError();
  }

}