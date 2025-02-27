import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class AddressComponent {
  final List<String> types;
  final String longName;
  final String shortName;

  AddressComponent(
      {required this.types, required this.longName, required this.shortName});

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      types: List<String>.from(json['types']),
      longName: json['long_name'],
      shortName: json['short_name'],
    );
  }
}

Future<dynamic> getGeocodingFromZip(String zipCode) async {
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$zipCode&key=AIzaSyC1RuhYlMwVwWMn6RZwjBuzvECC298vpgM'));

  return json.decode(response.body);
}

Future<List<AddressComponent>> getCityFromZip(String zipCode) async {
  final responseBody = await getGeocodingFromZip(zipCode);
  return (responseBody['results'][0]['address_components'] as List)
      .map((component) => AddressComponent.fromJson(component))
      .toList();
}

Future<List<AddressComponent>> getCityFromResponse(dynamic responseBody) async {
  return (responseBody['results'][0]['address_components'] as List)
      .map((component) => AddressComponent.fromJson(component))
      .toList();
}

Future<String> getCityNameFromZip(String zipCode) async {
  final addressComponents = await getCityFromZip(zipCode);
  final cityComponent = addressComponents
      .firstWhere((component) => component.types.contains('locality'));
  return cityComponent.longName;
}

Future<LatLng> getLocationFromZip(String zipCode) async {
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$zipCode&key=AIzaSyC1RuhYlMwVwWMn6RZwjBuzvECC298vpgM'));
  final responseBody = json.decode(response.body);
  return LatLng(responseBody['results'][0]['geometry']['location']['lat'],
      responseBody['results'][0]['geometry']['location']['lng']);
}
