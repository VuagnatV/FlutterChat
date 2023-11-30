import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eferei2023gr109/constant.dart';
import 'package:eferei2023gr109/controller/firebase_helper.dart';
import 'package:eferei2023gr109/model/my_user.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class AllPersonn extends StatefulWidget {
  const AllPersonn({super.key});

  @override
  State<AllPersonn> createState() => _AllPersonnState();
}

class _AllPersonnState extends State<AllPersonn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FiresbaseHelper().cloudUsers.snapshots(),
        builder: (context,snap){
          if(snap.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else
            {
              if(!snap.hasData){
                return const Center(
                  child: Text("aucune donnée"),
                );
              }
              else
                {
                  List documents = snap.data!.docs;
                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context,index){
                        MyUser otherUser = MyUser(documents[index]);
                        return GestureDetector(
                          onLongPress: (){
                            print("coucou");
                          },
                          onDoubleTap: (){
                            print("J'ai appuyé deux fois");
                          },
                          child: Card(
                            color: Colors.amberAccent,
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),

                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(otherUser.photo ?? imageDefault),
                                  ),
                                  title: Text(otherUser.prenom),
                                  subtitle: Text(otherUser.mail),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String mail = otherUser.mail;
                                    String uid = otherUser.uid;
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context){
                                          return Chat(receiverUserEmail: otherUser.mail, receiverUserID: otherUser.uid,);
                                        }
                                    ));
                                  },
                                  child: Text('Chat'),
                                ),
                              ],
                            ),


                          ),
                        );
                      }
                  );
                }
            }
        }
    );
  }
}
