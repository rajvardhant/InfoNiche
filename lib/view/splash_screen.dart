import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/interest_controller.dart';
import 'home_screen.dart';
import 'interest_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final interestController = Get.put(InterestController());

    Timer(const Duration(seconds: 2), () {
      if (interestController.hasSelectedInterests) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InterestScreen()));
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center ,
          children: [
            Image.asset(
              'assets/images/news1.png',
              fit: BoxFit.cover,
              width: width * 1,
              height: height *.5,
            ),
            SizedBox(height: height * 0.04,),
            Text('TOP HEADLINES' , style: GoogleFonts.anton(letterSpacing: .6 , color: Colors.grey.shade700),),
            SizedBox(height: height * 0.04,),
            const SpinKitSpinningLines(
              color: Colors.blue ,
                size: 40,
            )
          ],
        ),
      ),

    );
  }
}
