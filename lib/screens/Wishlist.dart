import 'package:dtt_real_estate/Items/House.dart';
import 'package:dtt_real_estate/Items/HouseCard.dart';
import 'package:dtt_real_estate/Items/Utils.dart';
import 'package:dtt_real_estate/Items/WishlistDB.dart';
import 'package:dtt_real_estate/Provider/ApiProvider.dart';
import 'package:dtt_real_estate/screens/Homepage.dart';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<House> wishlist = [];
  Utils utils = Utils();
  late Position position = utils.createPosition(0, 0);
  late Future<Position> userLocation = utils.getCurrentLocation();

  Future<void> fetchUserLocation() async {
    position = await userLocation;
    print("User Location: ${position.latitude}, ${position.longitude}");
  }

  @override
  void initState() {
    _loadWishlist();
    super.initState();
    fetchUserLocation();
  }

  //Function to load wishlist
  Future<void> _loadWishlist() async {
    final db = WishlistDatabase.instance;
    final items = await db.getWishlist();
    setState(() {
      wishlist = items;
    });
  }

//Function to add house data to wishlist database
  Future<void> _addToWishlist(House house) async {
    final db = WishlistDatabase.instance;
    await db.insertHouse(house);
    _loadWishlist();
  }

  //Function to remove house data from wishlist
  Future<void> _removeFromWishlist(int id) async {
    final db = WishlistDatabase.instance;
    await db.deleteHouse(id);
    _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Wishlist")),
        body: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final house = wishlist[index];

              return Stack(
                children: [
                  HouseCard(house: house, userLocation: position),
                  Positioned(
                    top: 30,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.delete,
                          color: Color.fromARGB(255, 127, 125, 125)),
                      onPressed: () => _removeFromWishlist(house.id),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
