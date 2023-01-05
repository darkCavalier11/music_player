// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserProfileState {
  final String userName;
  final String profilePicPlatformPath;
  final bool isOnBoardingDone;
  final bool intelligentCache;
  UserProfileState({
    required this.userName,
    required this.profilePicPlatformPath,
    required this.isOnBoardingDone,
    required this.intelligentCache,
  });

  factory UserProfileState.initial() {
    return UserProfileState(
      userName: '',
      profilePicPlatformPath: '',
      isOnBoardingDone: false,
      intelligentCache: true,
    );
  }

  UserProfileState copyWith({
    String? userName,
    String? profilePicPlatformPath,
    bool? isOnBoardingDone,
    bool? intelligentCache,
  }) {
    return UserProfileState(
      userName: userName ?? this.userName,
      profilePicPlatformPath:
          profilePicPlatformPath ?? this.profilePicPlatformPath,
      isOnBoardingDone: isOnBoardingDone ?? this.isOnBoardingDone,
      intelligentCache: intelligentCache ?? this.intelligentCache,
    );
  }

  @override
  String toString() {
    return 'UserProfileState(userName: $userName, profilePicPlatformPath: $profilePicPlatformPath, isOnBoardingDone: $isOnBoardingDone, intelligentCache: $intelligentCache)';
  }

  @override
  bool operator ==(covariant UserProfileState other) {
    if (identical(this, other)) return true;

    return other.userName == userName &&
        other.profilePicPlatformPath == profilePicPlatformPath &&
        other.isOnBoardingDone == isOnBoardingDone &&
        other.intelligentCache == intelligentCache;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
        profilePicPlatformPath.hashCode ^
        isOnBoardingDone.hashCode ^
        intelligentCache.hashCode;
  }
}
