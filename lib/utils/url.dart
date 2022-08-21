class AppUrl {
  static String searchUrl(String query) {
    return Uri.encodeFull(
        "https://suggestqueries-clients6.youtube.com/complete/search?client=youtube&hl=en-gb&gl=in&sugexp=foo%2Cyte%3D1%2Cedi%3Dytp6m%2Ccfro%3D1&gs_rn=64&gs_ri=youtube&ds=yt&cp=7&gs_id=t&q=${query}&xhr=t&xssi=t");
  }

  static String searchResultUrl(String query) {
    return Uri.encodeFull(
        "https://www.youtube.com/results?search_query=${query.replaceAll(' ', '+')}");
  }
}
