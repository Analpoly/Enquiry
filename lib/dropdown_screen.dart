import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dropdown_provider.dart';

class DropdownScreen extends StatelessWidget {
  const DropdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Dropdowns',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: dropdownProvider.addDropdownSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              if (dropdownProvider.dropdownSets.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: dropdownProvider.dropdownSets.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(height: 16.0),
                          DropdownButton<String>(
                            hint: const Text('Select Item 1'),
                            value: dropdownProvider
                                .dropdownSets[index].dropdownValue1,
                            onChanged: (String? newValue) {
                              // Update dropdownValue1 and fetch new subitems
                              dropdownProvider.dropdownSets[index]
                                  .dropdownValue1 = newValue;
                              dropdownProvider.fetchSubItems(
                                dropdownProvider.categories
                                    .firstWhere(
                                        (cat) => cat.catgName == newValue)
                                    .id!,
                                index,
                              );

                              dropdownProvider
                                  .dropdownSets[index].dropdownValue2 = null;
                              dropdownProvider.dropdownSets[index].items3 = [];
                            },
                            items: dropdownProvider.categories
                                .map<DropdownMenuItem<String>>(
                                    (Category category) {
                              return DropdownMenuItem<String>(
                                value: category.catgName!,
                                child: Text(category.catgName!),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButton<String>(
                            hint: const Text('Select Item 2'),
                            value: dropdownProvider
                                .dropdownSets[index].dropdownValue2,
                            onChanged: (String? newValue) {
                              final subcategory = dropdownProvider
                                  .dropdownSets[index].subcategories
                                  .firstWhere(
                                      (subcat) => subcat.name == newValue);
                              final subcategoryId = subcategory.id!;
                              dropdownProvider.dropdownSets[index]
                                  .dropdownValue2 = newValue;
                              dropdownProvider.fetchBrands(
                                  subcategoryId, index);
                            },
                            items: dropdownProvider.dropdownSets[index].items2
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButton<String>(
                            hint: const Text('Select Item 3'),
                            value: dropdownProvider
                                .dropdownSets[index].dropdownValue3,
                            onChanged: (String? newValue) {
                              dropdownProvider.dropdownSets[index]
                                  .dropdownValue3 = newValue;
                              dropdownProvider.notifyListeners();
                            },
                            items: dropdownProvider.dropdownSets[index].items3
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    },
                  ),
                ),
              if (dropdownProvider.dropdownSets.isNotEmpty)
                ElevatedButton(
                  onPressed: dropdownProvider.deleteDropdownSet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
