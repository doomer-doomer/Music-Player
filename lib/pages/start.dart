import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testz/pages/home.dart';
import 'package:testz/pages/homepage/home.dart';
import 'package:camera/camera.dart';

class StartScreen extends StatefulWidget {
final List<CameraDescription> cameras;
final AudioHandler audioHandler;
  const StartScreen({super.key,
  required this.cameras,
  required this.audioHandler
  });


  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  Hero(tag: 'test2', child: Image(image: AssetImage("assets/singup2.png"))),
                  Image(image: AssetImage("assets/main2.png")),
                  Hero(tag: 'phone',child: Image(image: AssetImage("assets/main3.png"))),
                  Hero(tag: 'test',child: Image(image: AssetImage("assets/main4.png"))),

                ]
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
 ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.redAccent, Colors.greenAccent , Colors.yellowAccent], // Adjust gradient colors
                                stops: [0.1, 0.25, 0.4], // Adjust gradient stops
                              ).createShader(bounds);
                            },
                            child: Text(
                              'FERSR.',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),),
                    Text("The best place to share your emotions to get your personalized music playlist.", style: TextStyle(color: Colors.white, fontSize: 12,fontFamily: GoogleFonts.poppins().fontFamily,)),
                            ],
                          ),
                         
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          label: Text("Login", style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),),
                          icon: Icon(Icons.email),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          label: Text("Sign Up", style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),),
                          icon: Icon(Icons.person),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/phone');
                          },
                          label: Text("Login with Phone", style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),),
                          icon: Icon(Icons.phone)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen(cameras: widget.cameras, username: '', email: '',audioHandler: widget.audioHandler,)));
          },
          child: Icon(Icons.home),
        ),
      );
  }
}