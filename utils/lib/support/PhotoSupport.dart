
import 'package:utils/model/Photo.dart';

class PhotoSupport{
  bool isSelected = false;
  Photo photo;

  PhotoSupport(this.photo);

  bool operator == (other) {
    return other is PhotoSupport && photo == other.photo;
  }
  @override
  int get hashCode => photo.hashCode;
}