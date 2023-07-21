import 'package:flutter/material.dart';

class InAppNotification extends StatefulWidget {
  final String message;

  const InAppNotification({Key key, this.message}) : super(key: key);

  @override
  _InAppNotificationState createState() => _InAppNotificationState();

  static void showInAppNotification(BuildContext context, String message) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            top: MediaQuery
                .of(context)
                .padding
                .top,
            left: 0,
            right: 0,
            child: Material(
              child: InAppNotification(message: message),
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay entry after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }
}

class _InAppNotificationState extends State<InAppNotification> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();

    Future.delayed(Duration(seconds: 5), () {
      _animationController.reverse().then((value) {
        if (mounted) {
          // Dismiss the widget after the animation completes
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: double.infinity,
        color: Colors.blue,
        padding: EdgeInsets.all(16),
        child: Text(
          widget.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
