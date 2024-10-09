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
  final AudioPlayer _audioPlayer1 = AudioPlayer();
  final AudioPlayer _audioPlayer2 = AudioPlayer();
  final AudioPlayer _audioPlayer3 = AudioPlayer();
  final AudioPlayer _audioPlayer4 = AudioPlayer();
  //winning spider
  double _winningSpiderX = 100;
  double _winningSpiderY = 150;

  final int objectCount = 5; //Number of spiders
  List<Offset> _positions = [];
  final Random _random = Random();

  @override
  
  void initState() {
    super.initState();
    _loadSounds();
     _positions = List.generate(
      objectCount,
      (_) => Offset(
        _random.nextDouble() * 300, // Initial random x position
        _random.nextDouble() * 500, // Initial random y position
      ),
    );
    // Start moving the object randomly every second
    Timer.periodic( Duration(seconds: 1 ), (Timer timer) {
      setState(() { 
        _positions = List.generate(
          objectCount,
          (_) => Offset(
            _random.nextDouble() * MediaQuery.of(context).size.width - 150,
            _random.nextDouble() * MediaQuery.of(context).size.height - 150,
          ),
        );
         // Random movement for the winner
        _winningSpiderX = _random.nextDouble() * MediaQuery.of(context).size.width - 100;
        _winningSpiderY = _random.nextDouble() * MediaQuery.of(context).size.height - 100;
      });
    });
  }

  Future<void> _loadSounds() async {
    await Future.wait([
      _audioPlayer1.setAsset('assets/squish.mp3'),
      _audioPlayer2.setAsset('assets/scream.mp3'),
      _audioPlayer3.setAsset('assets/Ghost House.mp3'),
      _audioPlayer4.setAsset('assets/Spooky.mp3'),
    ]);
    _audioPlayer3.play();
  }

  void _playSound(int soundIndex) {
    switch (soundIndex) {
      case 1:
        _audioPlayer1.seek(Duration.zero);
        _audioPlayer1.play();
        break;
      case 2:
        _audioPlayer2.seek(Duration.zero);
        _audioPlayer2.play();
        break;
      case 3:
        _audioPlayer3.seek(Duration.zero);
        _audioPlayer3.play();
        break;
      case 4:
        _audioPlayer4.seek(Duration.zero);
        _audioPlayer4.play();
        break;
    }
  }

  void _onObjectTappedScare() {
    // Navigate to a different screen when the object is tapped
    _playSound(2);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScareScreen()),
    );
  }

  void _onObjectTappedWin() {
    // Navigate to a different screen when the object is tapped
    _playSound(1);
    _audioPlayer3.stop();
    _audioPlayer4.play();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WinScreen()),
    );
  }

  @override
  void dispose() {
    _audioPlayer1.dispose();
    _audioPlayer2.dispose();
    _audioPlayer3.dispose();
    _audioPlayer4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the SpiderScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Squish The Spiders"),
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

        for (int i = 0; i < objectCount; i++)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            left: _positions[i].dx,
              top: _positions[i].dy,
            child: GestureDetector(
              onTap: _onObjectTappedScare,
              child: Image.asset("assets/spider.gif", width: 200,height: 200,),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            left: _winningSpiderX,
            top: _winningSpiderY,
            child: GestureDetector(
              onTap: _onObjectTappedWin, // Navigate to separate screen
              child: Image.asset(
                'assets/spider.gif', // Separate image path
                width: 200, // Customize size of the separate object
                height: 200,
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
        title: const Text("BOO!!!"),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You clicked a Ghost!'),
            Image.asset(
              'assets/ghost.png',
              height: 200,
              width: 200,
            )
          ],
        ),
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
        title: const Text("NICE!!!"),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You squished the spider!'),
            Image.asset(
              'assets/skeletons.png',
              height: 200,
              width: 200,
            )
          ],
        ),
      ),
    );
  }
}