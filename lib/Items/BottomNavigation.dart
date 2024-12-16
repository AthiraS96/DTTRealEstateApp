import 'package:dtt_real_estate/screens/AboutPage.dart';
import 'package:dtt_real_estate/screens/Homepage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//Class used to display Bottom navigation bar on the Home page and Details page
class Bottomappbar extends StatefulWidget {
  const Bottomappbar({super.key});

  @override
  State<Bottomappbar> createState() => _BottomappbarState();
}

class _BottomappbarState extends State<Bottomappbar> {
  static int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFFFFFFFF),
      height: MediaQuery.of(context).size.height * 0.075,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                currentPage = 0; //Set the current page status of home page
              });
              //When pressed on home icon it should load Home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            //Custom icon in svg format
            icon: SvgPicture.asset(
              'assets/Icons/ic_home.svg',
              width: MediaQuery.of(context).size.height * 0.06,
              height: MediaQuery.of(context).size.height * 0.06,
              colorFilter: ColorFilter.mode(
                currentPage == 0 ? Colors.black : const Color(0xFF33000000),
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                currentPage = 1; // set the current page status for aboutpage
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            icon: SvgPicture.asset(
              'assets/Icons/ic_info.svg',
              width: MediaQuery.of(context).size.height * 0.05,
              height: MediaQuery.of(context).size.height * 0.05,
              colorFilter: ColorFilter.mode(
                currentPage == 1 ? Colors.black : const Color(0xFF33000000),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
