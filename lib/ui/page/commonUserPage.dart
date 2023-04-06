import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../listRepository/userRepository.dart';
import '../../model/user.dart';
import '../../state/global.dart';
import '../../widgets/itemBuilder.dart';
import '../../widgets/listIndicator.dart';

class CommonUserPage extends StatefulWidget{

  final String str;

  const CommonUserPage({Key? key, required this.str}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommonUserPageState();
  }
}

class _CommonUserPageState extends State<CommonUserPage> {

  late UserRepository _userRepository;
  @override
  void initState() {
    super.initState();
    _userRepository =  UserRepository(Global.profile.user!.id!,1,widget.str);
  }

  @override
  void dispose() {
    _userRepository.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _userRepository.refresh,
        child: LoadingMoreList(
          ListConfig<User>(
            itemBuilder: (BuildContext context, User user, int index){
              return ItemBuilder.buildUserRow(context,user);
            },
            sourceList: _userRepository,
            indicatorBuilder: _buildIndicator,
          ),
        ),
      ),
    );
  }
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _userRepository);
  }
}