import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mobile_features/pages/camera.dart';
import 'package:mobile_features/pages/firebase.dart';
import 'package:mobile_features/pages/gps.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            FilledButton(
                onPressed: () {
                  Get.to(() => const CameraPage());
                },
                child: const Text("Demo Camera")),
            FilledButton(
                onPressed: () {
                  Get.to(() => const GpsPage());
                },
                child: const Text("Demo GPS")),
            FilledButton(
                onPressed: () {
                  Get.to(() => const FirebasePage());
                },
                child: const Text("Demo Firebase"))
          ],
        ),
      ),
    );
  }
}
