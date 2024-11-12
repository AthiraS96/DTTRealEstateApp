import 'package:dtt_real_estate/Items/BottomNavigation.dart';
import 'package:dtt_real_estate/screens/HouseDetailPage.dart';
import 'package:dtt_real_estate/Provider/ApiProvider.dart';
import 'package:dtt_real_estate/screens/SearchPage.dart';
import 'package:dtt_real_estate/screens/Wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<House> houses = []; //Holds all the details of Houses
  TextEditingController searchController =
      TextEditingController(); //Used to implement search
  static const double defaultLatitude =
      52.3676; // Default lattittude when user denies location permission
  static const double defaultLongitude =
      4.9041; // Default Longitude  when user denies location permission
  Position? userLocation; //used to store user location when user allows

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);

    userLocation = Position(
      headingAccuracy: 0.0,
      latitude: defaultLatitude,
      longitude:
          defaultLongitude, //First setting the default location as the actual location
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
    requestLocationPermission().then((permissionGranted) {
      if (permissionGranted) {
        getCurrentLocation().then((location) {
          setState(() {
            userLocation =
                location; //Location permissions are granted so userlocation becomes the actual location
          });
          fetchHouses();
        });
      } else {
        setState(() {
          userLocation = Position(
            headingAccuracy: 0.0,
            latitude: defaultLatitude,
            longitude: defaultLongitude,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );
        });

        fetchHouses(); // Fetch houses even if permission is denied
      }
    });
  }

  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      // Permission granted, proceed to get location
      return true;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
      return false;
    } else {
      // Permission denied, set default location to Amsterdam
      setState(() {
        userLocation = Position(
          headingAccuracy: 0.0,
          latitude: defaultLatitude,
          longitude: defaultLongitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      });
      return false;
    }
  }

  //Using the Geolocator package get the current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  //Fetching house details from api and sorting that in asending order to price
  Future<void> fetchHouses() async {
    try {
      final apiService = ApiService();
      final fetchedHouses = await apiService.fetchHouses();
      fetchedHouses.sort((a, b) => a.price.compareTo(b.price));

      setState(() {
        houses = fetchedHouses;
      });
    } catch (e) {
      print('Error fetching houses: $e');
    }
  }

  //Using the latitude and longitude of user and house's calculate the distance between them
  double calculateDistance(Position userLocation, Position houseLocation) {
    return Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      houseLocation.latitude,
      houseLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    // void navigateToWishlist(BuildContext context) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => WishlistScreen()),
    //   );
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        //Developed a seperate function for Bottom navigation bar
        bottomNavigationBar: const Bottomappbar(),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F7F7),
          elevation: 0,
          automaticallyImplyLeading: false, // This removes the back arrow

          title: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      'DTT REAL ESTATE',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'GothamSSm',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WishlistScreen(),
                              ));
                        },
                        icon: Icon(Icons.favorite))
                    // Icon(Icons.favorite)
                    // Builder(
                    //   builder: (context) {
                    //     IconButton(
                    //       onPressed: () => navigateToWishlist(context),,
                    //       icon: Icon(
                    //         Icons.favorite,
                    //         color: Colors.grey,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                )
              ],
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
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFEBEBEB),
                          filled: true,
                          hintText: "Search for a home",
                          hintStyle:
                              const TextStyle(color: Color(0xFF33000000)),
                          contentPadding: const EdgeInsets.all(12.0),
                          suffixIcon: IconButton(
                              onPressed: () {
                                //Navigate to search page when search icon is pressed
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchPage(
                                        text: searchController.text,
                                        houses: houses,
                                        userLocation: userLocation,
                                      ),
                                    ));
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Color(0xFF33000000),
                              )),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
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
              //All house details as shown as listview format in home page using Housecard Function
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: houses.length,
                itemBuilder: (context, index) {
                  final house = houses[index];

                  return HouseCard(
                      house: house,
                      userLocation:
                          userLocation); //User location is passed for calculating the distance
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged() {
    if (searchController.text.trim().isEmpty) {
      clearSearchResults();
      // Optionally handle empty search query case.
      return;
    }
    getAllSearchData(
      context,
      searchQuery: searchController.text.trim(),
    );
  }

  List<House> AllSearchItems =
      []; //all searched items are stored in alist and displayed in search page
  List<House> get SearchItem {
    return [...AllSearchItems];
  }

  Future getAllSearchData(BuildContext context,
      {required String searchQuery}) async {}

  void clearSearchResults() {
    AllSearchItems.clear(); // Assuming AllSearchItems holds the search results
  }
}

//HouseCard class is to display house details in listview as cards
class HouseCard extends StatelessWidget {
  final House house;
  final Position? userLocation;

  final String baseUrl = "https://intern.d-tt.nl/";

  HouseCard({required this.house, required this.userLocation});

  @override
  Widget build(BuildContext context) {
    // Inkwell is used to get the onTap function for each cards to navigate to detail page
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HouseDetails(house: house, userLocation: userLocation),
            ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: const Color(0xFFFFFFFF),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Image.network(
                        baseUrl + house.imageUrl,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$${house.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 2,
                    ),
                    child: Text(
                      house.zip + ' ' + house.city,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF66000000)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            'assets/Icons/ic_bed.svg',
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF66000000),
                              BlendMode.srcIn,
                            ),
                            width: MediaQuery.of(context).size.height * 0.015,
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        house.bedrooms.toString(),
                        style: const TextStyle(
                            color: Color(0xFF66000000), fontSize: 10),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/Icons/ic_bath.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF66000000),
                                  BlendMode.srcIn,
                                ),
                                width:
                                    MediaQuery.of(context).size.height * 0.015,
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(house.bathrooms.toString(),
                              style: const TextStyle(
                                  color: Color(0xFF66000000), fontSize: 10)),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/Icons/ic_layers.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF66000000),
                                  BlendMode.srcIn,
                                ),
                                width:
                                    MediaQuery.of(context).size.height * 0.015,
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(house.size.toString(),
                              style: const TextStyle(
                                  color: Color(0xFF66000000), fontSize: 10)),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset(
                                'assets/Icons/ic_location.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF66000000),
                                  BlendMode.srcIn,
                                ),
                                width:
                                    MediaQuery.of(context).size.height * 0.015,
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          if (userLocation != null)
                            Text(
                                (calculateDistance(
                                                userLocation!,
                                                createPosition(
                                                    house.lattitude.toDouble(),
                                                    house.longitude
                                                        .toDouble())) /
                                            1000)
                                        .toStringAsFixed(2) +
                                    'KM',
                                style: const TextStyle(
                                    color: Color(0xFF66000000), fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateDistance(Position userLocation, Position houseLocation) {
    return Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      houseLocation.latitude,
      houseLocation.longitude,
    );
  }
}

Position createPosition(double latitude, double longitude) {
  return Position(
    latitude: latitude,
    longitude: longitude,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    headingAccuracy: 0.0,
  );
}
