import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/data/repositories/place_repository.dart';
import 'package:structure/data/repositories/storage_repository.dart';
import 'package:structure/logic/responses/set_place_response.dart';
import 'package:structure/logic/states/set_place_state.dart';
import 'package:structure/utils/methods.dart';
import 'package:structure/utils/my_material.dart';
import 'package:geocoding/geocoding.dart';

class SetPlaceCubit extends Cubit<SetPlaceState> {

  final UserItem user;
  final StorageRepository storageRepository = StorageRepository();
  final PlaceRepository repository = PlaceRepository();
  final ImagePicker picker = ImagePicker();

  SetPlaceCubit(super.initialState, {required this.user}) {
    initData();
  }

  initData() async {

    if (state.place != null) {
      state.descriptionEditingController.text = state.place!.description;
    }

    emit(state.copy());
  }

  pickFile() async {
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      state.imagePickerResults.add(file);
      emit(state.copy());
    }
  }

  removeFile(int index) {
    state.imagePickerResults.removeAt(index);
    emit(state.copy());
  }

  removePhotoUrl (int index) {
    state.place!.photosUrls.removeAt(index);
    emit(state.copy());
  }

  showMessage({SetPlaceCode? code, MessageType type = MessageType.dialog}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (code != null) {
      state.response = SetPlaceResponse(code: code, messageType: type);
    }

    state.isLoading = false;
    emit(state.copy());
  }

  setPlace({bool addPhotos = false}) async {
    if (state.isLoading) {
      return;
    }

    if (state.descriptionEditingController.text.isEmpty ||
        (
            state.imagePickerResults.isEmpty &&
            (
                state.place == null ||
                addPhotos
            )
        )
    ) {
      showMessage(code: SetPlaceCode.fillRequiredFields);
      return;
    }

    state.isLoading = true;
    emit(state.copy());

    //upload images
    List<String> urlImages = [];
    for (XFile file in state.imagePickerResults) {
      String urlImage = await storageRepository.uploadFile(
        bytes: await file.readAsBytes(),
        fileType: file.mimeType?? '',
        storageReference: storageRefPlaces,
        name: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (urlImage.isEmpty) {
        showMessage(code: SetPlaceCode.errorUpload,);
        return;
      }

      urlImages.add(urlImage);
    }

    if (addPhotos) {
      _addPhotos(urlImages);
    } else {
      if (state.place == null) {
        _add(urlImages);
      }
      else {
        _edit(urlImages);
      }
    }

  }

  _add(List<String> urlImages) async {
    Position? position = await getCurrentPosition();
    if (position == null) {
      showMessage(code: SetPlaceCode.failedGetLocation);
      return;
    }

    String city = '';
    List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
    if (placemarks.isNotEmpty) {
      city = placemarks.first.locality ?? '';
    }

    PlaceItem place = PlaceItem(description: state.descriptionEditingController.text, createdBy: user.authId,
      latitude: position.latitude, longitude: position.longitude, city: city,);
    place.photosUrls = urlImages;
    DocumentSnapshot? document = await repository.add(place);

    if (document != null) {
      place.document = document;
      state.place = place;
      state.imagePickerResults.clear();
      showMessage(code: SetPlaceCode.added, type: MessageType.toast);
      return;
    }
    else {
      showMessage(code: SetPlaceCode.error);
      return;
    }
  }

  _edit(List<String> urlImages) async {

    DateTime createdAt = state.place!.createdAt;
    List<String> photosUrls = state.place!.photosUrls;
    state.place = PlaceItem(description: state.descriptionEditingController.text, createdBy: state.place!.createdBy,
      document: state.place!.document, latitude: state.place!.latitude, longitude: state.place!.longitude, city: state.place!.city,);
    state.place!.createdAt = createdAt;
    state.place!.photosUrls = [...photosUrls, ...urlImages];

    bool result = await repository.update(state.place!,);

    if (result) {
      state.imagePickerResults.clear();
      showMessage(code: SetPlaceCode.updated, type: MessageType.toast);
      return;
    }
    else {
      showMessage(code: SetPlaceCode.error);
      return;
    }
  }

  _addPhotos(List<String> urlImages) async {
    Position? position = await getCurrentPosition();
    if (position == null) {
      showMessage(code: SetPlaceCode.failedGetLocation);
      return;
    }

    double distance = Geolocator.distanceBetween(state.place!.latitude, state.place!.longitude, position.latitude, position.longitude);
    debugPrint('==========> distance: $distance');
    if (distance > maxDistanceUpdatePlace) {
      showMessage(code: SetPlaceCode.notAroundPlace);
      return;
    }

    state.place!.photosUrls = [...state.place!.photosUrls, ...urlImages];
    bool result = await repository.updatePhotosUrls(state.place!, state.place!.photosUrls);

    if (result) {
      showMessage(code: SetPlaceCode.updated, type: MessageType.dialog);
      return;
    }
    else {
      showMessage(code: SetPlaceCode.error);
      return;
    }
  }

}