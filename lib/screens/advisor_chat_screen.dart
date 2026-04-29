import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AdvisorChatScreen extends StatefulWidget {
  const AdvisorChatScreen({super.key});

  @override
  State<AdvisorChatScreen> createState() => _AdvisorChatScreenState();
}

class _AdvisorChatScreenState extends State<AdvisorChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Bonjour ! Je suis votre conseiller IA. Comment puis-je vous aider dans votre orientation aujourd\'hui ?'
    },
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _controller.clear();
      _isTyping = true;
    });

    _generateResponse(text);
  }

  void _generateResponse(String userText) {
    String response;
    final query = userText.toLowerCase();

    if (query.contains('école') || query.contains('etablissement')) {
      response = 'Nous avons répertorié plus de 50 établissements au Burkina Faso. Vous pouvez consulter la liste dans l\'onglet "ÉCOLES" pour voir les détails et postuler.';
    } else if (query.contains('informatique') || query.contains('logiciel') || query.contains('tech')) {
      response = 'L\'informatique est un secteur très dynamique. Au Burkina, des instituts comme l\'ESI ou l\'IST offrent d\'excellentes formations en Génie Logiciel.';
    } else if (query.contains('médecine') || query.contains('santé')) {
      response = 'La santé est une noble vocation. L\'Université Joseph Ki-Zerbo possède l\'une des facultés de médecine les plus renommées de la sous-région.';
    } else if (query.contains('bourse')) {
      response = 'Il existe plusieurs bourses : nationales (FONER), d\'excellence, et internationales. Regardez la section "Bourses" dans l\'onglet ÉCOLES.';
    } else if (query.contains('merci') || query.contains('au revoir')) {
      response = 'Je vous en prie ! N\'hésitez pas si vous avez d\'autres questions sur votre futur parcours.';
    } else {
      response = 'C\'est une question intéressante. D\'après votre profil, je vous suggère de regarder les filières qui allient vos passions et les besoins du marché actuel.';
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'isUser': false,
            'text': response
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conseiller IA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('En ligne', style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildChatBubble(msg['text'], msg['isUser']);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'IA est en train d\'écrire...',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryLight : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: isUser ? null : Border.all(color: isDark ? AppColors.borderDark : Colors.grey[100]!),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
            height: 1.5,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Posez votre question...',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
