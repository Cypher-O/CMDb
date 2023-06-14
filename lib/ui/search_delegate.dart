import 'package:CMDb/service/api_service.dart';
import 'package:flutter/material.dart';

class MovieSearchDelegate {
  bool searchVisible = false;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final ApiService apiService = ApiService();
  List<dynamic> searchResults = [];
  bool showRecentSearches = false;

  MovieSearchDelegate._privateConstructor();

  static final MovieSearchDelegate _instance = MovieSearchDelegate._privateConstructor();

  factory MovieSearchDelegate() {
    return _instance;
  }

  void initState() {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
  }

  void updateSearchResults(String query) {
    if (query.isNotEmpty) {
      apiService.returnSearchResults(query).then((movies) {
        searchResults = movies;
      });
    } else {
      searchResults = [];
    }
  }
}
