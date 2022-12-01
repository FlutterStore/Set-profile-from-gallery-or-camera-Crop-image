import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    checkper();
    super.initState();
  }

  checkper() async
  {
    await Permission.storage.isDenied.then((value) => Permission.storage.request());
    await Permission.camera.isDenied.then((value) => Permission.camera.request());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ImagePicker pick= ImagePicker();
  XFile? profileimage;
  CroppedFile? croppedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Set profile",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25,left: 20,right: 20),
        child: Column(
          children: [
            croppedFile == null ?
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.green,
                border: Border.all(),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Icon(Icons.person,size: 100,)
              ),
            )
            :
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                border: Border.all(),
                color: Colors.transparent
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: Image.file(
                  File(croppedFile!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30,),
            InkWell(
              onTap: ()async{
                profileimage = await pick.pickImage(source: ImageSource.camera);
                croppedFile = await ImageCropper().cropImage(
                  sourcePath: profileimage!.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: Colors.green,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false
                    ),
                  ],
                );
                setState(() {});
              },
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Take picture from camera', style: TextStyle(color: Colors.white,),),
              ),
            ),
            const SizedBox(height: 30,),
            InkWell(
              onTap: ()async{
                profileimage = await pick.pickImage(source: ImageSource.gallery);
                croppedFile = await ImageCropper().cropImage(
                  sourcePath: profileimage!.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.green,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );
                setState(() {});
              },
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Choose picture from gallery', style: TextStyle(color: Colors.white,),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}