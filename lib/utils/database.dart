// This module contains the read and write functions to the database. abstract





import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

Future<Null> writeNewElementToDatabase(Type newElement) async {
    DatabaseReference _userCheckinsRef = FirebaseDatabase.instance
        .reference()
        .child('users/$userIdCopy/checkins');
    
    final TransactionResult transactionResult =
        await _userCheckinsRef.runTransaction((MutableData mutableData) async {
      print(mutableData.value);
      _userCheckinsRef.push(newElement.toJson()).set(newElement.toJson());
      return mutableData;
    });

    if (transactionResult.committed) {
      print("transactionResult.committed");
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
  }