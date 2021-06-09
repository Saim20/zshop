import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFloationgSearchBar extends StatefulWidget {
  const MyFloationgSearchBar({Key? key}) : super(key: key);

  @override
  _MyFloationgSearchBarState createState() => _MyFloationgSearchBarState();
}

class _MyFloationgSearchBarState extends State<MyFloationgSearchBar> {
  static const int historyLength = 5;
  static List<String> searchHistory = [];
  static List<String> filteredSearchHistory = [];

  static FloatingSearchBarController? controller;

  List<String> filterSearchTerms({
    required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if(term == ''){
      return;
    }
    if (searchHistory.contains(term)) {
      putSearchTermFirst(term);
      saveSearchHistory();
      return;
    }
    searchHistory.add(term);
    if (searchHistory.length > historyLength) {
      searchHistory.removeRange(0, searchHistory.length - historyLength);
    }
    // Update filter for changes to history
    filteredSearchHistory = filterSearchTerms(filter: null);
    saveSearchHistory();
  }

  void deleteSearchTerm(String term) {
    searchHistory.removeWhere((t) => t == term);
    // Update filter for changes to history
    filteredSearchHistory = filterSearchTerms(filter: null);
    saveSearchHistory();
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  void saveSearchHistory() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', searchHistory);
  }

  void retrieveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('searchHistory')!;
    setState(() {
      filteredSearchHistory = filterSearchTerms(filter: null);
    });
  }

  @override
  void initState() {
    controller = FloatingSearchBarController();
    if(searchHistory.isEmpty){
      setState(() {
        retrieveSearchHistory();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      key: key,
      hint: 'Search...',
      onSubmitted: (value) {
        setState(() {
          key.currentState!.deactivate();
          search(value);
        });
      },
      controller: controller,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredSearchHistory.map((term) {
                return ListTile(
                  onTap: (){
                    setState(() {
                      search(term);
                    });
                  },
                  leading: Icon(Icons.history),
                  title: Text(term),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        deleteSearchTerm(term);
                      });
                    },
                    icon: Icon(Icons.highlight_remove),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void search(String value){
    addSearchTerm(value);
    controller!.clear();
    Navigator.pushNamed(context, '/search',arguments: {
      'term' : value,
    });
  }
}
