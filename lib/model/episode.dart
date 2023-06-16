class Episode {
  final int id;
  final int episodeNumber;
  final String name;
  final String overview;
  final DateTime airDate;
  final String stillPath; // Episode image
  final double voteAverage; // Vote average
  final int runtime; // Runtime in minutes


  Episode({
    this.id,
    this.episodeNumber,
    this.name,
    this.overview,
    this.airDate,
    this.stillPath, this.voteAverage, this.runtime,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      episodeNumber: json['episode_number'],
      name: json['name'],
      overview: json['overview'],
      airDate: DateTime.parse(json['air_date']),
      stillPath: json['still_path'], // Episode image
      voteAverage: json['vote_average'].toDouble(), // Vote average
      runtime: json['runtime'], // Runtime in minutes
    );
  }
}