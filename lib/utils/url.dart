class AppUrl {
  static String suggestionUrl(String query) {
    return Uri.encodeFull(
        "https://suggestqueries-clients6.youtube.com/complete/search?client=youtube&hl=en&gl=en&q=$query&callback=func'");
  }

  static String searchResultUrl(String query) {
    return Uri.encodeFull(
        "https://www.youtube.com/results?search_query=${query.replaceAll(' ', '+')}");
  }

  static const loadPayloadForFilterUrl =
      'https://www.youtube.com/?themeRefresh=1';

  // This url used for browsing music
  static String browseUrl() {
    return Uri.encodeFull('https://www.youtube.com/');
  }

  // This url used for searching music
  static String searchUrl() {
    return Uri.encodeFull(
      'https://www.youtube.com/youtubei/v1/search?prettyPrint=false',
    );
  }

  // url used to fetch paricular music details
  static String playMusicUrl(String apiKey) {
    return 'https://www.youtube.com/youtubei/v1/player?key=$apiKey&prettyPrint=false';
  }

  // url to fetch next set of music
  static String nextMusicListUrl() {
    return 'https://www.youtube.com/youtubei/v1/next?prettyPrint=false';
  }
}
