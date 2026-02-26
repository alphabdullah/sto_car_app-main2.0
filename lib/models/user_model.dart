/// User role enumeration
enum UserRole {
  guest,
  user,
  admin,
}

/// Convert string role to UserRole enum
UserRole roleFromString(String role) {
  switch (role.toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'user':
      return UserRole.user;
    default:
      return UserRole.guest;
  }
}

/// Convert UserRole enum to string
String roleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.user:
      return 'user';
    case UserRole.guest:
      return 'guest';
  }
}

/// Parse role from user data - handles roles array, single role string, or enum
UserRole _parseRole(Map<String, dynamic> userData) {
  // Handle roles array (API format: "roles": ["user"] or "roles": ["admin"])
  if (userData['roles'] != null) {
    final roles = userData['roles'];
    if (roles is List && roles.isNotEmpty) {
      final firstRole = roles[0].toString();
      print('UserModel: Parsing role from roles array: $firstRole');
      return roleFromString(firstRole);
    }
  }
  
  // Handle single role string (legacy format: "role": "user")
  if (userData['role'] != null) {
    final roleStr = userData['role'].toString();
    print('UserModel: Parsing role from single role field: $roleStr');
    return roleFromString(roleStr);
  }
  
  // Default to user if no role found
  print('UserModel: No role found in userData, defaulting to UserRole.user');
  return UserRole.user;
}

/// User model representing user state
class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool isVerified;
  final DateTime? createdAt;
  final String? token;
  final String? phone;
  final String? profileImage;
  final String? address;
  final String? city;
  final String? country;
  final Map<String, dynamic>? wallet; // Wallet data from API
  final String? registrationImageFront;
  final String? registrationImageBack;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.isVerified = false,
    this.createdAt,
    this.token,
    this.phone,
    this.profileImage,
    this.address,
    this.city,
    this.country,
    this.wallet,
    this.registrationImageFront,
    this.registrationImageBack,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    bool? isVerified,
    DateTime? createdAt,
    String? token,
    String? phone,
    String? profileImage,
    String? address,
    String? city,
    String? country,
    Map<String, dynamic>? wallet,
    String? registrationImageFront,
    String? registrationImageBack,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      wallet: wallet ?? this.wallet,
      registrationImageFront: registrationImageFront ?? this.registrationImageFront,
      registrationImageBack: registrationImageBack ?? this.registrationImageBack,
    );
  }

  /// Create UserModel from JSON (API response)
  /// 
  /// Expects ONLY the user object, not nested in data/user
  /// Handles both snake_case (API) and camelCase (storage) formats
  /// Does NOT parse token (handled separately)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user object if present (defensive)
    final userData = json['user'] as Map<String, dynamic>? ?? json;
    
    return UserModel(
      // Required fields - handle both snake_case and camelCase
      id: (userData['id']?.toString() ?? '').trim(),
      email: (userData['email']?.toString() ?? '').trim(),
      name: (userData['name']?.toString() ?? '').trim(),
      
      // Role - handle roles array (API format), single role string, or enum
      role: _parseRole(userData),
      
      // Verification status - handle multiple formats
      isVerified: userData['is_verified'] == true ||
          userData['isVerified'] == true ||
          userData['verified'] == true,
      
      // Created date - handle both snake_case and camelCase
      createdAt: userData['created_at'] != null
          ? DateTime.tryParse(userData['created_at'].toString())
          : userData['createdAt'] != null
              ? DateTime.tryParse(userData['createdAt'].toString())
              : null,
      
      // Token is NOT parsed here - it's handled separately in AuthState
      // token: null, // Explicitly not parsing token
      
      // Optional fields - handle both snake_case and camelCase
      phone: userData['phone']?.toString(),
      profileImage: userData['profile_image']?.toString() ?? 
                   userData['profileImage']?.toString(),
    registrationImageFront: userData['registration_image_1']?.toString() ??
        userData['registrationImage1']?.toString(),
    registrationImageBack: userData['registration_image_2']?.toString() ??
        userData['registrationImage2']?.toString(),
      address: userData['address']?.toString(),
      city: userData['city']?.toString(),
      country: userData['country']?.toString(),
      
      // Wallet - handle nested object
      wallet: userData['wallet'] != null 
          ? (userData['wallet'] is Map<String, dynamic>
              ? userData['wallet'] as Map<String, dynamic>
              : null)
          : null,
    );
  }

  /// Convert UserModel to JSON (for storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': roleToString(role),
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      'phone': phone,
      'profile_image': profileImage,
      'address': address,
      'city': city,
      'country': country,
      'wallet': wallet,
      'registration_image_1': registrationImageFront,
      'registration_image_2': registrationImageBack,
      // Note: token is stored separately in storage
    };
  }
}

