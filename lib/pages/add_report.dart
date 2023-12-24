import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_book/components/input_widget.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/validators.dart';
import 'package:lapor_book/components/vars.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final bool _isLoading = false;

  String? title;

  String? institute;

  String? description;

  ImagePicker imagePicker = ImagePicker();

  XFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:
              Text('Tambah Laporan', style: headerStyle(level: 3, dark: false)),
          centerTitle: false,
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
                                onChanged: (value) => {},
                                validator: notEmptyValidator,
                                decoration:
                                    customInputDecoration('Judul Laporan'),
                              )),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_camera),
                                  Text('Foto Pendukung',
                                      style: headerStyle(level: 3))
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
                              )),
                          InputLayout(
                              'Deskripsi Laporan',
                              TextFormField(
                                onChanged: (value) => {},
                                keyboardType: TextInputType.multiline,
                                minLines: 3,
                                maxLines: 5,
                                decoration: customInputDecoration(
                                    'Deskripsikan laporan di sini'),
                              )),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: buttonStyle,
                              onPressed: () {},
                              child: Text('Kirim Laporan',
                                  style: headerStyle(level: 3, dark: false)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
