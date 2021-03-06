// This module contains the read and write functions to the database. abstract

import 'dart:async';
import 'package:cheese_me_up/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

/// This function writes a new node to a Firebase [DatabaseReference] point, based
/// off a Map [newJsonElement]. If [randomKey] is set to true, a new unique alphanumeric
/// id will be added at the referenced node, before writing the new data.
Future<TransactionResult> writeNewElementToDatabase(
    Map newJsonElement, DatabaseReference dbRef,
    {bool randomKey: true}) async {
  if (randomKey) {
    dbRef = dbRef.push();
  }

  final TransactionResult transactionResult =
      await dbRef.runTransaction((MutableData mutableData) async {
    mutableData.value = newJsonElement;
    return (mutableData);
  });

  if (transactionResult.committed) {
    print("transactionResult.committed");
    print(
        "transactionResult.dataSnapshot.value: \n${transactionResult.dataSnapshot.value}");
  } else {
    print('Transaction not committed.');
    if (transactionResult.error != null) {
      print(transactionResult.error.message);
    }
  }
  return transactionResult;
}

/// This function writes a [newUser] node in the Firebase database, 
/// located at the [userId] address. 
Future<TransactionResult> addUserToFirebase(
  User newUser,
  String userId,
) async {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _userRef;
  _userRef = database.reference().child("users/$userId");
  final TransactionResult transactionResult = await writeNewElementToDatabase(
      newUser.toJson(), _userRef,
      randomKey: false);
  return transactionResult;
}