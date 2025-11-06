// import 'package:flutter/material.dart';

// class LetsPlayButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const LetsPlayButton({super.key, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: 800,
//         height: 300,
//         padding: const EdgeInsets.all(80),
//         decoration: BoxDecoration(
//           color: const Color(0xFFB3DB70),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Center(
//           child: Text(
//             "let's play",
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.w900,
//               fontFamily: 'ComicSans',
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LetsPlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LetsPlayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 700,
        height: 300,
        padding: const EdgeInsets.all(80),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
              'assets/tidytown/images/1.png',
            ), // ✅ Your image path
            fit: BoxFit.cover, // Or BoxFit.fill, BoxFit.fitWidth, etc.
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          // child: Text(
          //   "let's play",
          //   style: TextStyle(
          //     fontSize: 28,
          //     fontWeight: FontWeight.w900,
          //     fontFamily: 'ComicSans',
          //     color: Colors.black, // Change if needed
          //   ),
          // ),
        ),
      ),
    );
  }
}
