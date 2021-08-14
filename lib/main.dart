import 'package:flutter/material.dart';
import 'package:ta_provider/models/Movie.dart';
import 'package:ta_provider/provider/TextColorProvider.dart';
import 'package:ta_provider/provider/CardProvider.dart';
import 'package:ta_provider/provider/FontFamilyProvider.dart';
import 'package:ta_provider/provider/FontSizeProvider.dart';
import 'package:ta_provider/provider/ImageSizeProvider.dart';
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
        ChangeNotifierProvider(create: (context) => TextColorProvider()),
        ChangeNotifierProvider(create: (context) => CardColorProvider()),
        ChangeNotifierProvider(create: (context) => FontSizesProvider()),
        ChangeNotifierProvider(create: (context) => FontFamilyProvider()),
        ChangeNotifierProvider(create: (context) => ImageSizeProvider()),
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

class FontSizeProvider {
}

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
            itemBuilder: (context) =>
            [
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
                  leading: Icon(Icons.widgets),
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
                      onChanged: (newValue) =>
                          setState(() {
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
                                Consumer<CardColorProvider>(
                                    builder: (context, themeProvider, child) =>
                                        Card(
                                          color: themeProvider.cardColor,
                                          elevation: 5,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child:
                                                Consumer<ImageSizeProvider>(
                                                  builder: (context,
                                                      themeProvider, child) =>
                                                      Container(
                                                        height: themeProvider
                                                            .imageSize[1],
                                                        width: themeProvider
                                                            .imageSize[0],
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    i.image
                                                                        .toString()
                                                                ),
                                                                fit: BoxFit
                                                                    .cover
                                                            )
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Consumer<
                                                          TextColorProvider>(
                                                        builder: (context,
                                                            themeProvider,
                                                            child) =>
                                                            Text(
                                                              i.title
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                fontSize: 20,
                                                                color: themeProvider
                                                                    .titleColor,
                                                                // fontFamily: themeProvider.themeFontFamily,
                                                              ),
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                          color: Colors.amber,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                          child:
                                                          Consumer<
                                                              FontFamilyProvider>(
                                                            builder: (context,
                                                                themeProvider,
                                                                child) =>
                                                                Text(
                                                                  i.genre
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily: themeProvider
                                                                        .themeFontFamily,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Consumer2<
                                                          FontSizesProvider,
                                                          FontFamilyProvider>(
                                                        builder: (context,
                                                            themeProvider1,
                                                            themeProvider2,
                                                            child) =>
                                                            Text(
                                                              i.synopsis,
                                                              style:
                                                              TextStyle(
                                                                fontSize: themeProvider1
                                                                    .themeFontSize,
                                                                fontFamily: themeProvider2
                                                                    .themeFontFamily,
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
        TextColorProvider themeProvider = Provider.of<TextColorProvider>(
            context, listen: false);
        themeProvider.changeTextColor(Colors.purple);
        break;
      case 1:
        TextColorProvider themeProvider = Provider.of<TextColorProvider>(
            context, listen: false);
        themeProvider.changeTextColor(Colors.black);
        break;
      case 2:
        CardColorProvider themeProvider = Provider.of<CardColorProvider>(
            context, listen: false);
        themeProvider.changeCardBackground(Colors.white);
        break;
      case 3:
        CardColorProvider themeProvider = Provider.of<CardColorProvider>(
            context, listen: false);
        themeProvider.changeCardBackground(Colors.purpleAccent);
        break;
      case 4:
        FontSizesProvider themeProvider = Provider.of<FontSizesProvider>(
            context, listen: false);
        themeProvider.changeFontSize(10);
        break;
      case 5:
        FontSizesProvider themeProvider = Provider.of<FontSizesProvider>(
            context, listen: false);
        themeProvider.changeFontSize(20);
        break;
      case 6:
        FontFamilyProvider themeProvider = Provider.of<FontFamilyProvider>(
            context, listen: false);
        themeProvider.changeFontFamily("Arial");
        break;
      case 7:
        FontFamilyProvider themeProvider = Provider.of<FontFamilyProvider>(
            context, listen: false);
        themeProvider.changeFontFamily("Roboto");
        break;
      case 8:
        ImageSizeProvider themeProvider = Provider.of<ImageSizeProvider>(
            context, listen: false);
        themeProvider.changeImageSize("small");
        break;
      case 9:
        ImageSizeProvider themeProvider = Provider.of<ImageSizeProvider>(
            context, listen: false);
        themeProvider.changeImageSize("big");
        break;
    }
  }
}
