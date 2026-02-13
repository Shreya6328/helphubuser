import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_app/untils/device_id.dart';
import 'Alert_Details_Page.dart';

final supabase = Supabase.instance.client;

class alerts extends StatelessWidget {
  const alerts({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmergencyAlertsPage(),
    );
  }
}

/// ================= EMERGENCY ALERTS PAGE =================
class EmergencyAlertsPage extends StatelessWidget {
  const EmergencyAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Alerts")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: DeviceId.get().asStream().asyncExpand((deviceId) {
          return supabase
              .from('sos_alerts')
              .stream(primaryKey: ['id'])
              .eq('device_id', deviceId) // ⭐ FILTER
              .order('created_at', ascending: false);
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data!;

          final active = alerts
              .where((a) =>
                  a['status'] == 'assigned' ||
                  a['status'] == 'awaiting_user_confirmation')
              .toList();

          final resolved =
              alerts.where((a) => a['status'] == 'completed').toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// ================= ACTIVE =================
              const Text(
                "Active Emergencies",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (active.isEmpty) const Text("No active emergencies"),

              ...active.map((a) => emergencyCard(context, a)),

              const SizedBox(height: 25),

              /// ================= RESOLVED =================
              const Text(
                "Resolved Emergencies",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (resolved.isEmpty) const Text("No resolved emergencies"),

              ...resolved.map((a) => resolvedCard(a)),
            ],
          );
        },
      ),
    );
  }

  /// ================= ACTIVE CARD =================
  Widget emergencyCard(BuildContext context, Map<String, dynamic> a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a['type'] ?? 'UNKNOWN',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "📍 ${a['latitude']} , ${a['longitude']}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            "🚑 Team: ${a['assigned_team']}",
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          if (a['status'] == 'awaiting_user_confirmation')
            SizedBox(
              width: double.infinity,
              child: a['status'] == 'awaiting_user_confirmation'
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AlertDetailsPage(alert: a),
                          ),
                        );
                      },
                      child: const Text("Confirm Resolved"),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  /// ================= RESOLVED CARD =================
  Widget resolvedCard(Map<String, dynamic> a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a['type'] ?? 'UNKNOWN',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "📍 ${a['latitude']} , ${a['longitude']}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            "🚑 Team: ${a['assigned_team']}",
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
