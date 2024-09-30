import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortsPage extends StatefulWidget {
  @override
  _ShortsPageState createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final List<String> _videoUrls = [
    // Sample video URLs
    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
    'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
    'https://samplelib.com/lib/preview/mp4/sample-15s.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videoUrls.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(videoUrl: _videoUrls[index]);
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Autoplay the video
        _controller.setLooping(true); // Loop the video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video Player
        GestureDetector(
          onTap: () {
            // Pause/play video on tap
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          left: 10,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User's name
              Text(
                "Sif Yacine",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              // Subtitle and hashtags
              Text(
                "A day in the life of a developer #coding #flutter #developer",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Right-side list of icons
        Positioned(
          right: 10,
          bottom: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Avatar with Plus Icon
              _buildAvatar(),

              SizedBox(height: 20),

              // Like Icon and Count
              _buildIconWithText(Icons.favorite, '1.5k'),

              SizedBox(height: 20),

              // Comment Icon and Count
              _buildIconWithText(Icons.comment, '340'),

              SizedBox(height: 20),

              // Save Icon and Count
              _buildIconWithText(Icons.bookmark, '120'),

              SizedBox(height: 20),

              // Share Icon and Count
              _buildIconWithText(Icons.share, '50'),
            ],
          ),
        ),
      ],
    );
  }

// Circle Avatar with Plus Icon
  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/images/content/user.png"),
        ),
        Positioned(
          bottom: -8, // Align the icon at the bottom
          child: Container(
            width: 16, // Increase size if needed
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent,
            ),
            child: Center(
              child: Icon(Icons.add, color: Colors.white, size: 10),
            ),
          ),
        ),
      ],
    );
  }

  // Icon with Text (e.g., Likes, Comments)
  Widget _buildIconWithText(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
