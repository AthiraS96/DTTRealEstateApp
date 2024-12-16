//HouseCard class is to display house details in listview as cards
import 'package:dtt_real_estate/Items/House.dart';
import 'package:dtt_real_estate/Items/Utils.dart';
import 'package:dtt_real_estate/screens/HouseDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

// This class is used to display content as card inside each listview items in home page and also in search page
class HouseCard extends StatelessWidget {
  final House house;
  final Position? userLocation;
  final Utils utils = Utils();

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
                  //Add curved borders to image
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
                                '${(calculateDistance(userLocation!, utils.createPosition(house.lattitude.toDouble(), house.longitude.toDouble())) / 1000).toStringAsFixed(2)}KM',
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
