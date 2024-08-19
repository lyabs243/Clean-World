import 'package:image_picker/image_picker.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/logic/responses/set_place_response.dart';
import 'package:structure/utils/my_material.dart';

class SetPlaceState {

  TextEditingController descriptionEditingController = TextEditingController();
  SetPlaceResponse? response;
  PlaceItem? place;
  List<XFile> imagePickerResults = [];
  bool isLoading;

  SetPlaceState({this.place, this.response, this.isLoading = false,});

  SetPlaceState copy() {
    SetPlaceState copy = SetPlaceState(response: response, place: place,
        isLoading: isLoading,);

    copy.descriptionEditingController = descriptionEditingController;
    copy.imagePickerResults = [... imagePickerResults];

    return copy;
  }

}