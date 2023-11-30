

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eferei2023gr109/constant.dart';
import 'package:eferei2023gr109/controller/firebase_helper.dart';
import 'package:eferei2023gr109/controller/texting.dart';
import 'package:eferei2023gr109/model/my_user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MyMap extends StatefulWidget {
  Position gps;
  MyMap({required this.gps,super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  //variable
  late CameraPosition initCamera;
  Completer<GoogleMapController> completerMaps = Completer();
  Set<Marker> allMarkers = Set();



  init(){
    //initilialiser la caméra
    initCamera = CameraPosition(target: LatLng(widget.gps.latitude,widget.gps.longitude),zoom: 14);
//enregistrer les coordonnées dans la base de donnée
    Map<String,dynamic> data = {
      "GPS":GeoPoint(widget.gps.latitude,widget.gps.longitude)
    };
    FiresbaseHelper().updateUser(moi.uid, data);
    // récuperer tous les Markers
    FiresbaseHelper().cloudUsers.snapshots().listen((event) {
      List documents = event.docs;
      for(int index =0; index<documents.length;index++){

        MyUser other = MyUser(documents[index]);
        print(other.mail);


          setState(() {
            allMarkers.add(
              Marker(
                  markerId: MarkerId(other.uid),
                position: LatLng(other.gps!.latitude, other.gps!.longitude),
                infoWindow: InfoWindow(
                  title: other.mail,
                )
              )
            );
          });


      }
    });

}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: allMarkers,

      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (controller){
        completerMaps.complete(controller);

      },
        initialCameraPosition: initCamera,
    );
  }
}
