import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/model/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  final String _apiKey = '14f2fa807emsh123ca0aa4d59b0fp1ef141jsn4d8712b217a8'; 
  final String _apiHost = 'tasty.p.rapidapi.com';

  Future<void> fetchRecipes(String query) async {
    final url = Uri.parse(
      'https://tasty.p.rapidapi.com/recipes/list?from=0&size=10&q=$query',
    );
    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': _apiHost,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List recipesData = data['results'];
      _recipes = recipesData.map((recipeData) => Recipe.fromJson(recipeData)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
