import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ui/api/categoryListAPI.dart';
import 'package:ui/api/userRole/change_user_role.dart';
import 'package:ui/config/const.dart';
import 'package:ui/config/images.dart';
import 'package:ui/model/categorylistModel.dart';
import 'package:ui/model/designation_list_model.dart';
import 'package:ui/model/search/management_list_model.dart';
import 'package:ui/utils/utils_file.dart';
import '../api/designation_list_api.dart';

class ManagementProfileInfo extends StatefulWidget {
  final ManagementList managementList;
  final String role;

  const ManagementProfileInfo({
    super.key,
    required this.managementList,
    required this.role,
  });

  @override
  State<ManagementProfileInfo> createState() => _ManagementProfileInfoState();
}

class _ManagementProfileInfoState extends State<ManagementProfileInfo> {
  List<UserRole> userRole = [
    UserRole('Admin', 1),
  ];

  int currentRole = 1;
  int teachingTypeInfo = 0;
  int managementType = 0;

  List<DesignationList> managementTypeList = [];
  List<Class_> categoryListStaff = [];
  List<Category> teachingType = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await getDesignationList().then((value) {
      if (value != null) {
        setState(() {
          managementTypeList = value;
        });
      }
    });

    await getCategoryList().then((value) {
      if (value != null) {
        setState(() {
          categoryListStaff = value;
        });
      }
    });
    await getTeacherCategoryList().then((value) {
      if (value != null) {
        setState(() {
          teachingType = value;
        });
      }
    });
  }

  Future<bool> goBack() async {
    Navigator.pop(context, true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 1314;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Text("Management Profile Information",
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 21 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 0.9152272542 * ffem / fem,
                    letterSpacing: 1.4 * fem,
                    color: const Color(0xff575757),
                  ))),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.blueGrey,
                Colors.blueGrey,
                Colors.transparent,
                Colors.transparent
              ])),
              height: 0.3,
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: widget.managementList.profileImage == ''
                        ? Image.asset(
                            'assets/images/profile.png',
                            width: 88.28 * fem,
                            height: 81 * fem,
                          )
                        : ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: Image.network(
                              widget.managementList.profileImage,
                              width: 81.28 * fem,
                              height: 88 * fem,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/profile.png',
                                  width: 88.28 * fem,
                                  height: 81 * fem,
                                );
                              },
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      "Name : ",
                      style: TextStyle(
                          color: Color(0xff575757),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.managementList.firstName,
                      style: const TextStyle(
                          color: Color(0xff575757),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height * 0.42,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.blue.withOpacity(0.2), BlendMode.dstATop),
                        image: const AssetImage(Images.bgImage),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: [
                        ListTile(
                          title: const Text(
                            "Mobile Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff575757)),
                          ),
                          subtitle: Text(
                              widget.managementList.mobileNumber.toString()),
                        ),
                        ListTile(
                          title: const Text(
                            "Email address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff575757)),
                          ),
                          subtitle:
                              Text(widget.managementList.emailId.toString()),
                        ),
                        // ticket no :- 92
                        ListTile(
                          title: const Text(
                            "Date of Birth",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff575757)),
                          ),
                          subtitle: Text(widget.managementList.dob == ''
                              ? "N/A"
                              : widget.managementList.dob),
                        ),
                        ListTile(
                            title: const Text(
                              "Employee Number",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                            subtitle: Text(widget.managementList.employeeNo ==
                                    ''
                                ? "N/A"
                                : widget.managementList.employeeNo.toString())),
                        ListTile(
                            title: const Text(
                              "Date Of Joining",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                            subtitle: Text(widget.managementList.doj == ''
                                ? "N/A"
                                : widget.managementList.doj)),

                        ListTile(
                            title: const Text(
                              "Designation",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                            trailing: widget.role.toUpperCase() == "MANAGEMENT"
                                ? IconButton(
                                    onPressed: () {
                                      _showAlertDialog();
                                    },
                                    icon: const Icon(
                                      Icons.manage_accounts,
                                      color: Colors.black,
                                    ))
                                : null,
                            subtitle: Text(
                                widget.managementList.designation == ''
                                    ? "N/A"
                                    : widget.managementList.designation)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  _snackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<dynamic> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade100,
              actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
              contentPadding: const EdgeInsets.all(10),
              titlePadding: const EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: const Text(
                'Change User Role ?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              actions: [
                TextButton(
                  style: buttonStyle,
                  child: const Text('Save'),
                  onPressed: () async {
                    await changeUserRole('5', widget.managementList.userId,
                            currentRole.toString(), managementType.toString())
                        .then((value) {
                      if (value != null) {
                        _snackBar(value['message']);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        _snackBar(
                            'Error in Changing role Please try again Later');
                      }
                    });
                  },
                ),
              ],
              content: SingleChildScrollView(
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width,
                      child: FormBuilderDropdown(
                        initialValue: currentRole,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            label: Text('user role'),
                            border: InputBorder.none,
                            floatingLabelStyle: TextStyle(color: Colors.grey)),
                        name: '',
                        items: userRole.map<DropdownMenuItem<dynamic>>((item) {
                          return DropdownMenuItem(
                            value: item.value,
                            child: Text(item.role),
                            onTap: () {
                              setState(() {
                                currentRole = item.value;
                                teachingTypeInfo = 0;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    currentRole == 5
                        ? Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            child: FormBuilderDropdown(
                              initialValue:
                                  widget.managementList.designation == ''
                                      ? null
                                      : widget.managementList.designation,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  label: Text('Management Designation'),
                                  border: InputBorder.none,
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.grey)),
                              name: '',
                              items: managementTypeList
                                  .map<DropdownMenuItem<dynamic>>((item) {
                                return DropdownMenuItem(
                                  value: item.categoryName,
                                  child: Text(item.categoryName),
                                  onTap: () {
                                    setState(() {
                                      managementType = item.id;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        : Visibility(visible: false, child: Container()),
                    currentRole == 2
                        ? Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            width: MediaQuery.of(context).size.width,
                            child: FormBuilderDropdown(
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  label: Text('Staff Type'),
                                  border: InputBorder.none,
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.grey)),
                              name: '',
                              items: teachingType
                                  .map<DropdownMenuItem<dynamic>>((item) {
                                return DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.categoryName),
                                  onTap: () {
                                    setState(() {
                                      managementType = item.id;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class UserRole {
  final String role;
  final int value;

  UserRole(this.role, this.value);
}
