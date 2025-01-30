import 'package:flutter/material.dart';

class Filter {
  final String name;
  bool isSelected;

  Filter(this.name, this.isSelected);
}

class MenuFilterChips extends StatefulWidget {
  @override
  _MenuFilterChipsState createState() => _MenuFilterChipsState();
}

class _MenuFilterChipsState extends State<MenuFilterChips> {
  final List<Filter> filters = [
    Filter('Bestseller Items', false),
    Filter('Top rated Item', false),
  ];
  final List<String> sortOptions = ['Alphabetical', 'Rating', 'Price'];

  String? selectedSortOption;

  List<String> getAppliedFilters() {
    List<String> appliedFilters = filters.where((filter) => filter.isSelected).map((filter) => filter.name).toList();
    if (selectedSortOption != null) {
      appliedFilters.add(selectedSortOption!);
    }
    return appliedFilters;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(width: 1, color: Colors.black26),
            ),
            child: DropdownButton<String>(
              underline: Container(),
              hint: Text('Sort by'),
              value: selectedSortOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSortOption = newValue;
                  print("Selected sort option: $selectedSortOption");
                });
              },
              items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.black87)),
                );
              }).toList(),
              style: TextStyle(color: Colors.black),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
            ),
          ),
          SizedBox(width: 8),
          ...filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                padding: EdgeInsets.symmetric(horizontal: 6),
                showCheckmark: false,
                label: Text(
                  filter.name,
                  style: TextStyle(
                    color: filter.isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                selected: filter.isSelected,
                onSelected: (isSelected) {
                  setState(() {
                    filter.isSelected = isSelected;
                    print("Applied filters: ${getAppliedFilters()}");
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: Color(0xff5B4CBD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
