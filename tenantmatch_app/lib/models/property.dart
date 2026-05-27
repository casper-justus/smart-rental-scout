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
      title: '\$3,200',
      price: '\$3,200/mo',
      address: '1000 Skyline Ave, Apt 4B',
      beds: 2,
      baths: 2,
      sqft: 1150,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeb5yN2VQ5joyMLB8Grc9Fz8c6XPssf20Kene7XpZlCIdFFp6JbRZqZAie3eSIhakb_I3oHbsitSi-BrHrAG1QZJH1JYCV-ErazcQ86ZYP8dCo_43XX3_fr2d7zpHHKNbEjRoHYf7QnPgMiIkHYQQIdph9Fe3gwmQZUVUHX1SIeNwBnM_VLDx0AeCme9wj-CgSvZxhtxmPfjeaS8P4aom7JUxC1gT0Vj2s_r1eLoEw3ganRlmk2JMDZdIAtyFltMPGHsNsSWSRKhE',
      lat: 37.7749,
      lng: -122.4194,
      transitScore: 98,
      tenantScore: 94,
      petsOk: true,
      isHot: true,
      hasVirtualTour: true,
      insight: 'Priced 4% below similar units in this building. 12 min transit to your office.',
      type: 'Apartment',
      neighborhood: 'Downtown',
    ),
    PropertyListing(
      id: 'prop_2',
      title: '\$2,850',
      price: '\$2,850/mo',
      address: '1024 Market St, Apt 4B',
      beds: 2,
      baths: 2,
      sqft: 950,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCMf3rMjiYmOe3BKzHg9gLL-zcm8ITtKEhxa10e7Dt_MV8xVbsueKe4bDc2Cfc66QZewLcrLAKl_CM3vIGdf4pJ5wAQI84tIXrvy3MhWwBtoGIw76EodC5BbTlN6dVPKlLLL2b1W4tkCMsvzmBWydh9wBwm-yd5B5XCpDc3A58QTXImEpRph1e3sYaukMYe_yZ5yVxbkAoStpJg3EYOvw25ztVDOTv1JL834TNb5k6Kxn0ZUKiXmVFH5JK0w61XQhlqBplLHaLMxB8',
      lat: 37.7789,
      lng: -122.4233,
      transitScore: 85,
      tenantScore: 85,
      petsOk: false,
      isHot: false,
      type: 'Apartment',
      neighborhood: 'SoMa',
    ),
    PropertyListing(
      id: 'prop_3',
      title: '\$3,200',
      price: '\$3,200/mo',
      address: '450 Downtown Ave, #1201',
      beds: 2,
      baths: 2,
      sqft: 1100,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBEIKK2eJOjVIlBd1_7IM-oologEB8AvMQ-i_M5UqhMCWKs-1_6v5J5M4zcsKgWFAuman3XTweOxQfAIM9ji1NuH5NYO6VmVOPuEh4Wpv1NyJWFJXlLaEvGc6Y95nhFgF93uUzRUL8FTp5aqu2f0dO8_2mWsuQRgZJLN-eQyhQpP3JZ4MfGoksUAU64CHVIkcdVKbL16AUDKlLKc2FLlgYPRih0nIYNvOOnVfkQGRGqshMFTwj0MJ50vUtFT0EGxdRtVYESQysr09g',
      lat: 37.7715,
      lng: -122.4128,
      transitScore: 92,
      tenantScore: 92,
      petsOk: false,
      isHot: false,
      isGreatValue: true,
      type: 'Apartment',
      neighborhood: 'Downtown',
    ),
    PropertyListing(
      id: 'prop_4',
      title: '\$2,100',
      price: '\$2,100/mo',
      address: '555 Pine St, Studio 7',
      beds: 1,
      baths: 1,
      sqft: 650,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAav82gLIpA33LU01h-XC-Q3Lhg6N4zuBov8ZSDAJtII8mJfzKsqW6n8siZ1A8Mx7JIOORGCUEupz5cgU6w72liqzTOWfcTrN0mZYjWtIO5ae66f8-Y0f2sczOdFcdNtR0foc-PGiNw-jrvAqX8TdLhU3hRXvfJ07lGsOFpKaBu7tOT-m0gZKmexK3nzon7Tq3oSHyBEnR8QicxZD0wdr4MJitCsLXNXAmvaR39UnurWv_5sderlCeK0HSsPC0onyBlmLle1ysktPg',
      lat: 37.7729,
      lng: -122.4099,
      transitScore: 78,
      tenantScore: 78,
      petsOk: false,
      isHot: false,
      type: 'Studio',
      neighborhood: 'Nob Hill',
    ),
    PropertyListing(
      id: 'prop_5',
      title: '\$4,100',
      price: '\$4,100/mo',
      address: '200 Spear St, #2204',
      beds: 3,
      baths: 2,
      sqft: 1450,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeb5yN2VQ5joyMLB8Grc9Fz8c6XPssf20Kene7XpZlCIdFFp6JbRZqZAie3eSIhakb_I3oHbsitSi-BrHrAG1QZJH1JYCV-ErazcQ86ZYP8dCo_43XX3_fr2d7zpHHKNbEjRoHYf7QnPgMiIkHYQQIdph9Fe3gwmQZUVUHX1SIeNwBnM_VLDx0AeCme9wj-CgSvZxhtxmPfjeaS8P4aom7JUxC1gT0Vj2s_r1eLoEw3ganRlmk2JMDZdIAtyFltMPGHsNsSWSRKhE',
      lat: 37.7896,
      lng: -122.3907,
      transitScore: 90,
      tenantScore: 96,
      petsOk: true,
      isHot: true,
      hasVirtualTour: true,
      insight: 'Premium waterfront living. Top-rated schools within 1 mile.',
      type: 'Condo',
      neighborhood: 'Embarcadero',
    ),
    PropertyListing(
      id: 'prop_6',
      title: '\$1,800',
      price: '\$1,800/mo',
      address: '789 Valencia St, #3',
      beds: 1,
      baths: 1,
      sqft: 550,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAav82gLIpA33LU01h-XC-Q3Lhg6N4zuBov8ZSDAJtII8mJfzKsqW6n8siZ1A8Mx7JIOORGCUEupz5cgU6w72liqzTOWfcTrN0mZYjWtIO5ae66f8-Y0f2sczOdFcdNtR0foc-PGiNw-jrvAqX8TdLhU3hRXvfJ07lGsOFpKaBu7tOT-m0gZKmexK3nzon7Tq3oSHyBEnR8QicxZD0wdr4MJitCsLXNXAmvaR39UnurWv_5sderlCeK0HSsPC0onyBlmLle1ysktPg',
      lat: 37.7645,
      lng: -122.4215,
      transitScore: 72,
      tenantScore: 70,
      petsOk: false,
      isHot: false,
      isGreatValue: true,
      type: 'Apartment',
      neighborhood: 'Mission',
    ),
    PropertyListing(
      id: 'prop_7',
      title: '\$5,200',
      price: '\$5,200/mo',
      address: '1 St Francis Wood Dr',
      beds: 4,
      baths: 3,
      sqft: 2200,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBEIKK2eJOjVIlBd1_7IM-oologEB8AvMQ-i_M5UqhMCWKs-1_6v5J5M4zcsKgWFAuman3XTweOxQfAIM9ji1NuH5NYO6VmVOPuEh4Wpv1NyJWFJXlLaEvGc6Y95nhFgF93uUzRUL8FTp5aqu2f0dO8_2mWsuQRgZJLN-eQyhQpP3JZ4MfGoksUAU64CHVIkcdVKbL16AUDKlLKc2FLlgYPRih0nIYNvOOnVfkQGRGqshMFTwj0MJ50vUtFT0EGxdRtVYESQysr09g',
      lat: 37.7354,
      lng: -122.4550,
      transitScore: 55,
      tenantScore: 88,
      petsOk: true,
      isHot: false,
      isGreatValue: false,
      insight: 'Spacious family home with a large backyard. Quiet neighborhood.',
      type: 'House',
      neighborhood: 'St Francis Wood',
    ),
    PropertyListing(
      id: 'prop_8',
      title: '\$2,600',
      price: '\$2,600/mo',
      address: '1888 Market St, #305',
      beds: 2,
      baths: 1,
      sqft: 850,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCMf3rMjiYmOe3BKzHg9gLL-zcm8ITtKEhxa10e7Dt_MV8xVbsueKe4bDc2Cfc66QZewLcrLAKl_CM3vIGdf4pJ5wAQI84tIXrvy3MhWwBtoGIw76EodC5BbTlN6dVPKlLLL2b1W4tkCMsvzmBWydh9wBwm-yd5B5XCpDc3A58QTXImEpRph1e3sYaukMYe_yZ5yVxbkAoStpJg3EYOvw25ztVDOTv1JL834TNb5k6Kxn0ZUKiXmVFH5JK0w61XQhlqBplLHaLMxB8',
      lat: 37.7710,
      lng: -122.4282,
      transitScore: 88,
      tenantScore: 82,
      petsOk: false,
      isHot: false,
      type: 'Apartment',
      neighborhood: 'Castro',
    ),
    PropertyListing(
      id: 'prop_9',
      title: '\$3,500',
      price: '\$3,500/mo',
      address: '888 Brannan St, #501',
      beds: 2,
      baths: 2,
      sqft: 1200,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&q=80&w=800',
      lat: 37.7712,
      lng: -122.4035,
      transitScore: 95,
      tenantScore: 91,
      petsOk: true,
      isHot: true,
      hasVirtualTour: true,
      type: 'Loft',
      neighborhood: 'SoMa',
    ),
    PropertyListing(
      id: 'prop_10',
      title: '\$2,450',
      price: '\$2,450/mo',
      address: '420 Taylor St, Apt 2',
      beds: 1,
      baths: 1,
      sqft: 750,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&q=80&w=800',
      lat: 37.7865,
      lng: -122.4112,
      transitScore: 82,
      tenantScore: 79,
      petsOk: false,
      isHot: false,
      type: 'Apartment',
      neighborhood: 'Tenderloin',
    ),
    PropertyListing(
      id: 'prop_11',
      title: '\$4,800',
      price: '\$4,800/mo',
      address: '1500 Haight St',
      beds: 3,
      baths: 2,
      sqft: 1600,
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&q=80&w=800',
      lat: 37.7695,
      lng: -122.4485,
      transitScore: 75,
      tenantScore: 88,
      petsOk: true,
      isHot: false,
      type: 'Flat',
      neighborhood: 'Haight-Ashbury',
    ),
    PropertyListing(
      id: 'prop_12',
      title: '\$3,100',
      price: '\$3,100/mo',
      address: '1201 Greenwich St',
      beds: 2,
      baths: 1,
      sqft: 1050,
      imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&q=80&w=800',
      lat: 37.8015,
      lng: -122.4195,
      transitScore: 89,
      tenantScore: 93,
      petsOk: false,
      isGreatValue: true,
      type: 'Apartment',
      neighborhood: 'Russian Hill',
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
