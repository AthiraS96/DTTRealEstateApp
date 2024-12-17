//Model class that represt the structure of house entity

class House {
  final int id;
  final String imageUrl;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final int size;
  final String description;
  final String city;
  final String zip;
  final String date;
  final int lattitude;
  final int longitude;

  House({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.description,
    required this.city,
    required this.zip,
    required this.date,
    required this.lattitude,
    required this.longitude,
  });

  // Factory constructor to parse JSON data
  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'] ?? 0, // Provide default value if null
      imageUrl: json['image'] ?? '',
      price: json['price'] ?? 0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      size: json['size'] ?? 0,
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      zip: json['zip'] ?? '',
      date: json['createdDate'] ?? '',
      lattitude: json['lattitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
    );
  }
  // Convert a House object to a Map for database storage
  Map<String, dynamic> toMap(House house) {
    return {
      'id': house.id,
      'imageUrl': house.imageUrl,
      'price': house.price,
      'bedrooms': house.bedrooms,
      'bathrooms': house.bathrooms,
      'size': house.size,
      'description': house.description,
      'city': house.city,
      'zip': house.zip,
      'date': house.date,
      'lattitude': house.lattitude,
      'longitude': house.longitude,
    };
  }

  // Create a House object from a Map retrieved from the database
  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      id: map['id'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
      size: map['size'],
      description: map['description'],
      city: map['city'],
      zip: map['zip'],
      date: map['date'],
      lattitude: map['lattitude'],
      longitude: map['longitude'],
    );
  }
}
