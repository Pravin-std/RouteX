class LocationData {
  static const List<String> countries = [
    'India',
    'United States',
    'United Kingdom',
    'Australia',
    'Canada',
    'Germany',
    'France',
    'Japan',
    'Singapore',
    'United Arab Emirates',
  ];

  static const Map<String, List<String>> statesByCountry = {
    'India': [
      'Andhra Pradesh',
      'Arunachal Pradesh',
      'Assam',
      'Bihar',
      'Chhattisgarh',
      'Goa',
      'Gujarat',
      'Haryana',
      'Himachal Pradesh',
      'Jharkhand',
      'Karnataka',
      'Kerala',
      'Madhya Pradesh',
      'Maharashtra',
      'Manipur',
      'Meghalaya',
      'Mizoram',
      'Nagaland',
      'Odisha',
      'Punjab',
      'Rajasthan',
      'Sikkim',
      'Tamil Nadu',
      'Telangana',
      'Tripura',
      'Uttar Pradesh',
      'Uttarakhand',
      'West Bengal',
      'Andaman and Nicobar Islands',
      'Chandigarh',
      'Dadra and Nagar Haveli and Daman and Diu',
      'Delhi',
      'Jammu and Kashmir',
      'Ladakh',
      'Lakshadweep',
      'Puducherry',
    ],
    'United States': [
      'California',
      'Texas',
      'Florida',
      'New York',
      'Pennsylvania',
      'Illinois',
      'Ohio',
      'Georgia',
      'North Carolina',
      'Michigan',
    ],
    'United Kingdom': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
    'Australia': [
      'New South Wales',
      'Victoria',
      'Queensland',
      'Western Australia',
      'South Australia',
      'Tasmania',
    ],
    'Canada': [
      'Ontario',
      'Quebec',
      'British Columbia',
      'Alberta',
      'Manitoba',
    ],
  };

  static const Map<String, List<String>> citiesByState = {
    'Tamil Nadu': [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Tiruchirappalli',
      'Salem',
      'Tirunelveli',
      'Tiruppur',
      'Vellore',
      'Erode',
      'Thoothukudi',
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Nashik',
      'Aurangabad',
      'Solapur',
      'Amravati',
      'Kolhapur',
      'Navi Mumbai',
    ],
    'Karnataka': [
      'Bengaluru',
      'Mysuru',
      'Hubballi-Dharwad',
      'Mangaluru',
      'Belagavi',
      'Kalaburagi',
      'Davangere',
      'Ballari',
    ],
    'Delhi': ['New Delhi', 'Delhi'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar', 'Jamnagar'],
    'California': ['Los Angeles', 'San Francisco', 'San Diego', 'San Jose', 'Sacramento'],
    'Texas': ['Houston', 'San Antonio', 'Dallas', 'Austin', 'Fort Worth'],
    'New York': ['New York City', 'Buffalo', 'Rochester', 'Yonkers', 'Syracuse'],
    'England': ['London', 'Birmingham', 'Manchester', 'Leeds', 'Liverpool'],
    'Scotland': ['Glasgow', 'Edinburgh', 'Aberdeen', 'Dundee'],
    'New South Wales': ['Sydney', 'Newcastle', 'Central Coast', 'Wollongong'],
    'Victoria': ['Melbourne', 'Geelong', 'Ballarat', 'Bendigo'],
    'Ontario': ['Toronto', 'Ottawa', 'Mississauga', 'Brampton', 'Hamilton'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau'],
  };

  static List<String> getCountries(String query) {
    if (query.isEmpty) return countries;
    return countries
        .where((c) => c.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<String> getStates(String query, String? selectedCountry) {
    List<String> availableStates = [];
    if (selectedCountry != null && statesByCountry.containsKey(selectedCountry)) {
      availableStates = statesByCountry[selectedCountry]!;
    } else {
      availableStates = statesByCountry.values.expand((s) => s).toList().toSet().toList();
    }
    
    if (query.isEmpty) return availableStates;
    return availableStates
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<String> getCities(String query, String? selectedState) {
    List<String> availableCities = [];
    if (selectedState != null && citiesByState.containsKey(selectedState)) {
      availableCities = citiesByState[selectedState]!;
    } else {
      availableCities = citiesByState.values.expand((c) => c).toList().toSet().toList();
    }

    if (query.isEmpty) return availableCities;
    return availableCities
        .where((c) => c.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
