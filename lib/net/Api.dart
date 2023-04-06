
class Api{
  //postId查找post
  static String getPostByPostId(int postId) {
    return '/post/$postId';
  }

  //userId查找post
  static String queryByUserId(int current,int userId) {
    return '/post/queryByUserId?&current=$current&userId=$userId';
  }

  static String getAllPostsByDate(int current) {
    return '/post/hot?&current=$current';
  }

  //根据正文关键字查找文章
  static String queryPostByText(int current,String text) {
    return '/post/search?&current=$current&text=$text';
  }

  //根据查找用户点赞文章
  static String queryLikedPost(int current,int userId) {
    return '/post/queryLikedPost?&current=$current&id=$userId';
  }

  //查找文章点赞用户
  static String queryPostLikes(int current,int id) {
    return '/post/likes?&current=$current&id=$id';
  }

  //根据postId查找评论
  static String queryCommentsByPostId(int postId,int page) {
    return '/comments/getCommentByPostId?&current=$page&postId=$postId';
  }

  //获取验证码
  static String sendEmail(String email) {
    return '/user/code?email=$email';
  }

  //点赞
  static String like(int id){
    return "/likePost/like?id=$id";
  }

  //删除文章
  static String deletePost(int postId) {
    return '/post/delete?postId=$postId';
  }

  //根据用户名字查找用户
  static String searchUser(int current,String name){
    return '/user/search?&current=$current&name=$name';
  }

  //根据用户ID查找信息
  static String info(int id){
    return '/user/info/$id';
  }

  //根据用户ID查询历史记录
  static String queryHistoryByUserId(int userId){
    return '/history/queryByUserId?&userId=$userId';
  }

  //根据用户ID删除全部历史记录
  static String deleteAll(int userId){
    return '/history/deleteAll?&userId=$userId';
  }

  //删除历史记录
  static String delete(int id){
    return '/history/delete?&id=$id';
  }

  //Id查找疾病
  static String getDiseaseById(int id) {
    return '/disease/$id';
  }
}