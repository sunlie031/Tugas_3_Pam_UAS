class UserProfile {
  String name;
  String email;

  UserProfile({required this.name, required this.email});

  factory UserProfile.fromPrefs(Map<String, String> data) {
    return UserProfile(
      name: data['name'] ?? 'Nama Belum Disetel',
      email: data['email'] ?? 'Email Belum Disetel',
    );
  }

  Map<String, String> toPrefs() {
    return {'name': name, 'email': email};
  }
}
