import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/filter_page/filter_page.dart';
class FilterChipsExample extends StatelessWidget {
  final FilterController filterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Obx(() {
            return Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(width: 1, color: Colors.black26),
              ),
              child: DropdownButton<String>(
                underline: Container(),
                hint: const Text('Cuisines'),
                value: filterController.selectedService.value,
                onChanged: (String? newValue) {
                  filterController.selectedService.value = newValue ?? 'All';
                  filterController.applyFilters(); // Запит до бази
                },
                items: ['All', 'Italian', 'Chinese', 'Indian', 'Mexican', 'Japanese']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.black87)),
                  );
                }).toList(),
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down),
              ),
            );
          }),
          const SizedBox(width: 12),
          Obx(() {
            return Row(
              children: filterController.filterChips.map((filter) {
                return SizedBox(
                  height: 32,
                  child: FilterChip(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
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
                      filter.isSelected = isSelected;
                      filterController.filterChips.refresh();
                      filterController.applyFilters(); // Запит до бази
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xff5B4CBD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
