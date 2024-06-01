import 'dart:math';
import 'dart:developer' as dev;
import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/service/firebase_firestore.dart';
import 'package:presensi_blockchain/core/service/firebase_service.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/preferences.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

abstract class AuthDataSource {
  Future<User?> login(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  Future<DocumentSnapshot> getDataUser({
    required String id,
    String collection = "User",
  });
  Future<void> updateDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  });
  Future<Wallet> createWallet({required String password});
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseService firebaseService = FirebaseService();
  final FireStore fireStore = FireStore();
  final LocalPreferences preferences;
  final SecureStorage storage;

  AuthDataSourceImpl({
    required this.preferences,
    required this.storage,
  });

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    final result = await firebaseService.signInWithemailAndPassword(
      email,
      password,
    );
    return result;
  }

  @override
  Future<User?> signUp(
    String email,
    String password,
  ) async {
    final result = await firebaseService.signUpWithemailAndPassword(
      email,
      password,
    );
    return result;
  }

  @override
  Future<void> signOut() async {
    final result = await firebaseService.signOut();
    return result;
  }

  @override
  Future<DocumentSnapshot> getDataUser({
    required String id,
    String collection = "User",
  }) async {
    final result = await fireStore.getData(
      doc: id,
      collection: collection,
    );
    return result;
  }

  @override
  Future<void> updateDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  }) async {
    final result = await fireStore.updateData(
      doc: id,
      collection: collection,
      data: data,
    );

    return result;
  }

  @override
  Future<Wallet> createWallet({required String password}) async {
    Random random = Random.secure();
    //Generate Recovery Phrase.
    String mnemonic = bip39.generateMnemonic();

    //Generate Private Key.
    String seedHex = bip39.mnemonicToSeedHex(mnemonic);
    EthPrivateKey privateKey = EthPrivateKey.fromHex(seedHex);

    //Generate Wallet.
    Wallet wallet = Wallet.createNew(
      privateKey,
      password,
      random,
    );

    var privateKeyHex = bytesToHex(wallet.privateKey.privateKey);

    dev.log(mnemonic);
    dev.log(privateKeyHex.toString());

    //Save Wallet to Shared Preferences.
    preferences.wallet = wallet.toJson();

    //Save password, address, privateKey, recoveryPhrase in Secure Storage.
    await storage.writeData(
      key: AppConstant.password,
      value: password,
    );
    await storage.writeData(
      key: AppConstant.address,
      value: wallet.privateKey.address.toString(),
    );
    await storage.writeData(
      key: AppConstant.recoveryPhrase,
      value: mnemonic,
    );
    await storage.writeData(
      key: AppConstant.privateKey,
      value: privateKeyHex,
    );

    return wallet;
  }
}
