import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: SpiderScreen( ),
    );
  }
}

class SpiderScreen extends StatefulWidget {
  SpiderScreen({super.key});

  @override
  State<SpiderScreen> createState() => Spiders();
}

class Spiders extends State<SpiderScreen> {
  double _xPosition = 50;
  double _yPosition = 100;
  final Random _random = Random();

  @override
  
  void initState() {
    super.initState();
    // Start moving the object randomly every second
    Timer.periodic(const Duration(seconds: 1 ), (Timer timer) {
      setState(() {
        // Update the x and y positions randomly within screen limits
        _xPosition = _random.nextDouble() * MediaQuery.of(context).size.width - 50;
        _yPosition = _random.nextDouble() * MediaQuery.of(context).size.height - 50;
      });
    });
  }

   void _onObjectTappedScare() {
    // Navigate to a different screen when the object is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScareScreen()),
    );
  }

    void _onObjectTappedWin() {
    // Navigate to a different screen when the object is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the SpiderScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("s"),
      ),
      body: Stack(
        children: [
          // Background Container with an image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wall.jpg"), // Add your image in the assets folder
                fit: BoxFit.cover,
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            left: _xPosition,
            top: _yPosition,
            child: GestureDetector(
              onTap: _onObjectTappedScare,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red, // The moving object (a red square)
              ),
            ),
          ),
        ],
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ScareScreen extends StatelessWidget {
  const ScareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
      ),
      body: const Center(
        child: Text("You clicked on the object!"),
      ),
    );
  }
}
class WinScreen extends StatelessWidget {
  const WinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
      ),
      body: const Center(
        child: Text("You clicked on the object!"),
      ),
    );
  }
}