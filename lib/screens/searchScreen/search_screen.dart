import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui/api/profile_api.dart';
import 'package:ui/api/search/change_user_status.dart';
import 'package:ui/api/search_parent_api.dart';
import 'package:ui/config/images.dart';
import 'package:ui/custom/loading_animator.dart';
import 'package:ui/model/profile_model.dart';
import 'package:ui/model/search_parent_model.dart';
import 'package:ui/model/search_staff_model.dart';
import 'package:ui/widget/parent_info.dart';
import 'package:ui/widget/staff_info.dart';
import '../../api/search_staff_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearch = false;
  String searchText = '';
  TextEditingController controller = TextEditingController();
  Iterable<StaffSearchList>? listOfStaff;
  Iterable<ParentSearchList>? listOfParents;

  @override
  void initState() {
    super.initState();
    staffList();
    parentsList();
  }

  Future<void> staffList() async {
    await getStaffList().then((value) {
      if (value != null) {
        setState(() {
          listOfStaff = value;
          isLoading = false;
        });
      }
    });
  }

  Future<void> parentsList() async {
    await getParentList().then((value) {
      if (value != null) {
        setState(() {
          listOfParents = value;
          isLoading = false;
        });
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

  Future<bool> activeInactiveUser(
    int id,
    String name,
    String number,
  ) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(id == 1 ? 'Deactivate User' : 'Activate User'),
            content: Text(id == 1
                ? 'Do you want to Deactivate $name User?'
                : "Do you want to Activate $name User?"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: id == 1
                    ? () async {
                        // await changeUserStatus(number, '2').then((value) {
                        //   _snackBar(value['message']);
                        //   staffList();
                        //   Navigator.pop(context);
                        // });
                      }
                    : () async {
                        // await changeUserStatus(number, '1').then((value) {
                        //   _snackBar(value['message']);
                        //   staffList();
                        //   Navigator.pop(context);
                        // });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //padding: const EdgeInsets.only(top: 13),
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
                    "Search Parents & Staffs",
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
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                          searchNumber();
                          searchTeacher();
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
                      SizedBox(
                          width: 40,
                          child: PopupMenuButton<int>(
                            icon: Icon(!filter
                                ? Icons.filter_alt
                                : Icons.filter_alt_off),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () async {
                                  isLoading = true;
                                  await getStaffList().then((value) {
                                    if (value != null) {
                                      setState(() {
                                        listOfStaff = value;
                                        var newFilteredStaffList = listOfStaff!
                                            .where((element) =>
                                                element.userStatus == 1)
                                            .toList();
                                        listOfStaff = newFilteredStaffList;
                                        filter = true;
                                        isLoading = false;
                                      });
                                    }
                                  });
                                },
                                value: 1,
                                // row has two child icon and text.
                                child: const Text("Active Users"),
                              ),
                              PopupMenuItem(
                                onTap: () async {
                                  isLoading = true;
                                  await getStaffList().then((value) {
                                    if (value != null) {
                                      setState(() {
                                        listOfStaff = value;
                                        var newFilteredStaffList = listOfStaff!
                                            .where((element) =>
                                                element.userStatus == 2)
                                            .toList();
                                        listOfStaff = newFilteredStaffList;
                                        filter = true;
                                        isLoading = false;
                                      });
                                    }
                                  });
                                },
                                value: 2,
                                // row has two child icon and text
                                child: const Text("Inactive User"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                    staffList();
                                    filter = false;
                                  });
                                },
                                value: 2,
                                // row has two child icon and text
                                child: const Text("Cancel"),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: 40,
                        child: FormBuilderDropdown(
                          name: 'Staff',
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: 'Staff',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value == 'Staff') {
                                listOfParents = [];
                                getStaffList().then((value) {
                                  if (value != null) {
                                    setState(() {
                                      listOfStaff = value;
                                    });
                                  }
                                });
                              }
                              if (value == 'Parents') {
                                listOfStaff = [];
                                getParentList().then((value) {
                                  if (value != null) {
                                    setState(() {
                                      listOfParents = value;
                                    });
                                  }
                                });
                              }
                            });
                          },
                          items: ["Staff", "Parents"].map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                children: [
                                  // ignore: prefer_const_constructors
                                  SizedBox(
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
                    ],
                  ),
                ],
              ),
            ),
            listOfStaff == null || listOfParents == null
                ? LoadingAnimator()
                : listOfStaff!.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.83,
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
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                width: MediaQuery.of(context).size.width * 0.68,
                                child: DataTable(
                                    border:
                                        TableBorder.all(color: Colors.black26),
                                    sortAscending: true,
                                    showCheckboxColumn: false,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Id',
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Name',
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Mobile Number',
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Role',
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Type',
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: white)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Student Name',
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: white)),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      for (int i = 0;
                                          i < listOfParents!.length;
                                          i++)
                                        DataRow(
                                            onSelectChanged: (value) async {
                                              await getProfile(
                                                      id: listOfParents!
                                                          .elementAt(i)
                                                          .id
                                                          .toString(),
                                                      role: "3")
                                                  .then((value) {
                                                if (value != null) {
                                                  parentProfileInfo(
                                                      listOfParents!
                                                          .elementAt(i),
                                                      value);
                                                }
                                              });
                                            },
                                            cells: [
                                              DataCell(SizedBox(
                                                child: Text(
                                                  listOfParents!
                                                      .elementAt(i)
                                                      .id
                                                      .toString(),
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: white)),
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
                                                              color: white)),
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
                                                              color: white)),
                                                ),
                                              )),
                                              DataCell(SizedBox(
                                                child: Text(
                                                  (listOfParents!
                                                              .elementAt(i)
                                                              .userCategory ==
                                                          1
                                                      ? 'Father'
                                                      : 'Mother'),
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: white)),
                                                ),
                                              )),
                                              DataCell(SizedBox(
                                                child: Text(
                                                  'PARENTS',
                                                  style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: white)),
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
                                                              color: white)),
                                                ),
                                              )),
                                            ]),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.83,
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
                          child: Column(
                            children: [
                              DataTable(
                                  showCheckboxColumn: false,
                                  border:
                                      TableBorder.all(color: Colors.black26),
                                  sortAscending: true,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Id',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Name',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Mobile Number',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Role',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Type',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Class Name',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Status',
                                        style: GoogleFonts.lato(
                                            textStyle:
                                                const TextStyle(color: white)),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    for (int i = 0;
                                        i < listOfStaff!.length;
                                        i++)
                                      DataRow(
                                          onSelectChanged: (value) async {
                                            await getProfile(
                                                    id: listOfStaff!
                                                        .elementAt(i)
                                                        .id
                                                        .toString(),
                                                    role: "2")
                                                .then((value) {
                                              if (value != null) {
                                                profileInfo(
                                                    listOfStaff!.elementAt(i),
                                                    value);
                                              }
                                            });
                                          },
                                          cells: [
                                            DataCell(SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              child: Text(
                                                listOfStaff!
                                                    .elementAt(i)
                                                    .id
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: white)),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: Text(
                                                listOfStaff!
                                                    .elementAt(i)
                                                    .firstName
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: white)),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: Text(
                                                listOfStaff!
                                                    .elementAt(i)
                                                    .mobileNumber
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: white)),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: Text(
                                                listOfStaff!
                                                    .elementAt(i)
                                                    .userCategory
                                                    .toString(),
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: white)),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: Text(
                                                'STAFF',
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: white)),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08,
                                              child: Text(
                                                listOfStaff!
                                                            .elementAt(i)
                                                            .staffSearchListClass ==
                                                        ''
                                                    ? 'N/A'
                                                    : listOfStaff!
                                                        .elementAt(i)
                                                        .staffSearchListClass,
                                                style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: white)),
                                              ),
                                            )),
                                            DataCell(SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08,
                                                child: listOfStaff!.elementAt(i).userStatus == 1
                                                    ? ElevatedButton(
                                                        clipBehavior: Clip
                                                            .antiAlias,
                                                        style: const ButtonStyle(
                                                            backgroundColor: MaterialStatePropertyAll(
                                                                Colors.green)),
                                                        onPressed: () => activeInactiveUser(
                                                            listOfStaff!
                                                                .elementAt(i)
                                                                .userStatus,
                                                            listOfStaff!
                                                                .elementAt(i)
                                                                .firstName,
                                                            listOfStaff!
                                                                .elementAt(i)
                                                                .mobileNumber
                                                                .toString()),
                                                        child: const Text("Active"))
                                                    : ElevatedButton(clipBehavior: Clip.antiAlias, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)), onPressed: () => activeInactiveUser(listOfStaff!.elementAt(i).userStatus, listOfStaff!.elementAt(i).firstName, listOfStaff!.elementAt(i).mobileNumber.toString()), child: const Text("Inactive")))),
                                          ]),
                                  ])
                            ],
                          ),
                        ),
                      )
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
}

const white = Colors.black;
