//gere toutes les opérations concernant la bdd Firebase
import 'dart:typed_data';

import 'package:eferei2023gr109/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FiresbaseHelper{
  //atttributs
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");



  //méthdes
  //inscription un utilisateur
  Future <MyUser>resgiter(mail,mdp,nom,prenom) async{
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: mail, password: mdp);
    String uid = credential.user!.uid;
    Map<String,dynamic> map = {
      "MAIL":mail,
      "NOM":nom,
      "PRENOM":prenom,
      "FAVORIS":[]
    };
    adddUser(uid, map);
    return getUser(uid);





  }

  //récupérer notre model
  Future <MyUser> getUser(String uid) async {
     DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
     return MyUser(snapshot);

  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }



//connexion d'unutilisateur
  Future <MyUser>connect(mail,mdp)async {
    UserCredential credential = await auth.signInWithEmailAndPassword(email: mail, password: mdp);
    String uid = credential.user!.uid;
    return getUser(uid);
  }


//ajouter un utilisateur
adddUser(String uid,Map<String,dynamic> data){
  cloudUsers.doc(uid).set(data);
}

updateUser(String uid, Map<String,dynamic> data){
    cloudUsers.doc(uid).update(data);
}

Future<String>storageFile({required String dossier,required String uid, required String nameFile, required Uint8List dataFile}) async {
    TaskSnapshot snapshot = await storage.ref("$dossier/$uid/$nameFile").putData(dataFile);
    String url = await snapshot.ref.getDownloadURL();
    return url;

}





}