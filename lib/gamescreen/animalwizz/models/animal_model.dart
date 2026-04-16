import 'package:flutter/material.dart';

// NOTE: Some animal images and sounds need to be added to assets folder:
// Missing images: cow.png, monkey.png, giraffe.png, gorilla.png
// Missing sounds: All animal sounds (cow.mp3, lion.mp3, etc.)
// Use jpg versions where png is not available

enum FoodType { meat, grass, fish, fruits }

class AnimalModel {
  final String englishName;
  final String spanishName;
  final String image;
  final String sound;
  final FoodType correctFood;
  final String factEnglish;
  final String factSpanish;

  const AnimalModel({
    required this.englishName,
    required this.spanishName,
    required this.image,
    required this.sound,
    required this.correctFood,
    required this.factEnglish,
    required this.factSpanish,
  });
}

class FoodOption {
  final FoodType type;
  final String englishName;
  final String spanishName;
  final String emoji;
  final Color color;

  const FoodOption({
    required this.type,
    required this.englishName,
    required this.spanishName,
    required this.emoji,
    required this.color,
  });
}

// Animal Data for the game
const List<AnimalModel> animalData = [

  // SHARK
  AnimalModel(
    englishName: 'Shark',
    spanishName: 'Tiburón',
    image: 'assets/animalwizz/images/shark.jpg',
    sound: 'assets/animalwizz/sounds/shark.mp3',
    correctFood: FoodType.fish,
    factEnglish: 'Sharks are ocean predators that eat fish and other sea creatures!',
    factSpanish: '¡Los tiburones son depredadores del océano que comen pescado y otras criaturas marinas!',
  ),

  // LION
  AnimalModel(
    englishName: 'Lion',
    spanishName: 'León',
    image: 'assets/animalwizz/images/lion.jpg',
    sound: 'assets/animalwizz/sounds/lion.mp3',
    correctFood: FoodType.meat,
    factEnglish: 'Lions are carnivores and the king of the jungle! They hunt for meat.',
    factSpanish: '¡Los leones son carnívoros y el rey de la selva! Cazan carne.',
  ),

  // MONKEY
  AnimalModel(
    englishName: 'Monkey',
    spanishName: 'Mono',
    image: 'assets/animalwizz/images/chimpanzee.jpg', // Using chimp as placeholder
    sound: 'assets/animalwizz/sounds/monkey.mp3',
    correctFood: FoodType.fruits,
    factEnglish: 'Monkeys love bananas, apples, and other fruits! They are omnivores.',
    factSpanish: '¡A los monos les encantan los plátanos, las manzanas y otras frutas! Son omnívoros.',
  ),

  // PENGUIN
  AnimalModel(
    englishName: 'Penguin',
    spanishName: 'Pingüino',
    image: 'assets/animalwizz/images/penguin.png',
    sound: 'assets/animalwizz/sounds/penguin.mp3',
    correctFood: FoodType.fish,
    factEnglish: 'Penguins are great swimmers and love to eat fish from the ocean!',
    factSpanish: '¡Los pingüinos son grandes nadadores y les encanta comer pescado del océano!',
  ),

  // ELEPHANT
  AnimalModel(
    englishName: 'Elephant',
    spanishName: 'Elefante',
    image: 'assets/animalwizz/images/elephant.jpg',
    sound: 'assets/animalwizz/sounds/elephant.mp3',
    correctFood: FoodType.grass,
    factEnglish: 'Elephants are the largest land animals and eat grass, leaves, and fruits!',
    factSpanish: '¡Los elefantes son los animales terrestres más grandes y comen hierba, hojas y frutas!',
  ),

  // TIGER
  AnimalModel(
    englishName: 'Tiger',
    spanishName: 'Tigre',
    image: 'assets/animalwizz/images/tiger.jpg',
    sound: 'assets/animalwizz/sounds/tiger.mp3',
    correctFood: FoodType.meat,
    factEnglish: 'Tigers are powerful carnivores and excellent hunters!',
    factSpanish: '¡Los tigres son carnívoros poderosos y excelentes cazadores!',
  ),

  // DOLPHIN
  AnimalModel(
    englishName: 'Dolphin',
    spanishName: 'Delfín',
    image: 'assets/animalwizz/images/dolphin.jpg',
    sound: 'assets/animalwizz/sounds/dolphin.mp3',
    correctFood: FoodType.fish,
    factEnglish: 'Dolphins are smart sea mammals that eat fish and squid!',
    factSpanish: '¡Los delfines son mamíferos marinos inteligentes que comen pescado y calamares!',
  ),

    // SHEEP
  AnimalModel(
    englishName: 'Sheep',
    spanishName: 'Oveja',
    image: 'assets/animalwizz/images/sheep.png',
    sound: 'assets/animalwizz/sounds/sheep.mp3',
    correctFood: FoodType.grass,
    factEnglish: 'Sheep are gentle farm animals that love to eat grass and plants!',
    factSpanish: '¡Las ovejas son animales de granja gentiles que les encanta comer hierba y plantas!',
  ),

  // HORSE
  AnimalModel(
    englishName: 'Horse',
    spanishName: 'Caballo',
    image: 'assets/animalwizz/images/horse.jpg',
    sound: 'assets/animalwizz/sounds/horse.mp3',
    correctFood: FoodType.grass,
    factEnglish: 'Horses are fast runners and love to eat grass, hay, and plants!',
    factSpanish: '¡Los caballos son corredores rápidos y les encanta comer hierba, heno y plantas!',
  ),

  // FROG
  AnimalModel(
    englishName: 'Frog',
    spanishName: 'Rana',
    image: 'assets/animalwizz/images/frog.png',
    sound: 'assets/animalwizz/sounds/frog.mp3',
    correctFood: FoodType.fish, // closest available option in your current FoodType enum
    factEnglish: 'Frogs are amphibians that eat insects and live near water!',
    factSpanish: '¡Las ranas son anfibios que comen insectos y viven cerca del agua!',
  ),


  // GORILLA
  AnimalModel(
    englishName: 'Gorilla',
    spanishName: 'Gorila',
    image: 'assets/animalwizz/images/chimpanzee.jpg', // TODO: Add gorilla.png
    sound: 'assets/animalwizz/sounds/gorilla.mp3',
    correctFood: FoodType.fruits,
    factEnglish: 'Gorillas are strong primates that love to eat fruits and plants!',
    factSpanish: '¡Los gorilas son primates fuertes que aman comer frutas y plantas!',
  ),

];
