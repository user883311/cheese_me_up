// This module contains the read and write functions to the database. abstract

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

Future<TransactionResult> writeNewElementToDatabase(
    Map newJsonElement, DatabaseReference dbRef) async {
  DatabaseReference newDbRef = dbRef.push("temporary transaction data");
  final TransactionResult transactionResult =
      await newDbRef.runTransaction((MutableData mutableData) async {
    mutableData.value = newJsonElement;
    print("mutableData.value: \n${mutableData.value}");
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
