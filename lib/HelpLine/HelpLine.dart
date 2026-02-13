import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HelpLine());
}

class HelpLine extends StatelessWidget {
  const HelpLine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Dial',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const EmergencyHomePage(),
    );
  }
}

class EmergencyHomePage extends StatelessWidget {
  const EmergencyHomePage({super.key});

  Future<void> _callNumber(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget emergencyCard({
    required String title,
    required String number,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _callNumber(number),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              number,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Numbers"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            emergencyCard(
              title: "All Emergency",
              number: "9307798100",
              icon: Icons.warning,
              color: const Color.fromARGB(255, 227, 133, 133),
            ),
            emergencyCard(
              title: "Police",
              number: "100",
              icon: Icons.local_police,
              color: const Color.fromARGB(255, 130, 186, 232),
            ),
            emergencyCard(
              title: "Fire",
              number: "112",
              icon: Icons.local_fire_department,
              color: const Color.fromARGB(255, 231, 181, 106),
            ),
            emergencyCard(
              title: "Ambulance",
              number: "108",
              icon: Icons.local_hospital,
              color: const Color.fromARGB(255, 118, 237, 122),
            ),
            emergencyCard(
              title: "Disaster Help",
              number: "9545199228",
              icon: Icons.support_agent,
              color: const Color.fromARGB(255, 228, 135, 244),
            ),
            emergencyCard(
              title: "Women Helpline",
              number: "181",
              icon: Icons.woman,
              color: const Color.fromARGB(255, 251, 142, 178),
            ),
          ],
        ),
      ),
    );
  }
}
