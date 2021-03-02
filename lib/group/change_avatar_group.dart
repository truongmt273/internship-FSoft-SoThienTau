import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeAvatarDialog {
  static void showChoiceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Make a choice!"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        ChangAvatarGroup().openGalary();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        ChangAvatarGroup().openCamera();
                      },
                    ),
                  ],
                ),
              ),
            ));
  }
}

class ChangAvatarGroup {
  String profileImage;
  final userCollection = Firestore.instance.collection('groups');
  void openGalary() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final File image = File(pickedImage.path);
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    profileImage = await uploadImage(image);
    userCollection.document(firebaseUser.uid).updateData({
      'image': '$profileImage',
    });
  }

  void openCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    final File image = File(pickedImage.path);
    profileImage = await uploadImage(image);
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    userCollection.document(firebaseUser.uid).updateData({
      'image': '$profileImage',
    });
  }

  Future<String> uploadImage(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseUser groupImage = await FirebaseAuth.instance.currentUser();
    var uploadTask =
        storage.ref().child("groupImage/'${groupImage.uid}'").putFile(image);
    final snapshot = await uploadTask.onComplete;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
