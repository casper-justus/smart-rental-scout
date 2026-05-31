import 'package:flutter/material.dart';

class PropertyListing {
  final String id;
  final String title;
  final String price;
  final String address;
  final int beds;
  final int baths;
  final int sqft;
  final String imageUrl;
  final int transitScore;
  final int tenantScore;
  final bool petsOk;
  final bool isHot;
  final bool isGreatValue;
  final bool hasVirtualTour;
  final String insight;
  final double lat;
  final double lng;
  final String type;
  final String neighborhood;

  const PropertyListing({
    required this.id,
    required this.title,
    required this.price,
    required this.address,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.imageUrl,
    required this.lat,
    required this.lng,
    this.transitScore = 0,
    this.tenantScore = 0,
    this.petsOk = false,
    this.isHot = false,
    this.isGreatValue = false,
    this.hasVirtualTour = false,
    this.insight = '',
    this.type = 'Apartment',
    this.neighborhood = '',
  });

  List<String> get images => [
    imageUrl,
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&q=80&w=800',
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&q=80&w=800',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&q=80&w=800',
    'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&q=80&w=800',
  ];

  Color get chipColor {
    if (isHot) return Colors.orange;
    if (isGreatValue) return Colors.green;
    return Colors.blue;
  }

  String get chipLabel {
    if (isHot) return 'Hot';
    if (isGreatValue) return 'Great Value';
    return '';
  }

  static const List<PropertyListing> sampleProperties = [
    PropertyListing(
      id: 'prop_1',
      title: 'KSh 95,000',
      price: 'KSh 95,000/mo',
      address: 'Muthithi Rd, Westlands',
      beds: 2,
      baths: 2,
      sqft: 1150,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeb5yN2VQ5joyMLB8Grc9Fz8c6XPssf20Kene7XpZlCIdFFp6JbRZqZAie3eSIhakb_I3oHbsitSi-BrHrAG1QZJH1JYCV-ErazcQ86ZYP8dCo_43XX3_fr2d7zpHHKNbEjRoHYf7QnPgMiIkHYQQIdph9Fe3gwmQZUVUHX1SIeNwBnM_VLDx0AeCme9wj-CgSvZxhtxmPfjeaS8P4aom7JUxC1gT0Vj2s_r1eLoEw3ganRlmk2JMDZdIAtyFltMPGHsNsSWSRKhE',
      lat: -1.2667,
      lng: 36.8167,
      transitScore: 98,
      tenantScore: 94,
      petsOk: true,
      isHot: true,
      hasVirtualTour: true,
      insight: 'Priced 4% below similar units in Westlands. 10 min matatu to CBD.',
      type: 'Apartment',
      neighborhood: 'Westlands',
    ),
    PropertyListing(
      id: 'prop_2',
      title: 'KSh 75,000',
      price: 'KSh 75,000/mo',
      address: 'Argwings Kodhek Rd, Kilimani',
      beds: 2,
      baths: 2,
      sqft: 950,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCMf3rMjiYmOe3BKzHg9gLL-zcm8ITtKEhxa10e7Dt_MV8xVbsueKe4bDc2Cfc66QZewLcrLAKl_CM3vIGdf4pJ5wAQI84tIXrvy3MhWwBtoGIw76EodC5BbTlN6dVPKlLLL2b1W4tkCMsvzmBWydh9wBwm-yd5B5XCpDc3A58QTXImEpRph1e3sYaukMYe_yZ5yVxbkAoStpJg3EYOvw25ztVDOTv1JL834TNb5k6Kxn0ZUKiXmVFH5JK0w61XQhlqBplLHaLMxB8',
      lat: -1.2900,
      lng: 36.7800,
      transitScore: 85,
      tenantScore: 85,
      petsOk: false,
      isHot: false,
      type: 'Apartment',
      neighborhood: 'Kilimani',
    ),
    PropertyListing(
      id: 'prop_3',
      title: 'KSh 85,000',
      price: 'KSh 85,000/mo',
      address: 'Ngong Rd, Kileleshwa',
      beds: 2,
      baths: 2,
      sqft: 1100,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBEIKK2eJOjVIlBd1_7IM-oologEB8AvMQ-i_M5UqhMCWKs-1_6v5J5M4zcsKgWFAuman3XTweOxQfAIM9ji1NuH5NYO6VmVOPuEh4Wpv1NyJWFJXlLaEvGc6Y95nhFgF93uUzRUL8FTp5aqu2f0dO8_2mWsuQRgZJLN-eQyhQpP3JZ4MfGoksUAU64CHVIkcdVKbL16AUDKlLKc2FLlgYPRih0nIYNvOOnVfkQGRGqshMFTwj0MJ50vUtFT0EGxdRtVYESQysr09g',
      lat: -1.2800,
      lng: 36.7800,
      transitScore: 92,
      tenantScore: 92,
      petsOk: false,
      isHot: false,
      isGreatValue: true,
      type: 'Apartment',
      neighborhood: 'Kileleshwa',
    ),
    PropertyListing(
      id: 'prop_4',
      title: 'KSh 45,000',
      price: 'KSh 45,000/mo',
      address: 'Mbaazi Ave, Lavington',
      beds: 1,
      baths: 1,
      sqft: 650,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAav82gLIpA33LU01h-XC-Q3Lhg6N4zuBov8ZSDAJtII8mJfzKsqW6n8siZ1A8Mx7JIOORGCUEupz5cgU6w72liqzTOWfcTrN0mZYjWtIO5ae66f8-Y0f2sczOdFcdNtR0foc-PGiNw-jrvAqX8TdLhU3hRXvfJ07lGsOFpKaBu7tOT-m0gZKmexK3nzon7Tq3oSHyBEnR8QicxZD0wdr4MJitCsLXNXAmvaR39UnurWv_5sderlCeK0HSsPC0onyBlmLle1ysktPg',
      lat: -1.2778,
      lng: 36.7636,
      transitScore: 78,
      tenantScore: 78,
      petsOk: false,
      isHot: false,
      type: 'Studio',
      neighborhood: 'Lavington',
    ),
    PropertyListing(
      id: 'prop_5',
      title: 'KSh 150,000',
      price: 'KSh 150,000/mo',
      address: 'Langata Rd, Karen',
      beds: 3,
      baths: 2,
      sqft: 1450,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeb5yN2VQ5joyMLB8Grc9Fz8c6XPssf20Kene7XpZlCIdFFp6JbRZqZAie3eSIhakb_I3oHbsitSi-BrHrAG1QZJH1JYCV-ErazcQ86ZYP8dCo_43XX3_fr2d7zpHHKNbEjRoHYf7QnPgMiIkHYQQIdph9Fe3gwmQZUVUHX1SIeNwBnM_VLDx0AeCme9wj-CgSvZxhtxmPfjeaS8P4aom7JUxC1gT0Vj2s_r1eLoEw3ganRlmk2JMDZdIAtyFltMPGHsNsSWSRKhE',
      lat: -1.3182,
      lng: 36.7292,
      transitScore: 90,
      tenantScore: 96,
      petsOk: true,
      isHot: true,
      hasVirtualTour: true,
      insight: 'Premium Karen living. Top-rated schools within 2 km.',
      type: 'Condo',
      neighborhood: 'Karen',
    ),
    PropertyListing(
      id: 'prop_6',
      title: 'KSh 35,000',
      price: 'KSh 35,000/mo',
      address: 'Mutonga Rd, South B',
      beds: 1,
      baths: 1,
      sqft: 550,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAav82gLIpA33LU01h-XC-Q3Lhg6N4zuBov8ZSDAJtII8mJfzKsqW6n8siZ1A8Mx7JIOORGCUEupz5cgU6w72liqzTOWfcTrN0mZYjWtIO5ae66f8-Y0f2sczOdFcdNtR0foc-PGiNw-jrvAqX8TdLhU3hRXvfJ07lGsOFpKaBu7tOT-m0gZKmexK3nzon7Tq3oSHyBEnR8QicxZD0wdr4MJitCsLXNXAmvaR39UnurWv_5sderlCeK0HSsPC0onyBlmLle1ysktPg',
      lat: -1.3167,
      lng: 36.8333,
      transitScore: 72,
      tenantScore: 70,
      petsOk: false,
      isHot: false,
      isGreatValue: true,
      type: 'Apartment',
      neighborhood: 'South B',
    ),
    PropertyListing(
      id: 'prop_7',
      title: 'KSh 180,000',
      price: 'KSh 180,000/mo',
      address: 'Miotoni Rd, Lang\'ata',
      beds: 4,
      baths: 3,
      sqft: 2200,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBEIKK2eJOjVIlBd1_7IM-oologEB8AvMQ-i_M5UqhMCWKs-1_6v5J5M4zcsKgWFAuman3XTweOxQfAIM9ji1NuH5NYO6VmVOPuEh4Wpv1NyJWFJXlLaEvGc6Y95nhFgF93uUzRUL8FTp5aqu2f0dO8_2mWsuQRgZJLN-eQyhQpP3JZ4MfGoksUAU64CHVIkcdVKbL16AUDKlLKc2FLlgYPRih0nIYNvOOnVfkQGRGqshMFTwj0MJ50vUtFT0EGxdRtVYESQysr09g',
      lat: -1.3333,
      lng: 36.7000,
      transitScore: 55,
      tenantScore: 88,
      petsOk: true,
      isHot: false,
      isGreatValue: false,
      insight: 'Spacious family home with a large garden. Quiet neighborhood.',
      type: 'House',
      neighborhood: 'Lang\'ata',
    ),
    PropertyListing(
      id: 'prop_8',
      title: 'KSh 65,000',
      price: 'KSh 65,000/mo',
      address: 'Parklands Rd, Parklands',
      beds: 2,
      baths: 1,
      sqft: 850,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCMf3rMjiYmOe3BKzHg9gLL-zcm8ITtKEhxa10e7Dt_MV8xVbsueKe4bDc2Cfc66QZewLcrLAKl_CM3vIGdf4pJ5wAQI84tIXrvy3MhWwBtoGIw76EodC5BbTlN6dVPKlLLL2b1W4tkCMsvzmBWydh9wBwm-yd5B5XCpDc3A58QTXImEpRph1e3sYaukMYe_yZ5yVxbkAoStpJg3EYOvw25ztVDOTv1JL834TNb5k6Kxn0ZUKiXmVFH5JK0w61XQhlqBplLHaLMxB8',
      lat: -1.2550,
      lng: 36.8100,
      transitScore: 88,
      tenantScore: 82,
      petsOk: false,
      isHot: false,
      type: 'Apartment',
      neighborhood: 'Parklands',
    ),
    PropertyListing(
      id: 'prop_9',
      title: 'KSh 90,000',
      price: 'KSh 90,000/mo',
      address: 'Upper Hill Rd, Upper Hill',
      beds: 2,
      baths: 2,
      sqft: 1200,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&q=80&w=800',
      lat: -1.2950,
      lng: 36.8050,
      transitScore: 95,
      tenantScore: 91,
      petsOk: true,
      isHot: true,
      hasVirtualTour: true,
      type: 'Loft',
      neighborhood: 'Upper Hill',
    ),
    PropertyListing(
      id: 'prop_10',
      title: 'KSh 55,000',
      price: 'KSh 55,000/mo',
      address: 'Moktar Daddah St, CBD',
      beds: 1,
      baths: 1,
      sqft: 750,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&q=80&w=800',
      lat: -1.2833,
      lng: 36.8219,
      transitScore: 82,
      tenantScore: 79,
      petsOk: false,
      isHot: false,
      type: 'Apartment',
      neighborhood: 'CBD',
    ),
    PropertyListing(
      id: 'prop_11',
      title: 'KSh 130,000',
      price: 'KSh 130,000/mo',
      address: 'Lenana Rd, Kilimani',
      beds: 3,
      baths: 2,
      sqft: 1600,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&q=80&w=800',
      lat: -1.2880,
      lng: 36.7850,
      transitScore: 75,
      tenantScore: 88,
      petsOk: true,
      isHot: false,
      type: 'Flat',
      neighborhood: 'Kilimani',
    ),
    PropertyListing(
      id: 'prop_12',
      title: 'KSh 80,000',
      price: 'KSh 80,000/mo',
      address: 'Gitanga Rd, Lavington',
      beds: 2,
      baths: 1,
      sqft: 1050,
      imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&q=80&w=800',
      lat: -1.2730,
      lng: 36.7650,
      transitScore: 89,
      tenantScore: 93,
      petsOk: false,
      isGreatValue: true,
      type: 'Apartment',
      neighborhood: 'Lavington',
    ),
  ];

  static PropertyListing fromId(String id) {
    return sampleProperties.firstWhere(
      (p) => p.id == id,
      orElse: () => sampleProperties[0],
    );
  }

  static List<String> get types => ['All', 'Apartment', 'Condo', 'House', 'Studio', 'Loft', 'Flat'];
  static List<String> get neighborhoods =>
      sampleProperties.map((p) => p.neighborhood).toSet().toList()..sort();
}
