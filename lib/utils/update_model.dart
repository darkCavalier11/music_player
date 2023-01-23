import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpdateModel {
  final String latestVersion;
  final int latestBuildNumber;
  final String appUrl;
  final double appSize;
  final int ageRating;
  final List<String> supportedLocales;
  final List<String> permissionsRequired;
  final String description;
  final List<String> updateLog;
  UpdateModel({
    required this.latestVersion,
    required this.latestBuildNumber,
    required this.appUrl,
    required this.appSize,
    this.ageRating = 4,
    this.supportedLocales = const ["EN"],
    this.permissionsRequired = const ["None"],
    required this.description,
    required this.updateLog,
  });

  UpdateModel copyWith({
    String? latestVersion,
    int? latestBuildNumber,
    String? appUrl,
    double? appSize,
    int? ageRating,
    List<String>? supportedLocales,
    List<String>? permissionsRequired,
    String? description,
    List<String>? updateLog,
  }) {
    return UpdateModel(
      latestVersion: latestVersion ?? this.latestVersion,
      latestBuildNumber: latestBuildNumber ?? this.latestBuildNumber,
      appUrl: appUrl ?? this.appUrl,
      appSize: appSize ?? this.appSize,
      ageRating: ageRating ?? this.ageRating,
      supportedLocales: supportedLocales ?? this.supportedLocales,
      permissionsRequired: permissionsRequired ?? this.permissionsRequired,
      description: description ?? this.description,
      updateLog: updateLog ?? this.updateLog,
    );
  }

  factory UpdateModel.init() {
    return UpdateModel(
      latestVersion: '',
      latestBuildNumber: 0,
      appUrl: '',
      appSize: 0,
      description: '',
      updateLog: [],
    );
  }

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      latestVersion: json['latest_version'],
      latestBuildNumber: json['latest_build_number'],
      appUrl: json['app_url'],
      appSize: json['appsize'],
      description: json['description'],
      updateLog: (json['update_log'] as List<String>),
    );
  }

  @override
  String toString() {
    return 'UpdateModel(latestVersion: $latestVersion, latestBuildNumber: $latestBuildNumber, appUrl: $appUrl, appSize: $appSize, ageRating: $ageRating, supportedLocales: $supportedLocales, permissionsRequired: $permissionsRequired, description: $description, updateLog: $updateLog)';
  }

  @override
  bool operator ==(covariant UpdateModel other) {
    if (identical(this, other)) return true;

    return other.latestVersion == latestVersion &&
        other.latestBuildNumber == latestBuildNumber &&
        other.appUrl == appUrl &&
        other.appSize == appSize &&
        other.ageRating == ageRating &&
        listEquals(other.supportedLocales, supportedLocales) &&
        listEquals(other.permissionsRequired, permissionsRequired) &&
        other.description == description &&
        listEquals(other.updateLog, updateLog);
  }

  @override
  int get hashCode {
    return latestVersion.hashCode ^
        latestBuildNumber.hashCode ^
        appUrl.hashCode ^
        appSize.hashCode ^
        ageRating.hashCode ^
        supportedLocales.hashCode ^
        permissionsRequired.hashCode ^
        description.hashCode ^
        updateLog.hashCode;
  }
}

enum LoadingState {
  idle,
  loading,
  failed,
}
