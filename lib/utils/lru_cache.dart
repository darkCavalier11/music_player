// a generic cache storage wrapped around shared preferences.
class LruCache {
  // This specifies how much music key-value pair should be stored
  // A key is the musicId and the value is the musicUrl.
  // todo : resolve IP address in the url to make the url work as cache.
  static const MUSIC_KEY_LIMIT = 1000;
}
