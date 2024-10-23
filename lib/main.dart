import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/recipe_api.dart';
import 'package:recipe_app/recipe_detail_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RecipeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasty Recipes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: RecipeSearchPage(),
    );
  }
}

class RecipeSearchPage extends StatefulWidget {
  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tasty Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter a recipe name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text;
                    if (query.isNotEmpty) {
                      Provider.of<RecipeProvider>(context, listen: false)
                          .fetchRecipes(query);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<RecipeProvider>(
                builder: (context, provider, child) {
                  if (provider.recipes.isEmpty) {
                    return const Center(child: Text('No recipes found.'));
                  }
                  return ListView.builder(
                    itemCount: provider.recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = provider.recipes[index];
                      String truncatedDescription =
                          recipe.description.length > 50
                              ? '${recipe.description.substring(0, 50)}...'
                              : recipe.description;

                      return ListTile(
                        leading: Image.network(
                          recipe.thumbnailUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(recipe.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(truncatedDescription),
                            if (recipe.description.length > 50)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailPage(recipe: recipe),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'See more',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
