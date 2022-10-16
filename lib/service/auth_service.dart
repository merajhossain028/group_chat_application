import 'package:firebase_auth/firebase_auth.dart';
import 'package:tt_group_chat/helper/helper_function.dart';
import 'package:tt_group_chat/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginUserWithEmailandPassword(
      String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //call our database service to register
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  //register
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //call our database service to register
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF('');
      await HelperFunction.saveUserNameSF('');
      await firebaseAuth.signOut();

    } catch (e) {
      return null;
    }
  } 
}
