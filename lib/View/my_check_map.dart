import 'package:eferei2023gr109/View/my_map.dart';
import 'package:eferei2023gr109/controller/my_permission_gps.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyCheckMap extends StatefulWidget {
  const MyCheckMap({super.key});

  @override
  State<MyCheckMap> createState() => _MyCheckMapState();
}

class _MyCheckMapState extends State<MyCheckMap> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: MyPermissionGps().init(),
        builder: (context,futur){
          if(futur.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else
            {
              if(futur.hasData){
                Position position = futur.data!;
                return MyMap(gps: position,);
              }
              else
                {
                 return const Center(
                   child: Text("Aucune idéee"),
                 ) ;
                }
            }
        }
    );
  }
}
