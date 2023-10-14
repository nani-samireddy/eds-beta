class AddressModel {
  final String title;
  final String fullName;
  final String phone;
  final String address;
  final String landMark;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final bool isDefault;
  AddressModel({
    required this.title,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.landMark,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.isDefault,
    this.country = "India",
  });

  AddressModel copyWith({
    String? title,
    String? fullName,
    String? phone,
    String? address,
    String? landMark,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    bool? isDefault,
  }) {
    return AddressModel(
      title: title ?? this.title,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      landMark: landMark ?? this.landMark,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'landMark': landMark,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      title: map['title'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      landMark: map['landMark'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      zipCode: map['zipCode'] as String,
      isDefault: map['isDefault'] as bool,
    );
  }

  @override
  String toString() {
    return 'AddressModel(title: $title, firstName: $fullName, phone: $phone, address: $address,landMark: $landMark , city: $city, state: $state, country: $country, zipCode: $zipCode, isDefault: $isDefault)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.address == address &&
        other.landMark == landMark &&
        other.city == city &&
        other.state == state &&
        other.country == country &&
        other.zipCode == zipCode &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        landMark.hashCode ^
        city.hashCode ^
        state.hashCode ^
        country.hashCode ^
        zipCode.hashCode ^
        isDefault.hashCode;
  }
}
