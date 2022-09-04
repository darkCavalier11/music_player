// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:just_audio_background/just_audio_background.dart';

class MusicItem {
  final String videoId;
  final String imageUrl;
  final String title;
  final String author;
  final String duration;
  // this field gets populated when the music details fetched.
  final String? musicUrl;
  MusicItem({
    required this.videoId,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.duration,
    this.musicUrl,
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
    return 'MusicItem(videoId: $videoId, imageUrl: $imageUrl, title: $title, author: $author, duration: $duration, musicUrl: $musicUrl)';
  }

  MediaItem toMediaItem() {
    final durationList = duration.split(':');
    int durSeconds = 0, counter = 1;
    for (int i = durationList.length - 1; i >= 0; i--) {
      int d = int.parse(durationList[i]);
      durSeconds += d * counter;
      counter *= 60;
    }
    return MediaItem(
      id: videoId,
      title: title,
      // todo : parse proper duration
      duration: Duration(seconds: durSeconds),
      artUri: Uri.parse(musicUrl ?? ''),
      artist: author,
      artHeaders: {'image_url': imageUrl},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'imageUrl': imageUrl,
      'title': title,
      'author': author,
      'duration': duration,
    };
  }

  MusicItem copyWith({
    String? videoId,
    String? imageUrl,
    String? title,
    String? author,
    String? duration,
    String? musicUrl,
  }) {
    return MusicItem(
      videoId: videoId ?? this.videoId,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      author: author ?? this.author,
      duration: duration ?? this.duration,
      musicUrl: musicUrl ?? this.musicUrl,
    );
  }

  @override
  bool operator ==(covariant MusicItem other) {
    if (identical(this, other)) return true;

    return other.videoId == videoId &&
        other.imageUrl == imageUrl &&
        other.title == title &&
        other.author == author &&
        other.duration == duration &&
        other.musicUrl == musicUrl;
  }

  @override
  int get hashCode {
    return videoId.hashCode ^
        imageUrl.hashCode ^
        title.hashCode ^
        author.hashCode ^
        duration.hashCode ^
        musicUrl.hashCode;
  }
}
