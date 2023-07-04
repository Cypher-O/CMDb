import 'package:flutter/material.dart';

class GlowingText extends StatefulWidget {
  const GlowingText({Key key}) : super(key: key);

  @override
  _GlowingTextState createState() => _GlowingTextState();
}

class _GlowingTextState extends State<GlowingText> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Create an animated color
    _colorAnimation = ColorTween(
      begin: Colors.orange,
      end: Colors.white,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Text(
          'cmdB'.toUpperCase(),
          style: Theme.of(context).textTheme.caption.copyWith(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: 'mulish',
            foreground: Paint()
              // ..style = PaintingStyle.stroke
              // ..strokeWidth = 1.5
              ..color = _colorAnimation.value,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: _colorAnimation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
//
// class GlowingText extends StatefulWidget {
//   const GlowingText({Key key}) : super(key: key);
//
//   @override
//   _GlowingTextState createState() => _GlowingTextState();
// }
//
// class _GlowingTextState extends State<GlowingText> with SingleTickerProviderStateMixin {
//   AnimationController _animationController;
//   Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Create an animation controller
//     _animationController = AnimationController(
//       duration: Duration(seconds: 4),
//       vsync: this,
//     )..repeat();
//
//     // Create a curved animation
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.linear,
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Color getLetterColor(int index) {
//     final double animationValue = _animation.value ?? 0.0;
//     final double progress = (animationValue + index / 4) % 1.0;
//     return Color.lerp(Colors.white, Colors.orange, progress);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Text.rich(
//           TextSpan(
//             children: [
//               for (int i = 0; i < 4; i++)
//                 TextSpan(
//                   text: 'cmdB'[i].toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 23,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'mulish',
//                     color: getLetterColor(i),
//                     shadows: [
//                       Shadow(
//                         blurRadius: 10,
//                         color: getLetterColor(i),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
