import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
   static String verificationID = '';
    static String num = '';

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
    bool _showContainer = false;
    FirebaseAuth auth = FirebaseAuth.instance;
   

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showContainer = true;
      });
    });
  }

  

  verifyPhone(num) async{
    await auth.verifyPhoneNumber(
  phoneNumber: num,
  verificationCompleted: (PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);
  },
  verificationFailed: (FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
  },
  codeSent: (String verificationId, int? resendToken) async {
    PhoneScreen.verificationID = verificationId;
    Navigator.pushNamed(context, '/otp');
  },
  codeAutoRetrievalTimeout: (String verificationId) {
    // Auto-resolution timed out...
  },
);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Hero(
                           tag: 'phone',
                           child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/main3.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                           ),
                         ),
             
            AnimatedOpacity(
                opacity: _showContainer ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
              
                child: Container(
                  height: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0,),
                    Image(image: AssetImage("assets/arrow.png"),width: 50,height: 50,),
                    Text("Sign up with Phone Number", style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,fontSize: 24.0), textAlign: TextAlign.start,),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      onChanged: (value) => PhoneScreen.num = value,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,  
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        verifyPhone(PhoneScreen.num);
                       
                        print('Request OTP button pressed');
                      },
                      child: Text('Request OTP', style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14.0,
                      
                        
                      ),
                      ),
                    ),
                  ],
                            ),
                ),
              ),
            
          ]
        ),
    
    );
  }
}