import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'ItemList.dart';

Future<List<ItemList>> fetchRecipes(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://raw.githubusercontent.com/ababicheva/FlutterInternshipTestTask/main/recipes.json'));

  return compute(parseRecipes, response.body);
}

List<ItemList> parseRecipes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  final parsedMapped = parsed
      .map<ItemList>(
          (Map<String, dynamic> json) => ItemList.fromJson(json))
      .toList();

  parsedMapped.sort((a, b) =>
      int.parse(a.id.toString()).compareTo(int.parse(b.id.toString())));

  return parsedMapped as List<ItemList>;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'My Recipes';

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF6200EE),
      ),
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: const Icon(
              Icons.search_outlined,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<ItemList>>(
        future: fetchRecipes(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? RecipesList(recipes: snapshot.data!)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class RecipesList extends StatelessWidget {
  final List<ItemList> recipes;

  const RecipesList({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: index == 0 ? 65 : 0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 65,
                  width: 110,
                  margin: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: Image.network(
                    recipes[index].picture,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipes[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          recipes[index].description,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: Colors.black45,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    10 > recipes[index].id
                        ? "0${recipes[index].id.toString()}"
                        : recipes[index].id.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 24,
              indent: 115,
            ),
          ],
        );
      },
    );
  }
}