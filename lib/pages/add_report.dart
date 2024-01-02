import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_book/components/input_widget.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/validators.dart';
import 'package:lapor_book/components/vars.dart';
import 'package:lapor_book/models/account.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  bool _isLoading = false;
  String? title;
  String? institute;
  String? description;
  ImagePicker imagePicker = ImagePicker();
  XFile? file;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<Position> getCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  void addReport(Account account) async {
    setState(() {
      _isLoading = true;
    });

    try {
      CollectionReference reportCollection = _firestore.collection('reports');

      Timestamp timestamp = Timestamp.fromDate(DateTime.now());
      String url = await uploadImage();

      String currentLocation = await getCurrentLocation().then((value) {
        return '${value.latitude},${value.longitude}';
      });

      String maps = 'https://www.google.com/maps/place/$currentLocation';

      final id = reportCollection.doc().id;

      await reportCollection.doc(id).set({
        'uid': _auth.currentUser!.uid,
        'docId': id,
        'title': title,
        'institute': institute,
        'description': description,
        'imageUrl': url,
        'name': account.name,
        'status': 'Posted',
        'date': timestamp,
        'maps': maps,
      }).catchError((error) {
        throw error;
      });
      Navigator.popAndPushNamed(context, '/dashboard');
    } catch (error) {
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference dirUpload =
          _storage.ref().child('upload/${_auth.currentUser!.uid}');
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (error) {
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(error);
      return '';
    }
  }

  Image imagePreview() {
    if (file == null) {
      return Image.asset('assets/istock-default.jpg', width: 180, height: 180);
    } else {
      return Image.file(File(file!.path), width: 180, height: 180);
    }
  }

  Future<dynamic> uploadDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text('Choose Source'),
          actions: [
            TextButton(
              onPressed: () async {
                XFile? upload =
                    await imagePicker.pickImage(source: ImageSource.camera);

                setState(() {
                  file = upload;
                });
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.camera_alt),
            ),
            TextButton(
              onPressed: () async {
                XFile? upload = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {
                  file = upload;
                });
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.photo_library),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Account account = arguments['account'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            Text('Tambah Laporan', style: headerStyle(level: 3, dark: false)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        InputLayout(
                          'Judul Laporan',
                          TextFormField(
                            onChanged: (value) => {title = value},
                            validator: notEmptyValidator,
                            decoration: customInputDecoration('Judul Laporan'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: imagePreview(),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              uploadDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.photo_camera),
                                Text(
                                  'Foto Pendukung',
                                  style: headerStyle(level: 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InputLayout(
                          'Instansi',
                          DropdownButtonFormField<String>(
                            decoration: customInputDecoration('Instansi'),
                            items: instituteData.map((institute) {
                              return DropdownMenuItem<String>(
                                value: institute,
                                child: Text(institute),
                              );
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                institute = selected;
                              });
                            },
                          ),
                        ),
                        InputLayout(
                          'Deskripsi Laporan',
                          TextFormField(
                            onChanged: (value) => {description = value},
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 5,
                            decoration: customInputDecoration(
                              'Deskripsikan laporan di sini',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: buttonStyle,
                            onPressed: () {
                              addReport(account);
                            },
                            child: Text(
                              'Kirim Laporan',
                              style: headerStyle(level: 3, dark: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
