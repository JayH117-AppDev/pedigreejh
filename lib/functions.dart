import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class petMethods{

  bool isLoggedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      return true;
    }else{
      return false;
    }
  }

  Future<void> addData(petData) async{
    if (isLoggedIn()){
      FirebaseFirestore.instance.collection('pets').add(petData).catchError((e){
        print(e);
      });
    }else{
      print('You need to sign in');
    }
  }

  getData() async{
    return await FirebaseFirestore.instance.collection('pets').orderBy("time", descending: true).get();
  }

  updateData(selectedDoc, newValue){
    FirebaseFirestore.instance.collection('pets').doc(selectedDoc).update(newValue).catchError((e){
      print(e);
    });
  }

  deleteData(docId){
    FirebaseFirestore.instance.collection('pets').doc(docId).delete().catchError((e){
      print(e);
    });
  }
}