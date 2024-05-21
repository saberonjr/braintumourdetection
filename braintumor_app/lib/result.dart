import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:brainscan/upload_img.dart';

class ResultPage extends StatelessWidget {
  final Uint8List imageData;

  const ResultPage({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'RESULT',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 54, 215, 183),
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 31),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'The brain MRI has:',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Color.fromARGB(255, 54, 215, 183),
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 35.0),
                  Center(
                    child: Container(
                      height: 250.0, // Set the desired height
                      width: 250.0, // Set width to match parent container
                      child: Image.memory(
                        imageData,
                        fit: BoxFit
                            .cover, // Adjust the fit as per your requirement
                      ),
                    ),
                  ),
                  const SizedBox(height: 35.0),
                ],
              ),
            ),
            SizedBox(
              width: 290.0,
              height: 46.0,
              child: ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 54, 215, 183),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'PRINT RESULT',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 246, 246, 246),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              margin: const EdgeInsets.only(top: 80.0),
              child: SizedBox(
                width: 290.0,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadBody()))
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      width: 1.0,
                      color: Color.fromARGB(255, 96, 96, 96),
                    ),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'SCAN IMAGE AGAIN',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 96, 96, 96),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
