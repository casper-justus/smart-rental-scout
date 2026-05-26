import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/property.dart';

class CommuteDestination {
  final String name;
  final String address;

  const CommuteDestination({required this.name, required this.address});

  Map<String, dynamic> toJson() => {'name': name, 'address': address};

  factory CommuteDestination.fromJson(Map<String, dynamic> json) =>
      CommuteDestination(
        name: json['name'] as String,
        address: json['address'] as String,
      );
}

class CommuteService {
  CommuteService._();
  static final CommuteService instance = CommuteService._();

  final ValueNotifier<List<CommuteDestination>> destinationsNotifier =
      ValueNotifier([]);

  List<CommuteDestination> get destinations => destinationsNotifier.value;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tm-commute-destinations');
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) =>
                CommuteDestination.fromJson(e as Map<String, dynamic>))
            .toList();
        destinationsNotifier.value = list;
      } catch (_) {}
    }
  }

  Future<void> addDestination(String name, String address) async {
    final list = List<CommuteDestination>.from(destinations);
    list.add(CommuteDestination(name: name, address: address));
    await _save(list);
  }

  Future<void> removeDestination(int index) async {
    final list = List<CommuteDestination>.from(destinations);
    list.removeAt(index);
    await _save(list);
  }

  Future<void> _save(List<CommuteDestination> list) async {
    destinationsNotifier.value = list;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'tm-commute-destinations', jsonEncode(list.map((d) => d.toJson()).toList()));
  }

  /// Calculate mock commute time in minutes based on transitScore.
  /// Higher transit score = shorter commute.
  List<MapEntry<String, int>> calculateCommuteTimes(PropertyListing property) {
    return destinations.map((dest) {
      final minutes = ((100 - property.transitScore) * 0.55 + 5).round();
      return MapEntry(dest.name, minutes.clamp(3, 60));
    }).toList();
  }
}
