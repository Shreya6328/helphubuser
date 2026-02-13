import 'package:flutter/material.dart';
import '../services/user_profile_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserProfileService _service = UserProfileService();

  bool isEditing = false;
  String safetyStatus = "safe";

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final userIdCtrl = TextEditingController();

  final contactNameCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();

  List<Map<String, String>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _loadLocalProfile();
    _service.syncOfflineData(); // ✅ auto sync
  }

  /// ---------------- LOAD LOCAL DATA ----------------
  void _loadLocalProfile() {
    final data = _service.getLocalProfile();

    if (data != null) {
      nameCtrl.text = data['name'] ?? '';
      phoneCtrl.text = data['phone'] ?? '';
      userIdCtrl.text = data['user_id'] ?? '';
      safetyStatus = data['safety'] ?? 'safe';

      emergencyContacts = List<Map<String, String>>.from(
        (data['contacts'] ?? []).map(
          (e) => Map<String, String>.from(e),
        ),
      );
    } else {
      userIdCtrl.text = "user_${DateTime.now().millisecondsSinceEpoch}";
    }

    setState(() {});
  }

  /// ---------------- SAVE PROFILE ----------------
  Future<void> _saveProfile() async {
    if (userIdCtrl.text.isEmpty) {
      userIdCtrl.text = "user_${DateTime.now().millisecondsSinceEpoch}";
    }

    await _service.saveProfile(
      userId: userIdCtrl.text,
      name: nameCtrl.text,
      phone: phoneCtrl.text,
      safety: safetyStatus,
      emergencyContacts: emergencyContacts,
    );

    setState(() => isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully")),
    );
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile & Safety",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => isEditing = !isEditing),
            child: Text(isEditing ? "Cancel" : "Edit",
                style: const TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Personal Information"),
            _infoCard(),
            const SizedBox(height: 20),
            _sectionTitle("Safety Status"),
            _safetyButtons(),
            const SizedBox(height: 20),
            _emergencyContacts(),
            const SizedBox(height: 20),
            _infoNote(),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Save Profile"),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  /// ---------------- WIDGETS ----------------
  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  Widget _infoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          _infoRow(Icons.person, "Name", nameCtrl),
          _infoRow(Icons.phone, "Phone Number", phoneCtrl),
          _infoRow(Icons.verified_user, "User ID", userIdCtrl, enabled: false),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    TextEditingController ctrl, {
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: isEditing && enabled
          ? TextField(controller: ctrl)
          : Text(ctrl.text.isEmpty ? "-" : ctrl.text),
      subtitle: Text(label),
    );
  }

  Widget _safetyButtons() {
    return Column(
      children: [
        _safetyButton("I'm Safe", Colors.green, "safe"),
        _safetyButton("Need Help", Colors.red, "help"),
        // _safetyButton("Unknown", Colors.grey, "unknown"),
      ],
    );
  }

  Widget _safetyButton(String text, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        onPressed:
            isEditing ? () => setState(() => safetyStatus = value) : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          backgroundColor:
              safetyStatus == value ? color.withOpacity(0.15) : null,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(text, style: TextStyle(color: color)),
      ),
    );
  }

  Widget _emergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Emergency Contacts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (isEditing)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: _addContactDialog,
              )
          ],
        ),
        ...emergencyContacts.map(
          (c) => Card(
            child: ListTile(
              title: Text(c['name'] ?? ''),
              subtitle: Text(c['phone'] ?? ''),
              trailing: isEditing
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          setState(() => emergencyContacts.remove(c)),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Your information is stored locally and syncs automatically when internet is available.",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  /// ---------------- ADD CONTACT DIALOG ----------------
  void _addContactDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contactNameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: contactPhoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (contactNameCtrl.text.isNotEmpty &&
                  contactPhoneCtrl.text.isNotEmpty) {
                emergencyContacts.add({
                  "name": contactNameCtrl.text,
                  "phone": contactPhoneCtrl.text,
                });
              }

              contactNameCtrl.clear();
              contactPhoneCtrl.clear();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
