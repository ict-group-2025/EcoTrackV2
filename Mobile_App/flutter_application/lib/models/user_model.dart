class User {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? token;
  final String? role;
  final int? avatarId;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.token,
    this.role,
    this.avatarId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      role: json['role'],
      avatarId: json['avatarId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      if (token != null) 'token': token,
      if (role != null) 'role': role,
      if (avatarId != null) 'avatarId': avatarId,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    String? token,
    String? role,
    int? avatarId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      token: token ?? this.token,
      role: role ?? this.role,
      avatarId: avatarId ?? this.avatarId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.username == username &&
        other.fullName == fullName &&
        other.email == email &&
        other.token == token &&
        other.role == role &&
        other.avatarId == avatarId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        token.hashCode ^
        role.hashCode ^
        avatarId.hashCode;
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String username;
  final String fullName;
  final String email;
  final String password;

  RegisterRequest({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }
}

class AuthResponse {
  final bool success;
  final String? message;
  final User? user;

  AuthResponse({
    required this.success,
    this.message,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print('AuthResponse.fromJson input: $json');
    final success = json['success'] ?? false;
    final message = json['message'];
    final user = json['user'] != null ? User.fromJson(json['user']) : null;
    
    print('AuthResponse parsed - success: $success, message: $message, user: $user');
    
    return AuthResponse(
      success: success,
      message: message,
      user: user,
    );
  }
}
