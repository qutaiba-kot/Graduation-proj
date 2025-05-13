import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/size.dart';
import '../modules/leadBoard/controllers/lead_board_controller.dart';

Widget leaderboardTopRow(BuildContext context, List<UserLeader> top3) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (top3.length > 1)
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                      "${top3[1].rank}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${top3[1].userName}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              "${top3[1].totalPoints} ${"Points".tr}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      if (top3.isNotEmpty)
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: getHeight(context, 0.06),
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
                      "${top3[0].rank}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${top3[0].userName}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              "${top3[0].totalPoints} ${"Points".tr}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      if (top3.length > 2)
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                      "${top3[2].rank}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${top3[2].userName}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              "${top3[2].totalPoints} ${"Points".tr}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
    ],
  );
}
