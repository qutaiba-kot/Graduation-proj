import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserLeader {
  final int userId;
  final int rank;
  final int totalPoints;
  String userName = ""; 

  UserLeader({
    required this.userId,
    required this.rank,
    required this.totalPoints,
  });

  factory UserLeader.fromMap(Map<String, dynamic> map) {
    return UserLeader(
      userId: map['user_id'] ?? 0,
      rank: map['rank'] ?? 0,
      totalPoints: map['total_points'] ?? 0,
    );
  }
}

class LeadBoardController extends GetxController {
  final RxList<UserLeader> leaders = <UserLeader>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaders();
  }

  Future<void> fetchLeaders() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client
          .from('user_leaderboard')
          .select()
          .order('rank', ascending: true);

      leaders.value =
          (response as List).map((item) => UserLeader.fromMap(item)).toList();

      await fetchUserNames();
    } catch (e) {
      print("❌ Error fetching leaderboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserNames() async {
    try {
      final userIds = leaders.map((u) => u.userId).toList();

      final response = await Supabase.instance.client
          .from('users')
          .select('id, name')
          .filter('id', 'in', '(${userIds.join(",")})');
      final namesMap = {
        for (var item in response) item['id'] as int: item['name'] as String
      };

      for (var leader in leaders) {
        leader.userName = namesMap[leader.userId] ?? '';
      }
    } catch (e) {
      print("❌ Error fetching user names: $e");
    }
  }
}
