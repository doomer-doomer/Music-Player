import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify/spotify.dart';

class Lib extends StatefulWidget {
  const Lib({super.key});

  @override
  State<Lib> createState() => _LibState();
}

class _LibState extends State<Lib> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        
        child: CustomScrollView(
          
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              stretch: true,
             
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Library', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              floating: true,
              snap: true,
            ),
          ],
        ),
      )
    );
  }
}