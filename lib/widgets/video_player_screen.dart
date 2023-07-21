import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key key, this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController _controller;
  bool _videoLoaded = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = YoutubePlayerController(
  //     initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl),
  //     flags: const YoutubePlayerFlags(
  //       autoPlay: false,
  //       mute: false,
  //     ),
  //   );
  //   _preloadVideo();
  // }

  // Future<void> _preloadVideo() async {
  //   await _controller.load(); // Preload the video
  //   setState(() {
  //     _videoLoaded = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    _preloadVideo(videoId);
  }

  Future<void> _preloadVideo(String videoId) async {
    await _controller.cue(videoId); // Preload the video
    setState(() {
      _videoLoaded = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: _videoLoaded
            ? YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrls;

//   const VideoPlayerScreen({Key key, this.videoUrls}) : super(key: key);

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   int _currentIndex = 0;
//   YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrls[0]),
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _playVideoAtIndex(int index) {
//     setState(() {
//       _currentIndex = index;
//       _controller.load(YoutubePlayer.convertUrlToId(widget.videoUrls[index]));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//       ),
//       body: Column(
//         children: [
//           YoutubePlayer(
//             controller: _controller,
//             showVideoProgressIndicator: true,
//             progressIndicatorColor: Colors.red,
//           ),
//           SizedBox(height: 16),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(widget.videoUrls.length, (index) {
//                 return Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () => _playVideoAtIndex(index),
//                     child: Text(
//                       'Trailer ${index + 1}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: _currentIndex == index ? Colors.blue : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
