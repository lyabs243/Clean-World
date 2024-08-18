import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:structure/data/models/place_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/places_cubit.dart';
import 'package:structure/logic/states/places_state.dart';
import 'package:structure/presentation/sheets/place_details_sheet.dart';
import 'package:structure/utils/my_material.dart';

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
                markers: state.getMarkers(onMarkerTap),
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
    );
  }

  onMarkerTap(PlaceItem place) {
    final ValueNotifier<bool> isExpanded = ValueNotifier(false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return PlaceDetailsSheet(isExpanded: isExpanded,);
      },
    );
  }

}