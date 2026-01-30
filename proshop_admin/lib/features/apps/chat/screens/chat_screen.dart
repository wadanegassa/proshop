import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 180,
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.divider),
      ),
      child: const Row(
        children: [
          // Left - Users List
          SizedBox(
            width: 320,
            child: Column(
              children: [
                _ChatSearchHeader(),
                Expanded(child: _ChatUserList()),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: AdminColors.divider),
          // Middle - Chat Messages
          Expanded(
            child: Column(
              children: [
                _ChatHeader(),
                Expanded(child: _ChatMessageList()),
                _ChatInput(),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: AdminColors.divider),
          // Right - Profile Info
          SizedBox(
            width: 300,
            child: _ChatProfileSidebar(),
          ),
        ],
      ),
    );
  }
}

class _ChatSearchHeader extends StatelessWidget {
  const _ChatSearchHeader();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search message...',
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.divider)),
        ),
      ),
    );
  }
}

class _ChatUserList extends StatelessWidget {
  const _ChatUserList();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildUserItem('Gaston Lapierre', 'How are you?', '09:40 am', true, 2),
        _buildUserItem('Alice Freeman', 'Can you check the...', '08:30 am', false, 0),
        _buildUserItem('John Smith', 'Payment received!', 'Yesterday', false, 0),
        _buildUserItem('Sarah Connor', 'I\'ll be back.', '2 days ago', false, 0),
      ],
    );
  }

  Widget _buildUserItem(String name, String lastMsg, String time, bool isActive, int unreadCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: isActive ? AdminColors.primary.withValues(alpha: 0.05) : Colors.transparent,
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$name')),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lastMsg, style: const TextStyle(color: AdminColors.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AdminColors.primary, shape: BoxShape.circle),
                        child: Text(unreadCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AdminColors.divider))),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=Gaston')),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gaston Lapierre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Online', style: TextStyle(color: AdminColors.success, fontSize: 12)),
            ],
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.phone_outlined, color: AdminColors.textMuted), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: AdminColors.textMuted), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: AdminColors.textMuted), onPressed: () {}),
        ],
      ),
    );
  }
}

class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildBubble('Hello! How can I help you today?', false, '09:40 am'),
        _buildBubble('I need to check my last order status.', true, '09:41 am'),
        _buildBubble('Sure! Can you provide the order ID?', false, '09:42 am'),
        _buildBubble('The order ID is #0758267/90.', true, '09:43 am'),
        _buildBubble('Checking it right now...', false, '09:43 am'),
      ],
    );
  }

  Widget _buildBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: isMe ? AdminColors.primary : AdminColors.background,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isMe ? 12 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 12),
              ),
            ),
            child: Text(text, style: TextStyle(color: isMe ? Colors.white : AdminColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(color: AdminColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AdminColors.divider))),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.attach_file, color: AdminColors.textMuted), onPressed: () {}),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AdminColors.textMuted),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.emoji_emotions_outlined, color: AdminColors.textMuted), onPressed: () {}),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(color: AdminColors.primary, borderRadius: BorderRadius.circular(8)),
            child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

class _ChatProfileSidebar extends StatelessWidget {
  const _ChatProfileSidebar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=Gaston')),
          const SizedBox(height: 16),
          const Text('Gaston Lapierre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text('Full Stack Developer', style: TextStyle(color: AdminColors.textMuted, fontSize: 13)),
          const SizedBox(height: 32),
          _buildInfoRow(Icons.email_outlined, 'Email', 'hello@dundermifflin.com'),
          _buildInfoRow(Icons.phone_outlined, 'Phone', '(723) 732-756-5760'),
          _buildInfoRow(Icons.location_on_outlined, 'Location', 'Washington, USA'),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
            child: const Text('View Full Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AdminColors.textMuted),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AdminColors.textMuted, fontSize: 11)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
