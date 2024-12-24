import 'package:get_storage/get_storage.dart';

class UserStorageService {
  final GetStorage _storage = GetStorage();

  final String emailKey = 'email';
  final String phoneKey = 'phone';
  final String nameKey = 'name';
  final String userIdKey = 'user_id';
  final String trustedScoreKey = 'trusted_score';
  final String totalReportsKey = 'total_reports';
  final String isLoggedInKey = 'is_logged_in';

  void saveUserData({
    required String email,
    required String phone,
    required String name,
    required int userId,
    required int trustedScore,
    required int totalReports,
    required bool isLoggedIn,
  }) {
    _storage.write(emailKey, email);
    _storage.write(phoneKey, phone);
    _storage.write(nameKey, name);
    _storage.write(userIdKey, userId);
    _storage.write(trustedScoreKey, trustedScore);
    _storage.write(totalReportsKey, totalReports);
    _storage.write(isLoggedInKey, isLoggedIn);
  }

  String? get email => _storage.read(emailKey);
  String? get phone => _storage.read(phoneKey);
  String? get name => _storage.read(nameKey);
  int? get userId => _storage.read(userIdKey);
  int? get trustedScore => _storage.read(trustedScoreKey);
  int? get totalReports => _storage.read(totalReportsKey);
  bool get isLoggedIn => _storage.read(isLoggedInKey) ?? false; 

  void clearUserData() {
    _storage.remove(emailKey);
    _storage.remove(phoneKey);
    _storage.remove(nameKey);
    _storage.remove(userIdKey);
    _storage.remove(trustedScoreKey);
    _storage.remove(totalReportsKey);
    _storage.write(isLoggedInKey, false);
  }
}
