import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:ui/api/designation_list_api.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/api/search/change_user_status.dart';
import 'package:ui/api/search/get_admin_list_api.dart';
import 'package:ui/api/search/get_student_list_api.dart';
import 'package:ui/api/search_parent_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/model/search/staff_list_model.dart';
import 'package:ui/model/search_parent_model.dart';
import 'package:ui/model/settings/index.dart';
import 'package:ui/widget/parent_info.dart';
import 'package:ui/widget/search_profile_admin.dart';
import 'package:ui/widget/search_profile_management.dart';
import 'package:ui/widget/search_profile_student.dart';
import 'package:ui/widget/staff_info.dart';
import 'package:ui/widget/users/add_edit_admin.dart';
import 'package:ui/widget/users/add_edit_management.dart';
import 'package:ui/widget/users/add_edit_parent.dart';
import 'package:ui/widget/users/add_edit_staff.dart';
import '../../api/search/get_management_list_api.dart';
import '../../api/search_staff_api.dart';
import '../../config/const.dart';
import '../../model/search/admin_list_model.dart';
import '../../model/search/student_list_model.dart';
import 'package:ui/model/search/management_list_model.dart';

import '../../widget/users/add_edit_student.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearch = false;
  String searchText = '';
  String currentTab = 'Parent';
  TextEditingController controller = TextEditingController();
  Iterable<StaffSearchList>? listOfStaff;
  Iterable<ParentSearchList>? listOfParents;
  Iterable<StudentList>? listOfStudent;
  Iterable<ManagementList>? listOfManagement;
  Iterable<AdminList>? listOfAdmin;

  String parentName = '';
  String url = 'data';

  int pageNumber = 1;
  int userStatus = 0;
  List<StudentList> studentListData = [];
  List<StaffSearchList> staffListData = [];
  List<ParentSearchList> parentListData = [];
  ParentSearchList? count;
  List<AdminList> adminListData = [];
  List<ManagementList> managementListData = [];

  final ScrollController staffController = ScrollController();
  final ScrollController studentController = ScrollController();
  final ScrollController parentController = ScrollController();
  final ScrollController adminController = ScrollController();
  final ScrollController managementController = ScrollController();

  int totalRecord = 0;

  @override
  void initState() {
    super.initState();
    parentsList();
    initialize();
  }

  void loadAdminData() {
    clearData();
    adminList();
  }

  void loadManagementData() {
    clearData();
    managementList();
  }

  void loadStaffData() {
    clearData();
    staffList();
  }

  void loadStudentData() {
    clearData();
    studentList();
  }

  void loadParentData() {
    clearData();
    parentsList();
  }

  List<DesignationList> managementTypeList = [];

  void initialize() async {
    staffController.addListener(() {
      if (staffController.position.pixels ==
          staffController.position.maxScrollExtent) {
        if (listOfStaff!.length != totalRecord) {
          if (pageNumber != 0) {
            _loadNextPage(staffList);
          }
        }
      }
    });
    studentController.addListener(() {
      if (studentController.position.pixels ==
          studentController.position.maxScrollExtent) {
        if (listOfStudent!.length != totalRecord) {
          if (pageNumber != 0) {
            _loadNextPage(studentList);
          }
        }
      }
    });
    parentController.addListener(() {
      if (parentController.position.pixels ==
          parentController.position.maxScrollExtent) {
        if (listOfParents!.length != totalRecord) {
          if (pageNumber != 0) {
            _loadNextPage(parentsList);
          }
        }
      }
    });
    adminController.addListener(() {
      if (adminController.position.pixels ==
          adminController.position.maxScrollExtent) {
        if (listOfAdmin!.length != totalRecord) {
          if (pageNumber != 0) {
            _loadNextPage(adminList);
          }
        }
      }
    });
    managementController.addListener(() {
      if (managementController.position.pixels ==
          managementController.position.maxScrollExtent) {
        if (listOfManagement!.length != totalRecord) {
          if (pageNumber != 0) {
            _loadNextPage(managementList);
          }
        }
      }
    });
    await getDesignationList().then((value) {
      if (value != null) {
        setState(() {
          managementTypeList = value;
        });
      }
    });
  }

  Future<void> staffList() async {
    await getStaffList(pageNumber).then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
          staffListData = value.data;
          listOfStaff = staffListData;
          totalRecord = value.total;
          url = value.nextPageUrl;
          switch (userStatus) {
            case 1:
              {
                var newFilteredStaffList = listOfStaff!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfStaff = newFilteredStaffList;
                filter = true;
              }
              break;
            case 2:
              {
                var newFilteredStaffList = listOfStaff!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfStaff = newFilteredStaffList;
                filter = true;
              }
          }
        });
      }
    });
  }

  void parentsList() async {
    await getParentList(pageNumber).then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
          parentListData = value.data;
          listOfParents = parentListData;
          totalRecord = value.total;
          switch (userStatus) {
            case 1:
              {
                var newFilteredStaffList = listOfParents!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfParents = newFilteredStaffList;
                filter = true;
              }
              break;
            case 2:
              {
                var newFilteredStaffList = listOfParents!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfParents = newFilteredStaffList;
                filter = true;
              }
          }
        });
      }
    });
  }

  Future<void> managementList() async {
    await getManagementList(pageNumber).then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
          managementListData = value.data;
          listOfManagement = managementListData;
          totalRecord = value.total;
          switch (userStatus) {
            case 1:
              {
                var newFilteredStaffList = listOfManagement!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfManagement = newFilteredStaffList;
                filter = true;
              }
              break;
            case 2:
              {
                var newFilteredStaffList = listOfManagement!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfManagement = newFilteredStaffList;
                filter = true;
              }
          }
        });
      }
    });
  }

  Future<void> studentList() async {
    await getStudentList(pageNumber).then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
          studentListData = value.data;
          listOfStudent = studentListData;
          totalRecord = value.total;
          switch (userStatus) {
            case 1:
              {
                var newFilteredStaffList = listOfStudent!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfStudent = newFilteredStaffList;
                filter = true;
              }
              break;
            case 2:
              {
                var newFilteredStaffList = listOfStudent!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfStudent = newFilteredStaffList;
                filter = true;
              }
          }
        });
      }
    });
  }

  Future<void> adminList() async {
    await getAdminList(pageNumber).then((value) {
      if (value != null) {
        setState(() {
          isLoading = false;
          adminListData = value.data;
          listOfAdmin = adminListData;
          totalRecord = value.total;
          switch (userStatus) {
            case 1:
              {
                var newFilteredStaffList = listOfAdmin!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfAdmin = newFilteredStaffList;
                filter = true;
              }
              break;
            case 2:
              {
                var newFilteredStaffList = listOfAdmin!
                    .where((element) => element.userStatus == userStatus)
                    .toList();
                listOfAdmin = newFilteredStaffList;
                filter = true;
              }
          }
        });
      }
    });
  }

  void _loadNextPage(Function callback) {
    setState(() {
      isLoading = true;
      pageNumber++;
    });
    callback();
  }

  void nextPage(Function callback, int number) {
    setState(() {
      isLoading = true;
      pageNumber == number;
    });
    callback();
  }

  Future<bool> activeInactiveUser(
      int id, String name, String number, String role) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(id == 1 ? 'Deactivate User' : 'Activate User'),
            content: Text(id == 1
                ? 'Do you want to Deactivate $name User?'
                : "Do you want to Activate $name User?"),
            actions: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  if (id != 1) {
                    activateAnyUser(number, '1', role).then((value) {
                      if (value != null) {
                        _snackBar(value['message']);
                        clearData();
                        refreshData();
                        Navigator.pop(context);
                      } else {
                        _snackBar("SomeThing Went Wrong");
                      }
                    });
                  } else {
                    Navigator.pop(context);
                    deactivateUser(id, name, number, role);
                  }
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> deactivateUser(
      int id, String name, String number, String role) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(id == 1 ? 'Deactivate App  User' : 'Activate App User'),
            content: Text(id == 1
                ? 'Do you want to Deactivate App for $name User?'
                : "Do you want to Activate App for $name User?"),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  await changeUserStatus(number, '2', role, 'no').then((value) {
                    if (value != null) {
                      _snackBar(value['message']);
                      clearData();
                      refreshData();

                      Navigator.pop(context);
                    } else {
                      _snackBar("SomeThing Went Wrong");
                    }
                  });
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () async {
                  await changeUserStatus(number, '2', role, 'yes')
                      .then((value) {
                    if (value != null) {
                      _snackBar(value['message']);
                      clearData();
                      refreshData();
                      Navigator.pop(context);
                    } else {
                      _snackBar("SomeThing Went Wrong");
                    }
                  });
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> deactivateStudent(
      int id, String name, String number, String userId) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(id == 1 ? 'Deactivate App User' : 'Activate App User'),
            content: Text(id == 1
                ? 'Do you want to Deactivate App for $name User?'
                : "Do you want to Activate App for $name User?"),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  await changeUserStatusStudent('2', userId, 'no')
                      .then((value) {
                    if (value != null) {
                      _snackBar(value['message']);
                      clearData();
                      refreshData();
                      Navigator.pop(context);
                    } else {
                      _snackBar("SomeThing Went Wrong");
                    }
                  });
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () async {
                  await changeUserStatusStudent('2', userId, 'yes')
                      .then((value) {
                    if (value != null) {
                      _snackBar(value['message']);
                      clearData();
                      refreshData();

                      Navigator.pop(context);
                    } else {
                      _snackBar("SomeThing Went Wrong");
                    }
                  });
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> activeInactiveStudent(
      int id, String name, String number, String userId) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(id == 1 ? 'Deactivate User' : 'Activate User'),
            content: Text(id == 1
                ? 'Do you want to Deactivate $name User?'
                : "Do you want to Activate $name User?"),
            actions: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  if (id != 1) {
                    changeUserStatusStudent('1', userId, '').then((value) {
                      if (value != null) {
                        _snackBar(value['message']);
                        clearData();
                        refreshData();

                        Navigator.pop(context);
                      } else {
                        _snackBar("SomeThing Went Wrong");
                      }
                    });
                  } else {
                    Navigator.pop(context);
                    deactivateStudent(id, name, number, userId);
                  }
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  _snackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool filter = false;
  bool isLoading = false;
  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  var colorizeTextStyle = GoogleFonts.acme(
    fontSize: 27,
  );

  void clearData() {
    setState(() {
      userStatus = 0;
      listOfManagement = null;
      managementListData = [];
      listOfStudent = null;
      studentListData = [];
      listOfParents = null;
      parentListData = [];
      listOfStaff = null;
      staffListData = [];
      listOfAdmin = null;
      adminListData = [];
      pageNumber = 1;
    });
  }

  void refreshData() async {
    switch (currentTab) {
      case 'Student':
        {
          studentList();
        }
        break;
      case 'Parent':
        {
          parentsList();
        }
        break;
      case 'Staff':
        {
          staffList();
        }
        break;
      case 'Management':
        {
          managementList();
        }
        break;
      case 'Admin':
        {
          adminList();
        }
    }
  }

  Widget dynamicWidget = AddEditParentPage(
    userModel: ParentSearchList.parentModelData,
    callback: () {},
    isEdit: false,
  );

  void dynamicAddController() async {
    setState(() {
      switch (currentTab) {
        case 'Student':
          {
            dynamicWidget = AddEditAdminPage(
              userModel: AdminList.adminModelData,
              callback: loadAdminData,
              isEdit: false,
            );
          }
          break;
        case 'Parent':
          {
            dynamicWidget = AddEditParentPage(
              userModel: ParentSearchList.parentModelData,
              callback: loadParentData,
              isEdit: false,
            );
          }
          break;
        case 'Staff':
          {
            dynamicWidget = AddEditStaffPage(
              userModel: StaffSearchList.staffModelData,
              callBack: loadStaffData,
              isEdit: false,
            );
          }
          break;
        case 'Management':
          {
            dynamicWidget = AddEditManagementPage(
              userModel: ManagementList.managementModelData,
              callback: loadManagementData,
              isEdit: false,
            );
          }
          break;
        case 'Admin':
          {
            dynamicWidget = AddEditAdminPage(
              userModel: AdminList.adminModelData,
              callback: loadAdminData,
              isEdit: false,
            );
          }
      }
    });
  }

  Future<bool> profileInfo(
    StaffSearchList staffSearchList,
    ProfileModel profile,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StaffProfileInfo(
                          staffProfile: staffSearchList, profileModel: profile),
                    ),
                  ),
                )) ??
        false;
  }

  Future<bool> adminProfileInfo(
    AdminList adminSearchList,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: AdminProfileInfo(
                        adminList: adminSearchList,
                        role: '1',
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  Future<bool> addEditUserPopUp(
    Widget dynamicPageWidget,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Add $currentTab"),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: dynamicPageWidget),
                )) ??
        false;
  }

  Future<bool> managementProfileInfo(
    ManagementList managementList,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ManagementProfileInfo(
                        managementList: managementList,
                        role: 'Admin',
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  Future<bool> studentProfileInfo(
    StudentList studentList,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StudentProfileInfo(
                        studentList: studentList,
                      ),
                    ),
                  ),
                )) ??
        false;
  }

  Future<bool> parentProfileInfo(
    ParentSearchList parentSearchList,
    ProfileModel profile,
  ) async {
    return await showDialog(
            context: context,
            builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ParentProfileInfo(
                          parentProfile: parentSearchList,
                          profileModel: profile),
                    ),
                  ),
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.2), BlendMode.dstATop),
              image: const AssetImage(Images.bgImage),
              repeat: ImageRepeat.repeat),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Search",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black26)),
                    child: TextField(
                      onTap: () {
                        setState(() {
                          isSearch = !isSearch;
                          clearData();
                          pageNumber = 0;
                          refreshData();
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                          switch (currentTab) {
                            case 'Student':
                              {
                                searchStudent();
                              }
                              break;
                            case 'Parent':
                              {
                                searchNumber();
                              }
                              break;
                            case 'Staff':
                              {
                                searchTeacher();
                              }
                              break;
                            case 'Management':
                              {
                                searchManagement();
                              }
                              break;
                            case 'Admin':
                              {
                                searchAdmin();
                              }
                          }
                        });
                      },
                      controller: controller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: !isSearch
                                ? Colors.black38
                                : Colors.grey.shade600,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: !isSearch
                                  ? Colors.black38
                                  : Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                controller.clear();
                                searchText = '';
                                isSearch = !isSearch;
                              });
                            },
                          ),
                          hintText: 'Search...',
                          contentPadding: const EdgeInsets.all(10),
                          hintStyle: TextStyle(
                            color: !isSearch
                                ? Colors.black38
                                : Colors.grey.shade600,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total Users: $totalRecord  ",
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      SizedBox(
                          width: 40,
                          child: PopupMenuButton<int>(
                            icon: Icon(!filter
                                ? Icons.filter_alt
                                : Icons.filter_alt_off),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  clearData();
                                  setState(() {
                                    userStatus = 1;
                                    refreshData();
                                  });
                                },
                                value: 1,
                                child: const Text("Active Users"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  clearData();
                                  setState(() {
                                    userStatus = 2;
                                    refreshData();
                                  });
                                },
                                value: 2,
                                child: const Text("DeActive  User"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  clearData();
                                  setState(() {
                                    userStatus = 0;
                                    filter = false;
                                    refreshData();
                                  });
                                },
                                value: 2,
                                child: const Text("Cancel"),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: 40,
                        child: FormBuilderDropdown(
                          name: 'Staff',
                          initialValue: currentTab,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          items: [
                            "Staff",
                            "Parent",
                            "Admin",
                            "Management",
                            "Student"
                          ].map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              onTap: () {
                                setState(() {
                                  clearData();
                                  currentTab = item;
                                  refreshData();
                                  dynamicAddController();
                                });
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    item,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (currentTab != 'Student' && currentTab != 'Parent')
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              style: buttonStyle,
                              onPressed: () {
                                addEditUserPopUp(dynamicWidget);
                              },
                              label: Text("Add $currentTab")),
                        )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.83,
              width: double.infinity,
              child: Builder(
                builder: (ctx) {
                  switch (currentTab) {
                    case 'Student':
                      return listOfStudent == null
                          ? LoadingAnimator()
                          : studentListData.isEmpty
                              ? Center(
                                  child: Lottie.asset(
                                    Animations.noData,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    repeat: true,
                                    reverse: true,
                                    animate: true,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.83,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.blue.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: const AssetImage(Images.bgImage),
                                        repeat: ImageRepeat.repeat),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: studentController,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: DataTable(
                                              showCheckboxColumn: false,
                                              border: TableBorder.all(
                                                  color: Colors.black26),
                                              sortAscending: true,
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'No',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Class Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Roll Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Admission Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Gender',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                for (int i = 0;
                                                    i < listOfStudent!.length;
                                                    i++)
                                                  DataRow(
                                                      onSelectChanged: (value) {
                                                        studentProfileInfo(
                                                            listOfStudent!
                                                                .elementAt(i));
                                                      },
                                                      cells: [
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                          child: Text(
                                                            "${int.parse("${pageNumber - 1}$i") + 1}",
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStudent!
                                                                .elementAt(i)
                                                                .firstName
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStudent!
                                                                .elementAt(i)
                                                                .studentListClass
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStudent!
                                                                .elementAt(i)
                                                                .rollNumber
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStudent!
                                                                .elementAt(i)
                                                                .admissionNumber
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStudent!
                                                                        .elementAt(
                                                                            i)
                                                                        .gender ==
                                                                    1
                                                                ? "Male"
                                                                : "Female",
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  addEditUserPopUp(
                                                                      StudentEditPage(
                                                                    callBack:
                                                                        loadStudentData,
                                                                    studentList:
                                                                        listOfStudent!
                                                                            .elementAt(i),
                                                                  ));
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                                child: ElevatedButton(
                                                                    clipBehavior: Clip.antiAlias,
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(listOfStudent!.elementAt(i).userStatus == 1
                                                                            ? Colors.green
                                                                            : listOfStudent!.elementAt(i).userStatus == 3
                                                                                ? Colors.yellow
                                                                                : Colors.red)),
                                                                    onPressed: () {
                                                                      activeInactiveStudent(
                                                                        listOfStudent!
                                                                            .elementAt(i)
                                                                            .userStatus,
                                                                        listOfStudent!
                                                                            .elementAt(i)
                                                                            .firstName,
                                                                        listOfStudent!
                                                                            .elementAt(i)
                                                                            .fatherMobile
                                                                            .toString(),
                                                                        listOfStudent!
                                                                            .elementAt(i)
                                                                            .id
                                                                            .toString(),
                                                                      );
                                                                    },
                                                                    child: Text(listOfStudent!.elementAt(i).userStatus == 1
                                                                        ? "Active"
                                                                        : listOfStudent!.elementAt(i).userStatus == 3
                                                                            ? "Par-active"
                                                                            : "Inactive"))),
                                                          ],
                                                        )),
                                                      ]),
                                              ]),
                                        ),
                                        if (pageNumber != 0)
                                          NumberPagination(
                                            onPageChanged: (int number) {
                                              setState(() {
                                                pageNumber = number;
                                              });
                                              nextPage(studentList, number);
                                            },
                                            pageTotal:
                                                (totalRecord / 10).ceil(),
                                            pageInit: pageNumber,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                    case 'Staff':
                      return listOfStaff == null
                          ? LoadingAnimator()
                          : staffListData.isEmpty
                              ? Center(
                                  child: Lottie.asset(
                                    Animations.noData,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    repeat: true,
                                    reverse: true,
                                    animate: true,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.83,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.blue.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: const AssetImage(Images.bgImage),
                                        repeat: ImageRepeat.repeat),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: staffController,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: DataTable(
                                              showCheckboxColumn: false,
                                              border: TableBorder.all(
                                                  color: Colors.black26),
                                              sortAscending: true,
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'No',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Mobile Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Role',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Employee Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                for (int i = 0;
                                                    i < listOfStaff!.length;
                                                    i++)
                                                  DataRow(
                                                      onSelectChanged:
                                                          (value) async {
                                                        await getProfile(
                                                                id: listOfStaff!
                                                                    .elementAt(
                                                                        i)
                                                                    .id
                                                                    .toString(),
                                                                role: "2",
                                                                studentId: '')
                                                            .then((value) {
                                                          if (value != null) {
                                                            profileInfo(
                                                                listOfStaff!
                                                                    .elementAt(
                                                                        i),
                                                                value);
                                                          }
                                                        });
                                                      },
                                                      cells: [
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                          child: Text(
                                                            "${int.parse("${pageNumber - 1}$i") + 1}",
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStaff!
                                                                .elementAt(i)
                                                                .firstName
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStaff!
                                                                .elementAt(i)
                                                                .mobileNumber
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStaff!
                                                                .elementAt(i)
                                                                .userCategory
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfStaff!
                                                                        .elementAt(
                                                                            i)
                                                                        .employeeNo ==
                                                                    ''
                                                                ? 'N/A'
                                                                : listOfStaff!
                                                                    .elementAt(
                                                                        i)
                                                                    .employeeNo!,
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  addEditUserPopUp(
                                                                      AddEditStaffPage(
                                                                    callBack:
                                                                        loadStaffData,
                                                                    userModel:
                                                                        listOfStaff!
                                                                            .elementAt(i),
                                                                    isEdit:
                                                                        true,
                                                                  ));
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                                child: ElevatedButton(
                                                                    clipBehavior: Clip.antiAlias,
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(listOfStaff!.elementAt(i).userStatus == 1
                                                                            ? Colors.green
                                                                            : listOfStaff!.elementAt(i).userStatus == 3
                                                                                ? Colors.yellow
                                                                                : Colors.red)),
                                                                    onPressed: () {
                                                                      activeInactiveUser(
                                                                          listOfStaff!
                                                                              .elementAt(
                                                                                  i)
                                                                              .userStatus,
                                                                          listOfStaff!
                                                                              .elementAt(
                                                                                  i)
                                                                              .firstName,
                                                                          listOfStaff!
                                                                              .elementAt(i)
                                                                              .mobileNumber
                                                                              .toString(),
                                                                          '2');
                                                                    },
                                                                    child: Text(listOfStaff!.elementAt(i).userStatus == 1
                                                                        ? "Active"
                                                                        : listOfStaff!.elementAt(i).userStatus == 3
                                                                            ? "Par-active"
                                                                            : "Inactive"))),
                                                          ],
                                                        )),
                                                      ]),
                                              ]),
                                        ),
                                        if (pageNumber != 0)
                                          NumberPagination(
                                            onPageChanged: (int number) {
                                              //do something for selected page
                                              setState(() {
                                                pageNumber = number;
                                              });
                                              nextPage(staffList, number);
                                            },
                                            pageTotal:
                                                (totalRecord / 10).ceil(),
                                            pageInit: pageNumber,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                    case 'Parent':
                      return listOfParents == null
                          ? LoadingAnimator()
                          : parentListData.isEmpty
                              ? Center(
                                  child: Lottie.asset(
                                    Animations.noData,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    repeat: true,
                                    reverse: true,
                                    animate: true,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.83,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.blue.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: const AssetImage(Images.bgImage),
                                        repeat: ImageRepeat.repeat),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: parentController,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: DataTable(
                                              border: TableBorder.all(
                                                  color: Colors.black26),
                                              sortAscending: true,
                                              showCheckboxColumn: false,
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'No',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Mobile Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Class Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Role',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Student Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                for (int i = 0;
                                                    i < listOfParents!.length;
                                                    i++)
                                                  DataRow(
                                                      onSelectChanged:
                                                          (value) async {
                                                        await getProfile(
                                                                id: listOfParents!
                                                                    .elementAt(
                                                                        i)
                                                                    .id
                                                                    .toString(),
                                                                role: "3",
                                                                studentId: '')
                                                            .then((value) {
                                                          if (value != null) {
                                                            parentProfileInfo(
                                                                listOfParents!
                                                                    .elementAt(
                                                                        i),
                                                                value);
                                                          }
                                                        });
                                                      },
                                                      cells: [
                                                        DataCell(SizedBox(
                                                          child: Text(
                                                            "${int.parse("${pageNumber - 1}$i") + 1}",
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          child: Text(
                                                            listOfParents!
                                                                .elementAt(i)
                                                                .firstName
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          child: Text(
                                                            listOfParents!
                                                                .elementAt(i)
                                                                .mobileNumber
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          child: Text(
                                                            listOfParents!
                                                                .elementAt(i)
                                                                .className
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          child: Text(
                                                            (listOfParents!
                                                                        .elementAt(
                                                                            i)
                                                                        .userCategory ==
                                                                    1
                                                                ? 'Father'
                                                                : 'Mother'),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          child: Text(
                                                            listOfParents!
                                                                .elementAt(i)
                                                                .studentName
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  addEditUserPopUp(
                                                                      AddEditParentPage(
                                                                    callback:
                                                                        loadParentData,
                                                                    userModel:
                                                                        listOfParents!
                                                                            .elementAt(i),
                                                                    isEdit:
                                                                        true,
                                                                  ));
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                                child: ElevatedButton(
                                                                    clipBehavior: Clip.antiAlias,
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(listOfParents!.elementAt(i).userStatus == 1
                                                                            ? Colors.green
                                                                            : listOfParents!.elementAt(i).userStatus == 3
                                                                                ? Colors.yellow
                                                                                : Colors.red)),
                                                                    onPressed: () {},
                                                                    child: Text(listOfParents!.elementAt(i).userStatus == 1
                                                                        ? "Active"
                                                                        : listOfParents!.elementAt(i).userStatus == 3
                                                                            ? "Par-active"
                                                                            : "Inactive"))),
                                                          ],
                                                        )),
                                                      ]),
                                              ]),
                                        ),
                                        if (pageNumber != 0)
                                          NumberPagination(
                                            onPageChanged: (int number) {
                                              //do somthing for selected page
                                              setState(() {
                                                pageNumber = number;
                                              });
                                              nextPage(parentsList, number);
                                            },
                                            pageTotal:
                                                (totalRecord / 10).ceil(),
                                            pageInit: pageNumber,
                                          ),
                                      ],
                                    ),
                                  ),
                                );

                    case 'Management':
                      return listOfManagement == null
                          ? LoadingAnimator()
                          : managementListData.isEmpty
                              ? Center(
                                  child: Lottie.asset(
                                    Animations.noData,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    repeat: true,
                                    reverse: true,
                                    animate: true,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.83,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.blue.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: const AssetImage(Images.bgImage),
                                        repeat: ImageRepeat.repeat),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: managementController,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: DataTable(
                                              showCheckboxColumn: false,
                                              border: TableBorder.all(
                                                  color: Colors.black26),
                                              sortAscending: true,
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'No',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Mobile Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Designation',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Employee Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Action',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                for (int i = 0;
                                                    i <
                                                        listOfManagement!
                                                            .length;
                                                    i++)
                                                  DataRow(
                                                      onSelectChanged:
                                                          (value) async {
                                                        managementProfileInfo(
                                                            listOfManagement!
                                                                .elementAt(i));
                                                      },
                                                      cells: [
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                          child: Text(
                                                            "${int.parse("${pageNumber - 1}$i") + 1}",
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfManagement!
                                                                .elementAt(i)
                                                                .firstName
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfManagement!
                                                                .elementAt(i)
                                                                .mobileNumber
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            managementTypeList
                                                                    .where((element) =>
                                                                        element
                                                                            .id ==
                                                                        listOfManagement!
                                                                            .elementAt(
                                                                                i)
                                                                            .userCategory)
                                                                    .isNotEmpty
                                                                ? managementTypeList
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        listOfManagement!
                                                                            .elementAt(i)
                                                                            .userCategory)
                                                                    .categoryName
                                                                : 'N/A',
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              child: Text(
                                                                listOfManagement!
                                                                            .elementAt(
                                                                                i)
                                                                            .employeeNo ==
                                                                        ''
                                                                    ? 'N/A'
                                                                    : listOfManagement!
                                                                        .elementAt(
                                                                            i)
                                                                        .employeeNo!,
                                                                style: GoogleFonts.lato(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                            color:
                                                                                white)),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        DataCell(Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  addEditUserPopUp(
                                                                      AddEditManagementPage(
                                                                    callback:
                                                                        loadManagementData,
                                                                    userModel:
                                                                        listOfManagement!
                                                                            .elementAt(i),
                                                                    isEdit:
                                                                        true,
                                                                  ));
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                                child: ElevatedButton(
                                                                    clipBehavior: Clip.antiAlias,
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(listOfManagement!.elementAt(i).userStatus == 1
                                                                            ? Colors.green
                                                                            : listOfManagement!.elementAt(i).userStatus == 3
                                                                                ? Colors.yellow
                                                                                : Colors.red)),
                                                                    onPressed: () {
                                                                      activeInactiveUser(
                                                                          listOfManagement!
                                                                              .elementAt(
                                                                                  i)
                                                                              .userStatus,
                                                                          listOfManagement!
                                                                              .elementAt(
                                                                                  i)
                                                                              .firstName,
                                                                          listOfManagement!
                                                                              .elementAt(i)
                                                                              .mobileNumber
                                                                              .toString(),
                                                                          '5');
                                                                    },
                                                                    child: Text(listOfManagement!.elementAt(i).userStatus == 1
                                                                        ? "Active"
                                                                        : listOfManagement!.elementAt(i).userStatus == 3
                                                                            ? "Par-active"
                                                                            : "Inactive"))),
                                                          ],
                                                        )),
                                                      ]),
                                              ]),
                                        ),
                                        if (pageNumber != 0)
                                          NumberPagination(
                                            onPageChanged: (int number) {
                                              //do somthing for selected page
                                              setState(() {
                                                pageNumber = number;
                                              });
                                              nextPage(managementList, number);
                                            },
                                            pageTotal:
                                                (totalRecord / 10).ceil(),
                                            pageInit: pageNumber,
                                          ),
                                      ],
                                    ),
                                  ),
                                );

                    case 'Admin':
                      return listOfAdmin == null
                          ? LoadingAnimator()
                          : adminListData.isEmpty
                              ? Center(
                                  child: Lottie.asset(
                                    Animations.noData,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    repeat: true,
                                    reverse: true,
                                    animate: true,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.83,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.blue.withOpacity(0.2),
                                            BlendMode.dstATop),
                                        image: const AssetImage(Images.bgImage),
                                        repeat: ImageRepeat.repeat),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: adminController,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: DataTable(
                                              showCheckboxColumn: false,
                                              border: TableBorder.all(
                                                  color: Colors.black26),
                                              sortAscending: true,
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'Id',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Mobile Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Employee Number',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Status',
                                                    style: GoogleFonts.lato(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: white)),
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                for (int i = 0;
                                                    i < listOfAdmin!.length;
                                                    i++)
                                                  DataRow(
                                                      onSelectChanged:
                                                          (value) async {
                                                        adminProfileInfo(
                                                            listOfAdmin!
                                                                .elementAt(i));
                                                      },
                                                      cells: [
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                          child: Text(
                                                            "${int.parse("${pageNumber - 1}$i") + 1}",
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfAdmin!
                                                                .elementAt(i)
                                                                .firstName
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfAdmin!
                                                                .elementAt(i)
                                                                .mobileNumber
                                                                .toString(),
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          child: Text(
                                                            listOfAdmin!
                                                                        .elementAt(
                                                                            i)
                                                                        .employeeNo ==
                                                                    ''
                                                                ? 'N/A'
                                                                : listOfAdmin!
                                                                    .elementAt(
                                                                        i)
                                                                    .employeeNo,
                                                            style: GoogleFonts.lato(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        )),
                                                        DataCell(Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  addEditUserPopUp(
                                                                      AddEditAdminPage(
                                                                    callback:
                                                                        loadAdminData,
                                                                    userModel:
                                                                        listOfAdmin!
                                                                            .elementAt(i),
                                                                    isEdit:
                                                                        true,
                                                                  ));
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                                child: ElevatedButton(
                                                                    clipBehavior: Clip.antiAlias,
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(listOfAdmin!.elementAt(i).userStatus == 1
                                                                            ? Colors.green
                                                                            : listOfAdmin!.elementAt(i).userStatus == 3
                                                                                ? Colors.yellow
                                                                                : Colors.red)),
                                                                    onPressed: () {
                                                                      activeInactiveUser(
                                                                          listOfAdmin!
                                                                              .elementAt(
                                                                                  i)
                                                                              .userStatus,
                                                                          listOfAdmin!
                                                                              .elementAt(
                                                                                  i)
                                                                              .firstName,
                                                                          listOfAdmin!
                                                                              .elementAt(i)
                                                                              .mobileNumber
                                                                              .toString(),
                                                                          '1');
                                                                    },
                                                                    child: Text(listOfAdmin!.elementAt(i).userStatus == 1
                                                                        ? "Active"
                                                                        : listOfAdmin!.elementAt(i).userStatus == 3
                                                                            ? "Par-active"
                                                                            : "Inactive"))),
                                                          ],
                                                        )),
                                                      ]),
                                              ]),
                                        ),
                                        if (pageNumber != 0)
                                          NumberPagination(
                                            onPageChanged: (int number) {
                                              //do somthing for selected page
                                              setState(() {
                                                pageNumber = number;
                                              });
                                              nextPage(adminList, number);
                                            },
                                            pageTotal:
                                                (totalRecord / 10).ceil(),
                                            pageInit: pageNumber,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchNumber() {
    final listOfData = listOfParents!.where((element) {
      final name = element.firstName.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => listOfParents = listOfData);
  }

  void searchTeacher() {
    final listOfData = listOfStaff!.where((element) {
      final name = element.firstName.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => listOfStaff = listOfData);
  }

  void searchAdmin() {
    final listOfData = listOfAdmin!.where((element) {
      final name = element.firstName.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => listOfAdmin = listOfData);
  }

  void searchManagement() {
    final listOfData = listOfManagement!.where((element) {
      final name = element.firstName.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => listOfManagement = listOfData);
  }

  void searchStudent() {
    final listOfData = listOfStudent!.where((element) {
      final name = element.firstName.toLowerCase();
      final text = searchText.toLowerCase();
      return name.contains(text);
    });
    setState(() => listOfStudent = listOfData);
  }
}

const white = Colors.black;
