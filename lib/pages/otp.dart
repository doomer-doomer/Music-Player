import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_pinput/new_pinput.dart';
import 'package:testz/pages/phone.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  String smsCode = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
    borderRadius: BorderRadius.circular(20),
  ),
);

final focusedPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(8),
  ),
  
);

final submittedPinTheme = PinTheme(
   width: 56,
  height: 56,
  textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
     color: Color.fromRGBO(234, 239, 243, 1),
  ));

Future<bool>verifyOTP() async{
      var phoneAuthCredential = await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: PhoneScreen.verificationID, smsCode: smsCode));
      
      return phoneAuthCredential != null ? true: false;
      

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,),
            Text("OTP Verification", style: TextStyle(fontSize: 30, color: Colors.black,
             fontWeight: FontWeight.bold,
             fontFamily: GoogleFonts.poppins().fontFamily),),
            Text(
              "Enter the 6-digit code sent to you",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              PhoneScreen.num,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            SizedBox(
              height: 30,
            ),
           Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              showCursor: true,
              onChanged: (String pin) {
                smsCode = pin;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text("Resend OTP", style: TextStyle(fontSize: 14, color: Colors.blue),),
           
            SizedBox(
              height: 20,
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async{
          var result = await verifyOTP();
          if(result){
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        },
        child: Icon(Icons.arrow_forward),
      )
    );
  }
}