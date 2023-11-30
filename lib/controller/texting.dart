import 'package:eferei2023gr109/constant.dart';
import 'package:eferei2023gr109/model/my_user.dart';
import 'package:flutter/material.dart';

class TextOnImage extends StatelessWidget {
  MyUser user;
  TextOnImage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
       shape: BoxShape.rectangle,
       borderRadius: BorderRadius.circular(20),

     ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(user.photo ?? imageDefault),

          ),
          Text(user.mail)
        ],
      ),

    );
  }
}