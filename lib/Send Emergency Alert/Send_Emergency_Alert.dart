import 'package:flutter/material.dart';
import '../services/sos_service.dart';

class SendEmergencyAlertScreen extends StatefulWidget {
  const SendEmergencyAlertScreen({super.key});

  @override
  State<SendEmergencyAlertScreen> createState() =>
      _SendEmergencyAlertScreenState();
}

class _SendEmergencyAlertScreenState extends State<SendEmergencyAlertScreen> {
  final SosService _sosService = SosService();
  bool sending = false;

  final List<Map<String, String>> emergencyTypes = [
    {"label": "Fire", "icon": "🔥"},
    {"label": "Flood", "icon": "🌊"},
    {"label": "Earthquake", "icon": "🏚️"},
    {"label": "Medical", "icon": "🏥"},          
    {"label": "Accident", "icon": "🚨"},
    {"label": "Violence", "icon": "⚠️"},
    {"label": "Other", "icon": "❗"},
  ];

  // Future<void> _send(String type) async {
  //   if (sending) return;
  //   setState(() => sending = true);

  //   await _sosService.sendSOS(type: type);

  //   if (!mounted) return;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("$type SOS sent"),
  //       backgroundColor: Colors.green,
  //     ),
  //   );

  //   Navigator.pop(context);
  // }
  Future<void> _send(String type) async {
    if (sending) return;
    setState(() => sending = true);

    try {
      await _sosService.sendSOS(type: type);
      // .timeout(const Duration(seconds: 10)); // ⏱️ TIMEOUT ONLY HERE

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$type SOS sent successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("SOS sending failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => sending = false);
      }
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Send Emergency Alert")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: emergencyTypes.map((e) {
//             return GestureDetector(
//               onTap: () => _send(e['label']!),
//               child: Container(
//                 width: 110,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.red),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(e['icon']!, style: const TextStyle(fontSize: 32)),
//                     const SizedBox(height: 8),
//                     Text(e['label']!,
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

// // i think this is my file
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Emergency Alert")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: emergencyTypes.map((e) {
                return GestureDetector(
                  onTap: sending ? null : () => _send(e['label']!),
                  child: Opacity(
                    opacity: sending ? 0.5 : 1,
                    child: Container(
                      width: 110,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Column(
                        children: [
                          Text(e['icon']!,
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(
                            e['label']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          /// 🔴 LOADING OVERLAY
          if (sending)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "Please wait...\nSending SOS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
