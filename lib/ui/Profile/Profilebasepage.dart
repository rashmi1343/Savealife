import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/SaveALifeRepository.dart';


import '../../bloc/Profile_bloc/profile_bloc.dart';
import 'Profilepage.dart';

class Profilebasepage extends StatefulWidget {
  late String accesstoken;

  late SaveaLifeRepository Reposavealife;

  late int userid;

  Profilebasepage(
      {required this.accesstoken,
      required this.Reposavealife,
      required this.userid})
      : super();

  @override
  State<Profilebasepage> createState() => _Profilebasepagestate();
}

class _Profilebasepagestate extends State<Profilebasepage> {
  SaveaLifeRepository get _Repository => widget.Reposavealife;
  // accesstoken get _accesstoken => widget.accesstoken;
  //String get _accesstoken => widget.accesstoken;
  // late String _accesstoken;
//String get _userid => widget.userid;
  @override
  void initState() {
    // _accesstoken = widget.accesstoken;
    print("accesstoken_Profile_base_page" + widget.accesstoken);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Complete your Details',
        debugShowCheckedModeBanner: false,

        home: BlocProvider(
            create: (context) => ProfileBloc(
                accesstoken: widget.accesstoken,
                savealifeRepository: _Repository,
                userid: widget.userid),
            child: Profilepage(
                accesstoken: widget.accesstoken,
                userid: widget.userid,
                repoSaveaLife: _Repository)));
  }
}
