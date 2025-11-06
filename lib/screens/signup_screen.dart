import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(3, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  final TextEditingController _nameController = TextEditingController();

  late AnimationController _wallpaperController;
  late Animation<double> _wallpaperAnimation;
  Timer? _wallpaperTimer;
  int _currentWallpaperIndex = 0;
  bool _isBackHovering = false;
  bool _isSignupHovering = false;

  String _errorMessage = '';
  bool _isLoading = false;

  final List<Color> _pinBoxColors = [
    Color(0xFFFF9999),
    Color(0xFF99FF99),
    Color(0xFF9999FF),
  ];

  final List<String> _backgroundImages = [
    "assets/images/wallpapers/wallpaper1.png",
    "assets/images/wallpapers/wallpaper2.png",
    "assets/images/wallpapers/wallpaper3.png",
    "assets/images/wallpapers/wallpaper4.png",
  ];

  @override
  void initState() {
    super.initState();
    _wallpaperController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _wallpaperAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _wallpaperController,
      curve: Curves.easeInOut,
    ));
    _startWallpaperRotation();
  }

  void _startWallpaperRotation() {
    _wallpaperTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _changeWallpaper();
    });
  }

  void _changeWallpaper() {
    if (mounted) {
      setState(() {
        _currentWallpaperIndex =
            (_currentWallpaperIndex + 1) % _backgroundImages.length;
      });
      _wallpaperController.forward().then((_) {
        _wallpaperController.reset();
      });
    }
  }

  void _setWallpaper(int index) {
    if (mounted && index != _currentWallpaperIndex) {
      setState(() {
        _currentWallpaperIndex = index;
      });
      _wallpaperController.forward().then((_) {
        _wallpaperController.reset();
      });
      _wallpaperTimer?.cancel();
      _startWallpaperRotation();
    }
  }

  @override
  void dispose() {
    _wallpaperController.dispose();
    _wallpaperTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    String pin = _controllers.map((c) => c.text).join();
    if (pin.length != 3) {
      setState(() {
        _errorMessage = 'Oops! We need all 3 numbers for your secret code! 🎯';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // Check if user already exists by querying users collection directly
      final existingUser =
          await FirebaseFirestore.instance.collection('users').doc(pin).get();
      if (existingUser.exists) {
        setState(() {
          _errorMessage =
              'This secret code is already taken! Try another one! 🎲';
          _isLoading = false;
        });
        return;
      }

      // Create user record in users collection with pin as document ID
      await FirebaseFirestore.instance.collection('users').doc(pin).set({
        'pin': pin,
        'name': _nameController.text,
        'created_at': FieldValue.serverTimestamp(),
        'TotalBestScore': 0,
      });

      if (mounted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    } catch (e) {
      print('Signup error: $e'); // Debug logging
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset:
          true, // Let Flutter handle keyboard on all platforms
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Rotating Background Wallpapers
          AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            child: Container(
              key: ValueKey(_currentWallpaperIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_backgroundImages[_currentWallpaperIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: isMobile
                ? _buildMobileLayout(keyboardHeight)
                : _buildTabletLayout(keyboardHeight),
          ),
          // Modern Wallpaper Indicator (only show on tablet/desktop)
          if (!isMobile)
            Positioned(
              left: 25,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_backgroundImages.length, (index) {
                  return GestureDetector(
                    onTap: () => _setWallpaper(index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: _currentWallpaperIndex == index ? 4 : 3,
                      height: _currentWallpaperIndex == index ? 24 : 16,
                      decoration: BoxDecoration(
                        color: _currentWallpaperIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: _currentWallpaperIndex == index
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  // Mobile Layout: Full-width with wallpaper as background
  Widget _buildMobileLayout(double keyboardHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              keyboardHeight,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildSignupContent(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Tablet/Desktop Layout: Split view with wallpaper on left, signup on right
  Widget _buildTabletLayout(double keyboardHeight) {
    return Row(
      children: [
        // Left side - Wallpaper area
        Expanded(
          flex: 1,
          child: Container(), // Empty container to show wallpaper
        ),
        // Right side - Signup panel
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  SizedBox(height: 25),
                  _buildSignupContent(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Shared signup content for both layouts
  Widget _buildSignupContent() {
    return Column(
      children: [
        Column(
          children: [
            Text(
              'BILINGUAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 86,
                fontWeight: FontWeight.w900,
                fontFamily: 'Rubik Moonrocks',
                color: Colors.white,
                letterSpacing: 0.4,
                height: 1.1,
              ),
            ),
            Text(
              'SCIENTISTS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 86,
                fontWeight: FontWeight.w900,
                fontFamily: 'Rubik Moonrocks',
                color: Colors.white,
                letterSpacing: 0.4,
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Learning Made Fun',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 80),
        Text(
          'Create Your Access Code',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 30),
        _buildNameInput(),
        SizedBox(height: 20),
        _buildPinInputBoxes(),
        _buildBackButton(),
        SizedBox(height: 20),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 14,
              fontFamily: 'BungeeInline',
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        SizedBox(height: 20),
        MouseRegion(
          onEnter: (_) => setState(() => _isSignupHovering = true),
          onExit: (_) => setState(() => _isSignupHovering = false),
          child: SizedBox(
            width: 250,
            height: 70,
            child: SignupButton(
              onPressed: _isLoading ? null : _signup,
              isHovered: _isSignupHovering,
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  // Name input widget
  Widget _buildNameInput() {
    return Container(
      width: 250,
      height: 60,
      child: TextField(
        textAlign: TextAlign.center,
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Name',
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Galindo',
        ),
      ),
    );
  }

  // PIN input boxes widget
  Widget _buildPinInputBoxes() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double boxSize = (availableWidth - 60) / 3;
        boxSize = boxSize.clamp(150.0, 150.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              width: 120,
              height: 120,
              margin: EdgeInsets.symmetric(horizontal: 0.5),
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      // If current field has content, clear it
                      if (_controllers[index].text.isNotEmpty) {
                        _controllers[index].clear();
                      }
                      // If current field is empty and not the first field, go back
                      else if (index > 0) {
                        _focusNodes[index - 1].requestFocus();
                        // Also clear the previous field for seamless deletion
                        _controllers[index - 1].clear();
                      }
                    }
                  }
                },
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: boxSize * 0.35,
                    fontFamily: 'Galindo',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textInputAction:
                      index < 2 ? TextInputAction.next : TextInputAction.done,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    // Auto-advance to next field when a digit is entered
                    if (value.length == 1 && index < 2) {
                      _focusNodes[index + 1].requestFocus();
                    }
                  },
                  onSubmitted: (value) {
                    if (index == 2) {
                      _signup();
                    }
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // Back button widget
  Widget _buildBackButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isBackHovering = true),
      onExit: (_) => setState(() => _isBackHovering = false),
      child: SizedBox(
        width: 250,
        height: 35,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                _isBackHovering ? Colors.grey.shade800 : Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
          child: Text(
            'Back to Login',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isHovered;
  const SignupButton(
      {super.key, required this.onPressed, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    const double boxHeight = 70;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 250,
        height: boxHeight - 10,
        decoration: BoxDecoration(
          color: isHovered
              ? Color.fromARGB(255, 213, 255, 75)
              : Color.fromARGB(255, 255, 192, 18),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: isHovered ? 24 : 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedSlide(
              duration: Duration(milliseconds: 250),
              offset: isHovered ? Offset(0, -0.1) : Offset.zero,
              child: AnimatedScale(
                duration: Duration(milliseconds: 250),
                scale: isHovered ? 1.18 : 1.0,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: isHovered ? 46 : 38,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Ranchers',
                    color: Colors
                        .black, // Always black for good contrast on yellow
                    shadows: isHovered
                        ? [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 5,
                              offset: Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      "Sign Up!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
