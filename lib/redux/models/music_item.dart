// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MusicItem {
  final String musicId;
  final String imageUrl;
  final String title;
  final String author;
  final String duration;
  // this field gets populated when the music details fetched.
  final String? musicUrl;
  MusicItem({
    required this.musicId,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.duration,
    this.musicUrl,
  });

  // `parsingForMusicList` used for getting title from set of
  // next music list json which has a little different structure.
  factory MusicItem.fromApiJson(Map<String, dynamic> json,
      {bool? parsingForMusicList}) {
    try {
      return MusicItem(
          musicId: json['videoId'],
          imageUrl: json['thumbnail']['thumbnails'].length > 1
              ? json['thumbnail']['thumbnails'][1]['url']
              : json['thumbnail']['thumbnails'][0]['url'],
          title: parsingForMusicList == true
              ? json['title']['simpleText']
              : json['title']['runs'][0]['text'],
          author: json['longBylineText']['runs'][0]['text'],
          duration: json['lengthText']?['simpleText'] ?? '-');
    } catch (err) {
      log(json.toString());
      throw ErrorDescription(err.toString());
    }
  }

  // store and retrieve from db
  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      musicId: json['musicId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      author: json['author'],
      duration: json['duration'],
    );
  }

  @override
  String toString() {
    return 'MusicItem(musicId: $musicId, imageUrl: $imageUrl, title: $title, author: $author, duration: $duration, musicUrl: $musicUrl)';
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
      id: musicId,
      title: title,
      // todo : parse proper duration
      duration: Duration(seconds: durSeconds),
      artUri: Uri.parse(imageUrl),
      artist: author,
    );
  }

  factory MusicItem.fromMediaItem(MediaItem mediaItem) {
    return MusicItem(
      musicId: mediaItem.id,
      imageUrl: mediaItem.artUri.toString(),
      title: mediaItem.title,
      author: mediaItem.artist!,
      duration: convertDurationToString(mediaItem.duration!),
    );
  }

  static String convertDurationToString(Duration duration) {
    int inSeconds = duration.inSeconds;
    var durString = <String>[];
    while (inSeconds > 0) {
      int rem = inSeconds % 60;
      if (rem < 10) {
        durString.add('0$rem');
      } else {
        durString.add('$rem');
      }
      inSeconds ~/= 60;
    }
    return durString.reversed.join(':');
  }

  Map<String, dynamic> toJson() {
    return {
      'musicId': musicId,
      'imageUrl': imageUrl,
      'title': title,
      'author': author,
      'duration': duration,
    };
  }

  MusicItem copyWith({
    String? musicId,
    String? imageUrl,
    String? title,
    String? author,
    String? duration,
    String? musicUrl,
  }) {
    return MusicItem(
      musicId: musicId ?? this.musicId,
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

    return other.musicId == musicId &&
        other.imageUrl == imageUrl &&
        other.title == title &&
        other.author == author &&
        other.duration == duration &&
        other.musicUrl == musicUrl;
  }

  @override
  int get hashCode {
    return musicId.hashCode ^
        imageUrl.hashCode ^
        title.hashCode ^
        author.hashCode ^
        duration.hashCode ^
        musicUrl.hashCode;
  }
}
