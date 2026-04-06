import 'package:flutter/material.dart';
import 'planet_page.dart';
import 'speaker_button.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool isSpanish = false;
  int highlightedIndex = -1;
  bool isSpeaking = false;

  final Map<String, Offset> planetPositions = {
    'Sun': Offset(50, 700),
    'Mercury': Offset(130, 450),
    'Venus': Offset(380, 750),
    'Earth': Offset(470, 560),
    'Mars': Offset(325, 260),
    'Jupiter': Offset(635, 450),
    'Saturn': Offset(825, 725),
    'Uranus': Offset(775, 190),
    'Neptune': Offset(1035, 420),
  };

  final Map<String, String> spanishNames = {
    'Sun': 'Sol',
    'Mercury': 'Mercurio',
    'Venus': 'Venus',
    'Earth': 'Tierra',
    'Mars': 'Marte',
    'Jupiter': 'Júpiter',
    'Saturn': 'Saturno',
    'Uranus': 'Urano',
    'Neptune': 'Neptuno',
  };

  void navigateToPlanet(String planet) {
    // TODO: Implement navigation to planet detail page
    final Map<String, dynamic> planetData = {
      'Sun': {
        'spanishName': 'Sol',
        'backgroundImage': 'assets/solarexplora/Sun.png',
        'englishFacts': [
          'The Sun is a giant ball of hot gas and its over 100 times wider than Earth!',
          'It’s so big that more than a million Earths could fit inside it!',
          'It gives us light and warmth so we can live on Earth.',
          'Without the Sun, there would be no day and no plants!',
        ],
        'spanishFacts': [
          '¡El Sol es una bola gigante de gas caliente y es más de 100 veces más ancha que la Tierra!',
          '¡Es tan grande que en su interior cabrían más de un millón de Tierras!',
          'Nos da luz y calor para que podamos vivir en la Tierra.',
          '¡Sin el Sol no habría día ni plantas!',
        ],
      },
      'Mercury': {
        'spanishName': 'Mercurio',
        'backgroundImage': 'assets/solarexplora/Mercury.png',
        'englishFacts': [
          'Mercury is the closest planet to the Sun.',
          'It’s the smallest planet in the solar system.',
          'A year on Mercury is just 88 Earth days long.',
          'It’s so small you could fit 18 Mercurys inside Earth.',
          'It’s super hot in the day and freezing at night.',
        ],
        'spanishFacts': [
          'Mercurio es el planeta más cercano al Sol.',
          'Es el planeta más pequeño del sistema solar.',
          'Un año en Mercurio dura sólo 88 días terrestres.',
          'Es tan pequeña que cabría 18 Mercurios dentro de la Tierra.',
          'Hace mucho calor durante el día y mucho frío por la noche.',
        ],
      },
      'Venus': {
        'spanishName': 'Venus',
        'backgroundImage': 'assets/solarexplora/Venus.png',
        'englishFacts': [
          'Venus is the hottest planet in our solar system. Even hotter than Mercury!',
          'Venus spins backwards, so the Sun rises in the west and sets in the east.',
          'It rains metal on Venus, but it evaporates before hitting the ground.',
          'It has clouds made of acid – you definitely can’t breathe there!',
          'Venus is the brightest object in the night sky after the Moon.',
        ],
        'spanishFacts': [
          'Venus es el planeta más caliente de nuestro sistema solar. ¡Incluso más caliente que Mercurio!',
          'Venus gira hacia atrás, por lo que el Sol sale por el oeste y se pone por el este.',
          'En Venus llueve metal, pero se evapora antes de tocar el suelo.',
          'Tiene nubes hechas de ácido: ¡definitivamente no se puede respirar allí!',
          'Venus es el objeto más brillante del cielo nocturno después de la Luna.',
        ],
      },
      'Earth': {
        'spanishName': 'Tierra',
        'backgroundImage': 'assets/solarexplora/Earth.png',
        'englishFacts': [
          'Earth is the only planet we know with life.',
          'Earth is the only planet with liquid water on the surface.',
          'It’s the perfect distance from the Sun for life – not too hot or cold.',
          'From space, Earth looks like a blue marble!',
          'About 70% of Earth is covered in water.',
        ],
        'spanishFacts': [
          'La Tierra es el único planeta que conocemos con vida.',
          'La Tierra es el único planeta con agua líquida en la superficie.',
          'Está a la distancia perfecta del Sol para la vida: ni demasiado caliente ni demasiado frío.',
          '¡Desde el espacio, la Tierra parece una canica azul!',
          'Aproximadamente el 70% de la Tierra está cubierta de agua.',
        ],
      },
      'Mars': {
        'spanishName': 'Marte',
        'backgroundImage': 'assets/solarexplora/Mars.png',
        'englishFacts': [
          'Mars is known as the Red Planet because of its rusty color.',
          'Mars has seasons, just like Earth!',
          'Scientists think Mars might have had water a long time ago.',
          'Mars has two small moons: Phobos and Deimos.',
          'Scientists think humans might live on Mars someday!',
        ],
        'spanishFacts': [
          'A Marte se le conoce como el Planeta Rojo por su color oxidado.',
          'Marte tiene estaciones, ¡al igual que la Tierra!',
          'Los científicos creen que Marte pudo haber tenido agua hace mucho tiempo.',
          'Marte tiene dos lunas pequeñas: Fobos y Deimos.',
          '¡Los científicos creen que los humanos podrían vivir en Marte algún día!',
        ],
      },
      'Jupiter': {
        'spanishName': 'Júpiter',
        'backgroundImage': 'assets/solarexplora/Jupiter.png',
        'englishFacts': [
          'Jupiter is the biggest planet in the solar system!',
          'It has a giant storm called the Great Red Spot – it’s bigger than Earth!',
          'You could fit 1,300 Earths inside Jupiter.',
          'Jupiter has over 90 moons – one of them, Ganymede, is the biggest moon in the solar system.',
        ],
        'spanishFacts': [
          '¡Júpiter es el planeta más grande del sistema solar!',
          'Tiene una tormenta gigante llamada Gran Mancha Roja: ¡es más grande que la Tierra!',
          'Podrían caber 1.300 Tierras dentro de Júpiter.',
          'Júpiter tiene más de 90 lunas; una de ellas, Ganímedes, es la luna más grande del sistema solar.',
        ],
      },
      'Saturn': {
        'spanishName': 'Saturno',
        'backgroundImage': 'assets/solarexplora/Saturn.png',
        'englishFacts': [
          'Saturn is famous for its beautiful rings.',
          'Its rings are made of ice and rock.',
          'It’s so light, it could float in water (if you could find a big enough tub)!',
          'A year on Saturn takes about 29 Earth years.',
        ],
        'spanishFacts': [
          'Saturno es famosa por sus hermosos anillos.',
          'Sus anillos están hechos de hielo y roca.',
          '¡Es tan liviano que podría flotar en el agua (si pudieras encontrar una tina lo suficientemente grande)!',
          'Un año en Saturno dura unos 29 años terrestres.',
        ],
      },
      'Uranus': {
        'spanishName': 'Urano',
        'backgroundImage': 'assets/solarexplora/Uranus.png',
        'englishFacts': [
          'It’s the coldest planet in the solar system.',
          'Uranus was the first planet discovered with a telescope.',
          'Its atmosphere smells like rotten eggs because of hydrogen sulfide!',
          'Uranus spins on its side – it’s like its rolling around the Sun!',
        ],
        'spanishFacts': [
          'Es el planeta más frío del sistema solar.',
          'Urano fue el primer planeta descubierto con un telescopio.',
          '¡Su atmósfera huele a huevos podridos debido al sulfuro de hidrógeno!',
          'Urano gira de costado: ¡es como si estuviera girando alrededor del Sol!',
        ],
      },
      'Neptune': {
        'spanishName': 'Neptuno',
        'backgroundImage': 'assets/solarexplora/Neptune.png',
        'englishFacts': [
          'Neptune is the farthest planet from the Sun.',
          'It has super strong winds – faster than any hurricane on Earth!',
          'It takes 165 Earth years to go around the Sun once.',
          'Neptune has seasons, but each one lasts over 40 years!',
        ],
        'spanishFacts': [
          'Neptuno es el planeta más alejado del Sol.',
          'Tiene vientos súper fuertes, ¡más rápidos que cualquier huracán en la Tierra!',
          'Se necesitan 165 años terrestres para dar una vuelta alrededor del Sol.',
          'Neptuno tiene estaciones, ¡pero cada una dura más de 40 años!',
        ],
      },
    };

    final data = planetData[planet];
    if (data != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlanetPage(
            planetName: planet,
            spanishName: data['spanishName'],
            backgroundImage: data['backgroundImage'],
            englishFacts: List<String>.from(data['englishFacts']),
            spanishFacts: List<String>.from(data['spanishFacts']),
          ),
        ),
      );
    } else {
      print('Planet data not found for: $planet');
    }
    print('Tapped on $planet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/solarexplora/solarsystem1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 🌍 Planet labels with tap interaction
          ...planetPositions.entries.map((entry) {
            final name = isSpanish ? spanishNames[entry.key]! : entry.key;
            return Positioned(
              left: entry.value.dx,
              top: entry.value.dy,
              child: GestureDetector(
                onTap: () => navigateToPlanet(entry.key),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        highlightedIndex ==
                            planetPositions.keys.toList().indexOf(entry.key)
                        ? Colors.orange
                        : Colors.white,
                    shadows: const [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // 🔙 Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 🔤 Language toggle button (like homepage)
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                              color: isSpeaking
                                  ? Colors.white24
                                  : (isSpanish ? Colors.white54 : Colors.white),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: isSpanish,
                            onChanged: isSpeaking
                                ? null
                                : (value) {
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
                              color: isSpeaking
                                  ? Colors.white24
                                  : (isSpanish ? Colors.white54 : Colors.white),
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
          ),
          // 🔊 Speaker button
          SpeakerButton(
            textSegments: planetPositions.keys
                .map((key) => isSpanish ? spanishNames[key]! : key)
                .toList(),
            isSpanish: isSpanish,
            onSegmentSpoken: (index) {
              setState(() {
                highlightedIndex = index;
              });
            },
            onSpeakingChanged: (speaking) {
              setState(() {
                isSpeaking = speaking;
              });
            },
          ),
        ],
      ),
    );
  }
}
