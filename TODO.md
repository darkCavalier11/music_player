# Todo(lock for first beta release)

## current operational issue with the music player
* Currently the entire music system based on running the music in the just audio playlist. Once tap on the music item it will create a new just audio playlist and add the tapped item to that list. It will fetch the next items(only the metadata, not the music playing url). So when playing need to handle next item that need to be played manually with loading each item once next is placed. Also if a music item clicked on the next item list, it is disrupting the playlist, cause a music item at unknown position
put at index next to currently playing item.
* Not able to play the music item from the user playlist. User playlist or downloaded items are a bit different from the regular playlist in term of how they will load the next items. User playlist item don't need to fetch the next music list, it will just play what is on the current playlist. But home screen music items need to do the fetching.
* user playlist need to support play all.xxxxxc 

#### sol: 1(Needs testing)
* The most clever hack would be load all the `musicItem` to the `just_audio` playlist, even if the exact url is absent. The urls will be fetched on realtime when requested(probable performance issue could be seen). For home screen music item lists will be dynamic.
* Once a home screen music or playlist music clicked, previous music list should be mandatorily cleared.
* when playing a previous music (or any music item on the list), parse the cached music url(todo) if there is expiry on url, if the url is expired, then only fetch again.
### Issue with sol 1
Not able to update the url once added to `just_audio` playlist.

### sol: 2
Complete migration to `audioplayers` library after testing
Test include
* Creating and updating playlist item with rich playlist api
* Playback stream or similar functionality to get update on playing audio state
* native system support for running audio on background.
* Proper api to handle loading audio, playing audio or any possible failure as such.
* Handling of audio images.
* Basic functionality as next, prev, pause, stop, clear playlist etc.

### Issue with sol 2
No support for native mobile functions like showing banner on the music screen or creating playlists.


### sol 3: part 1 
* get data on how to read audio byte stream and play them in a more low level way.


### sol 4
Use video player to play video
## issue
still issue long playing audios but better that audio player


## Known bugs need fix
* Repeatation of items on the home screen list(hard reproduction)
* Loading time for long audios on ios(song duration as well) and some time on android.

## UI enhancements
* Music playing screen UI quality bump.

## future features
* Shuffle play on playlist screen.
* Intelligent cache
* More setting features 
* Drag and move playlist items
* Offline downloads
* Possible bytes stream based music playing to support more low level playing to eliminate the ios playing issue.
* Fetch next music items on music playing sceen once reached to end of playing disc table.(low priority)
