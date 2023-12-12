import 'package:image_picker/image_picker.dart';
import 'package:ui/config/const.dart';
import 'package:ui/model/image/get_image_model.dart';

ImagePicker picker = ImagePicker();

class ImageController {
  static Future<List<XFile>> pickImage() async {
    final pickedFile = await picker.pickMultiImage();
    return pickedFile;
  }

  static Future<bool> isImageBelow5MB(XFile? pickedFile) async {
    if (pickedFile == null) return false;

    final fileSize = await pickedFile.length();
    return fileSize < IMG_SIZE_RESTRICTION * 1024 * 1024; // 5 MB in bytes
  }

  static Future<GetImageModel> pickAndProcessImage() async {
    var errorImage = '';
    List<XFile> image = [];
    var count = 0;
    final pickedFile = await pickImage();
    for (var img in pickedFile) {
      if (await isImageBelow5MB(img)) {
        image.add(img);
      } else {
        count++;
        errorImage = " $count images removed as per restriction";
      }
    }
    var result = GetImageModel(images: image, errorText: errorImage);
    return result;
  }
}
