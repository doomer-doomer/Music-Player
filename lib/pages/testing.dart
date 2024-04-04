import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify/spotify.dart' as music;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {

   List<String> id = [];
  List<String> _searchResults = [];
  List<String> _searchResults2 = [];
  List<String> _searchResults3 = [];
  List<String> market = [];
  List<String> artistID = [];
  List<List<String>> genre = [];

  late var cred = music.SpotifyApiCredentials('f1f95fae275c456d9b2bc95c4572501f', 'ad248e1a723f4b87b9b7f8de339aaff2');
   late var spotify = music.SpotifyApi(cred);


   void _search(String? query) async {
  if (query == null || query.isEmpty) {
    setState(() {
      _searchResults.clear(); // Clear the search results list if the query is empty
      _searchResults2.clear(); // Clear the image URLs list as well
      _searchResults3.clear();
      artistID.clear();
      market.clear();
      genre.clear();

    });
    return; // or handle the empty or null query case accordingly
  }

  var search = await spotify.search.get(query).first(3);
  
  setState(() {
    _searchResults.clear(); // Clear the search results list before adding new results
    _searchResults2.clear(); // Clear the image URLs list as well
    _searchResults3.clear();
    search.forEach((pages) {
      if (pages.items == null) {
        print('Empty items');
      }
      pages.items!.forEach((item) {
        if (item is music.Track) {
          _searchResults.add(item.name!);
          _searchResults2.add(item.album!.images!.first.url!);
          _searchResults3.add(item.artists!.first.name!);
          id.add(item.id!);
          artistID.add(item.artists!.first.id!);
          market.add(item.availableMarkets!.first.toString());
          print(item.availableMarkets!.first.toString());
          print(item.artists!.first.id);
          // if (item.artists != null && item.artists!.isNotEmpty) {
          //   List<List<String>>? firstArtistGenres = item.artists!.first.genres as List<List<String>>?;
          //   if (firstArtistGenres != null) {
          //     for (List<String> x in firstArtistGenres) {
          //       List<String> itemGenres = [];
          //       itemGenres.addAll(x);
          //       genre.add(itemGenres);
          //     }
          //   }
          // }

        }
        else if(item is music.Artist){
          print(item.genres);
        }
      });
    });
  });
  print(genre);
}

@override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _search('fein');
          },
          child: Text('Search'),
        )
      ),
    );
  }
}