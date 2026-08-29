class ChatHistoryService {
  static final ChatHistoryService _instance = ChatHistoryService._internal();
  factory ChatHistoryService() => _instance;
  ChatHistoryService._internal();

  final List<Map<String, dynamic>> messages = [
    {
      'isUser': false,
      'text': 'Bonjour ! Je suis ton conseiller IA. Comment puis-je t\'aider dans ton orientation aujourd\'hui ?'
    },
  ];

  void add(Map<String, dynamic> message) => messages.add(message);

  void clear() {
    messages.clear();
    messages.add({
      'isUser': false,
      'text': 'Bonjour ! Je suis ton conseiller IA. Comment puis-je t\'aider dans ton orientation aujourd\'hui ?'
    });
  }
}