import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Friend Requests Section
          Text(
            t.translate('friends_requests'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFriendRequest(context, t, 'Phạm Minh Tuấn', 5, Colors.blue),
          _buildFriendRequest(context, t, 'Nguyễn Thị Hoa', 12, Colors.pink),
          _buildFriendRequest(context, t, 'Trần Đức Mạnh', 3, Colors.green),
          const SizedBox(height: 24),
          // Suggestions Section
          Text(
            t.translate('friends_suggestions'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFriendSuggestion(context, t, 'Lê Thị Mai', 8, Colors.purple),
          _buildFriendSuggestion(
            context,
            t,
            'Hoàng Văn Nam',
            15,
            Colors.orange,
          ),
          _buildFriendSuggestion(context, t, 'Vũ Thị Lan', 2, Colors.teal),
          _buildFriendSuggestion(context, t, 'Đỗ Minh Quân', 7, Colors.red),
          _buildFriendSuggestion(
            context,
            t,
            'Bùi Thị Thanh',
            20,
            Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRequest(
    BuildContext context,
    AppLocalizations t,
    String name,
    int mutualFriends,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: Text(
                name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$mutualFriends ${t.translate('friends_mutual_friends')}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(t.translate('friends_confirm')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(t.translate('friends_delete')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendSuggestion(
    BuildContext context,
    AppLocalizations t,
    String name,
    int mutualFriends,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: Text(
                name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$mutualFriends ${t.translate('friends_mutual_friends')}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, size: 18),
                      label: Text(t.translate('friends_add_friend')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
