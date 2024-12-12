import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;

}
