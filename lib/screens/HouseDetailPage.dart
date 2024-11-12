import 'package:dtt_real_estate/Items/WishlistDB.dart';
import 'package:dtt_real_estate/screens/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dtt_real_estate/Provider/ApiProvider.dart';
import 'package:dtt_real_estate/Items/Utils.dart';

class HouseDetails extends StatefulWidget {
  final House house;

  final Position? userLocation;

  const HouseDetails(
      {super.key, required this.house, required this.userLocation});

  @override
  State<HouseDetails> createState() => _HouseDetailsState();
}

class _HouseDetailsState extends State<HouseDetails> {
  late GoogleMapController mapController;
  late WishlistDatabase database = WishlistDatabase.instance;
  bool _isInWishlist = false;

  void initState() {
    _checkWishlistStatus();
  }

  // Open Google Maps with directions to the house
  void _onMapTap() async {
    final latitude = widget.house.lattitude.toDouble();
    final longitude = widget.house.longitude.toDouble();
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  Future<void> _checkWishlistStatus() async {
    List<House> wishlist = await database.getWishlist();
    setState(() {
      _isInWishlist = wishlist.any((house) => house.id == widget.house.id);
    });
  }

  Future<void> _toggleWishlist() async {
    List<House> wishlist = await database.getWishlist();
    bool exists = wishlist.any((house) => house.id == widget.house.id);

    if (!exists) {
      await database.insertHouse(widget.house);
      print("House added to wishlist");
    } else {
      await database.deleteHouse(widget.house.id);
      print("House removed from wishlist");
    }

    setState(() {
      _isInWishlist = !_isInWishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "https://intern.d-tt.nl${widget.house.imageUrl}";
    final String price = widget.house.price.toString();
    final Position? userLocation = widget.userLocation;
    final Utils utils = Utils();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.network(
                imageUrl,
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Transparent AppBar with Back Arrow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: _isInWishlist ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleWishlist,
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.favorite_border,
                  //       color: Colors.white), // Wishlist icon
                  //   onPressed: () async {
                  //     // Handle wishlist action here
                  //     // Map<String, dynamic> houseMap = House.toMap(widget.house);

                  //     List<House> wishlist = await database.getWishlist();
                  //     print(wishlist);
                  //     bool exists =
                  //         wishlist.any((house) => house.id == widget.house.id);

                  //     if (!exists) {
                  //       await database.insertHouse(widget.house);
                  //       print("House added to wishlist");
                  //     } else {
                  //       print("House is already in the wishlist");
                  //     }

                  //     print("Wishlist button pressed");
                  //   },
                  // ),
                ]),
          ),
          // Container with details and map below the image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "\$$price",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 35),
                      _buildIconInfoRow(context),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GothamSSm',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.house.description,
                    style: const TextStyle(
                        color: Color(0Xff66000000), fontSize: 14),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    "Location",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GothamSSm',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildMapWidget(), // Google Map Widget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build map with marker
  Widget _buildMapWidget() {
    return GestureDetector(
      onTap: _onMapTap, // Opens Google Maps in emulator
      child: SizedBox(
        height: 200,
        child: GoogleMap(
          // mapType: MapType.satellite,
          // myLocationEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.house.lattitude.toDouble(),
                widget.house.longitude.toDouble()),
            zoom: 20,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("houseLocation"),
              position: LatLng(widget.house.lattitude.toDouble(),
                  widget.house.longitude.toDouble()),
              infoWindow: const InfoWindow(title: "House Location"),
            ),
          },
          zoomControlsEnabled: false,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
        ),
      ),
    );
  }

  // Icon row widget with bedrooms, bathrooms, size, and location distance
  Widget _buildIconInfoRow(BuildContext context) {
    final userLocation = widget.userLocation;
    final Utils utils = Utils();

    return Row(
      children: [
        _buildIconText(context, 'assets/Icons/ic_bed.svg',
            widget.house.bedrooms.toString()),
        _buildIconText(context, 'assets/Icons/ic_bath.svg',
            widget.house.bathrooms.toString()),
        _buildIconText(context, 'assets/Icons/ic_layers.svg',
            widget.house.size.toString()),
        if (userLocation != null)
          _buildIconText(
            context,
            'assets/Icons/ic_location.svg',
            '${(utils.calculateDistance(userLocation, createPosition(widget.house.lattitude.toDouble(), widget.house.longitude.toDouble())) / 1000).toStringAsFixed(2)} KM',
          ),
      ],
    );
  }

  // Helper method to create icon with text
  Widget _buildIconText(BuildContext context, String assetPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(
            Color(0xFF66000000),
            BlendMode.srcIn,
          ),
          width: MediaQuery.of(context).size.height * 0.015,
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Color(0xFF66000000), fontSize: 10),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
