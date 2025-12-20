import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // --------------------------
          // ACCOUNT SECTION
          // --------------------------
          _sectionTitle("Account"),
          _settingsTile(
            icon: Icons.person,
            title: "Profile",
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.mail,
            title: "Email",
            trailing: const Text("example@gmail.com", style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.lock,
            title: "Password",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // --------------------------
          // PLAYBACK SECTION
          // --------------------------
          _sectionTitle("Playback"),
          _switchTile(
            icon: Icons.wifi,
            title: "Data Saver Mode",
            value: true,
            onChanged: (v) {},
          ),
          _switchTile(
            icon: Icons.play_circle_fill,
            title: "Auto Play Next Song",
            value: false,
            onChanged: (v) {},
          ),
          _switchTile(
            icon: Icons.download,
            title: "Download using Wi-Fi only",
            value: true,
            onChanged: (v) {},
          ),

          const SizedBox(height: 20),

          // --------------------------
          // APP SETTINGS
          // --------------------------
          _sectionTitle("App Settings"),
          _settingsTile(
            icon: Icons.color_lens,
            title: "Theme",
            trailing: const Text("Dark", style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.language,
            title: "Language",
            trailing: const Text("English", style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // --------------------------
          // ABOUT SECTION
          // --------------------------
          _sectionTitle("About"),
          _settingsTile(
            icon: Icons.info,
            title: "About App",
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.shield,
            title: "Privacy Policy",
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.description,
            title: "Terms & Conditions",
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // LOGOUT
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --------------------------
  // SECTION TITLE WIDGET
  // --------------------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --------------------------
  // NORMAL TILE
  // --------------------------
  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    void Function()? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // --------------------------
  // SWITCH TILE
  // --------------------------
  Widget _switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.greenAccent,
      secondary: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }
}

