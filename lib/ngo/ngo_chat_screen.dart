import 'package:flutter/material.dart';

// --- NGO CHAT PAGE (Adapted from Donor Chat Screen, NGO Perspective) ---

class NgoChatScreen extends StatelessWidget {
  const NgoChatScreen({super.key});

  final List<Map<String, String>> mockChats = const [
    {'name': 'John Doe', 'lastMessage': 'I can donate 10 laptops for your school.', 'time': '10:00 AM', 'isNew': 'true'},
    {'name': 'Jane Smith', 'lastMessage': 'Thank you for accepting my book donation!', 'time': 'Yesterday', 'isNew': 'false'},
    {'name': 'Mike Johnson', 'lastMessage': 'Your pledge request has been fulfilled.', 'time': 'Mon', 'isNew': 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: mockChats.length,
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
              child: Text(chat['name']![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            title: Text(chat['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(chat['lastMessage']!, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(chat['time']!, style: TextStyle(color: chat['isNew'] == 'true' ? Colors.teal : Colors.grey, fontSize: 12)),
                if (chat['isNew'] == 'true')
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.redAccent,
                    ),
                  )
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NgoChatDetailScreen(donorName: chat['name']!)));
            },
          );
        },
      ),
    );
  }
}

// Helper: Specific chat detail screen for NGO
class NgoChatDetailScreen extends StatelessWidget {
  final String donorName;
  const NgoChatDetailScreen({required this.donorName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $donorName'),
        backgroundColor: Colors.teal.shade600,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.white)),
        ],
      ),
      body: Column(
        children: [
          // Mock Chat Messages (NGO Perspective: NGO is sender)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              reverse: true,
              children: const [
                _ChatBubble(
                    text: 'We are dispatching our volunteer for pickup at your location tomorrow morning!',
                    isSender: true), // NGO sending
                _ChatBubble(text: 'Great, thank you!', isSender: false), // Donor responding
                _ChatBubble(
                    text: 'Pledge Confirmed: 10x Laptops. Please coordinate pickup via this chat.',
                    isSender: true,
                    isSystem: true), // System message from NGO side
                _ChatBubble(text: 'Hi, I just pledged 10 laptops for your school.', isSender: false), // Donor initiating
              ],
            ),
          ),
          // Input area
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Mock send
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for Chat Bubbles
class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final bool isSystem;

  const _ChatBubble({required this.text, required this.isSender, this.isSystem = false});

  @override
  Widget build(BuildContext context) {
    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    final color = isSender ? Colors.teal.shade100 : Colors.white;
    final margin = isSender
        ? const EdgeInsets.only(top: 8, bottom: 8, left: 60)
        : const EdgeInsets.only(top: 8, bottom: 8, right: 60);

    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 2,
            )
          ],
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}
