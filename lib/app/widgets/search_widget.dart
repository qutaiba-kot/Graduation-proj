import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/google_map_controller.dart';

class SearchWidget extends GetView<MapController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchTextField(context),
        _buildSearchSuggestions(context),
      ],
    );
  }

  Widget _buildSearchTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background,
            blurRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller.textEditingController, 
        cursorColor: Theme.of(context).colorScheme.background,
        style: TextStyle(
          color: Theme.of(context).colorScheme.background,
        ),
        decoration: InputDecoration(
          hintText: "Find a location...".tr,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.background,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              controller.textEditingController.clear();
              controller.searchSuggestions.clear();
            },
          ),
        ),
        onChanged: (query) {
          if (query.isNotEmpty) {
            controller.fetchSearchSuggestions(query);
          } else {
            controller.searchSuggestions.clear();
          }
        },
      ),
    );
  }

  Widget _buildSearchSuggestions(BuildContext context) {
    return Obx(() => controller.searchSuggestions.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.background,
                  blurRadius: 1,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.searchSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = controller.searchSuggestions[index];
                return ListTile(
                  title: Text(
                    suggestion['description'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  onTap: () async {
                    controller.textEditingController.clear();
                    final placeId = suggestion['place_id'];
                    final description = suggestion['description'];
                    controller.searchSuggestions.clear();
                    await controller.fetchPlaceDetails(placeId);
                    controller.confirmStartTracking(description);
                  },
                );
              },
            ),
          )
        : SizedBox());
  }
}
