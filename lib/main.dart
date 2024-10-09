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
      home: WelcomeScreen( ),
    );
  }
}
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wall.jpg"), // Add your image in the assets folder
                fit: BoxFit.cover,
              ),
            ),
          
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Spider Squishing Game!',
              style: TextStyle(
                fontSize: 44,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            ),
             ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpiderScreen(spiderCount: 4), // Easy
                    ),
                  );
                },
                child: const Text('Easy (5 Spiders)'),
                
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpiderScreen(spiderCount: 9), // Medium
                    ),
                  );
                },
                child: const Text('Medium (10 Spiders)'),

              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpiderScreen(spiderCount: 15), // Hard
                    ),
                  );
                },
                child: const Text('Hard (15 Spiders)'),
              ),
              const SizedBox(height: 10),
               ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpiderScreen(spiderCount: 30), // Hard
                    ),
                  );
                },
                child: const Text('Nightmare (30 Spiders)'),
              ),
          ],
        ),
      ),
    ) 
    );
  }
}

class SpiderScreen extends StatefulWidget {
  final int spiderCount;
  
  SpiderScreen({super.key, required this.spiderCount});

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

  //int spiderCount = 7; //Number of spiders
  List<Offset> _positions = [];
  final Random _random = Random();

  List<bool> _isSquished = [];

  @override
  void initState() {
    super.initState();
    _loadSounds();
    _positions = List.generate(
      widget.spiderCount,
      (_) => Offset(
        _random.nextDouble() * 300, // Initial random x position
        _random.nextDouble() * 500, // Initial random y position
      ),
    );

    // Start moving the object randomly every second
    _isSquished = List.generate(widget.spiderCount, (_) => false);
    
    Timer.periodic( Duration(seconds: 1 ), (Timer timer) {
      setState(() { 
        _positions = List.generate(
          widget.spiderCount,
          (_) => Offset(
            _random.nextDouble() * (MediaQuery.of(context).size.width - 150),
            _random.nextDouble() * (MediaQuery.of(context).size.height - 150),
          ),
        );
         // Random movement for the winner
        _winningSpiderX = _random.nextDouble() * (MediaQuery.of(context).size.width - 100);
        _winningSpiderY = _random.nextDouble() * (MediaQuery.of(context).size.height - 100);
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

  void _onObjectTappedScare(int index) {
    // Navigate to a different screen when the object is tapped
    _playSound(2);
    setState(() {
       _isSquished[index] = true;
    });
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

        for (int i = 0; i < widget.spiderCount; i++)
          TweenAnimationBuilder(
            tween: Tween<Offset>(begin: Offset(0, 0), end: _positions[i]),
            duration: const Duration(seconds: 2),
            
            builder: (context, Offset offset, child){
              return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: child!,
              );
            },
            
            child: GestureDetector(
              onTap:!_isSquished[i] ? () => _onObjectTappedScare(i): null,
              child:  _isSquished[i]
              ? Image.asset("assets/ghost.png", width: 100, height: 100,)
              : Image.asset("assets/spider.gif", width: 200,height: 200,),
            )
          ),

          AnimatedPositioned(
            duration: const Duration(seconds: 2),
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