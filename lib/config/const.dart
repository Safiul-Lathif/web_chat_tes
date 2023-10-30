// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

bool USER_STATUS = true;
bool ROLE_CHANGED = false;
ButtonStyle buttonStyle = ButtonStyle(
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
    foregroundColor: const MaterialStatePropertyAll(Colors.white),
    backgroundColor: MaterialStatePropertyAll(Colors.blueGrey.shade400));
