import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:braintumor/upload_img.dart';

class ResultPage extends StatelessWidget {
  final Uint8List imageData;

  const ResultPage({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/group11.png'), // Background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'RESULT',
                  style: TextStyle(
                    fontFamily: 'Open-Sans',
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 60, 130, 84),
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
                      'The scan shows that it has:',
                      style: TextStyle(
                        fontFamily: 'Open-Sans',
                        color: Color.fromARGB(255, 175, 121, 37),
                        fontSize: 15.0,
                      ),
                    ),
                    const Text(
                      'N/A', // To be followed, model not ready for returning the result
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 175, 121, 37),
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    Container(
                      height: 250.0,
                      width: 250.0,
                      child: Image.memory(
                        imageData,
                        fit: BoxFit.cover,
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
                    backgroundColor: const Color.fromARGB(255, 60, 130, 84),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'PRINT RESULT',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 247, 255, 250),
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
                        color: Color.fromARGB(255, 175, 121, 37),
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: const Text(
                      'SCAN IMAGE AGAIN',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 175, 121, 37),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
