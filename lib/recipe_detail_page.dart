import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:recipe_app/model/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({required this.recipe});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.recipe.videoUrl.isNotEmpty) {
      try {
        final Uri videoUri = Uri.parse(widget.recipe.videoUrl);

        _videoPlayerController = VideoPlayerController.networkUrl(videoUri);
        await _videoPlayerController!.initialize();
        setState(() {
          _isVideoInitialized = true;
        });
      } catch (e) {
        print('Error initializing video player: $e');
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (widget.recipe.videoUrl.isEmpty) {
      return Container(
        height: 200,
        child: const Center(
          child: Text('No video available for this recipe'),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: 200,
        child: const Center(
          child: Text('Error loading video'),
        ),
      );
    }

    if (!_isVideoInitialized) {
      return Container(
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        ),
        VideoProgressIndicator(
          _videoPlayerController!,
          allowScrubbing: true,
          padding: const EdgeInsets.all(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  if (_videoPlayerController!.value.isPlaying) {
                    _videoPlayerController!.pause();
                  } else {
                    _videoPlayerController!.play();
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.recipe.thumbnailUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.recipe.thumbnailUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(widget.recipe.description),
                const SizedBox(height: 16),
                if (widget.recipe.videoUrl.isNotEmpty) ...[
                  const Text(
                    'Tutorial:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildVideoPlayer(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
