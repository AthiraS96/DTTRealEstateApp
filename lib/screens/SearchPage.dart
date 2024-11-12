import 'package:dtt_real_estate/Items/BottomNavigation.dart';
import 'package:dtt_real_estate/Provider/ApiProvider.dart';
import 'package:dtt_real_estate/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SearchPage extends StatefulWidget {
  final String text;
  final List<House> houses;
  final Position? userLocation;

  const SearchPage(
      {super.key,
      required this.text,
      required this.houses,
      required this.userLocation});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    List<House> matchingHouses = findHomes(widget.houses, widget.text);

    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      bottomNavigationBar: Bottomappbar(),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBEBEB),
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
        title: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: const Text(
            'DTT REAL ESTATE',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'GothamSSm',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 40, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    // Wrap TextField with Expanded
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 221, 220, 220),
                        filled: true,
                        hintText: widget.text,
                        contentPadding: const EdgeInsets.all(12.0),
                        suffixIcon: IconButton(
                            // onPressed: () => SearchPage(),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                            },
                            icon: const Icon(Icons.close)),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          // borderRadius: BorderRadius.all(
                          //   Radius.circular(10),
                          // ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (matchingHouses.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
                child: Column(
                  children: [
                    Image.asset('assets/Images/search_state_empty.png'),
                    Text(
                      'No Results found!',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Perhaps try another search?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matchingHouses.length,
                itemBuilder: (context, index) {
                  final house = matchingHouses[index];
                  print('Building HouseCard for house: $house'); // Debug print
                  return HouseCard(
                      house: house, userLocation: widget.userLocation);
                },
              ),
          ],
        ),
      ),
    ));
  }

  // List<House> findHomes(searchText, houses) {
  //   List<House> matchingHomes = [];

  //   for (var house in houses) {
  //     if (house.city.contains(searchText) || house.zip.contains(searchText)) {
  //       matchingHomes.add(house);
  //     }
  //   }

  //   return matchingHomes;
  // }

  List<House> findHomes(List<House> houses, String searchText) {
    List<House> matchingHomes = [];

    // Normalize the search text by removing spaces and converting to lowercase
    String normalizedSearchText = searchText.replaceAll(' ', '').toLowerCase();

    for (var house in houses) {
      // Normalize the city and zip fields by removing spaces and converting to lowercase
      String normalizedCity = house.city.replaceAll(' ', '').toLowerCase();
      String normalizedZip = house.zip.replaceAll(' ', '').toLowerCase();

      if (house.id.toString().contains(searchText) ||
          normalizedCity.contains(normalizedSearchText) ||
          normalizedZip.contains(normalizedSearchText)) {
        matchingHomes.add(house);
      }
    }

    return matchingHomes;
  }
}
