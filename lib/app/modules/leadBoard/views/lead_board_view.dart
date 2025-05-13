import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/leadBoard/controllers/lead_board_controller.dart';
import 'package:maps/app/widgets/LeaderboardTable.dart';
import '../../../widgets/leaderboardTopRow.dart';

class LeadBoardView extends GetView<LeadBoardController> {
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
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final top3 = controller.leaders.take(3).toList();

        return Column(
          children: [
            leaderboardTopRow(context, top3),
            SizedBox(height: 16.0),
            Expanded(
              child: LeaderboardTable(controller: controller),
            ),
          ],
        );
      }),
    );
  }
}
