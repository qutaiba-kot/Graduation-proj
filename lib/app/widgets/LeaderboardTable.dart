import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/size.dart';
import '../modules/leadBoard/controllers/lead_board_controller.dart';

class LeaderboardTable extends StatelessWidget {
  final LeadBoardController controller;

  const LeaderboardTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: getHeight(context, 0.10)),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(66),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: getHeight(context, 0.02),
            right: getWidth(context, 0.030),
            left: getWidth(context, 0.030),
          ),
          child: Card(
            color: Theme.of(context).colorScheme.background,
            elevation: 10.0,
            child: Column(
              children: [
                // Header
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
                      top: Radius.circular(66.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
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
                // List
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16.0)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: controller.leaders
                            .map(
                              (user) => Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: user.rank % 2 == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${user.rank}",
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
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            child: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            "${user.userName}",
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
                                        "${user.totalPoints}",
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
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
