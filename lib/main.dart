import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as fmtc;
import 'package:flutter/foundation.dart';

import 'map_screen/map_screen.dart';
import 'Profile/user_profile_page.dart';
import 'Send Emergency Alert/Send_Emergency_Alert.dart';
import 'services/sos_service.dart';
import 'HelpLine/HelpLine.dart';
import 'Tips/tips.dart';
import 'Alerts/alerts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INITIALIZE TILE CACHING (v10)
  try {
  if (!kIsWeb) {
    await fmtc.FMTCObjectBoxBackend().initialise();
    await fmtc.FMTCStore('offlineMap').manage.create();
  }
} catch (e) {
  print("Tile caching error: $e");
}

  // 🔹 LOCAL STORAGE
 await Hive.initFlutter();

try {
  await Hive.openBox('offline_profile');
  await Hive.openBox('offline_sos');
} catch (e) {
  print("Hive error: $e");
}

  // 🔹 SUPABASE
  try {
  await Supabase.initialize(
    url: 'https://iqwbgmlpkfaqytjqcphh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlxd2JnbWxwa2ZhcXl0anFjcGhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1OTMwNzEsImV4cCI6MjA4MTE2OTA3MX0.HzwheFwYCrjUJ6KRQfAoMkrJU60GoMD2Y9uJZMX__nY',
  );
} catch (e) {
  print("Supabase init error: $e");
}
  await ensureAnonymousLogin(); // ✅ ADD THIS LINE

  runApp(const RescueNetApp());
}

class RescueNetApp extends StatelessWidget {
  const RescueNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RescueNet',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const DashboardNavigation(),
    );
  }
}


Future<void> ensureAnonymousLogin() async {
  final supabase = Supabase.instance.client;

  if (supabase.auth.currentUser == null) {
    await supabase.auth.signInAnonymously();
  }
}


/// ----------------------------------------------------
/// BOTTOM NAVIGATION
/// ----------------------------------------------------
class DashboardNavigation extends StatefulWidget {
  const DashboardNavigation({super.key});

  @override
  State<DashboardNavigation> createState() => _DashboardNavigationState();
}

class _DashboardNavigationState extends State<DashboardNavigation> {
  int index = 0;

  final pages = const [
    DashboardScreen(),
    MapScreen(),
    alerts(),
    UserProfilePage(),
    HelpLine(),
    Tips(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings), label: "HelpLine"),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: "Tips"),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------
/// DASHBOARD SCREEN
/// ----------------------------------------------------
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseClient client = Supabase.instance.client;

  List alerts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    SosService().syncOfflineSOS();
    // meshService.startAdvertising("USER_${DateTime.now().millisecondsSinceEpoch}");
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    final data = await client
        .from('sos_alerts')
        .select()
        .order('created_at', ascending: false)
        .limit(5);

    setState(() {
      alerts = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f9),
      appBar: AppBar(
        title: const Text("RescueNet", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("RescueNet",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const Text("Emergency Response System",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     statCard(Icons.warning, Colors.red, alerts.length.toString(),
            //         "Active Alerts"),
            //     statCard(Icons.groups, Colors.green, "0", "Total Reports"),
            //     statCard(Icons.monitor_heart, Colors.orange, "Active",
            //         "Your Status"),
            //   ],
            // ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SendEmergencyAlertScreen(),
                  ),
                );
                fetchAlerts();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 28, horizontal: 120),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.warning, size: 48, color: Colors.white),
                    SizedBox(height: 10),
                    Text("SEND SOS",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            // const Text("Recent Alerts Nearby",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // const SizedBox(height: 12),

            // loading
            //     ? const Center(child: CircularProgressIndicator())
            //     : alerts.isEmpty
            //         ? const Center(
            //             child: Padding(
            //               padding: EdgeInsets.all(20),
            //               child: Text("No active alerts"),
            //             ),
            //           )
            //         : ListView.builder(
            //             shrinkWrap: true,
            //             physics: const NeverScrollableScrollPhysics(),
            //             itemCount: alerts.length,
            //             itemBuilder: (context, index) {
            //               final alert = alerts[index];
            //               return AlertCard(
            //                 type: alert['type'],
            //                 description: alert['description'],
            //                 time: alert['created_at'],
            //               );
            //             },
            //           ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------------------------------
/// ALERT CARD
/// ----------------------------------------------------
class AlertCard extends StatelessWidget {
  final String type;
  final String description;
  final String time;

  const AlertCard({
    super.key,
    required this.type,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.red),
                const SizedBox(width: 8),
                Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(time.substring(11, 16),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

/// ----------------------------------------------------
/// STAT CARD
/// ----------------------------------------------------
Widget statCard(IconData icon, Color color, String value, String label) {
  return Container(
    width: 105,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4),
      ],
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ),
  );
}
