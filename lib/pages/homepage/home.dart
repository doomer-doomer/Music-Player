import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:testz/pages/homepage/search.dart';
import 'package:testz/pages/playlist.dart';
import 'package:testz/pages/settings.dart';
import 'package:testz/song/song.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spotify/spotify.dart' as music;



class NewHome extends StatelessWidget {
  final String username;
  final String email;
  final AudioHandler  audioHandler;

  const NewHome({Key? key,required this.audioHandler ,required this.username, required this.email}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     late var cred = music.SpotifyApiCredentials('d96f4905b91247d8b38c24e3a77155bd', 'd86c9dead5084cada0ed5cd37073c14c');
   late var spotify = music.SpotifyApi(cred);
     GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


    List<String> title = ["Phonk", "Rock Mix", "DJ Snake"];
    List<String> ids = ['37i9dQZF1DWWY64wDtewQt','37i9dQZF1EQpj7X7UK8OOF','37i9dQZF1DXblmY5UIU3v3'];
    List<String> list = ["https://i.scdn.co/image/ab67706f000000034691f7100f5f2cf40d0b3cc9",
     "https://seed-mix-image.spotifycdn.com/v6/img/rock/3IYUhFvPQItj6xySrBmZkd/en/large",
      "https://i.scdn.co/image/ab67706f00000003296dfaca9d08da66ad668073"];
    final List<Widget> imageSliders = list
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: ids[list.indexOf(item)],
                      child: GestureDetector(
                        onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaylistSongz(
                              id: ids[list.indexOf(item)],
                               imageUrl: item, 
                               title: title[list.indexOf(item)],
                               audioHandler: audioHandler,))
                               
                               );
                          },
                        child:CachedNetworkImage(
                          imageUrl: item, 
                          fit: BoxFit.cover, 
                          width: 1000.0, 
                          height: 1000.0,
                          placeholder: (context, url) => LoadingAnimationWidget.flickr(leftDotColor: Colors.pinkAccent, rightDotColor: Colors.blueAccent, size: 30),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ))
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            DrawerHeader(
              curve: Curves.easeInCubic,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://i.scdn.co/image/ab67706f000000034691f7100f5f2cf40d0b3cc9'),
                  ),
                  SizedBox(height: 10),
                  Text(username,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),)
                ],
              ),
            ),
            ListTile(
              title: Text('Home',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){},
            ),
            ListTile(
              title: Text('Search',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){
               
              },
            ),
            ListTile(
              title: Text('Library',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){},
            ),
            ListTile(
              title: Text('Settings',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.poppins().fontFamily),),
              onTap: (){},
            ),
          ],
        ),
      ),
      body: CustomScrollView(
       
        slivers: <Widget>[
   
          SliverAppBar(
            backgroundColor: Colors.black,
            stretch: true,
            pinned: true,
            leading: IconButton(onPressed: (){
              _scaffoldKey.currentState?.openDrawer();
            }, icon: Icon(Icons.menu,color: Colors.white,)),
            title: Text('Home',style: TextStyle(color: Colors.white,fontFamily: GoogleFonts.poppins().fontFamily,fontWeight: FontWeight.bold),),
            floating: true,
          
            actions: [
              IconButton(onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (context)=> SearchScreen(audioHandler: audioHandler,)));}, icon: Icon(Icons.search,color: Colors.white,)),
              IconButton(onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (context)=> Settings()));}, icon: Icon(Icons.settings,color: Colors.white,))
            ],
          ),
          

             SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              height: 420,
              child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 0.8,
          enlargeCenterPage: true,
        ),
        items: imageSliders
          )
              ),
      
              // child: SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
            //         GestureDetector(
            //           onTap: () {
            //             Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaylistSongz(id: 'static1', imageUrl: 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/cf9dd908-d5b0-475d-88f0-aa81b956ef63/dfyqetz-16e5c004-2c62-44d2-a155-cc0439248e14.png/v1/fill/w_1280,h_760,q_80,strp/phonk_wallpaper1_by_phoenixteam4_dfyqetz-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzYwIiwicGF0aCI6IlwvZlwvY2Y5ZGQ5MDgtZDViMC00NzVkLTg4ZjAtYWE4MWI5NTZlZjYzXC9kZnlxZXR6LTE2ZTVjMDA0LTJjNjItNDRkMi1hMTU1LWNjMDQzOTI0OGUxNC5wbmciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.ziH2QX22R8tInAfRiKKBZHDg9NA8QXh_Mvu0Z6vJPDw', title: 'Phonk')));
            //           },
            //           child: Hero(
            //             tag: 'static1',
            //             child: Container(
            //               height: MediaQuery.of(context).size.height / 2,
            //               width: MediaQuery.of(context).size.width,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(16.0),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.end,
            //                   children: [
            //                 Text('Best\nof Phonk',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 50,fontFamily: GoogleFonts.poppins().fontFamily),textAlign: TextAlign.start, ),
            //                               ]  ),
            //                               ),
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: NetworkImage('https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/cf9dd908-d5b0-475d-88f0-aa81b956ef63/dfyqetz-16e5c004-2c62-44d2-a155-cc0439248e14.png/v1/fill/w_1280,h_760,q_80,strp/phonk_wallpaper1_by_phoenixteam4_dfyqetz-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzYwIiwicGF0aCI6IlwvZlwvY2Y5ZGQ5MDgtZDViMC00NzVkLTg4ZjAtYWE4MWI5NTZlZjYzXC9kZnlxZXR6LTE2ZTVjMDA0LTJjNjItNDRkMi1hMTU1LWNjMDQzOTI0OGUxNC5wbmciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.ziH2QX22R8tInAfRiKKBZHDg9NA8QXh_Mvu0Z6vJPDw'),
            //                   fit: BoxFit.cover,
            //                 ),
            //               )
            //             ),
            //           ),
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaylistSongz(id: 'static2', imageUrl: 'https://thewarriorledger.com/wp-content/uploads/2019/02/william-krause-697816-unsplash-900x600.jpg', title: 'Metal')));
            //           },
            //           child: Hero(
            //             tag: 'static2',
            //             child: Container(
            //               height: MediaQuery.of(context).size.height / 2,
            //               width: MediaQuery.of(context).size.width,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(16.0),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.end,
            //                   children: [
            //                 Text('Best\nof Metal',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 50,fontFamily: GoogleFonts.poppins().fontFamily),textAlign: TextAlign.start,),
                            
            //                               ]  ),
            //                               ),
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: NetworkImage('https://thewarriorledger.com/wp-content/uploads/2019/02/william-krause-697816-unsplash-900x600.jpg'),
            //                   fit: BoxFit.cover,
                              
            //                 ),
            //               )
            //             ),
            //           ),
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             Navigator.push(context, MaterialPageRoute(builder: (context)=> PlaylistSongz(id: 'static3', imageUrl: 'https://discotech.me/wp-content/uploads/2021/02/photo-1578946956088-940c3b502864.jpeg', title: 'Martin Garrix')));
            //           },
            //           child: Hero(
            //             tag: 'static3',
            //             child: Container(
            //               height: MediaQuery.of(context).size.height / 2,
            //               width: MediaQuery.of(context).size.width,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(16.0),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.end,
            //                   children: [
            //                 Text('Best\nof EDM',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 50,fontFamily: GoogleFonts.poppins().fontFamily),textAlign: TextAlign.start,),
                            
            //                               ]  ),
            //                               ),
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: NetworkImage('https://discotech.me/wp-content/uploads/2021/02/photo-1578946956088-940c3b502864.jpeg'),
            //                   fit: BoxFit.cover,
            //                 ),
            //               )
            //             ),
                    //   ),
                    // ),
                    
                  
              //     ],
                
              //   ),
              // )
              
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    'Dua Mix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                     overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 280,
                      child: HorizontalSongList(query: "Dua lipa",isPlaylist: false,audioHandler: audioHandler,),
                  ),
                  Text(
                    'Drake Mix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 280,
                    child: HorizontalSongList(query: "drake", isPlaylist: true,audioHandler: audioHandler,),
                  ),
                  Text(
                    'Travis Mix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 280,
                    child: HorizontalSongList(query: 'travis scott', isPlaylist: false,audioHandler: audioHandler,),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Arjit Mix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                     overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 280,
                      child: HorizontalSongList(query: "arjit singh", isPlaylist: true,audioHandler: audioHandler,),
                  ),
                  Text(
                    'Aveneged Mix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 280,
                    child: HorizontalSongList(query: "avenged sevenfold", isPlaylist: false,audioHandler:  audioHandler,),
                  ),
                  Text(
                    'Shreya Mix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 280,
                    child: HorizontalSongList(query: 'Shreya ghoshal', isPlaylist: true,audioHandler: audioHandler,),
                  ),
                ],
              ),
                        ),
            ),
        ],
        ),
      
      );
    
  }
}
