import 'package:flutter/material.dart';
import 'package:rest_reservation/pages/login/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 0, 0, 0), // Ефект внутрішньої тіні
                Colors.transparent,            // Прозорий верх
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn, // Змішування для створення прозорого ефекту
          child: Image.asset(
            "assets/images/splash.jpeg",
            height: MediaQuery.sizeOf(context).height * 0.55,
            fit: BoxFit.cover,
          ),
        ),

          Padding(
            padding: const EdgeInsets.all(28.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Elevate Your ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Чорний колір для першої частини тексту
                    ),
                  ),
                  TextSpan(
                    text: 'Dining Experience',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffE24601), // Помаранчевий колір для другої частини тексту
                    ),
                  ),
                  TextSpan(
                    text: ' Here!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Чорний колір для останньої частини тексту
                    ),
                  ),
                ],
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
              style: TextStyle(
                color: Color.fromARGB(255, 46, 46, 46)
              ),
              textAlign: TextAlign.center,
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(onPressed: (){},
               child: Text("Let's Get Started",
               style: TextStyle(color: Colors.white),),
               style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff5B4CBD),
                
               ),),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text("Already have an account?",
              style: TextStyle(
                color: Color.fromARGB(255, 19, 19, 19)
              ),
              textAlign: TextAlign.center,
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              }, child: 
              Text("Sign In"))
            ],
          )
        ],
      ),
    );
  }
}