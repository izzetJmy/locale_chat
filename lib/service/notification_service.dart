import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";

class NotificaitionService {
  Future<void> getUserToken() async {
    String? userToken = await FirebaseMessaging.instance.getToken();

    if (userToken != null) {
      saveTakenToDataBase(userToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTakenToDataBase);
  }

  void saveTakenToDataBase(String userToken) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': userToken}, SetOptions(merge: true));
  }
}
