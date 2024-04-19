import 'package:flutter/material.dart';
import 'package:brainscan/upload_img.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainScan',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: const BodyPage(),
    );
  }
}

class BodyPage extends StatelessWidget {
  const BodyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'WELCOME',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 54, 215, 183),
                fontSize: 24.0,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 33.0),
            child: Image(
              image: AssetImage('assets/images/brain.png'),
              width: 188.0,
              height: 204.0,
            ),
          ),
          const Center(
            child: Text(
              'BrainScan',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 54, 215, 183),
                fontSize: 24.0,
              ),
            ),
          ),
          const Center(
            child: Text(
              'by XTeam',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 54, 215, 183),
                fontSize: 24.0,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 33.0)),
          const Center(
            child: SizedBox(
              width: 180, // Set the desired width here
              child: Text(
                'A powerful medical App with a computer vision technology that can scan MRI images.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Color.fromARGB(255, 96, 96, 96),
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 90.0)),
          SizedBox(
            width: 290.0,
            height: 60.0,
            child: ElevatedButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UploadBody()))
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 54, 215, 183),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 246, 246, 246),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
