import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotify/spotify.dart' as music;
import 'package:testz/pages/playlist.dart';
import 'package:testz/pages/song.dart';
import 'package:testz/pages/songData.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Song {
  final String id;
  final String title;
  final String singer;
  final String imageUrl;
  final String market;
  final String artistID;
   List<String> genre = [];
  int duration = 0;
  final String audioUrl;

  Song({required this.id,
  required this.title, 
  required this.singer, 
  required this.imageUrl, 
  required this.market, 
  required this.artistID, 
  required this.genre,
  required this.duration,
  required this.audioUrl
  });
}

class HorizontalSongList extends StatefulWidget {
  final String query;
  final bool isPlaylist;
  final AudioHandler audioHandler;

  HorizontalSongList({required this.query, 
  required this.audioHandler,
  required this.isPlaylist});
  @override
  _HorizontalSongListState createState() => _HorizontalSongListState();
}

class _HorizontalSongListState extends State<HorizontalSongList> {
  late List<Song> songs;
  late music.SpotifyApi spotify;
 bool isLoading = true;

  List<String> id = [];
  List<String> _searchResults = [];
  List<String> _searchResults2 = [];
  List<String> _searchResults3 = [];
  List<String> market = [];
  List<String> artistID = [];
  List<List<String>> genre = [];

  List<String> playlist = [];
  List<String> playlistID = [];
  List<String> playlistImage = [];
  List<String> playlistOwner = [];
  List<String> playlistDescription = [];
  List<String> playlistMarket = [];
  List<String> playlistGenre = [];
  List<String> playlistFollowers = [];
  List<int> duration = [];
  

  @override
  void initState() {
    super.initState();
    songs = [];
    // Initialize SpotifyApi
    var cred = music.SpotifyApiCredentials('d96f4905b91247d8b38c24e3a77155bd', 'd86c9dead5084cada0ed5cd37073c14c');
    spotify = music.SpotifyApi(cred);
    // Fetch songs
    _fetchSongs();
  }
Future<void> _fetchSongs() async {
  try {
    var search = await spotify.search.get(widget.query).first(10);
    var encounteredIds = <String>{};

    setState(() {
      songs.clear(); // Clear the songs list before adding new songs
      id.clear();
      _searchResults.clear(); // Clear the search results list before adding new results
      _searchResults2.clear(); // Clear the image URLs list as well
      _searchResults3.clear();
      artistID.clear();
      market.clear();
      genre.clear();
      playlist.clear();
      playlistID.clear();
      playlistImage.clear();
      playlistOwner.clear();
      playlistDescription.clear();
      playlistMarket.clear();
      playlistGenre.clear();
      duration.clear();
      artistID.clear();
      genre.clear();
      playlistFollowers.clear();
      
      isLoading = true; // Set loading to true before fetching songs
    });

    for (var pages in search) {
      if (pages.items == null) {
        print('Empty items');
      }

      for (var item in pages.items!) {
        if (item is music.Track) {
          if (encounteredIds.contains(item.name!)) {
            continue;
          }
          encounteredIds.add(item.name!);

          if (!widget.isPlaylist) {
            final yt = YoutubeExplode();
            final result = await yt.search.search(item.name! + " " + item.artists!.first.name! + ' audio');
            final videoId = result.first.id.value;
            var manifest = await yt.videos.streamsClient.getManifest(videoId);
            var audioUrl = manifest.audioOnly.first.url;
            yt.close();

            setState(() {
              songs.add(Song(
                id: item.id!,
                title: item.name!,
                singer: item.artists!.first.name!,
                imageUrl: item.album!.images!.first.url!,
                market: item.availableMarkets!.first.toString(),
                artistID: item.artists!.first.id!,
                genre: item is music.Track ? [] : (item as music.Artist).genres!,
                duration: item.durationMs!,
                audioUrl: audioUrl.toString(),
              ));
            });
          }
        } else if (item is music.PlaylistSimple && widget.isPlaylist) {
          var playlist = item as music.PlaylistSimple;

          setState(() {
            songs.add(Song(
              id: playlist.id!,
              title: playlist.name!,
              singer: playlist.owner!.id!,
              imageUrl: playlist.images!.isNotEmpty ? playlist.images!.first.url! : '',
              market: '', // You might need to adjust this
              artistID: playlist.owner!.id!,
              genre: [],
              duration: 0,
              audioUrl: '',
            ));
          });

          print('Playlist: ${playlist.id}');
        }
      }
    }

    setState(() {
      isLoading = false; // Set loading to false after fetching songs
    });
  } catch (e) {
    print('Error fetching songs: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: songs.map((song) {
            return SongCard(
              song: song,
              isPlaylist: widget.isPlaylist,
              audioHandler: widget.audioHandler,
            );
          }).toList(),
        ),
        ),
        if (isLoading)
            Container(
              // Semi-transparent black background
              child: Center(
                
                child: CircularProgressIndicator(
                  color: Colors.green,
                ), // Loading indicator in the center
              ),
            ),
      
    
    ]);
  }
}

class SongCard extends StatelessWidget {
  final Song song;
  final bool isPlaylist;
  final AudioHandler audioHandler;

  const SongCard({required this.song,
    required this.audioHandler,
  required this.isPlaylist});

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      
      child: GestureDetector(
        
        onTap: () {
          if (!this.isPlaylist) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PlaySong(
                  songData: SongData(
                    id: song.id,
                    imageUrl: song.imageUrl,
                    title: song.title,
                    singer: song.singer,
                    artistID: song.artistID,
                    genre: song.genre,
                    duration: song.duration,
                    audioUrl: song.audioUrl
                  ),
                  songList: [],
                  currentIndex: 0,
                  audioHandler: audioHandler,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PlaylistSongz(
                  id: song.id,
                  imageUrl: song.imageUrl,
                  title: song.title,
                  audioHandler: audioHandler,
                ),
              ),
            );
          }
        },

        child: Container(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
                 Hero(
                    tag: song.id,
                   child: Container(
                    height: 170,
                    
                    child: CachedNetworkImage(
                            imageUrl :song.imageUrl, 
                            height: 170,
                            width: 170,
                          placeholder: (context, url) =>LoadingAnimationWidget.flickr(
                            size: 30,
                            leftDotColor: Colors.pinkAccent,
                            rightDotColor: Colors.blueAccent,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                    ),)
                 ),
                 
              
              
              SizedBox(height: 8.0),
              Text(
                song.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                ),
                 overflow: TextOverflow.ellipsis,
              ),
             Text(
                song.singer,
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                ),
                 overflow: TextOverflow.ellipsis,
                )
            
              
            ],
          ),
        ),
      ),
    );
  }
}