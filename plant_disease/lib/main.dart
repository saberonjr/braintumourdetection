import 'package:flutter/material.dart';
import 'package:leaflens/upload_img.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeafLens',
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
    return const Scaffold(
      body: BodyPage(),
    );
  }
}

class BodyPage extends StatelessWidget {
  const BodyPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/group11.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 25.0)),
              const Image(
                image: AssetImage('assets/images/maskgroup.png'),
                width: 225.0,
                height: 350.0,
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0)),
              const Center(
                child: Text(
                  'LeafLens',
                  style: TextStyle(
                    fontFamily: 'Open-Sans',
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 60, 130, 84),
                    fontSize: 40.0,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'by VerdeTech',
                  style: TextStyle(
                    fontFamily: 'Open-Sans',
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 60, 130, 84),
                    fontSize: 40.0,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 25.0)),
              const Center(
                child: SizedBox(
                  width: 284,
                  child: Text(
                    'Plant disease object detection and classification using machine learning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Open-Sans',
                      color: Color.fromARGB(255, 175, 121, 37),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 35.0)),
              SizedBox(
                width: 174.0,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadBody()))
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 130, 84),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Open-Sans',
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 246, 246, 246),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
