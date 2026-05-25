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
  final String insight;

  const PropertyListing({
    required this.id,
    required this.title,
    required this.price,
    required this.address,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.imageUrl,
    this.transitScore = 0,
    this.tenantScore = 0,
    this.petsOk = false,
    this.isHot = false,
    this.isGreatValue = false,
    this.insight = '',
  });

  static const List<PropertyListing> sampleProperties = [
    PropertyListing(
      id: 'prop_1',
      title: '\$3,200',
      price: '\$3,200/mo',
      address: '1000 Skyline Ave, Apt 4B, Downtown',
      beds: 2,
      baths: 2,
      sqft: 1150,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeb5yN2VQ5joyMLB8Grc9Fz8c6XPssf20Kene7XpZlCIdFFp6JbRZqZAie3eSIhakb_I3oHbsitSi-BrHrAG1QZJH1JYCV-ErazcQ86ZYP8dCo_43XX3_fr2d7zpHHKNbEjRoHYf7QnPgMiIkHYQQIdph9Fe3gwmQZUVUHX1SIeNwBnM_VLDx0AeCme9wj-CgSvZxhtxmPfjeaS8P4aom7JUxC1gT0Vj2s_r1eLoEw3ganRlmk2JMDZdIAtyFltMPGHsNsSWSRKhE',
      transitScore: 98,
      tenantScore: 94,
      petsOk: true,
      isHot: true,
      insight: 'Priced 4% below similar units in this building. 12 min transit to your office.',
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
      transitScore: 85,
      tenantScore: 85,
      petsOk: false,
      isHot: false,
      insight: '',
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
      transitScore: 92,
      tenantScore: 92,
      petsOk: false,
      isHot: false,
      isGreatValue: true,
      insight: '',
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
      transitScore: 78,
      tenantScore: 78,
      petsOk: false,
      isHot: false,
      insight: '',
    ),
  ];
}
