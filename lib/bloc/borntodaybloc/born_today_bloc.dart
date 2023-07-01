import 'dart:async';

import 'package:CMDb/bloc/borntodaybloc/born_today_event.dart';
import 'package:CMDb/bloc/borntodaybloc/born_today_state.dart';
import 'package:CMDb/model/born_today.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class BornTodayBloc extends Bloc<BornTodayEvent, BornTodayState> {
//   BornTodayBloc() : super(BornTodayLoading());
//
//   @override
//   Stream<BornTodayState> mapEventToState(BornTodayEvent event) async* {
//     if (event is BornTodayEventStarted) {
//       yield* _mapBornTodayEventStartedToState();
//     }
//   }
//
//   Stream<BornTodayState> _mapBornTodayEventStartedToState() async* {
//     final apiRepository = ApiService();
//     final int pageSize = 20; // Number of items to fetch per page
//     final int totalPageLimit = 500; // Maximum number of pages to fetch
//
//     List<BornToday> bornToday = [];
//
//     try {
//       for (int page = 1; page <= totalPageLimit; page++) {
//         final List<BornToday> pageResults =
//         await apiRepository.getBornToday(
//           page: page,
//           pageSize: pageSize,
//           totalPageLimit: totalPageLimit,
//         );
//
//         bornToday.addAll(pageResults);
//
//         yield BornTodayLoaded(List.from(bornToday)); // Emit current data
//
//         if (pageResults.length < pageSize || page >= totalPageLimit) {
//           break; // Break the loop if the last page is reached or the total page limit is exceeded
//         }
//       }
//     } catch (_) {
//       yield BornTodayError();
//     }
//   }
// }



class BornTodayBloc extends Bloc<BornTodayEvent, BornTodayState> {
  BornTodayBloc() : super(BornTodayLoading());

  @override
  Stream<BornTodayState> mapEventToState(BornTodayEvent event) async* {
    if (event is BornTodayEventStarted) {
      yield* _mapBornTodayEventStartedToState();
    }
  }

  Stream<BornTodayState> _mapBornTodayEventStartedToState() async* {
    final apiRepository = ApiService();
    final int pageSize = 20; // Number of items to fetch per page
    final int totalPageLimit = 100; // Maximum number of pages to fetch

    List<BornToday> bornToday = [];

    try {
      for (int page = 1; page <= totalPageLimit; page++) {
        final List<BornToday> pageResults = await apiRepository.getBornToday(
          page: page,
          pageSize: pageSize,
          totalPageLimit: totalPageLimit,
        );

      // for (final item in pageResults) {
      //     bornToday.add(item);
      //     print('Item added: $item');
      //     yield BornTodayLoaded(List.from(bornToday)); // Emit the updated list with the new item
      //   }
        for (final birthday in pageResults) {
          bornToday.add(birthday); // Update the bornToday list by appending the new item
          print('Birthday added: $birthday'); // Print the added item
          yield BornTodayLoaded(List.from(bornToday)); // Emit the updated list
          await Future.delayed(Duration(milliseconds: 100)); // Add a small delay
        }


        if (pageResults.length < pageSize || page >= totalPageLimit) {
          break; // Break the loop if the last page is reached or the total page limit is exceeded
        }
      }
    } catch (_) {
      yield BornTodayError();
    }
  }
}
