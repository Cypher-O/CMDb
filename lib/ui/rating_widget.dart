import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final String voteAverage;
  // final double voteAverage;
  final double starSize;
  final Color starColor;
  final Color emptyStarColor;

  RatingWidget({
    this.voteAverage,
    this.starSize,
    this.starColor,
    this.emptyStarColor,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the fill percentage
    // double fillPercentage = voteAverage / 10.0;
    double fillPercentage = double.parse(voteAverage) / 10.0;
    // Calculate the number of filled stars
    int filledStarCount = (fillPercentage * 5).floor();

    // Calculate the fill percentage of the last star
    double lastStarFillPercentage = (fillPercentage * 5) - filledStarCount.toDouble();

    return Row(
      children: List.generate(5, (index) {
        // Determine the star icon based on the fill percentage
        IconData starIcon;
        Color starFillColor = starColor;
        Color starBorderColor = Colors.white;
        if (index < filledStarCount) {
          // Full star
          starIcon = Icons.star;
        } else if (index == filledStarCount && lastStarFillPercentage >= 0.3) {
          // Partially filled star
          starIcon = Icons.star_half;
        } else {
          // Empty star
          starIcon = Icons.star_border;
          starFillColor = emptyStarColor;
        }

        return Icon(
          starIcon,
          size: starSize,
          color: starFillColor,
        );
      }),
    );
  }
}