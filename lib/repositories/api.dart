import 'dart:io';
import 'package:chatchit/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  static late ChatUser me;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      about: "NHin casi cho gi",
      name: user.displayName.toString(),
      createdAt: time,
      isOnline: false,
      id: user.uid,
      lastActive: time,
      email: user.email.toString(),
      pushToken: "pushToken",
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getALlUsers() {
    return firestore
        .collection('users')
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      "name": me.name,
      "about": me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split(".").last;

    final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data doi sang: ${p0.bytesTransferred / 1000} kb");
    });
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      "image": me.image,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore.collection('messages').snapshots();
  }
}
