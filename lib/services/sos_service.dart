import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'mesh_service.dart';
import 'package:user_app/untils/device_id.dart';

class SosService {
  final SupabaseClient client = Supabase.instance.client;
  final Box box = Hive.box('offline_sos');
  final MeshService mesh = MeshService();

  SosService() {
    mesh.initMesh();
    syncOfflineSOS();
  }

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<Position> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("Location disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

//   Future<void> sendSOS({required String type}) async {
//   final position = await _getLocation();
//   final deviceId = await DeviceId.get();

//   final data = {
//     "type": type,
//     "latitude": position.latitude,
//     "longitude": position.longitude,
//     "created_at": DateTime.now().toIso8601String(),
//     "device_id": deviceId,
//     "status": "pending"
//   };

//   if (await hasInternet()) {
//     // ✅ INTERNET AVAILABLE → DIRECT SUPABASE
//     try {
//       await client.from('sos_alerts').insert(data);
//       // await client.from('sos_alerts').insert(data).select();

//       print("✅ SOS sent directly to Supabase");
//       return;
//     } catch (e) {
//       print("❌ Supabase failed, switching to mesh");
//     }
//   }

//   // ❌ NO INTERNET → MESH + OFFLINE STORAGE
//   await mesh.sendSOS(data);

//   final List pending = box.get('pending', defaultValue: []);
//   pending.add(data);
//   await box.put('pending', pending);

//   print("📦 SOS sent via mesh & saved offline");
// }

  Future<void> sendSOS({required String type}) async {
    final position = await _getLocation();
    final deviceId = await DeviceId.get();

    final data = {
      "type": type,
      "latitude": position.latitude,
      "longitude": position.longitude,
      "created_at": DateTime.now().toIso8601String(),
      "device_id": deviceId,
      "status": "pending"
    };

    if (await hasInternet()) {
      try {
        // ✅ DO NOT EXPECT RESPONSE
        await client.from('sos_alerts').insert(data);

        print("✅ SOS sent directly to Supabase");
        return; // 🔴 IMPORTANT: STOP HERE
      } catch (e, stack) {
        print("❌ Supabase insert error: $e");
        print(stack);
      }
    }

    // 🔴 ONLY IF NO INTERNET OR INSERT FAILED
    await mesh.sendSOS(data);

    final List pending = box.get('pending', defaultValue: []);
    pending.add(data);
    await box.put('pending', pending);

    print("📦 SOS sent via mesh & saved offline");
  }

  Future<void> syncOfflineSOS() async {
    if (!await hasInternet()) return;

    final List pending = box.get('pending', defaultValue: []);
    if (pending.isEmpty) return;

    try {
      final deviceId = await DeviceId.get();

      final List<Map<String, dynamic>> cleanData = pending.map((e) {
        final raw = Map<String, dynamic>.from(e);
        return {
          "type": raw["type"],
          "latitude": raw["latitude"],
          "longitude": raw["longitude"],
          "created_at": raw["created_at"],
          "device_id": deviceId, // ⭐ ADD
          "status": "pending",
        };
      }).toList();

      await client.from('sos_alerts').insert(cleanData);
      await box.delete('pending');

      print("✅ SOS synced to Supabase");
    } catch (e, stack) {
      print("❌ Supabase insert error: $e");
      print(stack);
    }
  }
}
