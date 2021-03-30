import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trans/screens/main/MainScreen.dart';

class GreetingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GreetingsWidgetState();
}

class _GreetingsWidgetState extends State<GreetingsWidget> {
  String greeting = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                  offset: Offset(5.0, 5.0))
            ],
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/home_background.png'))),
        child: Container(
            alignment: Alignment.center,
            child: Text('VCS $greetings',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic))));
  }


  /// Set up greetings
  String get greetings {
    DateTime now = DateTime.now().toLocal();
    String time = DateFormat.Hm().format(now);
    int hour = int.parse(time.substring(0, 2));

    if (hour > 6 && hour <= 11) {
      /// For morning
      setState(() {
        greeting = MainConstants.MORNING;
      });

    } else if (hour > 11 && hour <= 12) {
      /// For afternoon
      setState(() {
        greeting = MainConstants.AFTERNOON;
      });
    } else if (hour > 12 && hour <= 18) {
      /// For evening
      setState(() {
        greeting = MainConstants.EVENING;
      });

    } else {
      /// For night
      setState(() {
        greeting = MainConstants.NIGHT;
      });

    }
    return greeting;
  }
}
