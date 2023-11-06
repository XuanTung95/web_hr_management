

import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_hr_management/model/user_model.dart';


final pFireStore = ChangeNotifierProvider((ref) => FireStoreProvider());

class FireStoreProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<UserModel> users = [];

  Future loadUsers() async {
    CollectionReference _users = FirebaseFirestore.instance.collection('users');
    final ret = await _users.get();
    final docs = ret.docs;
    users = docs.map((item) {
      return UserModel.fromJson(item.data() as Map<String, dynamic>);
    }).toList();
    notifyListeners();
  }

  Future updateUser(UserModel user) async {
    if (user.id?.isEmpty ?? true) {
      user.id = DateTime.now().millisecondsSinceEpoch.toString();
    }
    CollectionReference _users = FirebaseFirestore.instance.collection('users');
    await _users.doc(user.id!).set(user.toJson());
  }

  Future deleteUser(UserModel user) async {
    CollectionReference _users = FirebaseFirestore.instance.collection('users');
    await _users.doc(user.id!).delete();
  }

  Future<String> uploadImage(Uint8List data, String name) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    String fileName = name;
    final mountainsRef = storageRef.child("uploads/$fileName");
    final task = mountainsRef.putData(data);
    await task.whenComplete(() {});
    String url = await mountainsRef.getDownloadURL();
    print("url = $url");
    return url;
  }
}