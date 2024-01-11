// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';

class GetImageModel {
  List<PlatformFile> images;
  String errorText;
  GetImageModel({
    required this.images,
    required this.errorText,
  });
}
