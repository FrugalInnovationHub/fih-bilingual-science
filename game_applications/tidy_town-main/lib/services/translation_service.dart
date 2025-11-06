import 'package:flutter_tts/flutter_tts.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final FlutterTts flutterTts = FlutterTts();
  bool _isSpanish = false;

  bool get isSpanish => _isSpanish;

  final Map<String, String> _translations = {
    // Home Screen
    "Let's play": "Vamos a jugar",
    "Recycle": "Reciclar",
    "Compost": "Compostar",
    "Landfill": "Vertedero",
    "Settings": "Ajustes",
    "Logout": "Cerrar sesión",
    "Cancel": "Cancelar",
    "😢 Logout?": "😢 ¿Cerrar sesión?",
    "Hey Western! Are you sure you want to logout?": "¡Hola Western! ¿Estás seguro de que quieres cerrar sesión?",
    "Recycling ♻️": "Reciclaje ♻️",

    // Recycle Screen Titles and Subtitles
    "What is Recycling?": "¿Qué es el Reciclaje?",
    "Learn about recycling in a fun way! 🌟": "¡Aprende sobre el reciclaje de una manera divertida! 🌟",
    "What Can Be Recycled?": "¿Qué se Puede Reciclar?",
    "Discover recyclable items! 🔍": "¡Descubre los artículos reciclables! 🔍",
    "Why Should We Recycle?": "¿Por Qué Debemos Reciclar?",
    "Meet Tommy the Turtle! 🐢": "¡Conoce a Tommy la Tortuga! 🐢",
    "Recycle Quiz": "Cuestionario de Reciclaje",
    "Test your knowledge! 🎯": "¡Pon a prueba tus conocimientos! 🎯",

    // Captain Recycle's Message
    "Hi! I'm Captain Recycle! Recycling is like giving trash super powers! We take old things like bottles and paper and turn them into new things. It's like magic that helps keep our Earth clean and happy! 🌍✨": 
    "¡Hola! ¡Soy el Capitán Reciclaje! ¡Reciclar es como darle superpoderes a la basura! Tomamos cosas viejas como botellas y papel y las convertimos en cosas nuevas. ¡Es como magia que ayuda a mantener nuestra Tierra limpia y feliz! 🌍✨",

    // Tommy's Message
    "Meet Tommy the Turtle! He wants to tell you why recycling is important:\n\n🌊 It keeps our oceans clean for sea animals\n🌳 Saves trees and forests\n⚡ Helps save energy\n🌍 Makes Earth happy and healthy!":
    "¡Conoce a Tommy la Tortuga! Quiere contarte por qué es importante reciclar:\n\n🌊 Mantiene nuestros océanos limpios para los animales marinos\n🌳 Salva árboles y bosques\n⚡ Ayuda a ahorrar energía\n🌍 ¡Hace que la Tierra esté feliz y saludable!",

    // Quiz Content
    "Tap the items that can be recycled!": "¡Toca los artículos que se pueden reciclar!",
    "Yes! This can be recycled! ⭐": "¡Sí! ¡Esto se puede reciclar! ⭐",
    "Oops! This cannot be recycled. Try again! 💫": "¡Ups! Esto no se puede reciclar. ¡Inténtalo de nuevo! 💫",

    // Common items
    "Paper and Cardboard": "Papel y Cartón",
    "Plastic Bottles": "Botellas de Plástico",
    "Glass Containers": "Envases de Vidrio",
    "Metal Cans": "Latas de Metal",
    "Pizza Box (with grease)": "Caja de Pizza (con grasa)",
    "Banana Peel": "Cáscara de Plátano",
    "Fruit and Vegetable Scraps": "Restos de Frutas y Verduras",
    "Coffee Grounds": "Café Molido",
    "Yard Trimmings": "Recortes de Jardín",
    "Eggshells": "Cáscaras de Huevo",
    "Broken Ceramics": "Cerámicas Rotas",
    "Used Tissues": "Pañuelos Usados",
    "Styrofoam": "Poliestireno",
    "Plastic Bags": "Bolsas de Plástico",

    // Item descriptions
    "Flatten cardboard boxes and keep paper clean and dry": "Aplana las cajas de cartón y mantén el papel limpio y seco",
    "Rinse bottles and remove caps before recycling": "Enjuaga las botellas y quita las tapas antes de reciclar",
    "Clean and empty glass bottles and jars": "Limpia y vacía botellas y frascos de vidrio",
    "Rinse cans and crush if possible to save space": "Enjuaga las latas y aplástalas si es posible para ahorrar espacio",
    "All fruit and vegetable waste can be composted": "Todos los residuos de frutas y verduras se pueden compostar",
    "Coffee grounds and filters are great for composting": "El café molido y los filtros son excelentes para el compostaje",
    "Grass clippings, leaves, and small twigs": "Recortes de césped, hojas y ramitas pequeñas",
    "Crushed eggshells add calcium to your compost": "Las cáscaras de huevo trituradas agregan calcio a tu compost",
    "Broken plates, cups, and other ceramics cannot be recycled": "Los platos, tazas y otras cerámicas rotas no se pueden reciclar",
    "Used tissues and paper towels are not recyclable": "Los pañuelos y toallas de papel usados no son reciclables",
    "Most places cannot recycle styrofoam packaging": "La mayoría de los lugares no pueden reciclar el empaque de poliestireno",
    "Regular plastic bags cannot be recycled in normal bins": "Las bolsas de plástico normales no se pueden reciclar en contenedores normales",
    "Why is it Important?": "¿Por qué es Importante?",
    "Gives trash a second life": "Dale una segunda vida a la basura",
    "Helps plants and animals": "Ayuda a las plantas y animales",
    "Makes our planet happy": "Hace feliz a nuestro planeta",
    "Keeps our home clean": "Mantiene limpio nuestro hogar",
    "Listen to the Story": "Escuchar la Historia",

    // Story Titles
    "Tommy and the Talking Bottle": "Tommy y la Botella Parlante",
    "Luna the Leaf's Big Idea": "La Gran Idea de Luna la Hoja",
    "Wally the Water Bottle's Second Chance": "La Segunda Oportunidad de Wally la Botella de Agua",
    "Rocky the Robot's Recycling Adventure": "La Aventura de Reciclaje del Robot Rocky",
    
    // Rocky's Story
    "Hi kids! I'm Rocky, a recycling robot from the future! 🤖": 
    "¡Hola niños! ¡Soy Rocky, un robot reciclador del futuro! 🤖",
    
    "In my time, we learned how important recycling is for our planet.":
    "En mi tiempo, aprendimos lo importante que es reciclar para nuestro planeta.",
    
    "Did you know? Every item you recycle helps save energy and resources!":
    "¿Sabías que? ¡Cada artículo que reciclas ayuda a ahorrar energía y recursos!",
    
    "When we recycle one aluminum can, we save enough energy to power a TV for 3 hours!":
    "¡Cuando reciclamos una lata de aluminio, ahorramos suficiente energía para alimentar un televisor durante 3 horas!",
    
    "And when we recycle paper, we save trees that help clean our air!":
    "¡Y cuando reciclamos papel, salvamos árboles que ayudan a limpiar nuestro aire!",
    
    "In the future, we have special recycling machines everywhere!":
    "¡En el futuro, tenemos máquinas especiales de reciclaje en todas partes!",
    
    "But we need YOUR help today to make that future possible!":
    "¡Pero necesitamos TU ayuda hoy para hacer posible ese futuro!",
    
    "Remember: Every time you recycle, you're a hero for our planet! 🌍✨":
    "Recuerda: ¡Cada vez que reciclas, eres un héroe para nuestro planeta! 🌍✨",
    
    // Navigation
    "Previous": "Anterior",
    "Next": "Siguiente",
    "Listen": "Escuchar",
    "Stop": "Detener",

    // Tommy's Story
    "Tommy the Turtle: \"Whoa! What's that shiny thing in the sand?\"": 
    "Tommy la Tortuga: \"¡Guau! ¿Qué es esa cosa brillante en la arena?\"",
    
    "Plastic Bottle: \"Hi Tommy! I'm a lonely bottle. I got thrown away and ended up here!\"":
    "Botella de Plástico: \"¡Hola Tommy! Soy una botella solitaria. ¡Me tiraron y terminé aquí!\"",
    
    "Tommy the Turtle: \"Oh no! Aren't you supposed to go in the recycling bin?\"":
    "Tommy la Tortuga: \"¡Oh no! ¿No deberías estar en el contenedor de reciclaje?\"",
    
    "Plastic Bottle: \"Yes! If someone had recycled me, I could've become a toy or even a t-shirt!\"":
    "Botella de Plástico: \"¡Sí! Si alguien me hubiera reciclado, ¡podría haberme convertido en un juguete o incluso en una camiseta!\"",
    
    "Tommy the Turtle: \"Kids, did you hear that? Recycling helps me keep the beach clean!\"":
    "Tommy la Tortuga: \"Niños, ¿escucharon eso? ¡El reciclaje me ayuda a mantener la playa limpia!\"",
    
    "Plastic Bottle: \"And it gives me a chance to be useful again! Let's all recycle!\"":
    "Botella de Plástico: \"¡Y me da la oportunidad de ser útil de nuevo! ¡Vamos todos a reciclar!\"",
    
    "Narrator: \"Tommy and the bottle high-fived (well, sort of), and off they went to find the recycling bin!\"":
    "Narrador: \"Tommy y la botella chocaron los cinco (bueno, más o menos), ¡y se fueron a buscar el contenedor de reciclaje!\"",

    // Luna's Story
    "Luna the Leaf: \"Hi friends! I'm Luna. I live in a big, happy forest.\"":
    "Luna la Hoja: \"¡Hola amigos! Soy Luna. Vivo en un bosque grande y feliz.\"",
    
    "Luna the Leaf: \"But my forest friends are in danger because too many trees are being cut down.\"":
    "Luna la Hoja: \"Pero mis amigos del bosque están en peligro porque están cortando demasiados árboles.\"",
    
    "Bobby the Bin: \"Hey Luna! If kids recycle paper, we don't need to cut so many trees!\"":
    "Bobby el Contenedor: \"¡Hola Luna! Si los niños reciclan papel, ¡no necesitamos cortar tantos árboles!\"",
    
    "Luna the Leaf: \"That's right! Recycling paper saves homes for birds, bugs, and bears too!\"":
    "Luna la Hoja: \"¡Así es! ¡Reciclar papel salva hogares para pájaros, insectos y osos también!\"",
    
    "Bobby the Bin: \"Plus, it saves energy and keeps our Earth cool and clean.\"":
    "Bobby el Contenedor: \"Además, ahorra energía y mantiene nuestra Tierra fresca y limpia.\"",
    
    "Luna the Leaf: \"Let's be Earth heroes and recycle every day!\"":
    "Luna la Hoja: \"¡Seamos héroes de la Tierra y reciclemos todos los días!\"",

    // Story Selection
    "Choose a story to learn why recycling is important!": "¡Elige una historia para aprender por qué es importante reciclar!",

    // Wally's Story
    "I was once shiny and full of fresh water. But now? I lay crumpled under a park bench, forgotten.":
    "Una vez fui brillante y lleno de agua fresca. ¿Pero ahora? Estoy arrugado bajo un banco del parque, olvidado.",

    "I wish I had a purpose again...":
    "Desearía tener un propósito de nuevo...",

    "Suddenly, a little girl named Maya picked me up!":
    "¡De repente, una niña llamada Maya me recogió!",

    "Don't worry, Wally! You're going in the recycling bin!":
    "¡No te preocupes, Wally! ¡Vas al contenedor de reciclaje!",

    "I was nervous... What's going to happen to me?":
    "Estaba nervioso... ¿Qué me va a pasar?",

    "You'll see—it's the beginning of something amazing!":
    "Ya verás, ¡es el comienzo de algo increíble!",

    "At the recycling center, I met tons of new friends—Cans, newspapers, yogurt cups, even a cereal box!":
    "En el centro de reciclaje, conocí a muchos nuevos amigos: latas, periódicos, vasos de yogur, ¡incluso una caja de cereal!",

    "We were all getting sorted on loud conveyor belts.":
    "Todos estábamos siendo clasificados en ruidosas cintas transportadoras.",

    "Plastic over here! called a robotic arm, scooping me up.":
    "¡Plástico por aquí! gritó un brazo robótico, recogiéndome.",

    "I got cleaned, squished, melted, and stretched! At first, it tickled.":
    "¡Me limpiaron, aplastaron, derritieron y estiraron! Al principio, me hacía cosquillas.",

    "I felt different. I'm... I'm not a bottle anymore!":
    "Me sentía diferente. ¡Ya... ya no soy una botella!",

    "I had become a part of a shiny new backpack!":
    "¡Me había convertido en parte de una nueva mochila brillante!",

    "Maya wore the new backpack to school proudly.":
    "Maya llevó la nueva mochila a la escuela con orgullo.",

    "Recycling gives things like Wally a second chance, I told my class.":
    "El reciclaje le da una segunda oportunidad a cosas como Wally, le dije a mi clase.",

    "And I? I beamed with joy. I'm back in the world—better and braver than ever!":
    "¿Y yo? Brillé de alegría. ¡Estoy de vuelta en el mundo, mejor y más valiente que nunca!",

    // Wally's Story Moral
    "Even the smallest items we recycle can become something awesome again!":
    "¡Incluso los objetos más pequeños que reciclamos pueden convertirse en algo increíble de nuevo!",

    "Recycling gives second chances—to the Earth and everything on it":
    "El reciclaje da segundas oportunidades, a la Tierra y a todo lo que hay en ella",

    // Tommy's Story Lines
    "Whoa! What's that shiny thing in the sand?":
    "¡Vaya! ¿Qué es esa cosa brillante en la arena?",

    "Hi Tommy! I'm a lonely bottle. I got thrown away and ended up here!":
    "¡Hola Tommy! Soy una botella solitaria. ¡Me tiraron y terminé aquí!",

    "Oh no! Aren't you supposed to go in the recycling bin?":
    "¡Oh no! ¿No deberías estar en el contenedor de reciclaje?",

    "Yes! If someone had recycled me, I could've become a toy or even a t-shirt!":
    "¡Sí! Si alguien me hubiera reciclado, ¡podría haberme convertido en un juguete o incluso en una camiseta!",

    "Kids, did you hear that? Recycling helps me keep the beach clean!":
    "Niños, ¿escucharon eso? ¡El reciclaje me ayuda a mantener la playa limpia!",

    "And it gives me a chance to be useful again! Let's all recycle!":
    "¡Y me da la oportunidad de ser útil de nuevo! ¡Vamos todos a reciclar!",

    "Bye! Have a good day kids! 👋":
    "¡Adiós! ¡Que tengan un buen día niños! 👋",

    // Luna's Story Lines
    "Hi friends! I'm Luna. I live in a big, happy forest.":
    "¡Hola amigos! Soy Luna. Vivo en un bosque grande y feliz.",

    "But my forest friends are in danger because too many trees are being cut down.":
    "Pero mis amigos del bosque están en peligro porque están cortando demasiados árboles.",

    "Hey Luna! If kids recycle paper, we don't need to cut so many trees!":
    "¡Hola Luna! Si los niños reciclan papel, ¡no necesitamos cortar tantos árboles!",

    "That's right! Recycling paper saves homes for birds, bugs, and bears too!":
    "¡Así es! ¡Reciclar papel salva hogares para pájaros, insectos y osos también!",

    "Plus, it saves energy and keeps our Earth cool and clean.":
    "Además, ahorra energía y mantiene nuestra Tierra fresca y limpia.",

    "Let's be Earth heroes and recycle every day!":
    "¡Seamos héroes de la Tierra y reciclemos todos los días!",

    // Additional Story UI Elements
    "Moral of the Story": "Moraleja de la Historia",
    "Tap to hear my story!": "¡Toca para escuchar mi historia!",
    "Stop Story": "Detener Historia",
  };

  String translate(String text) {
    if (!_isSpanish) return text;
    return _translations[text] ?? text;
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(_isSpanish ? "es-ES" : "en-US");
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  void toggleLanguage() {
    _isSpanish = !_isSpanish;
  }
} 