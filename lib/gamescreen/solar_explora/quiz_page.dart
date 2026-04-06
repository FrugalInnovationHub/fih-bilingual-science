import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'speaker_button.dart';
import 'tts_service.dart';
import 'speaker_button.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _isSubmitted = false;
  bool isSpanish = false;
  bool isSpeaking = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              isSpanish ? '¡Juego Terminado!' : 'Quiz Completed!',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              isSpanish
                  ? 'Tu puntuación es $_score de 10.'
                  : 'Your score is $_score out of 10.',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 12),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                setState(() {
                  _currentIndex = 0;
                  _score = 0;
                  _selectedIndex = null;
                  _isSubmitted = false;
                });
              },
              child: Text(
                isSpanish ? 'Jugar de Nuevo' : 'Play Again',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
              child: Text(
                isSpanish ? 'Inicio' : 'Home',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadQuestions() async {
    final String data = await rootBundle.loadString(
      'assets/solarexplora/space_quiz_questions.json',
    );
    final List<dynamic> jsonResult = json.decode(data);
    final List<Map<String, dynamic>> shuffled = List<Map<String, dynamic>>.from(
      jsonResult,
    )..shuffle();

    setState(() {
      _questions = shuffled.take(10).toList();
    });
  }

  void _submitAnswer() {
    if (_selectedIndex == null) return;

    setState(() {
      _isSubmitted = true;
      if (_selectedIndex == _questions[_currentIndex]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _isSubmitted = false;
      isSpanish = false;
    });
  }

  Future<void> _speakQuestion() async {
    if (_questions.isEmpty || isSpeaking) return;

    final q = _questions[_currentIndex];
    final questionText = isSpanish ? q['question_es'] : q['question_en'];

    final options = isSpanish
        ? List<String>.from(q['options_es'] ?? [])
        : List<String>.from(q['options_en'] ?? []);

    final int answerIndex = (q['answer'] is int) ? q['answer'] : 0;
    final correctAnswer = isSpanish
        ? q['options_es'][answerIndex]
        : q['options_en'][answerIndex];

    setState(() {
      isSpeaking = true;
    });

    await TTSService.stop();
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_isSubmitted) {
      await TTSService.speak(
        '$questionText ${options.join(', ')}',
        language: isSpanish ? 'es-ES' : 'en-US',
      );
    } else {
      await TTSService.speak(
        '$questionText $correctAnswer',
        language: isSpanish ? 'es-ES' : 'en-US',
      );
    }

    setState(() {
      isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    final questionText = isSpanish
        ? (question['question_es'] ?? 'Pregunta no disponible')
        : (question['question_en'] ?? 'Question not available');
    final options = isSpanish
        ? List<String>.from(question['options_es'] ?? [])
        : List<String>.from(question['options_en'] ?? []);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🔙 Back Button + 🔤 Language Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IgnorePointer(
                    ignoring: isSpeaking,
                    child: Opacity(
                      opacity: isSpeaking ? 0.4 : 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'EN',
                              style: TextStyle(
                                color: isSpanish
                                    ? Colors.white54
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch(
                              value: isSpanish,
                              onChanged: (value) {
                                setState(() {
                                  isSpanish = value;
                                });
                              },
                              activeColor: Colors.orange,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
                            ),
                            Text(
                              'ES',
                              style: TextStyle(
                                color: isSpanish
                                    ? Colors.white
                                    : Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// ❓ Question
              Text(
                questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              /// 🧠 Options
              ...List.generate(options.length, (index) {
                Color? bgColor;
                final int answerIndex = (question['answer'] is int)
                    ? question['answer']
                    : 0;

                if (_isSubmitted) {
                  if (index == answerIndex) {
                    bgColor = Colors.green;
                  } else if (index == _selectedIndex) {
                    bgColor = Colors.red;
                  } else {
                    bgColor = Colors.white10;
                  }
                } else {
                  bgColor = _selectedIndex == index
                      ? Colors.white24
                      : Colors.white10;
                }

                return GestureDetector(
                  onTap: () {
                    if (_isSubmitted) return;
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      options[index],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// 🎯 Submit / Next
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (!_isSubmitted) {
                      _submitAnswer();
                    } else if (_currentIndex < _questions.length - 1) {
                      _nextQuestion();
                    } else {
                      _showScoreDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    !_isSubmitted
                        ? (isSpanish ? 'Enviar' : 'Submit')
                        : (_currentIndex < _questions.length - 1
                              ? (isSpanish ? 'Siguiente' : 'Next')
                              : (isSpanish ? 'Terminar' : 'Finish')),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// 🔊 Speaker
      floatingActionButton: SpeakerButton(
        isSpanish: isSpanish,
        textSegments: !_isSubmitted
            ? [questionText, ...options]
            : [questionText, options[question['answer']]],
      ),
    );
  }
}
