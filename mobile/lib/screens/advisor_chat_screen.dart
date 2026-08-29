import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/llm_service.dart';
import '../services/chat_history_service.dart';

class AdvisorChatScreen extends StatefulWidget {
  const AdvisorChatScreen({super.key});

  @override
  State<AdvisorChatScreen> createState() => _AdvisorChatScreenState();
}

class _AdvisorChatScreenState extends State<AdvisorChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatHistoryService _history = ChatHistoryService();
  final LlmService _llm = LlmService();

  bool _isTyping = false;
  bool _llmReady = false;
  String _statusText = 'Chargement...';

  @override
  void initState() {
    super.initState();
    _checkAndInitLlm();
  }

  Future<void> _checkAndInitLlm() async {
    // Si déjà prêt (préchargé au démarrage)
    if (_llm.isReady) {
      setState(() {
        _llmReady = true;
        _statusText = 'Prêt';
      });
      return;
    }

    // Sinon initialise maintenant
    setState(() => _statusText = 'Initialisation...');
    try {
      await _llm.initialize();
      if (mounted) {
        setState(() {
          _llmReady = true;
          _statusText = 'Prêt';
        });
      }
    } catch (e) {
      print('[CHAT] Init error: $e');
      if (mounted) {
        setState(() => _statusText = 'Erreur: $e');
        _history.add({
          'isUser': false,
          'text': '⚠️ Impossible de charger le conseiller.\nErreur : $e',
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isTyping || !_llmReady) return;

    _history.add({'isUser': true, 'text': text});
    _controller.clear();

    if (mounted) setState(() => _isTyping = true);
    _scrollToBottom();

    print('[CHAT] Sending: "$text"');
    final response = await _llm.generate(text);
    print('[CHAT] Got response: "$response"');

    if (mounted) {
      _history.add({'isUser': false, 'text': response});
      setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = _history.messages;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _llmReady
                      ? [const Color(0xFF0F52BA), const Color(0xFF4A90E2)]
                      : [Colors.grey, Colors.grey.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 15),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Conseiller IA',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _llmReady
                            ? Colors.green
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _statusText,
                      style: TextStyle(
                        fontSize: 10,
                        color: _llmReady ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        backgroundColor:
            isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            tooltip: 'Nouvelle conversation',
            onPressed: () async {
              await _llm.resetChat();
              _history.clear();
              if (mounted) setState(() {});
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child:
              Container(height: 1, color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      body: Column(
        children: [
          // Bannière chargement
          if (!_llmReady)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: Colors.orange.withOpacity(0.1),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.orange),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _statusText,
                      style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == messages.length) {
                  return _buildTypingIndicator();
                }
                final msg = messages[index];
                return _buildBubble(
                  msg['text'] as String,
                  msg['isUser'] as bool,
                );
              },
            ),
          ),

          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14, left: 40),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            const SizedBox(width: 5),
            _Dot(delay: 200),
            const SizedBox(width: 5),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F52BA), Color(0xFF4A90E2)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF0F52BA) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isUser
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
                border: isUser
                    ? null
                    : Border.all(color: Colors.grey.shade100),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF0F52BA).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  size: 15, color: Color(0xFF0F52BA)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.grey[50],
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: _llmReady
                        ? const Color(0xFF0F52BA).withOpacity(0.2)
                        : Colors.grey.shade200,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  enabled: _llmReady && !_isTyping,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14),
                  decoration: InputDecoration(
                    hintText: _llmReady
                        ? 'Pose ta question...'
                        : _statusText,
                    hintStyle:
                        TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    prefixIcon: Icon(
                      Icons.psychology_outlined,
                      color: _llmReady
                          ? const Color(0xFF0F52BA)
                          : Colors.grey,
                      size: 20,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _llmReady && !_isTyping ? _sendMessage : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _llmReady && !_isTyping
                        ? [
                            const Color(0xFF0F52BA),
                            const Color(0xFF4A90E2)
                          ]
                        : [Colors.grey.shade300, Colors.grey.shade300],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: _llmReady && !_isTyping
                      ? [
                          BoxShadow(
                              color: const Color(0xFF0F52BA).withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 5))
                        ]
                      : [],
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dot animé ──────────────────────────────────────────────────────────────

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    Future.delayed(
        Duration(milliseconds: widget.delay),
        () => mounted ? _ctrl.repeat(reverse: true) : null);
    _anim = Tween(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
            color: Color(0xFF0F52BA), shape: BoxShape.circle),
      ),
    );
  }
}