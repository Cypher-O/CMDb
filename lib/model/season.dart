// // import 'episode.dart';
// //
// // class Season {
// //   final int seasonNumber;
// //   final List<Episode> episodes;
// //
// //   Season({
// //     this.seasonNumber,
// //     this.episodes,
// //   });
// //
// //   // factory Season.fromJson(dynamic json) {
// //   //   if (json == null) {
// //   //     return Season();
// //   //   }
// //   //   return Season(
// //   //       seasonNumber: json['season_number'], episodes: json['episode_number']);
// //   // }
// //
// //   factory Season.fromJson(dynamic json) {
// //     if (json == null) {
// //       return Season();
// //     }
// //
// //     List<dynamic> episodeJsonList = json['episodes'];
// //     List<Episode> episodes = episodeJsonList != null ? episodeJsonList.map((episodeJson) => Episode.fromJson(episodeJson)).toList() : [];
// //
// //     return Season(
// //       seasonNumber: json['season_number'],
// //       episodes: episodes,
// //     );
// //   }
// // }
//
//
//
// import 'episode.dart';
//
// class Season {
//   final int seasonNumber;
//   final List<Episode> episodes;
//
//   Season({
//     this.seasonNumber,
//     this.episodes,
//   });
//
// //   factory Season.fromJson(dynamic json) {
// //     if (json == null) {
// //       return Season();
// //     }
// //
// //     List<dynamic> episodeJsonList = json['episodes'];
// //     List<Episode> episodes = episodeJsonList != null
// //         ? episodeJsonList.map((episodeJson) => Episode.fromJson(episodeJson)).toList()
// //         : [];
// //
// //     return Season(
// //       seasonNumber: json['season_number'],
// //       episodes: episodes,
// //     );
// //   }
// // }
//
//   factory Season.fromJson(dynamic json) {
//     if (json == null) {
//       return Season();
//     }
//
//     // List<Episode> episodes = [];
//     // if (json['episodes'] != null && json['episodes'] is List) {
//     //   episodes = (json['episodes'] as List)
//     //       .map((episodeJson) => Episode.fromJson(episodeJson))
//     //       .toList();
//     // }
//     List<Episode> episodes = [];
//     if (json['episodes'] != null && json['episodes'] is List) {
//       episodes = (json['episodes'] as List).map((episodeJson) {
//         int episodeNumber = episodeJson['episode_number'] as int;
//         if (episodeNumber == null && episodeJson['name'] != null) {
//           // Extract episode number from the episode name
//           String episodeName = episodeJson['name'] as String;
//           RegExp regex = RegExp(r'Episode (\d+)');
//           Match match = regex.firstMatch(episodeName);
//           if (match != null) {
//             episodeNumber = int.tryParse(match.group(1) ?? '');
//           }
//         }
//
//         return Episode(
//           episodeNumber: episodeNumber,
//           name: episodeJson['name'] as String,
//         );
//       }).toList();
//     }
//     return Season(
//       seasonNumber: json['season_number'],
//       episodes: episodes,
//     );
//   }
// }



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
