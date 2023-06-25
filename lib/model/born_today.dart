class BornToday {
  final int id;
  final String name;
  final String knownFor;
  final String profilePath;
  final DateTime birthday;
  final int age;

  BornToday({
    this.id,
    this.name,
    this.knownFor,
    this.profilePath,
    this.birthday,
    this.age,
  });

  factory BornToday.fromJson(Map<String, dynamic> json) {
    final birthday = DateTime.parse(json['birthday']);
    final now = DateTime.now();
    final age = now.year - birthday.year;

    return BornToday(
      id: json['id'],
      name: json['name'],
      knownFor: json['known_for'],
      profilePath: json['profile_path'],
      birthday: birthday,
      age: age,
    );
  }
}
