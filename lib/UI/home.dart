import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Drone Companion")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height,
          width: width,
          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/addmission');
                },
                child: Card(
                  elevation: 5,
                  color: Colors.blue[100],
                  child: Container(
                    height: height / 4,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          FontAwesomeIcons.plus,
                          size: 40,
                        ),
                        Text(
                          "Add Mission",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/dronecommand');
                },
                child: Card(
                  elevation: 5,
                  color: Colors.blue[100],
                  child: Container(
                    height: height / 4,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          FontAwesomeIcons.planeDeparture,
                          size: 40,
                        ),
                        Text(
                          "Drone Command",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/track');
                },
                child: Card(
                  elevation: 5,
                  color: Colors.blue[100],
                  child: Container(
                    height: height / 4,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          FontAwesomeIcons.mapLocation,
                          size: 40,
                        ),
                        Text(
                          "Location Tracking",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
