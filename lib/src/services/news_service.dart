import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import '../models/news_models.dart';

import 'package:http/http.dart' as http;

  // ignore: constant_identifier_names
  const _URL_NEWS = 'https://newsapi.org/v2';
  // ignore: constant_identifier_names
  const _APIKEY = 'c803e04e74fc4bf5819f478caa42dbbb';

class NewsService with ChangeNotifier {

  List<Article?> headlines = [];
  String _selectedCategory = 'business';
  
    bool _isLoading = true;


  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.football, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

   Map<String, List<Article?>> categoryArticles = {};



  NewsService(){
    getTopHeadlines();
    for (var item in categories) {
      categoryArticles[item.name] = [];
    }

    getArticlesByCategory( _selectedCategory );
     
  }

  bool get isLoading => _isLoading;


  get selectedCategory => _selectedCategory;
  set selectedCategory(dynamic valor) {
    _selectedCategory = valor;


    _isLoading = true;
    getArticlesByCategory(valor);

    notifyListeners();
  }

  List<Article?> get getArticulosCategoriaSeleccionada => categoryArticles[selectedCategory]!;


  getTopHeadlines()async{
    
    final url =  Uri.parse('$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ar');
    final resp = await http.get(url);

    final newsResponse = newsResponseFromMap( resp.body );

    headlines.addAll(newsResponse!.articles!);
    notifyListeners();
    

  }

  getArticlesByCategory(String category)async{

   if ( categoryArticles[category]!.length > 0 ) {
        _isLoading = false;
        notifyListeners();
        return categoryArticles[category];
      }
         
    final url =  Uri.parse('$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ar&category=$category');
    final resp = await http.get(url);

    final newsResponse = newsResponseFromMap( resp.body );

     categoryArticles[category]!.addAll(newsResponse!.articles!.toList());

      _isLoading = false; 
      notifyListeners();
    
  }


}