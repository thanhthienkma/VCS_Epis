class Country {
  final String name;

//  final String isoCode;
//  final String iso3Code;
  final String countryCode;
  final String flag;

  Country(
      {
//    this.isoCode,
//    this.iso3Code,
      this.countryCode,
      this.name,
      this.flag});

  factory Country.fromMap(Map<String, String> map) => Country(
      name: map['name'],
//      isoCode: map['isoCode'],
//      iso3Code: map['iso3Code'],
      countryCode: map['phoneCode'],
      flag: map['flag']);

  /// Init data
  List<Country> getCountries() {
    List<Country> _list = List();
    _list.add(Country(
        name: 'Việt Nam', countryCode: '+84', flag: 'assets/images/vn.png'));
    _list.add(Country(
        name: 'Australia', countryCode: '+61', flag: 'assets/images/au.png'));
    return _list;
  }
}
