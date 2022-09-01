class AppUrl {
  static String suggestionUrl(String query) {
    return Uri.encodeFull(
        "https://suggestqueries-clients6.youtube.com/complete/search?client=youtube&hl=en&gl=en&q=${query}&callback=func'");
  }

  static String searchResultUrl(String query) {
    return Uri.encodeFull(
        "https://www.youtube.com/results?search_query=${query.replaceAll(' ', '+')}");
  }

  static const loadPayloadForFilterUrl = 'https://www.youtube.com/?themeRefresh=1';

  // This generic url used both for search and loading music.
  static String genricUrl(String apiKey) {
    return Uri.encodeFull('https://www.youtube.com/youtubei/v1/browse?key=$apiKey&prettyPrint=false');
  }
}
