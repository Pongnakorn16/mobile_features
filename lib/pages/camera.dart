import 'dart:developer';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            FilledButton(
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    log(image!.path);
                  }
                  setState(() {});
                },
                child: Text("Gallery")),
            FilledButton(
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    log(image!.path);
                  }
                  setState(() {});
                },
                child: Text("Camera")),
            FilledButton(
                onPressed: () async {
                  if (image != null) {
                    // image.saveTo(path)
                    final Directory? downloadsDir =
                        await getDownloadsDirectory();
                    var downloadsPath = await AndroidPathProvider.downloadsPath;
                    log(downloadsDir!.path);
                    log(downloadsPath);
                    image!.saveTo("${downloadsDir.path}/${image!.name}");
                    image!.saveTo("${downloadsPath}/${image!.name}");
                  }
                },
                child: Text("Save")),
            (image != null) ? Image.file(File(image!.path)) : Container(),
          ],
        ),
      ),
    );
  }
}
