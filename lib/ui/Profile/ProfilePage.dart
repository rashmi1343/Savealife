
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savealifedemoapp/Model/StatesResponse.dart';
import 'package:savealifedemoapp/ui/Signin/SigninPage.dart';

import '../../Model/CountriesResponse.dart';
import '../../Model/Getuserprofile.dart';
import '../../Repository/SaveALifeRepository.dart';

import '../../bloc/Profile_bloc/profile_bloc.dart';
import '../../utils/CustomTextStyle.dart';
import '../HomeDashboard/homedashboard.dart';
import 'ProfileForm.dart';

class Profilepage extends StatefulWidget {
  final SaveaLifeRepository repoSaveaLife;
  final int userid;
  final String accesstoken;

  const Profilepage(
      {super.key,
      required this.repoSaveaLife,
      required this.userid,
      required this.accesstoken});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late ProfileBloc _profilebloc;
  GetUserProfile? objuserprofiledata;

  SaveaLifeRepository get _Repository => widget.repoSaveaLife;
  List<Country> countrylist = [];

  StatesResponse? statesResponse;

  BuildContext? buildContext;

  @override
  void initState() {
    _profilebloc = ProfileBloc(
        accesstoken: widget.accesstoken,
        savealifeRepository: _Repository,
        userid: widget.userid);
  //  _profilebloc.add(GetCountryDropdownEvent());

 _profilebloc.add(getProfileevent(userid: widget.userid));

    // _profilebloc.add(getIntialProfileevent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _profilebloc,
          builder: (BuildContext context, ProfileState state) {
            if (state is ProfileInitialState) {
              print("ProfileInitialState");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }




              if (state is ProfileloadingState) {
              print("Profile loading:${state.userid}");
              return const Center(
                child: CircularProgressIndicator(),
              );
              // print("Userid in ProfileloadingState:${state.userid}");
            }

            if (state is ProfileUpdateSuccessState) {
              print("User updated Successfully in profilepage: 63");
              _onWidgetDidBuild(() {
                // _showSuccessDialog(state.updateprofileresponse.message ?? "",
                //     context2: context);
                _dialogBuilder(state.updateprofileresponse.message ?? "",
                    context: context);
              });
            }
            // if (state is LoadCountryDropdownState) {
            //   print("CountryDropdownState");
            //   countrylist=state.countrieslist;
            //   print("countrylistSize:${countrylist.length}");
            //
            // }
            // if (state is LoadStatesDropdownState) {
            //   print("LoadStatesDropdownState");
            //   statesResponse=state.statesResponse;
            //   print("statesResponse:${statesResponse}");
            //
            // }
            if (state is ProfileloadedState) {
              print('state in profilepage: ${state.props}');
              print("id:${state.userprofiledata.id}");
              objuserprofiledata = state.userprofiledata;


              // countrylist=state.countrieslist;

              print("userProfile :${state.userprofiledata.username}");
              print("address :${state.userprofiledata.address}");
              print("country :${state.userprofiledata.country}");
              print("state :${state.userprofiledata.city}");
              print("pincode :${state.userprofiledata.pincode}");

              // for token expiry
              if (state.userprofiledata.id == 0) {
                _onWidgetDidBuild(() {
                  Fluttertoast.showToast(
                      msg: "Token may have Expired,\n Please login again",
                      //message to show toast
                      toastLength: Toast.LENGTH_SHORT,
                      //duration for message to show
                      gravity: ToastGravity.BOTTOM,
                      //where you want to show, top, bottom

                      backgroundColor: Colors.red,
                      //background Color for message
                      textColor: Colors.white,
                      //message text color
                      fontSize: 16.0 //message font size
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SigninPage(saveliferepo: SaveaLifeRepository())),
                  );
                });
              }
              else {
                return UserProfileForm(
                    objuserprofiledata: objuserprofiledata,
                    profilebloc: _profilebloc,
                    accesstoken: widget.accesstoken,
                    userid: widget.userid);
                // return UserProfileForm(
                //     objuserprofiledata: objuserprofiledata,
                //     profilebloc: _profilebloc,
                //     accesstoken: widget.accesstoken,
                //     userid: widget.userid, countrylist: countrylist);
              }
            }

            return Container();
            //return Scaffold(
            //     body: UserProfileForm(objuserprofiledata: objuserprofiledata));
          }),
    );
  }

  Future<Widget> _showSuccessDialog(String msg,
      {required BuildContext context2}) async {
    return await showDialog(
      context: context2,
      builder: (context) => AlertDialog(
        //title: Text('are_you_sure'.tr),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(String msg, {required BuildContext context}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(msg,
            style: TextStyle(
              fontFamily: FontName.poppinsRegular,
              fontSize: 15,
              color: Colors.black,
            ),),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK',
                style: TextStyle(
                  fontFamily: FontName.poppinsMedium,
                  fontSize: 12,
                  color: Colors.black,
                ),),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => homedashboard(
                              accesstoken: widget.accesstoken,
                              id: widget.userid,
                              savealiferep: widget.repoSaveaLife,
                            )),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
