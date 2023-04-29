import 'package:equatable/equatable.dart';
import 'package:CMDb/model/screen_shot.dart';

class TvShowImage extends Equatable {
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  const TvShowImage({this.backdrops, this.posters});

  factory TvShowImage.fromJson(Map<String, dynamic> result) {
    if (result == null) {
      return TvShowImage();
    }

    return TvShowImage(
      backdrops: (result['backdrops'] as List)
          ?.map((b) => Screenshot.fromJson(b))
          ?.toList() ??
          List.empty(),
      posters: (result['posters'] as List)
          ?.map((b) => Screenshot.fromJson(b))
          ?.toList() ??
          List.empty(),
    );
  }

  @override
  List<Object> get props => [backdrops, posters];
}
