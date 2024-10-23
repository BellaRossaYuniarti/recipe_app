class Recipe {
  final String name;
  final String thumbnailUrl;
  final String description;
  final String videoUrl;  

  Recipe({
    required this.name,
    required this.thumbnailUrl,
    required this.description,
    required this.videoUrl, 
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    String videoUrl = '';
    try {
      if (json['original_video_url'] != null) {
        videoUrl = json['original_video_url'];
        // Validate URL
        Uri.parse(videoUrl);
      } else if (json['video_url'] != null) {
        videoUrl = json['video_url'];
        // Validate URL
        Uri.parse(videoUrl);
      }
    } catch (e) {
      print('Invalid video URL: $e');
      videoUrl = '';
    }
    
    return Recipe(
      name: json['name'] ?? 'Unnamed Recipe',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      description: json['description'] ?? 'No description available',
      videoUrl: videoUrl,
    );
  }
}