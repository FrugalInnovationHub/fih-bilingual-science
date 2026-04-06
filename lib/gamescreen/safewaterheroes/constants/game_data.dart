import '../models/lesson_content.dart';
import 'assets.dart';

// ==========================================
// === FULL LESSON DATA (10 Lessons, 6 Cards each) ===
// ==========================================
const List<Lesson> kAllLessons = [
  // --- LESSON 1 ---
  Lesson(
    id: 1,
    titleEn: "What is clean water?",
    titleEs: "¿Qué es el agua limpia?",
    coverAssetPath: AppAssets.lessonCover1,
    cards: [
      LessonCard(textEn: "Clean water is clear. It looks sparkling!", textEs: "El agua limpia es clara. ¡Parece brillante!", imageAssetPath: AppAssets.l1c1),
      LessonCard(textEn: "It has no smell and no weird taste.", textEs: "No tiene olor ni sabor extraño.", imageAssetPath: AppAssets.l1c2),
      LessonCard(textEn: "We need clean water to drink and stay healthy.", textEs: "Necesitamos agua limpia para beber y mantenernos sanos.", imageAssetPath: AppAssets.l1c3),
      LessonCard(textEn: "Dirty water looks cloudy or brown.", textEs: "El agua sucia parece turbia o marrón.", imageAssetPath: AppAssets.l1c4),
      LessonCard(textEn: "Dirty water can hold tiny germs we cannot see.", textEs: "El agua sucia puede contener pequeños gérmenes que no podemos ver.", imageAssetPath: AppAssets.l1c5),
      LessonCard(textEn: "Drinking dirty water can make your tummy hurt.", textEs: "Beber agua sucia puede hacer que te duela la barriga.", imageAssetPath: AppAssets.l1c6),
  ]),
  // --- LESSON 2 ---
  Lesson(
    id: 2,
    titleEn: "Where drinking water comes from",
    titleEs: "De dónde viene el agua potable",
    coverAssetPath: AppAssets.lessonCover2,
    cards: [
      LessonCard(textEn: "Water can come from rain, rivers, and wells outside.", textEs: "El agua puede provenir de la lluvia, ríos y pozos exteriores.", imageAssetPath: AppAssets.l2c1),
      LessonCard(textEn: "In towns, it usually comes through pipes to a tap.", textEs: "En las ciudades, suele llegar por tuberías a un grifo.", imageAssetPath: AppAssets.l2c2),
      LessonCard(textEn: "Treatment plants clean the big river water first.", textEs: "Las plantas de tratamiento limpian primero el agua grande del río.", imageAssetPath: AppAssets.l2c3),
      LessonCard(textEn: "Big water towers store it high up above town.", textEs: "Grandes torres de agua la almacenan en alto sobre la ciudad.", imageAssetPath: AppAssets.l2c4),
      LessonCard(textEn: "Underground pipes bring it directly to homes.", textEs: "Tuberías subterráneas la llevan directamente a las casas.", imageAssetPath: AppAssets.l2c5),
      LessonCard(textEn: "Always ask an adult if tap water is safe here.", textEs: "Pregunta siempre a un adulto si el agua del grifo es segura aquí.", imageAssetPath: AppAssets.l2c6),
  ]),
  // --- LESSON 3 ---
  Lesson(
    id: 3,
    titleEn: "Safe vs Unsafe water sources",
    titleEs: "Fuentes seguras vs inseguras",
    coverAssetPath: AppAssets.lessonCover3,
    cards: [
    LessonCard(textEn: "Sealed bottled water bought from a shop is safe.", textEs: "El agua embotellada sellada comprada en tienda es segura.", imageAssetPath: AppAssets.l3c1),
    LessonCard(textEn: "Water from a dirty puddle on the ground is NEVER safe.", textEs: "El agua de un charco sucio en el suelo NUNCA es segura.", imageAssetPath: AppAssets.l3c2),
    LessonCard(textEn: "Fast-flowing rivers look clean but hide germs.", textEs: "Los ríos rápidos parecen limpios pero esconden gérmenes.", imageAssetPath: AppAssets.l3c3),
    LessonCard(textEn: "A deep handpump is usually safer than an open hole.", textEs: "Una bomba manual profunda suele ser más segura que un hoyo abierto.", imageAssetPath: AppAssets.l3c4),
    LessonCard(textEn: "Covered tanks keep dust and animals out.", textEs: "Los tanques cubiertos evitan el polvo y los animales.", imageAssetPath: AppAssets.l3c5),
    LessonCard(textEn: "Open buckets collect dirt and flies quickly.", textEs: "Los cubos abiertos recogen suciedad y moscas rápidamente.", imageAssetPath: AppAssets.l3c6),
  ]),
  // --- LESSON 4 ---
  Lesson(
    id: 4,
    titleEn: "What does “Needs Filtering” mean?",
    titleEs: "¿Qué significa “Necesita Filtrado”?",
    coverAssetPath: AppAssets.lessonCover4,
    cards: [
    LessonCard(textEn: "Some water isn't obviously dirty, but isn't truly clean.", textEs: "Alguna agua no está obviamente sucia, pero no está realmente limpia.", imageAssetPath: AppAssets.l4c1),
    LessonCard(textEn: "It might have tiny specs of dirt or sand floating.", textEs: "Puede tener pequeñas partículas de tierra o arena flotando.", imageAssetPath: AppAssets.l4c2),
    LessonCard(textEn: "Filtering is like pouring it through a very fine sieve.", textEs: "Filtrar es como verterla a través de un colador muy fino.", imageAssetPath: AppAssets.l4c3),
    LessonCard(textEn: "The filter catches the bad stuff and lets water pass.", textEs: "El filtro atrapa las cosas malas y deja pasar el agua.", imageAssetPath: AppAssets.l4c4),
    LessonCard(textEn: "We should filter river or well water before drinking.", textEs: "Debemos filtrar el agua de río o pozo antes de beber.", imageAssetPath: AppAssets.l4c5),
    LessonCard(textEn: "Filtering makes cloudy water look clearer.", textEs: "Filtrar hace que el agua turbia parezca más clara.", imageAssetPath: AppAssets.l4c6),
  ]),
  // --- LESSON 5 ---
  Lesson(
    id: 5,
    titleEn: "Germs: Why dirty water makes us sick",
    titleEs: "Gérmenes: Por qué el agua sucia nos enferma",
    coverAssetPath: AppAssets.lessonCover5,
    cards: [
    LessonCard(textEn: "Germs are tiny living things, like bad little bugs.", textEs: "Los gérmenes son seres vivos diminutos, como bichitos malos.", imageAssetPath: AppAssets.l5c1),
    LessonCard(textEn: "They are too small to see with just your eyes.", textEs: "Son demasiado pequeños para verlos solo con los ojos.", imageAssetPath: AppAssets.l5c2),
    LessonCard(textEn: "Germs love to swim in dirty water.", textEs: "A los gérmenes les encanta nadar en agua sucia.", imageAssetPath: AppAssets.l5c3),
    LessonCard(textEn: "If we drink them, they throw a party in our tummy.", textEs: "Si los bebemos, hacen una fiesta en nuestra barriga.", imageAssetPath: AppAssets.l5c4),
    LessonCard(textEn: "This party makes us vomit or have terrible diarrhea.", textEs: "Esta fiesta nos hace vomitar o tener diarrea terrible.", imageAssetPath: AppAssets.l5c5),
    LessonCard(textEn: "Clean water has zero germs allowed!", textEs: "¡El agua limpia no admite gérmenes!", imageAssetPath: AppAssets.l5c6),
  ]),
  // --- LESSON 6 ---
  Lesson(
    id: 6,
    titleEn: "Boiling water basics",
    titleEs: "Conceptos básicos para hervir agua",
    coverAssetPath: AppAssets.lessonCover6,
    cards: [
    LessonCard(textEn: "Strong heat can kill harmful germs.", textEs: "El calor fuerte puede matar gérmenes dañinos.", imageAssetPath: AppAssets.l6c1),
    LessonCard(textEn: "Boiling means heating water until it is very, very hot.", textEs: "Hervir significa calentar agua hasta que esté muy, muy caliente.", imageAssetPath: AppAssets.l6c2),
    LessonCard(textEn: "You know it's boiling when big bubbles roll quickly.", textEs: "Sabes que hierve cuando grandes burbujas ruedan rápidamente.", imageAssetPath: AppAssets.l6c3),
    LessonCard(textEn: "An adult must always do the boiling part.", textEs: "Un adulto siempre debe hacer la parte de hervir.", imageAssetPath: AppAssets.l6c4),
    LessonCard(textEn: "We must let it cool down before drinking it.", textEs: "Debemos dejarla enfriar antes de beberla.", imageAssetPath: AppAssets.l6c5),
    LessonCard(textEn: "Properly boiled water is safe water.", textEs: "El agua hervida correctamente es agua segura.", imageAssetPath: AppAssets.l6c6),
  ]),
  // --- LESSON 7 ---
  Lesson(
    id: 7,
    titleEn: "How cloth filtering works",
    titleEs: "Cómo funciona el filtrado con tela",
    coverAssetPath: AppAssets.lessonCover7,
    cards: [
    LessonCard(textEn: "We can use a clean cotton cloth to filter water.", textEs: "Podemos usar un paño de algodón limpio para filtrar agua.", imageAssetPath: AppAssets.l7c1),
    LessonCard(textEn: "Fold the cloth several times to make it thicker.", textEs: "Dobla la tela varias veces para hacerla más gruesa.", imageAssetPath: AppAssets.l7c2),
    LessonCard(textEn: "Secure it firmly over the mouth of a clean pot.", textEs: "Asegúrala firmemente sobre la boca de una olla limpia.", imageAssetPath: AppAssets.l7c3),
    LessonCard(textEn: "Pour the dirty water very slowly through the cloth.", textEs: "Vierte el agua sucia muy lentamente a través de la tela.", imageAssetPath: AppAssets.l7c4),
    LessonCard(textEn: "The cloth catches leaves, insects, and big dirt.", textEs: "La tela atrapa hojas, insectos y suciedad grande.", imageAssetPath: AppAssets.l7c5),
    LessonCard(textEn: "It helps clear water, but you must still boil it for germs.", textEs: "Ayuda a aclarar, pero aún debes hervirla para los gérmenes.", imageAssetPath: AppAssets.l7c6),
  ]),
  // --- LESSON 8 ---
  Lesson(
    id: 8,
    titleEn: "How bottle filters work (layers)",
    titleEs: "Cómo funcionan los filtros de botella (capas)",
    coverAssetPath: AppAssets.lessonCover8,
    cards: [
    LessonCard(textEn: "We can build a filter using nature's layers in a bottle.", textEs: "Podemos construir un filtro usando capas naturales en una botella.", imageAssetPath: AppAssets.l8c1),
    LessonCard(textEn: "Big pebbles go on top to catch large rocks.", textEs: "Guijarros grandes van arriba para atrapar rocas grandes.", imageAssetPath: AppAssets.l8c2),
    LessonCard(textEn: "Sand goes next to trap smaller dirt particles.", textEs: "La arena va después para atrapar partículas de suciedad más pequeñas.", imageAssetPath: AppAssets.l8c3),
    LessonCard(textEn: "Charcoal can help remove bad smells and tastes.", textEs: "El carbón puede ayudar a eliminar malos olores y sabores.", imageAssetPath: AppAssets.l8c4),
    LessonCard(textEn: "A cloth at the very bottom stops the sand falling out.", textEs: "Una tela en el fondo evita que la arena se caiga.", imageAssetPath: AppAssets.l8c5),
    LessonCard(textEn: "Dirty water in the top, cleaner water out the bottom!", textEs: "¡Agua sucia entra arriba, agua más limpia sale abajo!", imageAssetPath: AppAssets.l8c6),
  ]),
  // --- LESSON 9 ---
  Lesson(
    id: 9,
    titleEn: "Safe storage methods",
    titleEs: "Métodos de almacenamiento seguro",
    coverAssetPath: AppAssets.lessonCover9,
    cards: [
    LessonCard(textEn: "Once water is clean, it must stay clean.", textEs: "Una vez que el agua está limpia, debe permanecer limpia.", imageAssetPath: AppAssets.l9c1),
    LessonCard(textEn: "Always use a clean container with a tight lid.", textEs: "Usa siempre un recipiente limpio con tapa ajustada.", imageAssetPath: AppAssets.l9c2),
    LessonCard(textEn: "Keep the water container off the floor on a shelf.", textEs: "Mantén el recipiente de agua fuera del suelo en un estante.", imageAssetPath: AppAssets.l9c3),
    LessonCard(textEn: "Never dip your hands or a dirty cup inside.", textEs: "Nunca sumerjas tus manos o una taza sucia dentro.", imageAssetPath: AppAssets.l9c4),
    LessonCard(textEn: "Use a tap on the container or pour the water out.", textEs: "Usa un grifo en el recipiente o vierte el agua.", imageAssetPath: AppAssets.l9c5),
    LessonCard(textEn: "Wash the storage container often with soap.", textEs: "Lava el recipiente de almacenamiento a menudo con jabón.", imageAssetPath: AppAssets.l9c6),
  ]),
  // --- LESSON 10 ---
  Lesson(
    id: 10,
    titleEn: "Smart choices when thirsty",
    titleEs: "Elecciones inteligentes al tener sed",
    coverAssetPath: AppAssets.lessonCover10,
    cards: [
    LessonCard(textEn: "Are you thirsty? Stop and think first!", textEs: "Are you thirsty? Stop and think first!", imageAssetPath: AppAssets.l10c1),
    LessonCard(textEn: "Look: Is the water clear and sparkling?", textEs: "Mira: ¿El agua es clara y brillante?", imageAssetPath: AppAssets.l10c2),
    LessonCard(textEn: "Smell: Does it smell fresh like nothing?", textEs: "Huele: ¿Huele fresco como a nada?", imageAssetPath: AppAssets.l10c3),
    LessonCard(textEn: "Source: Did it come from a safe tap or bottle?", textEs: "Fuente: ¿Vino de un grifo seguro o botella?", imageAssetPath: AppAssets.l10c4),
    LessonCard(textEn: "If you do not know, ask an adult first.", textEs: "Si no sabes, pregunta a un adulto primero.", imageAssetPath: AppAssets.l10c5),
    LessonCard(textEn: "Never drink from puddles, streams, or open tubs!", textEs: "¡Nunca bebas de charcos, arroyos o bañeras abiertas!", imageAssetPath: AppAssets.l10c6),
  ]),
];

// ==========================================
// === SORTING GAME DATA ===
// ==========================================
enum WaterType { safe, needsFilter, unsafe }

class SortingItem {
  final String nameEn;
  final String nameEs;
  final WaterType type;
  const SortingItem(this.nameEn, this.nameEs, this.type);
}

const List<SortingItem> kSortingItems = [
  // SAFE
  SortingItem("Tap water (treated)", "Agua del grifo (tratada)", WaterType.safe),
  SortingItem("Sealed bottled water", "Agua embotellada sellada", WaterType.safe),
  SortingItem("Treated tank water", "Agua de tanque tratada", WaterType.safe),
  // NEEDS FILTER
  SortingItem("River water", "Agua de río", WaterType.needsFilter),
  SortingItem("Pond water", "Agua de estanque", WaterType.needsFilter),
  SortingItem("Well water", "Agua de pozo", WaterType.needsFilter),
  SortingItem("Rainwater (clean container)", "Agua de lluvia (recipiente limpio)", WaterType.needsFilter),
  SortingItem("Waterfall/stream", "Cascada/arroyo", WaterType.needsFilter),
  SortingItem("Handpump water", "Agua de bomba manual", WaterType.needsFilter),
  // UNSAFE
  SortingItem("Dirty puddle", "Charco sucio", WaterType.unsafe),
  SortingItem("Flood water", "Agua de inundación", WaterType.unsafe),
  SortingItem("Sewage/drain water", "Agua residual/drenaje", WaterType.unsafe),
  SortingItem("Water with trash", "Agua con basura", WaterType.unsafe),
  SortingItem("Green algae scum", "Espuma de algas verdes", WaterType.unsafe),
  SortingItem("Water near animals", "Agua cerca de animales", WaterType.unsafe),
];

// ==========================================
// === ADVENTURE GAME DATA ===
// ==========================================
class AdventureScene {
  final String id;
  final String descriptionEn;
  final String descriptionEs;
  final WaterType correctAction;
  // In real app, add image assets here for the scene background
  const AdventureScene({
    required this.id,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.correctAction,
  });
}

const List<AdventureScene> kAdventureScenes = [
  AdventureScene(id: 'pond', descriptionEn: "You see a calm pond. The water looks clear, but animals are nearby.", descriptionEs: "Ves un estanque tranquilo. El agua parece clara, pero hay animales cerca.", correctAction: WaterType.needsFilter),
  AdventureScene(id: 'river', descriptionEn: "A flowing river. It's moving fast and looks muddy.", descriptionEs: "Un río que fluye. Se mueve rápido y parece fangoso.", correctAction: WaterType.needsFilter),
  AdventureScene(id: 'handpump', descriptionEn: "A metal handpump in the village centre used by everyone.", descriptionEs: "Una bomba manual de metal en el centro del pueblo usada por todos.", correctAction: WaterType.needsFilter),
  AdventureScene(id: 'tap', descriptionEn: "A clean tap connected to the village treated water tank.", descriptionEs: "Un grifo limpio conectado al tanque de agua tratada del pueblo.", correctAction: WaterType.safe),
  AdventureScene(id: 'puddle', descriptionEn: "A muddy puddle on the road after the rain.", descriptionEs: "Un charco fangoso en el camino después de la lluvia.", correctAction: WaterType.unsafe),
  AdventureScene(id: 'stream_trash', descriptionEn: "A small stream, but there is plastic trash floating in it.", descriptionEs: "Un pequeño arroyo, pero hay basura plástica flotando en él.", correctAction: WaterType.unsafe),
];