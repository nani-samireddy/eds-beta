import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/controllers/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum MenuType { mainMenu, subMenu }

class FilterProductsMenu extends StatefulWidget {
  const FilterProductsMenu({super.key, required this.controller});
  final ProductsController controller;

  @override
  State<FilterProductsMenu> createState() => _FilterProductsMenuState();
}

class _FilterProductsMenuState extends State<FilterProductsMenu> {
  MenuType menuType = MenuType.mainMenu;
  String _subMenuName = "";
  Map<String, dynamic> _selectedFilters = {};
  Map<String, dynamic> _selectSubMenu = {};
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            menuType == MenuType.mainMenu ? _buildMainMenu() : _buildSubMenu(),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
                text: "SHOW",
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildMainMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter by:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        // Wrap(children: ,),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.controller.filteringProperites.keys.elementAt(index),
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                weight: 200,
              ),
              onTap: () {
                setState(() {
                  menuType = MenuType.subMenu;
                  _subMenuName = widget.controller.filteringProperites.keys
                      .elementAt(index);
                });
              },
            );
          },
          itemCount: widget.controller.filteringProperites.length,
        ),
      ],
    );
  }

  Widget _buildSubMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    menuType = MenuType.mainMenu;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                _subMenuName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount:
                widget.controller.filteringProperites[_subMenuName].length,
            itemBuilder: (context, index) {
              String category = widget
                  .controller.filteringProperites[_subMenuName]!.keys
                  .elementAt(index);
              int count = widget
                  .controller.filteringProperites[_subMenuName]!.values
                  .elementAt(index)['count'];
              bool isSelected = widget
                  .controller.filteringProperites[_subMenuName]!.values
                  .elementAt(index)['selected'];

              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("$category ($count)"),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    widget.controller.filteringProperites[_subMenuName]![
                        category]!['selected'] = value;
                    isSelected = value as bool;
                    widget.controller.applyFilterstoProducts();
                  });
                },
              );
            }),
      ],
    );
  }
}
