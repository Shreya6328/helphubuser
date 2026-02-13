import 'dart:convert';
import 'dart:typed_data';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MeshService {
  final Strategy strategy = Strategy.P2P_CLUSTER;
  String? _endpoint;

  void initMesh() {
    startAdvertising();
    startDiscovery();
  }

  Future<void> startAdvertising() async {
    await Nearby().startAdvertising(
      "RescueNet",
      strategy,
      onConnectionInitiated: (id, _) {
        _endpoint = id;
        Nearby().acceptConnection(
          id,
          onPayLoadRecieved: (_, payload) {
            if (payload.type == PayloadType.BYTES) {
              final data = jsonDecode(utf8.decode(payload.bytes!));
              print("📩 Mesh SOS received: $data");
              print("📩 Mesh SOS received: $data");
              _handleReceivedSOS(data);
            }
          },
          onPayloadTransferUpdate: (_, __) {},
        );
      },
      onConnectionResult: (_, __) {},
      onDisconnected: (_) => _endpoint = null,
    );
  }

  Future<void> startDiscovery() async {
    await Nearby().startDiscovery(
      "RescueNet",
      strategy,
      onEndpointFound: (id, _, __) {
        Nearby().requestConnection(
          "User",
          id,
          onConnectionInitiated: (id, _) {
            _endpoint = id;
            Nearby().acceptConnection(
              id,
              onPayLoadRecieved: (_, payload) {
                if (payload.type == PayloadType.BYTES) {
                  final data = jsonDecode(utf8.decode(payload.bytes!));
                  print("📩 Mesh SOS received: $data");
                }
              },
              onPayloadTransferUpdate: (_, __) {},
            );
          },
          onConnectionResult: (_, __) {},
          onDisconnected: (_) => _endpoint = null,
        );
      },
      onEndpointLost: (_) {},
    );
  }

  Future<void> sendSOS(Map<String, dynamic> data) async {
    if (_endpoint == null) {
      print("⚠️ No mesh peers");
      return;
    }

    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(data)));
    await Nearby().sendBytesPayload(_endpoint!, bytes);
  }

  Future<void> _handleReceivedSOS(Map<String, dynamic> data) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity != ConnectivityResult.none) {
      // ✅ INTERNET AVAILABLE → UPLOAD TO SUPABASE
      try {
        await Supabase.instance.client.from('sos_alerts').insert(data);

        print("🚀 Mesh SOS uploaded to Supabase");
      } catch (e) {
        print("❌ Supabase upload failed: $e");
      }
    } else {
      // ❌ STILL OFFLINE → FORWARD AGAIN
      await sendSOS(data);
      print("🔁 Mesh SOS forwarded");
    }
  }
}
