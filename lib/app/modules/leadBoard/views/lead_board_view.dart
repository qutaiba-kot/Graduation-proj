import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/const/size.dart';

class LeadBoardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'leaderboard'.tr,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: true,
        //backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: getHeight(context, 0.04),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: getHeight(context, -0.0080),
                        right: getWidth(context, 0.06),
                        child: Container(
                          padding: EdgeInsets.all(getWidth(context, 0.01)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Text(
                            "2",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "name".tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  Text(
                    "Points".tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ],
              ),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: getHeight(context, 0.06),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: getHeight(context, -0.0099),
                        right: getWidth(context, 0.080),
                        child: Container(
                          padding: EdgeInsets.all(getWidth(context, 0.02)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Text(
                            "1",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: getHeight(context, 0.089),
                        right: getWidth(context, 0.16),
                        child: Container(
                            padding: EdgeInsets.all(getWidth(context, 0.02)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Icon(
                              size: 12,
                              Icons.emoji_events,
                              color: Colors.amber,
                            )),
                      ),
                    ],
                  ),
                  Text(
                    "name".tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  Text(
                    "Points".tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  SizedBox(
                    height: getHeight(context, 0.04),
                  )
                ],
              ),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: getHeight(context, 0.04),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: getHeight(context, -0.0080),
                        right: getWidth(context, 0.06),
                        child: Container(
                          padding: EdgeInsets.all(getWidth(context, 0.01)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Text(
                            "3",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "name".tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  Text(
                    "Points".tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: getHeight(context, 0.10)),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(66))),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: getHeight(context, 0.02),
                      right: getWidth(context, 0.030),
                      left: getWidth(context, 0.030)),
                  child: Card(
                    color:  Theme.of(context).colorScheme.background,
                    elevation: 10.0,
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(66.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Rank'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onBackground,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'name'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onBackground,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Points'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onBackground,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Content Section
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16.0)),
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  30,
                                  (index) => Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${index + 1}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                child: Icon(Icons.person,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer),
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                "User ${index + 1}",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${(100 - index) * 100}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
