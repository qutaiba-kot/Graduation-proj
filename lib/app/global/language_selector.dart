import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maps/app/const/size.dart';

class LanguageSelector extends StatelessWidget {
  final double height;
  LanguageSelector({this.height = 50.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  getHeight(context, 0.05),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary, 
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5), 
      ),
      child: DropdownButton<String>(
        borderRadius:
            BorderRadius.all(Radius.circular(10)),
        value: Get.locale?.languageCode,
        dropdownColor: Theme.of(context).colorScheme.primary, 
        underline: SizedBox(), 
        icon: Icon(Icons.language, color: Theme.of(context).colorScheme.background), 
        style: TextStyle(color: Theme.of(context).colorScheme.background, fontSize: 16.0),
        items: [
          DropdownMenuItem(
            value: 'en',
            child: Text(
              'English',
              style: TextStyle(color:Theme.of(context).colorScheme.background), 
            ),
          ),
          DropdownMenuItem(
            value: 'ar',
            child: Text(
              'العربية',
              style: TextStyle(color:Theme.of(context).colorScheme.background),
            ),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            Get.updateLocale(Locale(value));
            GetStorage().write('lang', value);
          }
        },
      ),
    );
  }
}
