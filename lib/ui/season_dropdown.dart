import 'package:flutter/material.dart';
import 'package:CMDb/model/season.dart';

class SeasonDropdown extends StatelessWidget {
  final List<Season> seasons;
  final Season selectedSeason;
  final ValueChanged<Season> onChanged;
  final int showId;

  SeasonDropdown({
    this.seasons,
    this.selectedSeason,
    this.onChanged, this.showId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: DropdownButtonFormField<Season>(
        value: selectedSeason,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(10),),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        items: seasons
            .where((season) => season.seasonNumber != 0)
            .map<DropdownMenuItem<Season>>((season) {
          return DropdownMenuItem<Season>(
            value: season,
            child: Text(
              'Season ${season.seasonNumber}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}