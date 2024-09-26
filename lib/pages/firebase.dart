import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mobile_features/shared/appdata.dart';
import 'package:provider/provider.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  TextEditingController docCtl = TextEditingController();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController messageCtl = TextEditingController();
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        stopRealTimeGet(); // กัน listener ซ้อนกัน
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const Text('Document'),
            TextField(
              controller: docCtl,
            ),
            const Text('Name'),
            TextField(
              controller: nameCtl,
            ),
            const Text('Message'),
            TextField(
              controller: messageCtl,
            ),
            FilledButton(
                onPressed: () {
                  var data = {
                    'name': nameCtl.text,
                    'message': messageCtl.text,
                    'createAt': DateTime.timestamp()
                  };

                  db.collection('inbox').doc(docCtl.text).set(data);
                },
                child: const Text('Add Data')),
            FilledButton(onPressed: readData, child: Text("Read Data")),
            FilledButton(onPressed: queryData, child: Text("Query Data")),
            FilledButton(
                onPressed: startRealtimeGet,
                child: const Text('Start Real-time Get')),
            FilledButton(
                onPressed: stopRealTimeGet,
                child: const Text('Stop Real-time Get'))
          ],
        ),
      ),
    );
  }

  void readData() async {
    var result = await db.collection('inbox').doc(docCtl.text).get();
    var data = result.data();
    log(data!['name']);
    log(data!['message']);
    log((data['createAt'] as Timestamp).millisecondsSinceEpoch.toString());
  }

  void queryData() async {
    var inboxRef = db.collection("inbox");
    var query = inboxRef.where("name", isEqualTo: nameCtl.text);
    var result = await query.get();
    if (result.docs.isNotEmpty) {
      log(result.docs.first.data()['message']);
    }
  }

  void startRealtimeGet() {
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
      log("listener stopped");
    }

    final docRef = db.collection("inbox").doc(docCtl.text);
    context.read<Appdata>().listener = docRef.snapshots().listen(
      (event) {
        var data = event.data();
        Get.snackbar(data!['name'].toString(), data['message'].toString());
        log("current data: ${event.data()}");
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  void stopRealTimeGet() {
    if (context.read<Appdata>().listener != null) {
      context.read<Appdata>().listener!.cancel();
      context.read<Appdata>().listener = null;
      log("listener stopped");
    }
  }
}
