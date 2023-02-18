
import 'package:plant_disease_identification_app/model/post.dart';

class FakeData {
  static List<Post> posts = [
    Post(
        postId: 1,
        userId: 1,
        date: "2022-02-14",
        text: "天气真好",
        imageUrl: "https://ts1.cn.mm.bing.net/th/id/R-C.e2e217d30d552dec1c9ca6f69a5c5d62?rik=HwKLMaufZmpOKA&riu=http%3a%2f%2fimg1.gtimg.com%2fln%2fpics%2fhv1%2f238%2f229%2f2250%2f146364883.png&ehk=jpRTain5XZlV%2fkds5w0bhl%2bx0Owtj2frOgyI5ZOTXiU%3d&risl=&pid=ImgRaw&r=0",
        likeNum: 10,
        commentNum: 10,
        isLiked: true),
    Post(
        postId: 2,
        userId: 1,
        date: "2022-02-14",
        text: "天气说变就变",
        imageUrl: "https://pic4.zhimg.com/v2-0c99d414d1b0999b5c3f9b9b9acccb43_r.jpg?source=1940ef5c",
        likeNum: 43,
        commentNum: 23,
        isLiked: true),
    Post(
        postId: 3,
        userId: 1,
        date: "2022-02-14",
        text: "苏州😊",
        imageUrl: "https://img.zcool.cn/community/01f7e75d6e6caba801202f170bbd2b.jpg@1280w_1l_2o_100sh.jpg",
        likeNum: 53,
        commentNum: 63,
        isLiked: true),
  ];

}
