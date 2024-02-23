import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        color: Colors.cyan.shade800,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Add Expanded here
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'CARS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: 210.0,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                isRepeatingAnimation: true,
                                animatedTexts: [
                                  FadeAnimatedText(
                                    'Reach 10 Lakh+\nInterested Buyers',
                                    duration: Duration(seconds: 4),
                                  ),
                                  FadeAnimatedText(
                                    'New way to\nBuy or Sell Cars',
                                    duration: Duration(seconds: 4),
                                  ),
                                  FadeAnimatedText(
                                    'Over 1 Lakh\nCars to Buy',
                                    duration: Duration(seconds: 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                          color: Colors.white,
                          oppositeShadowLightSource: true
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/olxclone-12618.appspot.com/o/banner%2Ficons8-car-100.png?alt=media&token=8e6abf20-34d5-4d51-93c5-48cbf675924b',
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: (){},
                      style: NeumorphicStyle(color: Colors.white),
                      child: Text('Buy Car',textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(width:10,),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: (){},
                      style: NeumorphicStyle(color: Colors.white),
                      child: Text('Sell Car',textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
