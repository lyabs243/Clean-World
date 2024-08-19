import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:share_plus/share_plus.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/places_cubit.dart';
import 'package:structure/logic/states/places_state.dart';
import 'package:structure/presentation/sheets/place_details_sheet.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeFragment extends StatefulWidget {

  const HomeFragment({super.key});

  @override
  HomeFragmentState createState() {
    return HomeFragmentState();
  }

}

class HomeFragmentState extends State<HomeFragment> {

  final Completer<map.GoogleMapController> _controller = Completer<map.GoogleMapController>();
  map.AssetMapBitmap assetMapBitmap = map.AssetMapBitmap(PathIcons.waste,);

  @override
  Widget build(BuildContext context) {

    Position? currentPosition = context.read<AppCubit>().state.devicePosition;
    map.LatLng center = defaultMapPosition;
    if (currentPosition != null) {
      center = map.LatLng(currentPosition.latitude, currentPosition.longitude);
    }

    return BlocProvider<PlacesCubit>(
      create: (context) => PlacesCubit(PlacesState(currentPosition: center,)),
      child: BlocListener<PlacesCubit, PlacesState>(
        listener: listener,
        child: BlocBuilder<PlacesCubit, PlacesState>(
          builder: (context, state) {

            return Stack(
              children: [
                map.GoogleMap(
                  initialCameraPosition: map.CameraPosition(
                    target: state.currentPosition,
                    zoom: 14.4746,
                  ),
                  onMapCreated: (map.GoogleMapController controller) {
                    _controller.complete(controller);
                    context.read<PlacesCubit>().setController(controller);
                  },
                  onCameraMove: (map.CameraPosition position) {
                    // ignore: avoid_print
                    // print('=======> ${position.target}');
                  },
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  markers: getMarkers(context, state),
                ),
                Visibility(
                  visible: state.isLoading,
                  child: Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorWhite.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            );

          },
        ),
      ),
    );
  }

  sharePlace(PlaceItem place,) {
    String message = place.description;
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    message += '\n\n${place.photosUrls.first}';
    message += '\n\n${AppLocalizations.of(context)!.shareAppMessage(downloadAppLink)}';
    Share.share(message);
  }

  openPlaceInMap(BuildContext context, PlaceItem place) async {
    double latitude = place.latitude;
    double longitude = place.longitude;

    var uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.somethingWentWrong),
        backgroundColor: colorError,
      ));
    }
  }

  Set<map.Marker> getMarkers(BuildContext contextPlaces, PlacesState statePlaces) {
    Set<map.Marker> markers = {};

    for (PlaceItem item in statePlaces.places) {
      markers.add(map.Marker(
        markerId: map.MarkerId(item.document?.id ?? ''),
        position: map.LatLng(item.latitude, item.longitude),
        onTap: () {
          onMarkerTap(contextPlaces, item, statePlaces.getUser(item.createdBy));
        },
        icon: map.AssetMapBitmap(PathIcons.waste,),
      ));
    }

    return markers;
  }

  onMarkerTap(BuildContext contextPlace, PlaceItem place, UserItem? owner) {
    final ValueNotifier<bool> isExpanded = ValueNotifier(false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return PlaceDetailsSheet(isExpanded: isExpanded, place: place, user: owner,
          onShare: () {
            sharePlace(place);
          },
          onOpenInMap: () {
            openPlaceInMap(context, place);
          },
          onDelete: () {
            contextPlace.read<PlacesCubit>().deletePlace(place);
          },
        );
      },
    );
  }

  listener(BuildContext context, PlacesState state) {
    if (state.response != null) {
      ResponseCodeWidget(context: context, item: state.response!).show();
      state.response = null;
    }
  }

}