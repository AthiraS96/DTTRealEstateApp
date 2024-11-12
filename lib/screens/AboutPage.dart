import 'package:dtt_real_estate/Items/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  void launchURL() async {
    Uri url = Uri.parse('https://www.d-tt.nl');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      mode:
      LaunchMode.externalApplication;
    } else {
      throw 'Could not launch $url';
    }
  }

  String app_details =
      ''' Welkom bij DTT Real Estate, de perfecte app om u te helpen uw volgende woning te vinden! Met deze app kunt u een breed scala aan woningen doorzoeken, compleet met alle details die u nodig heeft, waaronder prijs, aantal slaapkamers en badkamers, vierkante meters en de afstand vanaf uw huidige locatie. Ons doel is om uw woningzoektocht zo soepel en persoonlijk mogelijk te maken. Met onze app kunt u eenvoudig woningen vergelijken om de beste match voor u te vinden.Deze app is ontwikkeld door DTT Multimedia. DTT Multimedia, gevestigd in Amsterdam, is gespecialiseerd in het ontwikkelen van mobiele applicaties, websites en games. Hun diensten omvatten conceptualisatie, design, ontwikkeling en marketing, waardoor klanten een allesomvattende digitale oplossing geboden wordt. Het team bestaat uit ervaren ontwikkelaars, projectmanagers, designers en marketeers, allen toegewijd aan het leveren van hoogwaardige, gebruiksvriendelijke producten. Het portfolio van DTT bevat samenwerkingen met verschillende klanten, variërend van startups tot gevestigde ondernemingen, in diverse sectoren. ''';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: const Bottomappbar(),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 40, left: 5),
          child: Text(
            'ABOUT',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'GothamSSm'),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(app_details,
                style: const TextStyle(
                  color: Color(0Xff66000000),
                  fontSize: 12,
                )),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Text(
                  'Design and Development',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GothamSSm'),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Center vertically
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8, top: 10),
                  child: Image(
                    height: 45,
                    image: AssetImage('assets/Images/launcher_icon.png'),
                    fit: BoxFit.fill,
                  ),
                ),

                // DTT Text and Subtitle
                Container(
                  child: const Column(
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DTT',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'APPS WEB GAMES',
                        style: TextStyle(
                          fontSize: 7,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // "by DTT" and website link
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'by DTT',
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: launchURL,
                        child: const Text(
                          'd-tt.nl',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
