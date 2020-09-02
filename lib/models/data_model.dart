import 'package:firebase_database/firebase_database.dart';

class House {
  House(
      {this.amount,
      this.address,
      this.bedrooms,
      this.bathrooms,
      this.squarefoot,
      this.garages,
      this.kitchen,
      this.date,
      this.imageUrl});

  int amount;
  int bedrooms;
  int bathrooms;
  int garages;
  int kitchen;
  String address;
  int squarefoot;
  String key;
  String date;
  String imageUrl;

  House.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        amount = snapshot.value['amount'],
        address = snapshot.value['address'],
        bedrooms = snapshot.value['bedrooms'],
        bathrooms = snapshot.value['bathrooms'],
        squarefoot = snapshot.value['squarefoot'],
        garages = snapshot.value['garages'],
        kitchen = snapshot.value['kitchen'],
        date = snapshot.value['date'],
        imageUrl = snapshot.value['imageUrl'];

  toJson() {
    return {
      'amount': amount,
      'address': address,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'squarefoot': squarefoot,
      'garages': garages,
      'kitchen': kitchen,
      'date': date,
      'imageUrl': imageUrl,
    };
  }
}
