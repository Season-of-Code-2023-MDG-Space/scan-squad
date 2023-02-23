import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String userName,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(userName);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await user.reload();
    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }

  static Future<void> resetPassword({required String? email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .sendPasswordResetEmail(email: email!)
        .catchError((e) => print(e));
  }
  // Future<void> userSetup(String displayName) async {
  //   //firebase auth instance to get uuid of user
  //   User auth = FirebaseAuth.instance.currentUser!;

  //   //now below I am getting an instance of firebaseiestore then getting the user collection
  //   //now I am creating the document if not already exist and setting the data.
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(auth.uid)
  //       .set({'displayName': displayName, 'uid': auth.uid});

  //   return;
  // }
}
