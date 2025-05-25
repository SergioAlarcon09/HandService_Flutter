class AuthUser {
  final String? id;
  final String name;
  final String email;
  final String? password;
  final String? role;
  final String? token; // Asegúrate de tener este campo

  AuthUser({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.role,
    this.token,
  });

  // Método copyWith añadido
  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? token,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'token': token,
    };
  }
}
