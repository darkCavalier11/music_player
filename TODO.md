# Todo(lock for first beta release)

## current operational issue with the music player
* Currently the entire music system based on running the music in the just audio playlist. Once tap on the music item it will create a new just audio playlist and add the tapped item to that list. It will fetch the next items(only the metadata, not the music playing url). So when playing need to handle next item that need to be played manually with loading each item once next is placed. Also if a music item clicked on the next item list, it is disrupting the playlist, cause a music item at unknown position
put at index next to currently playing item.
* Not able to play the music item from the user playlist. User playlist or downloaded items are a bit different from the regular playlist in term of how they will load the next items. User playlist item don't need to fetch the next music list, it will just play what is on the current playlist. But home screen music items need to do the fetching.
* user playlist need to support play all.xxxxxc 

#### sol: 1(Needs testing)
* The most clever hack would be load all the `musicItem` to the `just_audio` playlist, even if the exact url is absent. The urls will be fetched on realtime when requested(probable performance issue could be seen). For home screen music item lists will be dynamic.
* Once a home screen music or playlist music clicked, previous one should be mandatorily cleared.
* when playing a previous music, parse the cached music url(todo) if there is expiry on url, if the url is expired, then only fetch again.


## Known bugs need fix
* Music playlist detail screen song count and total duration need fix.
* Loading time for long audios on ios(song duration as well) and some time on android.
* Repeatation of items on the home screen list

## UI enhancements
* Music playing screen UI quality bump.

## future features
* Fetch next music items on music playing sceen once reached to end of playing disc table.
* Shuffle play on playlist screen.
* Intelligent cache
* Onboarding screen for dp and name.
* More setting features 
* Offline downloads
* Possible bytes stream based music playing to support more low level playing to eliminate the ios playing issue.
