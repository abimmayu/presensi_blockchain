import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:presensi_blockchain/core/service/firebase_firestore.dart';
import 'package:presensi_blockchain/core/service/firebase_service.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/preferences.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart' as crypto;
import 'package:web3dart/web3dart.dart';

abstract class AuthDataSource {
  Future<User?> login(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  Future<DocumentSnapshot> getDataUser({
    required String id,
    String collection = "User",
  });
  Future<void> addDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  });
  Future<void> updateDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  });
  Future<Wallet> createWallet({required String password});
  Future<Wallet> importWallet({
    required String password,
    String? privateKey,
    List<TextEditingController>? mnemonicWords,
  });
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
    dev.log(result.toString());
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
  Future<void> addDataUser({
    required String id,
    String collection = "User",
    required Map<String, dynamic> data,
  }) async {
    final result = await fireStore.addData(
      doc: id,
      collection: collection,
      data: data,
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
  Future<Wallet> createWallet({
    required String password,
  }) async {
    Random random = Random.secure();

    EthPrivateKey? privateKey;
    String? mnemonic;
    // String? privateKeyHex;

    //Generate Recovery Phrase.
    mnemonic = bip39.generateMnemonic(strength: 128);
    List<int> seed = bip39.mnemonicToSeed(mnemonic);

    final root = BIP32.fromSeed(Uint8List.fromList(seed));
    final child = root.derivePath("m/44'/60'/0'/0/0");

    final byte = child.privateKey!
        .map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join('');

    //Generate Private Key.
    final privateKeyHex = byte;
    privateKey = EthPrivateKey.fromHex(privateKeyHex);

    //Generate Wallet.
    Wallet wallet = Wallet.createNew(
      privateKey,
      password,
      random,
    );

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

  @override
  Future<Wallet> importWallet({
    required String password,
    String? privateKey,
    List<TextEditingController>? mnemonicWords,
  }) async {
    Random random = Random.secure();
    String? mnemonic;

    //Regenerate the EthPrivateKey
    EthPrivateKey? ethPrivateKey;
    if (privateKey != null) {
      ethPrivateKey = EthPrivateKey.fromHex(privateKey);
      mnemonic = bip39.generateMnemonic();
    } else if (mnemonicWords != null) {
      List<String> words = List.generate(
        mnemonicWords.length,
        (index) => mnemonicWords[index].text.trim(),
      );
      mnemonic = words.join(" ");
      final mnemonicIsValid = bip39.validateMnemonic(mnemonic);
      if (mnemonicIsValid) {
        final seed = bip39.mnemonicToSeedHex(mnemonic);
        ethPrivateKey = EthPrivateKey.fromHex(seed);
      }
    }

    dev.log(mnemonic.toString());

    //Generate Wallet.
    Wallet wallet = Wallet.createNew(
      ethPrivateKey!,
      password,
      random,
    );

    var privateKeyHex = crypto.bytesToHex(
      wallet.privateKey.privateKey,
    );

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
      value: mnemonic!,
    );
    await storage.writeData(
      key: AppConstant.privateKey,
      value: privateKeyHex,
    );

    return wallet;
  }
}
