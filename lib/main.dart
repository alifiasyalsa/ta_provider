import 'package:flutter/material.dart';
import 'package:ta_provider/models/Movie.dart';
import 'package:ta_provider/provider/CardProvider.dart';
import 'package:ta_provider/provider/TextSynopsisProvider.dart';
import 'package:ta_provider/provider/TextTitleProvider.dart';
import 'package:ta_provider/services/MovieService.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CardProvider()),
        ChangeNotifierProvider(create: (context) => TextTitleProvider()),
        ChangeNotifierProvider(create: (context) => TextSynopsisProvider()),
      ],
      child: MaterialApp(
        title: 'MovDB - Provider',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'MovDB'),
      ),
    );
  }
}

class FontSizeProvider {}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MovieService _movieService = MovieService();
  Future<List<Movie>> _movieList;
  int dropdownValue = 1000;

  @override
  void initState() {
    super.initState();
    print("init");
    _movieList = getMovies(dropdownValue);
  }

  Future<List<Movie>> getMovies(int limit) async {
    print('getMovies');
    return await _movieService.readMovies(limit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          PopupMenuButton<int>(
            padding: const EdgeInsets.all(0.0),
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.widgets),
                  title: Text('Ubah background item Card'),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.title),
                  title: Text('Ubah font-size Title'),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.title),
                  title: Text('Ubah font-color Title'),
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Ubah font-size Synopsis'),
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Ubah font-color Synopsis'),
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
                    child: DropdownButtonFormField<int>(
                      value: dropdownValue,
                      items: <int>[1000, 5000, 10000]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                            textAlign: TextAlign.right,
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() {
                        dropdownValue = newValue;
                        _movieList = getMovies(newValue);
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
                    builder: (context, AsyncSnapshot snapshots) {
                      if (snapshots.hasError) {
                        return Text(
                            'Error while retrieving data from database');
                      } else if (snapshots.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              for (var i in snapshots.data)
                                Consumer<CardProvider>(
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
                                            width: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        i.image.toString()),
                                                    fit: BoxFit.cover)),
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
                                                Consumer<TextTitleProvider>(
                                                  builder: (context,
                                                          titleProvider,
                                                          child) =>
                                                      Text(
                                                    i.title.toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: titleProvider
                                                          .titleFontSize,
                                                      color: titleProvider
                                                          .titleFontColor,
                                                      // fontFamily: themeProvider.themeFontFamily,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    color: Colors.amber,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      i.genre.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Consumer<TextSynopsisProvider>(
                                                  builder: (context,
                                                          synopsisProvider,
                                                          child) =>
                                                      Text(
                                                    i.synopsis,
                                                    style: TextStyle(
                                                      fontSize: synopsisProvider
                                                          .synopsisFontSize,
                                                      color: synopsisProvider
                                                          .synopsisFontColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
    switch (item) {
      case 0:
        CardProvider cardProvider =
            Provider.of<CardProvider>(context, listen: false);
        cardProvider.changeCardBackground(Colors.purple);
        break;
      case 1:
        TextTitleProvider titleProvider =
            Provider.of<TextTitleProvider>(context, listen: false);
        titleProvider.changeTitleFontSize(25);
        break;
      case 2:
        TextTitleProvider titleProvider =
            Provider.of<TextTitleProvider>(context, listen: false);
        titleProvider.changeTitleFontColor(Colors.purpleAccent);
        break;
      case 3:
        TextSynopsisProvider synopsisProvider =
            Provider.of<TextSynopsisProvider>(context, listen: false);
        synopsisProvider.changeSynopsisFontSize(20);
        break;
      case 4:
        TextSynopsisProvider synopsisProvider =
            Provider.of<TextSynopsisProvider>(context, listen: false);
        synopsisProvider.changeSynopsisFontColor(Colors.purpleAccent);
        break;
    }
  }
}
