import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
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
    return map.GoogleMap(
      initialCameraPosition: const map.CameraPosition(
        target: map.LatLng(37.42796133580664, -122.085749655962),
        zoom: 14.4746,
      ),
      onMapCreated: (map.GoogleMapController controller) {
        _controller.complete(controller);
      },
      onCameraMove: (map.CameraPosition position) {
        // ignore: avoid_print
        print('=======> ${position.target}');
      },
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      markers: {
        map.Marker(
          markerId: const map.MarkerId('1'),
          position: const map.LatLng(37.42796133580664, -122.085749655962),
          onTap: onMarkerTap,
          icon: assetMapBitmap,
        ),
        map.Marker(
          markerId: const map.MarkerId('2'),
          position: const map.LatLng(37.42008022143011, -122.08811201155186),
          onTap: onMarkerTap,
          icon: assetMapBitmap,
        ),
        map.Marker(
          markerId: const map.MarkerId('3'),
          position: const map.LatLng(37.41366933134158, -122.07691714167593),
          onTap: onMarkerTap,
          icon: assetMapBitmap,
        ),
      },
    );
  }

  onMarkerTap() {
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