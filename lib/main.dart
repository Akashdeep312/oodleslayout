import 'package:flutter/material.dart';
import 'package:layoutoodles/models/users.dart';
import 'package:layoutoodles/service/userservice.dart';
import 'package:layoutoodles/ui/search_data.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Users> data;
  bool fetchingData = true;
  bool errorOuccered = false;
  var errorMsg = "";

  @override
  void initState() {
    super.initState();
    _getUser();
  }


  //funtion which handles the request completion or error
  void _getUser() {
    UserService.fetchUsers().then((value) {
      setState(() {
        data = value;
        errorOuccered = false;
        fetchingData = false;
      });
    }).catchError((error) {
      setState(() {
        errorMsg = error.toString();
        errorOuccered = true;
        fetchingData = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              showSearch(context: context, delegate: SearchData(data)); //delegates to SearchData with current user list
            },
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: fetchingData                         //Checking if request is completed or not
            ? Center(
                child: CircularProgressIndicator(),
              )
            : errorOuccered
                ? Center(child: Text("$errorMsg"))  // if request is completed with an error
                : ListView.separated(               // bulding list when data is successfully arrived
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.transparent,
                      );
                    },
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return _tile(index, data);
                    }),
      ),
    );
  }

  //this function provide vertical space before and after the tile according to index
  Widget _tile(int index, List<Users> data) {
    if (index == 0 || index % 2 == 0) {
      return Row(
        children: <Widget>[
          _getTileContent(index, data),
          VerticalDivider(
            color: Colors.transparent,
            width: 30,
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          VerticalDivider(
            color: Colors.transparent,
            width: 30,
          ),
          _getTileContent(index, data)
        ],
      );
    }
  }

  //this function adds content the on the tile
  Widget _getTileContent(int index, List<Users> data) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff858585)),
          color: const Color(0xffEEEEEE),
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Name : ${data[index].name}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            data.removeAt(index);
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
                Align(
                  child: Text(
                    "Email : ${data[index].email}",
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  child: Text(
                    "${data[index].address.toString()}",
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  child: Text(
                    "Phone : ${data[index].phone}",
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Align(
                  child: Text(
                    "${data[index].website}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
