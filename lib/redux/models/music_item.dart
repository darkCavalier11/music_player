// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:just_audio_background/just_audio_background.dart';

class MusicItem {
  final String videoId;
  final String imageUrl;
  final String title;
  final String author;
  final String duration;
  MusicItem({
    required this.videoId,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.duration,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
        videoId: json['videoId'],
        imageUrl: json['thumbnail']['thumbnails'][0]['url'],
        title: json['title']['runs'][0]['text'],
        author: json['longBylineText']['runs'][0]['text'],
        duration: json['lengthText']['simpleText']);
  }

  @override
  String toString() {
    return 'MusicItem(videoId: $videoId, imageUrl: $imageUrl, title: $title, author: $author, duration: $duration)';
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: videoId,
      title: title,
      // todo : parse proper duration
      duration: const Duration(seconds: 1),
      artUri: Uri.parse('https://www.google.com/smaple.mp3'),
      artist: author,
      artHeaders: {'image_url': imageUrl},
    );
  }
}
