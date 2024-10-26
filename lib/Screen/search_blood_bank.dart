// ignore_for_file: use_build_context_synchronously

import 'package:blood_donation/Screen/blood_bank_search_list.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:blood_donation/data/district_data.dart';
import 'package:blood_donation/api/api.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchBloodBank extends StatefulWidget {
  const SearchBloodBank({super.key});

  @override
  State<SearchBloodBank> createState() => _SearchBloodBankState();
}

class _SearchBloodBankState extends State<SearchBloodBank>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final UserProvider userProvider; // Declare userProvider
  // for input ambulance data
  bool phoneNumberError = false;
  TextEditingController nameCont = TextEditingController();
  TextEditingController wardNoCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  String? selectProvince;
  String? selectDistrict;
  String? selectLocalLevel;
  //

  String? selectedProvince;
  String? selectedDistrict;
  String? selectedLocalLevel;
  TextEditingController wardNoController = TextEditingController();
  int searchResultcount = 0;
  bool isLoading = false;

  searchBloodBank() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    var data = {
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text,
    };

    var res = await CallApi().searchBloodBank(
        data, 'loadBloodBankInfo'); //test is table name for api
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);

      // Extract the count from the parsed JSON
      final count = jsonResponse['count'];

      setState(() {
        searchResultcount = count;
        isLoading = false;
      });
    } else {
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );

      isLoading = false;
    }
  }

// ADDING NEW BLOOD BANK DATA
  regBloodBank() async {
    var data = {
      'name': nameCont.text.trim(),
      'province': selectProvince,
      'district': selectDistrict,
      'localLevel': selectLocalLevel,
      'wardNo': wardNoCont.text.trim(),
      'contactNo': phoneCont.text.trim(),
      'doId': userProvider.donorId,
      'userId': userProvider.userId
    };

    var response = await CallApi().addBloodBank(data, 'regBloodBank');

    // Handle the response
    if (response.statusCode == 200) {
      CustomSnackBar.showSuccess(
        context: context,
        message: 'Blood bank data added successfully',
        icon: Icons.check_circle,
      );
      resetDropdowns();
    } else if (response.statusCode == 400) {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: 'Submission failed. Your account type is member',
        icon: Icons.error,
      );
    } else if (response.statusCode == 400) {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: 'Submission failed. something went wrong',
        icon: Icons.error,
      );
    } else {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: 'Internal Server Error: Something went wrong',
        icon: Icons.error,
      );
    }
  }
//ENDS HERE

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    // Fetch matched results when the widget is created
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
  }

  void _handleTabChange() {
    setState(() {});
    if (_tabController.index == 0) {
      resetDropdowns();
    } else if (_tabController.index == 1) {
      resetSearchDropdowns();
    }
  }

  resetDropdowns() {
    setState(() {
      nameCont.clear();
      wardNoCont.clear();
      phoneCont.clear();
      selectProvince = null;
      selectDistrict = null;
      selectLocalLevel = null;
    });
  }

  resetSearchDropdowns() {
    selectedProvince = null;
    selectedDistrict = null;
    selectedLocalLevel = null;
    wardNoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    super.build(context);
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFD3B5B5),
        body: Stack(
          children: <Widget>[
            Container(
              height: 0.45 * sh,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF00808),
                    Color(0xffBF371A),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.25 * sh),
                  bottomRight: Radius.circular(0.5 * sh),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.05 * sw,
                vertical: 0.05 * sh,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.05 * sh),
                    topRight: Radius.circular(0.05 * sh),
                    bottomLeft: Radius.circular(0.05 * sh),
                    bottomRight: Radius.circular(0.05 * sh),
                  ),
                ),
                child: Column(children: [
                  Container(
                    // Set to transparent
                    padding: EdgeInsets.only(
                        top: 0.02 * sh,
                        bottom: 0.02 * sh,
                        left: 0.02 * sw,
                        right: 0.02 * sw),

                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.03 * sh),
                        color: const Color(0xffFF0025),
                      ),
                      controller: _tabController,
                      //    isScrollable: true, // Make tabs scrollable
                      indicatorSize: TabBarIndicatorSize
                          .tab, // Use indicator size based on tab size
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            "Search Blood Bank",
                            style: TextStyle(
                              color: _tabController.index == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Add Blood Bank",
                            style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        physics:
                            const NeverScrollableScrollPhysics(), // prevenet screen to swipe left or right
                        children: [
                          SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //HEADER
                                  Padding(
                                    padding: EdgeInsets.only(top: 0.04 * sh),
                                    child: Container(
                                        height: 0.04 * sh,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFF0025),
                                          borderRadius: BorderRadius.only(),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Search Blood Bank Info By',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 0.025 * sh,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  ),

                                  //SEARCH BY Group
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.04 * sw,
                                        right: 0.04 * sw,
                                        top: 0.04 * sw),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        //DROPDOWN PROVINCE
                                        DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff858585)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff858585)),
                                            ),
                                            hintText: 'Select Province',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(0xff858585)),
                                          ),
                                          value: selectedProvince,
                                          items: [
                                            '1',
                                            '2',
                                            '3',
                                            '4',
                                            '5',
                                            '6',
                                            '7'
                                          ].map((province) {
                                            return DropdownMenuItem<String>(
                                              value: province,
                                              child: Text(
                                                'Province $province',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProvince = value;
                                              // Reset selected values for subsequent dropdowns
                                              selectedDistrict = null;
                                              selectedLocalLevel = null;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 0.02 * sh),

                                        // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
                                        DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff858585)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff858585)),
                                            ),
                                            hintText: 'Select District',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(0xff858585)),
                                          ),
                                          value: selectedDistrict,
                                          items: selectedProvince != null
                                              ? DistrictData.districtList[
                                                      selectedProvince!]!
                                                  .map((district) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: district,
                                                    child: Text(
                                                      district,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  );
                                                }).toList()
                                              : [],
                                          onChanged: (value) {
                                            setState(() {
                                              selectedDistrict = value;
                                              selectedLocalLevel = null;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 0.02 * sh),

                                        // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                                        DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff858585)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff858585)),
                                            ),
                                            hintText: 'Select Local Level',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(0xff858585)),
                                          ),
                                          value: selectedLocalLevel,
                                          items: selectedDistrict != null
                                              ? DistrictData.localLevelList[
                                                      selectedDistrict!]!
                                                  .map((locallevel) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: locallevel,
                                                    child: Text(
                                                      locallevel,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  );
                                                }).toList()
                                              : [],
                                          onChanged: (value) {
                                            setState(() {
                                              selectedLocalLevel = value;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 0.02 * sh),

                                        TextField(
                                          controller: wardNoController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: "Ward No.",
                                            errorText: (wardNoController
                                                        .text.isNotEmpty &&
                                                    int.tryParse(
                                                            wardNoController
                                                                .text)! >
                                                        33)
                                                ? 'Ward number cannot be greater than 33'
                                                : null,
                                            hintStyle: const TextStyle(
                                                color: Color(0xff858585)),
                                          ),
                                          maxLength: 2,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Allow only digits
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // end of selection search

                                  // Making Search button
                                  SizedBox(height: 0.02 * sh),
                                  Container(
                                    height: 0.05 * sh,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0.2 * sw),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(0.05 * sh),
                                      color: const Color(0xffFF0025),
                                    ),
                                    //calling insert function when button is pressed
                                    child: InkWell(
                                      onTap: () {
                                        if (selectedProvince == null) {
                                        } else {
                                          searchBloodBank();
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "Search Now",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 0.02 * sh),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // search button end
                                  //search results start

                                  SizedBox(height: 0.02 * sh),
                                  Text(
                                    'Searched results', // import total members from database
                                    style: TextStyle(
                                      fontSize: 0.015 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xff858585),
                                    ),
                                  ),

                                  SizedBox(height: 0.005 * sh),

                                  Text(
                                    '$searchResultcount', // import count number from database as per matched query
                                    style: TextStyle(
                                      fontSize: 0.04 * sh,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xffFF0025),
                                    ),
                                  ),

                                  SizedBox(height: 0.005 * sh),
                                  Container(
                                    height: 0.025 * sh,
                                    width: 0.4 * sw,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0.03 * sw),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(0.05 * sh),
                                      color: const Color(0xffFF0025),
                                    ),
                                    //calling insert function when button is pressed

                                    child: InkWell(
                                      onTap: searchResultcount != 0
                                          ? () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BloodBankSearchList(
                                                    searchCriteriaData: {
                                                      'province':
                                                          selectedProvince,
                                                      'district':
                                                          selectedDistrict,
                                                      'localLevel':
                                                          selectedLocalLevel,
                                                      'wardNo':
                                                          wardNoController.text,
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
                                      child: Center(
                                        child: Text(
                                          "View Search Results",
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 0.015 * sh,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.white,
                                            decorationThickness: 0.002 * sh,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ENDING OF ALL  WORKS
                                ]),
                          ),

                          // FOR ADD NEW BLOOD BANK INFO
                          SingleChildScrollView(
                            child: Column(children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 0.05 * sw,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 0.005 * sh),
                                      Text(
                                        '[Note: Only Admins are allow to fill the new blood bank details form.]',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFF44336),
                                          fontSize: 0.02 * sh,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),

                                      SizedBox(height: 0.005 * sh),
                                      TextField(
                                        controller: nameCont,
                                        decoration: const InputDecoration(
                                          hintText: "*Blood Bank Name",
                                          hintStyle: TextStyle(
                                              color: Color(0xff858585)),
                                        ),
                                        maxLength: 30,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^[a-zA-Z ]+$'), // Regular expression pattern for English alphabets and space
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 0.005 * sh),

                                      //DROPDOWN PROVINCE
                                      DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff858585)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff858585)),
                                          ),
                                          hintText: '*Select Province',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color(0xff858585)),
                                        ),
                                        value: selectProvince,
                                        items: [
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                          '6',
                                          '7'
                                        ].map((province) {
                                          return DropdownMenuItem<String>(
                                            value: province,
                                            child: Text(
                                              'Province $province',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectProvince = value;
                                            // Reset selected values for subsequent dropdowns
                                            selectDistrict = null;
                                            selectLocalLevel = null;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 0.03 * sh),

                                      // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
                                      DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff858585)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff858585)),
                                          ),
                                          hintText: '*Select District',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color(0xff858585)),
                                        ),
                                        value: selectDistrict,
                                        items: selectProvince != null
                                            ? DistrictData
                                                .districtList[selectProvince!]!
                                                .map((district) {
                                                return DropdownMenuItem<String>(
                                                  value: district,
                                                  child: Text(
                                                    district,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              }).toList()
                                            : [],
                                        onChanged: (value) {
                                          setState(() {
                                            selectDistrict = value;
                                            selectLocalLevel = null;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 0.03 * sh),

                                      // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                                      DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff858585)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff858585)),
                                          ),
                                          hintText: '*Select Local Level',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color(0xff858585)),
                                        ),
                                        value: selectLocalLevel,
                                        items: selectDistrict != null
                                            ? DistrictData.localLevelList[
                                                    selectDistrict!]!
                                                .map((locallevel) {
                                                return DropdownMenuItem<String>(
                                                  value: locallevel,
                                                  child: Text(
                                                    locallevel,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              }).toList()
                                            : [],
                                        onChanged: (value) {
                                          setState(() {
                                            selectLocalLevel = value;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 0.025 * sh),

                                      TextField(
                                        controller: wardNoCont,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "*Ward No.",
                                          errorText: (wardNoCont
                                                      .text.isNotEmpty &&
                                                  int.tryParse(
                                                          wardNoCont.text)! >
                                                      33)
                                              ? 'Ward number cannot be greater than 33'
                                              : null,
                                          hintStyle: const TextStyle(
                                              color: Color(0xff858585)),
                                        ),
                                        maxLength: 2,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly, // Allow only digits
                                        ],
                                      ),

                                      TextField(
                                        controller: phoneCont,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "*Phone No.",
                                          errorText: phoneCont.text.isEmpty
                                              ? null
                                              : (phoneNumberError
                                                  ? 'Phone number must be 10 digits'
                                                  : null),
                                          hintStyle: const TextStyle(
                                            color: Color(0xff858585),
                                          ),
                                        ),
                                        maxLength: 10,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(
                                              10), // Ensures maxLength is respected
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            // Check if the length of phone number is not 10
                                            phoneNumberError =
                                                value.length != 10;
                                          });
                                        },
                                      ),

                                      // Making Add button
                                      SizedBox(height: 0.02 * sh),
                                      Container(
                                        height: 0.05 * sh,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0.2 * sw),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0.05 * sh),
                                          color: const Color(0xffFF0025),
                                        ),
                                        //calling insert function when button is pressed
                                        child: InkWell(
                                          onTap: () {
                                            validationFields();
                                          },
                                          child: Center(
                                            child: Text(
                                              "Add Data",
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 0.02 * sh),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 0.03 * sh),
                                    ],
                                  )),
                            ]),
                          ),
                        ]),
                  ),
                ]),
              ),
            ),

            // circular progress bar
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.red), // Color of the progress indicator
                  strokeWidth: 0.01 * sw, // Thickness of the progress indicator
                  backgroundColor: Colors.black.withOpacity(
                      0.5), // Background color of the progress indicator
                ),
              ),
          ],
        ));
  }

  void validationFields() {
    setState(() {
      isLoading = true;
    });
    // Define a regular expression to match only numbers
    RegExp numericRegex = RegExp(r'^[0-9]+$');
    if (nameCont.text.trim() != '' &&
        selectProvince != null &&
        selectDistrict != null &&
        selectLocalLevel != null &&
        wardNoCont.text.trim() != '' &&
        wardNoCont.text.trim() != '0' &&
        phoneCont.text.trim() != '' &&
        phoneNumberError == false &&
        (wardNoCont.text.isEmpty ||
            (wardNoCont.text.isNotEmpty &&
                int.tryParse(wardNoCont.text)! <= 33))) {
      if (numericRegex.hasMatch(phoneCont.text.trim())) {
        regBloodBank();
        isLoading = false;
      } else {
        CustomSnackBar.showUnsuccess(
            context: context,
            message: "Contact number should contain only numbers.",
            icon: Icons.info);
        isLoading = false;
      }
    } else {
      CustomSnackBar.showUnsuccess(
          context: context,
          message: "Please fill all fields correctly.",
          icon: Icons.info);
      isLoading = false;
    }
  }
}
