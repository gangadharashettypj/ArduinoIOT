import 'dart:io';

import 'package:arduinoiot/util/user.dart' as mUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);

  Future<User> signUp(
    String email,
    String password,
    String fname,
    String lname,
  );

  Future<String> getCurrentUser();

  Future<User> updateCurrentUser({
    String displayName,
    String photoUrl,
  });

  Future<void> signOut();
}

class Auth implements BaseAuth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Reference _firebaseStorageReference =
      FirebaseStorage.instance.ref();

  Future<User> signIn(
    String email,
    String password,
  ) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user.user.email);
    prefs.setString('uid', user.user.uid);
    prefs.setString('displayName', user.user.displayName);
    prefs.setString('photoUrl', user.user.photoURL);

    return user.user;
  }

  @override
  Future<User> signUp(
    String email,
    String password,
    String fname,
    String lname,
  ) async {
    UserCredential fUser =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await fUser.user.updateProfile(displayName: '$fname $lname');

    User currentUser = await _firebaseAuth.currentUser;

    mUser.User user = mUser.User();
    user.setUser({
      'email': currentUser.email,
      'displayName': currentUser.displayName,
      'uid': currentUser.uid,
      'photoUrl': currentUser.photoURL,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', currentUser.email);
    prefs.setString('uid', currentUser.uid);
    prefs.setString('displayName', currentUser.displayName);
    prefs.setString('photoUrl', currentUser.photoURL);

    return currentUser;
  }

  Future<String> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return user.uid;
  }

  Future<String> storeProfilePhoto(File photo) async {
    User fUser = await _firebaseAuth.currentUser;
    var fileRef = _firebaseStorageReference.child(fUser.uid);

    final UploadTask uploadTask = fileRef.putFile(photo);

    final TaskSnapshot storageTaskSnapshot = (await uploadTask);

    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  Future<User> updateCurrentUser({
    String displayName,
    String photoUrl,
  }) async {
    User fUser = await _firebaseAuth.currentUser;

    await fUser.updateProfile(displayName: displayName, photoURL: photoUrl);

    User currentUser = await _firebaseAuth.currentUser;

    mUser.User user = mUser.User();
    user.setUser({
      'email': currentUser.email,
      'displayName': currentUser.displayName,
      'uid': currentUser.uid,
      'photoUrl': currentUser.photoURL,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', currentUser.email);
    prefs.setString('uid', currentUser.uid);
    prefs.setString('displayName', currentUser.displayName);
    prefs.setString('photoUrl', currentUser.photoURL);

    return currentUser;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    return await _firebaseAuth.signOut();
  }
}
