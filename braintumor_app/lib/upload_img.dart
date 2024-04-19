import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:http/http.dart' as http;

import 'result.dart';

class UploadBody extends StatefulWidget {
  const UploadBody({Key? key}) : super(key: key);

  @override
  _UploadBodyState createState() => _UploadBodyState();
}

class _UploadBodyState extends State<UploadBody> {
  String? _filePath;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        print('Selected file path: $_filePath');
      });
    }
  }

  void _cancelUpload() {
    setState(() {
      _filePath = null;
    });
  }

  Future<void> _uploadImage() async {
    if (_filePath == null) return;

    Uri apiUrl = Uri.parse(
        'http://192.168.254.129:8000/detect'); // Change this to API url or when run locally change the ip address

    try {
      var request = http.MultipartRequest('POST', apiUrl);
      request.files.add(await http.MultipartFile.fromPath('file', _filePath!));

      var response = await request.send();

      if (response.statusCode == 200) {
        var imageData = await response.stream.toBytes();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(imageData: imageData),
          ),
        );
      } else {
        print('Failed to upload image: ${response.statusCode}');
        // Print response body for debugging
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Upload Files',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 24.0,
                    color: Color.fromARGB(255, 54, 215, 183),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Upload a picture you want to scan',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 54, 215, 183),
                  ),
                ),
              ),
              const SizedBox(height: 46),
              if (_filePath != null)
                Column(
                  children: [
                    Container(
                      height: 196.0,
                      width: 290.0,
                      decoration: const BoxDecoration(
                        border: DashedBorder.fromBorderSide(
                          dashLength: 5,
                          side: BorderSide(
                            color: Color.fromARGB(255, 96, 96, 96),
                            width: 1,
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(_filePath!), // Use File constructor here
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140.0,
                          height: 46.0,
                          child: ElevatedButton(
                            onPressed: _cancelUpload,
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromARGB(255, 60, 60, 60),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 140.0,
                          height: 46.0,
                          child: ElevatedButton(
                            onPressed: _uploadImage,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromARGB(255, 54, 215, 183),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Upload',
                              style: TextStyle(
                                color: Color.fromARGB(255, 246, 246, 246),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (_filePath == null)
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Container(
                    height: 196.0,
                    width: 290.0,
                    decoration: const BoxDecoration(
                      border: DashedBorder.fromBorderSide(
                        dashLength: 5,
                        side: BorderSide(
                          color: Color.fromARGB(255, 96, 96, 96),
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/upload.png'),
                          height: 60.0,
                          width: 60,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Click to browse images',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
