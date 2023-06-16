import 'package:CMDb/ui/search_delegate.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSearchTextChanged;
  final VoidCallback onClearButtonPressed;
  final VoidCallback onBackButtonPressed;
  final Function(String) updateSearchResults;

  const SearchBar({
    Key key,
    this.onSearchTextChanged,
    this.onClearButtonPressed,
    this.onBackButtonPressed, this.updateSearchResults,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final MovieSearchDelegate searchDelegate = MovieSearchDelegate();

  void setState(VoidCallback callback) {
    // ...

    if (searchDelegate.searchController.text.isNotEmpty) {
      searchDelegate.showRecentSearches = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSearchResults);
  }

  void _updateSearchResults() {
    final searchText = _searchController.text;
    widget.updateSearchResults?.call(searchText);
    searchDelegate.updateSearchResults(searchText);
    widget.onSearchTextChanged?.call(searchText);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // searchDelegate.searchController = _searchController;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (text) {
          setState(() {
            _updateSearchResults();
          });
          widget.onSearchTextChanged?.call(text);
        },
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15.0),
          ),
          prefixIcon: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: widget.onBackButtonPressed,
          ),
          hintText: 'Search...',
          suffixIcon: ClipOval(
            child: IconButton(
              iconSize: 18,
              icon: Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                widget.onClearButtonPressed();
              },
            ),
          ),
        ),
      ),
    );
  }
}
