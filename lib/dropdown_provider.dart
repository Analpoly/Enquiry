import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Category {
  final int? id;
  final String? catgName;

  Category({this.id, this.catgName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      catgName: json['catg_name'],
    );
  }
}

class Subcategory {
  final int? id;
  final String? name;

  Subcategory({this.id, this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      name: json['Name'],
    );
  }
}

class Autogenerated {
  final String? brand;

  Autogenerated({this.brand});

  factory Autogenerated.fromJson(Map<String, dynamic> json) {
    return Autogenerated(
      brand: json['Brand'],
    );
  }
}



class DropdownProvider with ChangeNotifier {
  List<Category> categories = [];
  List<DropdownSet> dropdownSets = [];

  DropdownProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://suncity.warmonks.com/api/category'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          final List<dynamic> categoryData = data['data'];
          categories = categoryData.map((item) {
            return Category.fromJson(item);
          }).toList();
          notifyListeners();
        } else {
          throw Exception('Invalid categories data: ${data['data']}');
        }
      } else {
        throw Exception('Failed to load categories, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchSubItems(int categoryId, int setIndex) async {
  final String url = 'https://suncity.warmonks.com/api/prdtcat';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': categoryId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('data') && data['data'] is List) {
        final List<dynamic> subcategoryData = data['data'];
        final List<Subcategory> fetchedSubcategories = subcategoryData.map((item) {
          return Subcategory.fromJson(item);
        }).toList();
        
        // Update dropdownSet with new subcategories and reset items2
        dropdownSets[setIndex].subcategories = fetchedSubcategories;
        dropdownSets[setIndex].items2 = fetchedSubcategories.map((subcat) => subcat.name ?? '').toList();
        
        // Reset dropdownValue2 and items3
        dropdownSets[setIndex].dropdownValue2 = null;
        dropdownSets[setIndex].items3 = [];

        notifyListeners();
      } else {
        throw Exception('Invalid subcategories data: ${data['data']}');
      }
    } else {
      print('Response body: ${response.body}');
      throw Exception('Failed to load sub-items, status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  Future<void> fetchBrands(int subcategoryId, int setIndex) async {
    final String url = 'https://suncity.warmonks.com/api/brdcat';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': subcategoryId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          final List<dynamic> brands = data['data'];
          final List<String> fetchedBrands = brands.map((item) {
            return Autogenerated.fromJson(item).brand ?? '';
          }).toList();
          dropdownSets[setIndex].items3 = fetchedBrands;
          dropdownSets[setIndex].dropdownValue3 = null;
          notifyListeners();
        } else {
          throw Exception('Invalid brands data: ${data['data']}');
        }
      } else {
        throw Exception('Failed to load brands, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching brands: $e');
    }
  }

  void addDropdownSet() {
    dropdownSets.add(DropdownSet());
    notifyListeners();
  }

  void deleteDropdownSet() {
    if (dropdownSets.isNotEmpty) {
      dropdownSets.removeLast();
      notifyListeners();
    }
  }
}

class DropdownSet {
  String? dropdownValue1;
  String? dropdownValue2;
  String? dropdownValue3;
  List<String> items2 = [];
  List<String> items3 = [];
  List<Subcategory> subcategories = [];

  DropdownSet();
}
