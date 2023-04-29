import 'package:equatable/equatable.dart';

class Screenshot extends Equatable {
  final String aspect;
  final String imagePath;
  final int height;
  final int width;
  final String countryCode;
  final double voteAverage;
  final int voteCount;
  final Map<String, dynamic> data;

  const Screenshot(
      {this.aspect,
        this.imagePath,
        this.height,
        this.width,
        this.countryCode,
        this.voteAverage,
        this.voteCount,
        this.data});

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return const Screenshot();
    }

    return Screenshot(
        aspect: json['aspect_ratio']
            .toString(), //double.tryParse(json['aspect_ratio'])?.toString() ?? 1.0,
        imagePath: json['file_path'],
        height: json['height'],
        width: json['width'],
        countryCode: json['iso_639_1'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count']);
  }

  @override
  List<Object> get props =>
      [data, aspect, imagePath, height, width, countryCode, voteAverage, voteCount];
}
