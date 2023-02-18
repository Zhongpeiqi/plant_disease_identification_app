import 'package:flutter/material.dart';
class PostDetailPage extends StatefulWidget {
  final int? postId;
  final int offset;
  const PostDetailPage({Key? key, required this.postId, required this.offset}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
