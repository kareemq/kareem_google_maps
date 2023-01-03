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
      debugShowCheckedModeBanner: false,
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
    target: LatLng(31.920682,35.859416),
    zoom: 14.4746,
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