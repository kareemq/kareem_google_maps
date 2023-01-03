import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_service.dart';

void main()
{
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Maps',
      home: MapSample(),
    );
  }
}
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}
class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition CamM = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static const Marker _M =Marker(markerId: MarkerId('MARKER'), //marker
  infoWindow: InfoWindow(title: 'Google'),
  icon: BitmapDescriptor.defaultMarker,
  position: LatLng(37.427,-122.08835)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps'),),
      body: Column(
        children: [
          Row(children: [
            Expanded(child: TextFormField(
              controller: _searchController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Search a City'),
              onChanged: (value){
                print(value);
              },
            )),
            IconButton(onPressed: ()async {

              var place = await LocationService().getPlace(_searchController.text);
              _goToPlace(place);
            }, icon: const Icon(Icons.search),),
          ],),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {_M,},
              initialCameraPosition: CamM,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(Map<String,dynamic> place) async {
    final double lat = place ['geometry']['location']['lat'];
    final double lng = place ['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat,lng),
      zoom:12),
    ));
  }
}