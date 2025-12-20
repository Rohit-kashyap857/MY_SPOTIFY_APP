import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.90,
      child: Drawer(
        backgroundColor: const Color(0xFF121212),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.brown,
                      child: Text(
                        'R',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'username',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'View profile',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Add account
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage("assets/images/image 2.png"),
                      ),
                      SizedBox(width: 10),

                      Icon(Icons.add_circle_outline, color: Colors.white),
                      SizedBox(width: 5),
                      Text("Add account",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Options
                const ListTile(
                  leading: Icon(Icons.bolt, color: Colors.white),
                  title: Text('What’s new',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const ListTile(
                  leading: Icon(Icons.history, color: Colors.white),
                  title: Text('Recents',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title: Text('Settings and privacy',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

