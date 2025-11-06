import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearningCenterScreen extends StatefulWidget {
  const LearningCenterScreen({super.key});

  @override
  State<LearningCenterScreen> createState() => _LearningCenterScreenState();
}

class _LearningCenterScreenState extends State<LearningCenterScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int _currentIndex = 0;

  final List<LearningSection> _sections = [
    LearningSection(
      title: 'Recycling ♻️',
      description: 'Recycling helps turn used materials into new products!',
      items: [
        'Paper and cardboard',
        'Clean plastic bottles',
        'Glass containers',
        'Metal cans',
        'Electronics'
      ],
      color: Colors.blue.shade100,
      icon: Icons.recycling,
    ),
    LearningSection(
      title: 'Composting 🌱',
      description: 'Composting turns food waste into rich soil for plants!',
      items: [
        'Fruit and vegetable scraps',
        'Coffee grounds',
        'Eggshells',
        'Yard trimmings',
        'Leaves'
      ],
      color: Colors.green.shade100,
      icon: Icons.eco,
    ),
    LearningSection(
      title: 'Landfill 🗑️',
      description: 'Some items need to go to the landfill when they can\'t be recycled or composted.',
      items: [
        'Broken ceramics',
        'Used tissues',
        'Dirty food containers',
        'Plastic bags',
        'Styrofoam'
      ],
      color: Colors.grey.shade200,
      icon: Icons.delete,
    ),
  ];

  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Center',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Section Navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _sections.length,
                (index) => _buildNavButton(index),
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section Title with Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _sections[_currentIndex].icon,
                          size: 40,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _sections[_currentIndex].title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description Card
                    Card(
                      color: _sections[_currentIndex].color,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              _sections[_currentIndex].description,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'ComicNeue',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => _speakText(_sections[_currentIndex].description),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Items List
                    ...List.generate(
                      _sections[_currentIndex].items.length,
                      (index) => _buildItemCard(
                        _sections[_currentIndex].items[index],
                        index,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(int index) {
    bool isSelected = _currentIndex == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Row(
        children: [
          Icon(_sections[index].icon),
          const SizedBox(width: 8),
          Text(
            _sections[index].title.split(' ')[0],
            style: const TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(String item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _sections[_currentIndex].color,
          child: Text('${index + 1}'),
        ),
        title: Text(
          item,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'ComicNeue',
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () => _speakText(item),
        ),
      ),
    );
  }
}

class LearningSection {
  final String title;
  final String description;
  final List<String> items;
  final Color color;
  final IconData icon;

  LearningSection({
    required this.title,
    required this.description,
    required this.items,
    required this.color,
    required this.icon,
  });
} 