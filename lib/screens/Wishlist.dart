import 'package:dtt_real_estate/Items/Utils.dart';
import 'package:dtt_real_estate/Items/WishlistDB.dart';
import 'package:dtt_real_estate/Provider/ApiProvider.dart';
import 'package:dtt_real_estate/screens/Homepage.dart';
import 'package:dtt_real_estate/Items/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late List<House> wishlist = [];
  Utils utils = Utils();
  late Position position = createPosition(0, 0);
  late Future<Position> userLocation = utils.getCurrentLocation();

  Future<void> fetchUserLocation() async {
    position = await userLocation;
    print("User Location: ${position.latitude}, ${position.longitude}");
  }
  // ignore: use_function_type_syntax_for_parameters

  @override
  void initState() {
    _loadWishlist();
    super.initState();
    fetchUserLocation();
  }

  Future<void> _loadWishlist() async {
    final db = WishlistDatabase.instance;
    final items = await db.getWishlist();
    setState(() {
      wishlist = items;
    });
  }

  Future<void> _addToWishlist(House house) async {
    final db = WishlistDatabase.instance;
    await db.insertHouse(house);
    _loadWishlist();
  }

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
                    top: 30, // Adjust the position as needed
                    right: 8, // Adjust the position as needed
                    child: IconButton(
                      icon: Icon(Icons.delete,
                          color: Color.fromARGB(255, 127, 125, 125)),
                      onPressed: () => _removeFromWishlist(house.id),
                    ),
                  ),
                ],
              );
              //User location is passed for calculating the distance
            }),
      ),
    );
    // ListView.builder(
    //   itemCount: wishlist.length,
    //   itemBuilder: (context, index) {
    //     final house = wishlist[index];
    //     return ListTile(
    //       leading: Image.network(house.imageUrl),
    //       title: Text(house.city),
    //       subtitle: Text('${house.bedrooms} bedrooms - \$${house.price}'),
    //       trailing: IconButton(
    //         icon: Icon(Icons.delete),
    //         onPressed: () => _removeFromWishlist(house.id),
    //       ),
    //     );
    //   },
    // ),
    // );
  }
}
