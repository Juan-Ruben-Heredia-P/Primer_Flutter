import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Adivina la Palabra',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentWord = WordPair.random().asPascalCase;
  String guessedWord = '';
  String inputLetter = '';
  int lives = 3;
  String resultMessage = '';

  MyAppState() {
    guessedWord = '_' * currentWord.length;
  }

  void checkLetter(String letter) {
    if (lives <= 0) return;

    bool correctGuess = false;
    String newGuessedWord = '';

    for (int i = 0; i < currentWord.length; i++) {
      if (currentWord[i].toLowerCase() == letter.toLowerCase()) {
        newGuessedWord += currentWord[i];
        correctGuess = true;
      } else {
        newGuessedWord += guessedWord[i];
      }
    }

    if (correctGuess) {
      resultMessage = '¡Correcto!';
    } else {
      lives -= 1;
      resultMessage = '¡Incorrecto!';
    }

    guessedWord = newGuessedWord;

    if (!guessedWord.contains('_')) {
      resultMessage = '¡Felicidades! Adivinaste la palabra: $currentWord';
    }

    notifyListeners();
  }

  void resetGame() {
    currentWord = WordPair.random().asPascalCase;
    guessedWord = '_' * currentWord.length;
    lives = 3;
    inputLetter = '';
    resultMessage = '';
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Adivina la Palabra'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (appState.lives > 0 && appState.guessedWord.contains('_')) ...[
                Text(
                  'Palabra a Adivinar:',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  appState.guessedWord,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.yellowAccent,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Introduce una letra:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: TextField(
                        maxLength: 1,
                        onChanged: (value) {
                          appState.inputLetter = value;
                        },
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (appState.inputLetter.isNotEmpty) {
                          appState.checkLetter(appState.inputLetter);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Adivinar'),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                if (appState.resultMessage.isNotEmpty)
                  Text(
                    appState.resultMessage,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                Text(
                  'Vidas: ${appState.lives}',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ] else ...[
                Text(
                  appState.lives > 0
                      ? '¡Felicidades! Adivinaste la palabra: ${appState.currentWord}'
                      : '¡Juego Terminado! La palabra era: ${appState.currentWord}',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: appState.lives > 0
                          ? Colors.greenAccent
                          : Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    appState.resetGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Reiniciar Juego'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
