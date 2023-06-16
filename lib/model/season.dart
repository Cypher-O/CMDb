class Season {
  final int id;
  final int seasonNumber;
  final String name;
  final String overview;
  final DateTime airDate;

  Season({
    this.id,
    this.seasonNumber,
    this.name,
    this.overview,
    this.airDate,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      seasonNumber: json['season_number'],
      name: json['name'],
      overview: json['overview'],
      airDate: json['air_date'] != null ? DateTime.parse(json['air_date']) : null,
      // airDate: DateTime.parse(json['air_date']),
    );
  }
}
