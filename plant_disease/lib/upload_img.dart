import 'dart:io'; // Add this import statement

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

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

    Uri apiUrl = Uri.parse('http://192.168.254.129:5000/detect');

    var request = http.MultipartRequest('POST', apiUrl);
    request.files.add(await http.MultipartFile.fromPath('image', _filePath!));

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      // Read the response stream as bytes
      var imageData = await streamedResponse.stream.toBytes();

      // Navigate to the result page and pass the image data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(imageData: imageData),
        ),
      );
    } else {
      print('Failed to upload image: ${streamedResponse.statusCode}');
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _filePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/group11.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'SCAN',
                    style: TextStyle(
                      fontFamily: 'Open-Sans',
                      fontWeight: FontWeight.w900,
                      fontSize: 30.0,
                      color: Color.fromARGB(255, 60, 130, 84),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
                if (_filePath == null)
                  const Center(
                    child: Text(
                      'Use the camera to scan.',
                      style: TextStyle(
                        fontFamily: 'Open-Sans',
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 175, 121, 37),
                      ),
                    ),
                  ),
                if (_filePath != null)
                  const Text(
                    'Upload a picture you want to scan.',
                    style: TextStyle(
                      fontFamily: 'Open-Sans',
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 175, 121, 37),
                    ),
                  ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
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
                            File(_filePath!),
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
                                  color: Color.fromARGB(255, 175, 121, 37),
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 175, 121, 37),
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
                                    const Color.fromARGB(255, 60, 130, 84),
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
                    onPressed: _pickImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0, // No shadow
                      backgroundColor: Colors.transparent,
                    ),
                    child: Container(
                      height: 125.0,
                      width: 290.0,
                      decoration: const BoxDecoration(
                        // Set transparent background for the container
                        color: Colors.transparent,
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
                            image: AssetImage('assets/images/camera.png'),
                            height: 25.0,
                            width: 25.0,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Click to open camera.',
                            style: TextStyle(
                              fontFamily: 'Open-Sans',
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 116, 116, 116),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30.0),
                if (_filePath == null)
                  const Text('— OR —',
                      style: TextStyle(
                        fontFamily: 'Open-Sans',
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 60, 130, 84),
                      )),
                const SizedBox(height: 30.0),
                if (_filePath == null)
                  const Text(
                    'Upload a picture you want to scan.',
                    style: TextStyle(
                      fontFamily: 'Open-Sans',
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 175, 121, 37),
                    ),
                  ),
                const Padding(padding: EdgeInsets.only(top: 15.0)),
                if (_filePath == null)
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0, // No shadow
                      backgroundColor: Colors.transparent,
                    ),
                    child: Container(
                      height: 195.0,
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
                            width: 60.0,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Click to browse files.',
                            style: TextStyle(
                              fontFamily: 'Open-Sans',
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 116, 116, 116),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
