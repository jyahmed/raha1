class User {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profileImage;
  final List<Address> addresses;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profileImage,
    this.addresses = const [],
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((address) => Address.fromJson(address))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      isActive: json['isActive'] ?? true,
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
      'preferences': preferences.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? profileImage,
    List<Address>? addresses,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }
}

class Address {
  final String id;
  final String title;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final bool isDefault;
  final AddressType type;

  Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.landmark,
    this.isDefault = false,
    this.type = AddressType.other,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      title: json['title'],
      fullAddress: json['fullAddress'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      buildingNumber: json['buildingNumber'],
      floor: json['floor'],
      apartment: json['apartment'],
      landmark: json['landmark'],
      isDefault: json['isDefault'] ?? false,
      type: AddressType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => AddressType.other,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'buildingNumber': buildingNumber,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'isDefault': isDefault,
      'type': type.name,
    };
  }
}

enum AddressType {
  home,
  work,
  other,
}

class UserPreferences {
  final String language;
  final bool notificationsEnabled;
  final bool locationEnabled;
  final String theme;
  final bool soundEnabled;
  final bool vibrationEnabled;

  UserPreferences({
    this.language = 'ar',
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    this.theme = 'light',
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'ar',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      locationEnabled: json['locationEnabled'] ?? true,
      theme: json['theme'] ?? 'light',
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'locationEnabled': locationEnabled,
      'theme': theme,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
    };
  }

  UserPreferences copyWith({
    String? language,
    bool? notificationsEnabled,
    bool? locationEnabled,
    String? theme,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      theme: theme ?? this.theme,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

