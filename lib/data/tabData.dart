import 'package:flutter/material.dart';

// 封装导航栏的图标与文本数据
class TabData {
  /// 导航数据构造函数
  const TabData({required this.index, required this.title, required this.icon});
  /// 导航标题
  final String title;
  /// 导航图标
  final IconData icon;
  /// 索引
  final int index;
}

/// 导航栏数据集合
const List<TabData> datas = <TabData>[
  TabData(index: 0, title: '文章', icon: Icons.book_outlined),
  TabData(index: 1, title: '搜索', icon: Icons.search),
  // TabData(index: 2, title: '识别', icon: Icons.add),
  TabData(index: 2, title: '记录', icon: Icons.note_alt_outlined),
  TabData(index: 3, title: '我的', icon: Icons.person_outline_outlined),
];