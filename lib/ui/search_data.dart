import 'package:flutter/material.dart';
import 'package:layoutoodles/models/users.dart';


class SearchData extends SearchDelegate<String> {
  final List<Users> userList;

  SearchData(this.userList);

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //show some result  based on the selection
    return Container(
      //returning a blank container

);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searching for something
    final suggestionList = query.isEmpty
        ? userList
        : userList
            .where((element) =>
                element.name.toLowerCase().startsWith(query.toLowerCase()))  //matching query with list item
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              showResults(context);
            },
            leading: Icon(Icons.person),
            title: RichText(
              text: TextSpan(    //adding highlighting effect when user types search query
                  text: suggestionList[index].name.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text:
                            suggestionList[index].name.substring(query.length),
                        style: TextStyle(color: Colors.grey)),
                  ]),
            ),
          );
        });
  }
}
