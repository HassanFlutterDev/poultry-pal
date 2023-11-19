import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:poultry_pal/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //text controller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      return userCredential;
    } catch (e) {
      VxToast.show(context, msg: e.toString());
      return null; // Return null to indicate that the login failed
    }
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }
//Google Signin

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await this.googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          storeUserData(
              email: user.email, password: 'google', name: user.displayName);
          res = true;
        }
        res = true;
        return res;
      }
    } catch (e) {
      res = false;
      print(e.toString());
    }
    return res;
  }

  //facebook login
  FacebookAuth _facebookAuth = FacebookAuth.instance;
  Future<bool> signInWithFacebook(BuildContext context) async {
    bool res = false;
    try {
      LoginResult result = await _facebookAuth.login();
      final userData = await _facebookAuth.getUserData();
      final credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        storeUserData(
            email: userData['email'],
            password: 'facebook',
            name: userData['name']);
      });
      res = true;
    } catch (e) {
      res = false;
      print(e.toString());
    }
    return res;
  }

//storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'whishlist_count': "00",
      'oder_count': "00",
    });
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      await googleSignIn.disconnect();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
