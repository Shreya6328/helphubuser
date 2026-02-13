import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AlertDetailsPage extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertDetailsPage({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔴 ALERT TYPE
            Text(
              alert['type'] ?? 'UNKNOWN',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// 📍 LOCATION
            Text(
              "📍 Location:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${alert['latitude']} , ${alert['longitude']}"),

            const SizedBox(height: 12),

            /// 🚑 TEAM
            Text(
              "🚑 Assigned Team:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(alert['assigned_team'] ?? 'Not Assigned'),

            const SizedBox(height: 12),

            /// ⏱ TIME
            Text(
              "⏱ Created At:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(alert['created_at'] ?? ''),

            // ================= RESOLVED PHOTOS =================
            if (alert['resolved_photos'] != null &&
                (alert['resolved_photos'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                "Rescue Photos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alert['resolved_photos'].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final imageUrl = alert['resolved_photos'][index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  );
                },
              ),
            ],

            const Spacer(),

            /// ✅ FINAL CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  await supabase
                      .from('sos_alerts')
                      .update({'status': 'completed'}).eq('id', alert['id']);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Alert marked as resolved"),
                      ),
                    );

                    Navigator.pop(context); // back to alerts list
                  }
                },
                child: const Text(
                  "CONFIRM RESOLVED",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
