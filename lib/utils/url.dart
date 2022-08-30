import 'dart:math';

class AppUrl {
  static String suggestionUrl(String query) {
    return Uri.encodeFull(
        "https://suggestqueries-clients6.youtube.com/complete/search?client=youtube&hl=en&gl=en&q=${query}&callback=func'");
  }

  static String searchResultUrl(String query) {
    return Uri.encodeFull(
        "https://www.youtube.com/results?search_query=${query.replaceAll(' ', '+')}");
  }
}
