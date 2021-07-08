import 'package:flutter/material.dart';
import 'package:ta_provider/models/Movie.dart';
import 'package:ta_provider/services/MovieService.dart';
import 'package:ta_provider/provider/ThemeProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(        // define it
        create: (context) => ThemeProvider(),
        child :MaterialApp(
          title: 'Provider',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Movie DB'),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MovieService _movieService = MovieService();
  late Future<List<Movie>> _movieList;
  String dropdownValue = '1000';

  @override
  void initState() {
    super.initState();
    print("init");
    _movieList = getMovies(1000);
  }

  Future<List<Movie>> getMovies(int limit) async {
    print('getMovies');
    return await _movieService.readMovies(limit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black45,
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite_border_rounded,
            ),
            onPressed: (){},
          ),
          PopupMenuButton<int>(
            padding: const EdgeInsets.all(0.0),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.title),
                  title: Text('Purple Title'),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.title),
                  title: Text('Black Title'),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.widgets_outlined),
                  title: Text('White Card'),
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.widgets),
                  title: Text('Purple Card'),
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Small Font'),
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: ListTile(
                  leading: Icon(Icons.format_size),
                  title: Text('Large Font'),
                ),
              ),
              PopupMenuItem<int>(
                value: 6,
                child: ListTile(
                  leading: Icon(Icons.text_format),
                  title: Text('Arial Font'),
                ),
              ),
              PopupMenuItem<int>(
                value: 7,
                child: ListTile(
                  leading: Icon(Icons.text_format),
                  title: Text('Roboto Font'),
                ),
              ),
              PopupMenuItem<int>(
                value: 8,
                child: ListTile(
                  leading: Icon(Icons.zoom_out),
                  title: Text('Small Picture'),
                ),
              ),
              PopupMenuItem<int>(
                value: 9,
                child: ListTile(
                  leading: Icon(Icons.zoom_in),
                  title: Text('Large Picture'),
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Jumlah data:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      items: <String>['100', '1000', '10000']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            textAlign: TextAlign.right,
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() {
                        dropdownValue = newValue!;
                      }),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: FutureBuilder(
                    future: _movieList,
                    builder: (context, AsyncSnapshot? snapshots) {
                      if (snapshots!.hasError) {
                        return Text(
                            'Error while retrieving data from database');
                      } else if (snapshots.hasData) {
                        return Column(
                          children: [
                            for (var i in snapshots.data)
                            Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) =>
                              Card(
                                color: themeProvider.cardColor,
                                elevation: 5,
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        height: 120,
                                        width: 100.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    i.image.toString()
                                                ),
                                                fit: BoxFit.cover
                                            )
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Consumer<ThemeProvider>(
                                            builder: (context, themeProvider, child) =>
                                              Text(
                                                i.title.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: themeProvider.titleColor,
                                                    // fontFamily: themeProvider.themeFontFamily,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: Colors.amber,
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child:
                                                Consumer<ThemeProvider>(
                                                  builder: (context, themeProvider, child) => Text(
                                                    i.genre.toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: themeProvider.themeFontFamily,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Consumer<ThemeProvider>(
                                              builder: (context, themeProvider, child) =>
                                                Text(
                                                  i.synopsis.toString(),
                                                  style: TextStyle(
                                                    fontSize: themeProvider.themeFontSize,
                                                    fontFamily: themeProvider.themeFontFamily,
                                                  ),
                                                ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ],
                        );

                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ),
          ),
        ],
      ),

    );

  }
  onSelected(BuildContext context, int item) {
    switch(item){
      case 0:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeTextColor(Colors.purple);
        break;
      case 1:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeTextColor(Colors.black);
        break;
      case 2:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeCardBackground(Colors.white);
        break;
      case 3:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeCardBackground(Colors.purpleAccent);
        break;
      case 4:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeFontSize(10);
        break;
      case 5:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeFontSize(20);
        break;
      case 6:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeFontFamily("Arial");
        break;
      case 7:
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.changeFontFamily("Roboto");
        break;
    }
  }
}
