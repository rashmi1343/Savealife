import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:savealifedemoapp/Model/CountriesResponse.dart';
import 'package:savealifedemoapp/Repository/SaveALifeRepository.dart';

import '../../Model/Getuserprofile.dart';
import '../../Model/UpdateuserProfileRequest.dart';
import '../../bloc/Profile_bloc/profile_bloc.dart';
import '../../utils/Constant.dart';
import '../../utils/CustomTextStyle.dart';

import 'package:provider/provider.dart';

import '../../utils/pref.dart';
import '../HomeDashboard/homedashboard.dart';
import '../Signup/Validation/validation_provider.dart';

class UserProfileForm extends StatefulWidget {
  GetUserProfile? objuserprofiledata;
  ProfileBloc profilebloc;
  final int userid;
  final String accesstoken;

  //final List<Country> countrylist;

  UserProfileForm({
    required this.objuserprofiledata,
    required this.profilebloc,
    required this.userid,
    required this.accesstoken,
  });

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  String? countryname;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  Country? countries;
  final _formKey = GlobalKey<FormState>();
  String? selectedValue = null;
  final _dropdownFormKey = GlobalKey<FormState>();

  String _selectedCity = 'City';
  String? _selectedCountry;
  String _selectedState = 'State';

  //List<String> countryarr = [];

  ProfileBloc get _profilebloc => widget.profilebloc;

  // Initial Selected Value
  String dropdownvalue = 'India';

  // List of items in our dropdown menu
  var items = [
    'India',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  Future<void> getGeoCoderData() async {
    List<Location> locations =
        await locationFromAddress("Gronausestraat 710, Enschede");
    debugPrint(
        "Address to Lat long ${locations.first.latitude} : ${locations.first.longitude}");
  }

  @override
  void initState() {
    super.initState();
    // getGeoCoderData();
    //getCountriesName(widget.countrylist);
    //   _profilebloc.add(countryDropdownEvent(selectedCountry: const []));
    //  print("country_size_profile_form:" + widget.countrylist.length.toString());
    setTextfieldsIntialValue();

    // countryname = "India"; //default country
    // BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("Back To Homedashboard Page");
    //  Navigator.pop(context);
    ApiData.gridclickcount = 0;
    if (["homedashboardRoute"].contains(info.currentRoute(context)))
      return true;
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => homedashboard(
    //       savealiferep: SaveaLifeRepository(),
    //       accesstoken: Prefs.getString("accesstoken").toString(),
    //       id: Prefs.getInt("userid")!,
    //     )));

    return false;
  }

  setTextfieldsIntialValue() {
    _usernameController =
        TextEditingController(text: widget.objuserprofiledata?.username ?? "");
    _emailController =
        TextEditingController(text: widget.objuserprofiledata?.email ?? "");
    _mobileController =
        TextEditingController(text: widget.objuserprofiledata?.mobile ?? "");

    _addressController =
        TextEditingController(text: widget.objuserprofiledata?.address ?? "");
    _cityController =
        TextEditingController(text: widget.objuserprofiledata?.city ?? "");
    _countryController =
        TextEditingController(text: widget.objuserprofiledata?.country ?? "");
    _pincodeController =
        TextEditingController(text: widget.objuserprofiledata?.pincode ?? "");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    print("back called");

    /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return homedashboard(
                savealiferep: widget.savealiferep,
                accesstoken:widget.accesstoken,
                 id: Prefs.getInt("userid")!,
               );
             }));*/

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => homedashboard(
                  savealiferep: SaveaLifeRepository(),
                  accesstoken: Prefs.getString("accesstoken").toString(),
                  id: Prefs.getInt("userid")!,
                )),
        (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    final screenSize = MediaQuery.of(context).size;
    var countryname = widget.objuserprofiledata?.country.toString();
    var cityname = widget.objuserprofiledata?.city.toString();
    const edgeInsets = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);
    // final UserDetailsProvider myProvider =
    // Provider.of<UserDetailsProvider>(context);
    final validationProvider = Provider.of<ValidationProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xfff9fdfe),
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 75,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: const Color(0xfff9fdfe),
          elevation: 0,
          title: const Text(
            "Complete Your Details",
            style: TextStyle(
              fontFamily: FontName.poppinsSemiBold,
              fontSize: 17,
              color: Color(0xff243444),
            ),
          ),
          leading: Builder(
            builder: (context) => Container(
              margin: const EdgeInsets.only(left: 10),
              child: IconButton(
                alignment: Alignment.centerLeft,
                icon: Image.asset(
                  "assets/images/back.png",
                  color: const Color(0xff000000),
                  height: 21,
                  width: 24,
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  ApiData.gridclickcount = 0;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => homedashboard(
                            savealiferep: SaveaLifeRepository(),
                            accesstoken:
                                Prefs.getString("accesstoken").toString(),
                            id: Prefs.getInt("userid")!,
                          )));
                  //  Navigator.of(context, rootNavigator: true).pop(context);
                },
              ),
            ),
          ),
        ),
        body: Consumer<ValidationProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 50),
            child:
                //  myProvider.isFetching
                //     ? const Center(child: CircularProgressIndicator())
                //     :
                widget.objuserprofiledata != null
                    ? Form(
                        key: _formKey,
                        child: Center(
                          child: Container(
                            // height: MediaQuery.of(context).size.height,
                            // height: 705,
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(2),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: const Text(
                                            "Name",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                              fontSize: 14,
                                              color: Color(0xff243444),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        //height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child:
                                            // TextField(
                                            //   controller: _usernameController,
                                            //   decoration: const InputDecoration(
                                            //       border: OutlineInputBorder(),
                                            //       // labelText: 'Email Id',
                                            //       hintStyle: TextStyle(
                                            //           fontSize: 14,
                                            //           fontFamily: FontName.poppinsMedium),
                                            //       hintText: 'Enter your Full Name'),
                                            // ),

                                            TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          readOnly: true,
                                          enableInteractiveSelection: false,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          // onTap: () {
                                          //   FocusScope.of(context)
                                          //       .requestFocus(FocusNode());
                                          // },
                                          textAlign: TextAlign.start,
                                          controller: _usernameController,
                                          keyboardType: TextInputType.name,
                                          //    validator: myProvider.validateName,
                                          onChanged: (value) =>
                                              validationProvider
                                                  .validateName(value),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              // labelText: 'Email Id',
                                              contentPadding: edgeInsets,
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      FontName.poppinsMedium),
                                              hintText: 'Enter your Full Name',
                                              errorText:
                                                  validationProvider.name.error,
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.red))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: const Text(
                                            "Email",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                              fontSize: 14,
                                              color: Color(0xff243444),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        // //height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child:
                                            //   TextField(
                                            //     textAlign: TextAlign.start,
                                            //     controller: _emailController,
                                            //     decoration: const InputDecoration(
                                            //         border: OutlineInputBorder(),
                                            //         // labelText: 'Email Id',
                                            //         hintStyle: TextStyle(
                                            //             fontSize: 14,
                                            //             fontFamily: FontName.poppinsMedium),
                                            //         hintText: 'Enter your Email'),
                                            //   ),
                                            // ),
                                            TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          readOnly: true,
                                          enableInteractiveSelection: false,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          // onTap: () {
                                          //   FocusScope.of(context)
                                          //       .requestFocus(FocusNode());
                                          // },
                                          textAlign: TextAlign.start,
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          //  validator: myProvider.validateEmail,
                                          onChanged: (value) =>
                                              validationProvider
                                                  .validateEmail(value),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              // labelText: 'Email Id',
                                              contentPadding: edgeInsets,
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      FontName.poppinsMedium),
                                              hintText: 'Enter your Email',
                                              errorText: validationProvider
                                                  .email.error,
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.red))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: const Text(
                                            "Mobile",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                              fontSize: 14,
                                              color: Color(0xff243444),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        //height: 40,
                                        margin: const EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                        ),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          readOnly: true,
                                          enableInteractiveSelection: false,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          // onTap: () {
                                          //   FocusScope.of(context)
                                          //       .requestFocus(FocusNode());
                                          // },
                                          textAlign: TextAlign.start,
                                          controller: _mobileController,
                                          keyboardType: TextInputType.phone,
                                          // maxLength: 10,
                                          //    validator: myProvider.validateMobile,
                                          onChanged: (value) =>
                                              validationProvider
                                                  .validateMobileNumber(value),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              // labelText: 'Email Id',
                                              contentPadding: edgeInsets,
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      FontName.poppinsMedium),
                                              hintText:
                                                  'Enter your Mobile Number',
                                              errorText: validationProvider
                                                  .mobile.error,
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.red))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: const Text(
                                            "Address",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                              fontSize: 14,
                                              color: Color(0xff243444),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        //height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child:
                                            // TextField(
                                            //   obscureText: true,
                                            //   controller: _addressController,
                                            //   decoration: const InputDecoration(
                                            //       border: OutlineInputBorder(),
                                            //       // labelText: 'Password',
                                            //       hintStyle: TextStyle(
                                            //           fontSize: 14,
                                            //           fontFamily: FontName.poppinsMedium),
                                            //       hintText: 'Enter your Address'),
                                            // ),
                                            TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          textAlign: TextAlign.start,
                                          controller: _addressController,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          // validator: myProvider.validateAddress,
                                          onChanged: (value) =>
                                              validationProvider
                                                  .validateAddress(value),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              // labelText: 'Email Id',
                                              contentPadding: edgeInsets,
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      FontName.poppinsMedium),
                                              hintText: 'Enter your Address',
                                              errorText: validationProvider
                                                  .address.error,
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.red))),
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   height: 15,
                                      // ),
                                      // Align(
                                      //   alignment: Alignment.centerLeft,
                                      //   child: Container(
                                      //     padding:
                                      //         const EdgeInsets.only(left: 30),
                                      //     child: const Text(
                                      //       "Country",
                                      //       style: TextStyle(
                                      //         fontFamily: FontName.poppinsMedium,
                                      //         fontSize: 14,
                                      //         color: Color(0xff243444),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 15,
                                      ),

                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 28),
                                          // height: 100,
                                          child: Column(
                                            children: [
                                              ///Adding CSC Picker Widget in app
                                              CSCPicker(
                                                ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                                showStates: true,

                                                /// Enable disable city drop down [OPTIONAL PARAMETER]
                                                showCities: true,

                                                ///Enable (get flat with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                                flagState: CountryFlag
                                                    .SHOW_IN_DROP_DOWN_ONLY,
                                                layout: Platform.isIOS
                                                    ? Layout.vertical
                                                    : Layout
                                                        .horizontal, // Change Layout in iOS(vertical), Android(Horizontal : 21-Feb- 11:30AM)

                                                ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                                dropdownDecoration:
                                                    BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    3)),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 1)),

                                                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                                // disabledDropdownDecoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                                                //     color: Colors.grey.shade300,
                                                //     border: Border.all(color: Colors.grey.shade300, width: 1)),

                                                ///labels for dropdown
                                                //widget.objuserprofiledata

                                                /*countryDropdownLabel:
                                                    "*Country",
                                                stateDropdownLabel: "*State",
                                                cityDropdownLabel: "*City",
*/
                                                // Fixed default value issue on 21-02-2023 at 11:55 am by vivek
                                                countryDropdownLabel:
                                                    countryname
                                                                .toString()
                                                                .length >
                                                            0
                                                        ? countryname.toString()
                                                        : "*Country",
                                                stateDropdownLabel: "*State",
                                                cityDropdownLabel:
                                                    cityname.toString().length >
                                                            0
                                                        ? cityname.toString()
                                                        : "*City",

                                                ///selected item style [OPTIONAL PARAMETER]
                                                selectedItemStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),

                                                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                                dropdownHeadingStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),

                                                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                                dropdownItemStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),

                                                ///Dialog box radius [OPTIONAL PARAMETER]
                                                dropdownDialogRadius: 10.0,

                                                ///Search bar radius [OPTIONAL PARAMETER]
                                                searchBarRadius: 10.0,

                                                ///triggers once country selected in dropdown
                                                onCountryChanged: (value) {
                                                  setState(() {
                                                    ///store value in country variable
                                                    countryValue = value;
                                                  });
                                                },

                                                ///triggers once state selected in dropdown
                                                onStateChanged: (value) {
                                                  setState(() {
                                                    ///store value in state variable
                                                    stateValue =
                                                        value.toString();
                                                  });
                                                },

                                                ///triggers once city selected in dropdown
                                                onCityChanged: (value) {
                                                  setState(() {
                                                    ///store value in city variable
                                                    cityValue =
                                                        value.toString();
                                                  });
                                                },
                                              ),
                                            ],
                                          )),

                                      const SizedBox(
                                        height: 15,
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: const Text(
                                            "Pincode",
                                            style: TextStyle(
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                              fontSize: 14,
                                              color: Color(0xff243444),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        //height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child:
                                            // TextField(
                                            //   obscureText: true,
                                            //   controller: _pincodeController,
                                            //   decoration: const InputDecoration(
                                            //       border: OutlineInputBorder(),
                                            //       // labelText: 'Password',
                                            //       hintStyle: TextStyle(
                                            //           fontSize: 14,
                                            //           fontFamily: FontName.poppinsMedium),
                                            //       hintText: 'Enter your Pincode'),
                                            // ),
                                            TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.start,
                                          controller: _pincodeController,
                                          // validator: myProvider.validatePincode,
                                          onChanged: (value) =>
                                              validationProvider
                                                  .validatePincode(value),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          // Only numbers can be entered
                                          // maxLength: 6,

                                          // maxLengthEnforced: true,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              // labelText: 'Email Id',
                                              contentPadding: edgeInsets,
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      FontName.poppinsMedium),
                                              hintText: 'Enter your Pincode',
                                              errorText: validationProvider
                                                  .pincode.error,
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.red))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        height: 45,
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            left: 30, right: 30, bottom: 30),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff254fd5),
                                              elevation: 3,
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.normal),
                                              shape: RoundedRectangleBorder(
                                                  //to set border radius to button
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              padding: const EdgeInsets.all(5)),
                                          onPressed: () async {
                                            setState(() {
                                              address =
                                                  "${_addressController.text},${cityValue.toString().isNotEmpty ? cityValue : cityname}, ${countryValue.toString().isNotEmpty ? countryValue : countryname},${_pincodeController.text}"; //${stateValue.toString().isNotEmpty ? stateValue : ''}
                                              print("address:$address");
                                            });

                                            List<Location> locations =
                                                await locationFromAddress(
                                                    address);
                                            debugPrint(
                                                "Address to Lat long ${locations.first.latitude} : ${locations.first.longitude}");
                                            Prefs.setString(
                                                "ProfileAddress", address);
                                            Prefs.setDouble("Latitude",
                                                locations.first.latitude);
                                            Prefs.setDouble("Longitude",
                                                locations.first.longitude);

                                            final bool? isValid = _formKey
                                                .currentState
                                                ?.validate();

                                            print("isvalid$isValid");
                                            if (isValid == true) {
                                              // print(myProvider.useraddress);

                                              _profilebloc
                                                  .add(ProfileLoadingEvent());
                                              _profilebloc.add(
                                                  updateProfileEvent(
                                                      userprofilerequest:
                                                          UpdateuserProfileRequest(
                                                id: widget.userid,
                                                address:
                                                    _addressController.text,
                                                city: cityValue,
                                                country: countryValue,
                                                pincode:
                                                    _pincodeController.text,
                                                name: validationProvider
                                                    .name.value,
                                                lat:
                                                    Prefs.getDouble("Latitude"),
                                                long: Prefs.getDouble(
                                                    "Longitude"),
                                              )));
                                            }
                                          },
                                          child: const Text(
                                            'Update',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  FontName.poppinsMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    : Container(),
          );
        }),
      ),
    );
  }

// void getCountriesName(List<Country> countrylist) {
//   for (Country countryname in countrylist) {
//     //  countryarr = countryname.name.toString();
//     countryarr.add(countryname.name.toString());
//     // Text(countryname.name.toString());
//
//     print("countryarr:${countryarr}");
//   }
// }

// String? getcountrycodebyid(String countryname) {
//   String? countrycode;
//   for (Country objcountry in widget.countrylist) {
//     if (countryname == objcountry.name.toString()) {
//       countrycode = objcountry.code.toString();
//
//       print("countrycode: " + countrycode);
//       _profilebloc.add(GetstatesDropdownEvent(countrycode: countrycode));
//       break;
//     }
//   }
//   return countrycode;
// }
}
