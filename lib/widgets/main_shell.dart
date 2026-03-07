import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../screens/home_page.dart';
import '../screens/friends_page.dart';
import '../screens/messages_page.dart';
import '../screens/about_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    FriendsPage(),
    MessagesPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final langProvider = Provider.of<LanguageProvider>(context);

    final navLabels = [
      t.translate('nav_home'),
      t.translate('nav_friends'),
      t.translate('nav_messages'),
      t.translate('nav_about'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              t.translate('app_name'),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          // Language toggle button
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: TextButton.icon(
              onPressed: () {
                langProvider.toggleLanguage();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.translate('language_switched')),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Text(
                langProvider.isVietnamese ? '🇻🇳' : '🇺🇸',
                style: const TextStyle(fontSize: 18),
              ),
              label: Text(
                langProvider.isVietnamese ? 'VI' : 'EN',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            activeIcon: const Icon(Icons.home_filled),
            label: navLabels[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: navLabels[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_bubble_outline),
            activeIcon: const Icon(Icons.chat_bubble),
            label: navLabels[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            activeIcon: const Icon(Icons.info),
            label: navLabels[3],
          ),
        ],
      ),
    );
  }
}
