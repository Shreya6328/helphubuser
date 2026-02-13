import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserProfileService {
  final SupabaseClient client = Supabase.instance.client;
  final Box box = Hive.box('offline_profile');

  /// ---------------- CHECK INTERNET ----------------
  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// ---------------- SAVE PROFILE ----------------
  Future<void> saveProfile({
    required String userId,
    required String name,
    required String phone,
    required String safety,
    required List<Map<String, String>> emergencyContacts,
  }) async {
    final profileData = {
      "user_id": userId,
      "name": name,
      "phone": phone,
      "safety": safety,
      "contacts": emergencyContacts,
    };

    /// ✅ ALWAYS SAVE LOCALLY FIRST (OFFLINE SUPPORT)
    await box.put('profile', profileData);
    print("LOCAL SAVE: $profileData");

    /// ✅ TRY SUPABASE SAVE IF INTERNET
    if (await hasInternet()) {
      try {
        final res = await client
            .from('user_profiles')
            .upsert(profileData, onConflict: 'user_id')
            .select();

        print("SUPABASE INSERT SUCCESS: $res");
      } catch (e) {
        print("SUPABASE ERROR: $e");
      }
    } else {
      print("NO INTERNET → SAVED ONLY LOCALLY");
    }
  }

  /// ---------------- SYNC OFFLINE DATA ----------------
  Future<void> syncOfflineData() async {
    if (!box.containsKey('profile')) return;

    if (await hasInternet()) {
      try {
        final data = Map<String, dynamic>.from(box.get('profile'));

        final res = await client
            .from('user_profiles')
            .upsert(data, onConflict: 'user_id')
            .select();

        print("OFFLINE DATA SYNCED: $res");
      } catch (e) {
        print("SYNC ERROR: $e");
      }
    }
  }

  /// ---------------- LOAD LOCAL PROFILE ----------------
  Map<String, dynamic>? getLocalProfile() {
    if (!box.containsKey('profile')) return null;
    return Map<String, dynamic>.from(box.get('profile'));
  }
}
