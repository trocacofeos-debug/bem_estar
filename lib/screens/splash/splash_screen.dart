// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../auth/auth_wrapper.dart';


class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });


  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {


  late AnimationController _controller;

  late Animation<double> _fade;

  late Animation<double> _scale;



  @override
  void initState() {

    super.initState();


    _controller = AnimationController(

      vsync: this,

      duration:
          const Duration(
            milliseconds: 1500,
          ),

    );



    _fade = Tween<double>(

      begin: 0,

      end: 1,

    ).animate(

      CurvedAnimation(

        parent: _controller,

        curve: Curves.easeIn,

      ),

    );



    _scale = Tween<double>(

      begin: 0.85,

      end: 1,

    ).animate(

      CurvedAnimation(

        parent: _controller,

        curve: Curves.easeOutBack,

      ),

    );



    _controller.forward();



    _abrirSistema();

  }




  Future<void> _abrirSistema() async {


    await Future.delayed(

      const Duration(
        seconds: 3,
      ),

    );



    if(!mounted) return;



    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (context) {

          return AuthWrapper();

        },

      ),

    );


  }





  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
          const Color(0xFFF8FAFC),



      body: Center(


        child: FadeTransition(

          opacity: _fade,


          child: ScaleTransition(

            scale: _scale,


            child: Column(


              mainAxisAlignment:
                  MainAxisAlignment.center,



              children: [



                Image.asset(

                  'assets/images/logo.png',

                  width: 220,

                  height: 220,

                  fit: BoxFit.contain,

                ),




                const SizedBox(
                  height: 25,
                ),




                const Text(

                  "BEM ESTAR",


                  style: TextStyle(

                    color:
                        Color(0xFF0F172A),


                    fontSize:
                        30,


                    fontWeight:
                        FontWeight.bold,


                    letterSpacing:
                        3,


                  ),

                ),





                const SizedBox(
                  height: 8,
                ),





                const Text(

                  "Performance • Saúde • Evolução",


                  style: TextStyle(

                    color:
                        Colors.grey,


                    fontSize:
                        14,

                  ),

                ),





                const SizedBox(
                  height: 35,
                ),





                const SizedBox(

                  width: 28,

                  height: 28,


                  child: CircularProgressIndicator(

                    strokeWidth:
                        3,


                    color:
                        Color(0xFF22C55E),

                  ),

                ),



              ],

            ),

          ),

        ),

      ),

    );

  }

}