import 'package:loading_more_list/loading_more_list.dart';
import 'package:plant_disease_identification_app/model/post.dart';

class PostRepository extends LoadingMoreBase<Post> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int? userId;
  //1:getPostsById 2:followPost
  int type;
  PostRepository(this.userId,this.type);

  @override
  bool get hasMore => _hasMore || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
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