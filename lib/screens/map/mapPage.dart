import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teamfinalproject/model/park.dart';
import 'package:teamfinalproject/repositories/dbhelper.dart';
import 'package:teamfinalproject/services/fetchpark.dart';


class MapPage extends StatefulWidget{
  const MapPage({super.key});

  State<MapPage> createState() => _MapPageState();
}
class _MapPageState extends State<MapPage>{

  Completer<GoogleMapController> _controller = Completer();
  late Future<List<Park>> parks;
  final List<Marker> markers = [];
  Set<Marker> _markers = {};
  bool _isMarkerShow = false;

  @override
  void initState() {
    print('실행되냐???');
    super.initState();
    parks = fetchPark();
    parks.then((value) => value.forEach((element){
      print(element.parking_name);
      print(element.parking_code);
      print(element.lat);
      print(element.lng);
      var tempPark = Park(parking_name: element.parking_name, parking_code: element.parking_code, lat: element.lat, lng: element.lng);
      DBHelper().insertPark(tempPark);
    }));
  }




  final CameraPosition position = CameraPosition(
    target: LatLng(37.500784, 127.0368148),
    zoom: 15,
  );
  addMarker(cordinate, marker_id, marker_name){
    markers.add(Marker(
        position: cordinate,
        markerId: MarkerId(marker_id),
        infoWindow: InfoWindow(title: marker_name)
    ));
  }
  void _add_marker() {
    setState(() {
      _isMarkerShow = !_isMarkerShow;
      DBHelper dbHelper = DBHelper();
      print('>>>> ${dbHelper.parks()}');
      dbHelper.parks().then((value) => value.forEach((element) {
        print('parking_code: ${element.parking_code}, parking_name: ${element.parking_name}');
        addMarker(LatLng(element.lat, element.lng), element.parking_code, element.parking_name);
      }));
    });
    print('끝나김??');
  }
  void _remove_marker(){
    print('remove click!!');
    setState(() {
      _isMarkerShow = !_isMarkerShow;
      markers.clear();
    });
  }
  void _moveToCurrentLocation() async{
    final GoogleMapController controller = await _controller.future;
    LocationPermission permission = await Geolocator.requestPermission(); // 사용자에게 위치권한
    Position postion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low); // 현재 위치 받아오기
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(postion.latitude, postion.longitude),
        zoom: 17,
      ),
    ));
  }
  Widget build(BuildContext context){

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: position,
            markers: markers.toSet(),
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 60, right: 10),
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                FloatingActionButton.extended(
                  label: Text('가게위치'),
                  icon: Icon(Icons.store),
                  backgroundColor: Colors.lightBlue[400],
                  onPressed: _isMarkerShow ? _remove_marker : _add_marker,
                ),
                SizedBox(height: 10,),
                FloatingActionButton.extended(
                    label: Text('현재위치'),
                    icon: Icon(Icons.gps_fixed),
                    backgroundColor: Colors.green[400],
                    onPressed: () {
                      _moveToCurrentLocation();
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}