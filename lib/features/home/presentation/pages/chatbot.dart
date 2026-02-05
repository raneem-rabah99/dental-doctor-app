import 'package:dio/dio.dart';
import 'package:doctor/core/api/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// =======================================================
/// API — POST /v1/chat/message
/// =======================================================
class ByteDentChatMessageApi {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<ChatMessageResponse> sendMessage({
    required String message,
    String? conversationId,
  }) async {
    final token = await _storage.read(key: "token");
    if (token == null) {
      throw Exception("User not authenticated");
    }

    /// 🔥 FIX 1: لا ترسل conversation_id إذا كان null أو فارغ
    final Map<String, dynamic> payload = {
      "message": message,
      if (conversationId != null && conversationId.isNotEmpty)
        "conversation_id": conversationId,
    };

    final Response response = await ApiClient.dio.post(
      "/v1/chat/message",
      data: payload,

      options: Options(
        sendTimeout: const Duration(minutes: 5), // 🔥 هنا
        receiveTimeout: const Duration(minutes: 5),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json", // 🔥 FIX 2
        },
      ),
    );

    /// 🔍 DEBUG (احذفها لاحقًا)
    debugPrint("CHAT STATUS: ${response.statusCode}");
    debugPrint("CHAT RAW RESPONSE: ${response.data}");

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data["success"] == true &&
        response.data["data"] != null) {
      return ChatMessageResponse.fromJson(response.data["data"]);
    }

    if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    }

    throw Exception("Chat service error");
  }
}

class ChatMessageResponse {
  final String response;
  final String conversationId;

  ChatMessageResponse({required this.response, required this.conversationId});
  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      // 🔥 FIX: backend uses "answer" not "response"
      response: (json["answer"] ?? "").toString(),
      conversationId: (json["conversation_id"] ?? "").toString(),
    );
  }
}

/// =======================================================
/// UI MODELS & COLORS
/// =======================================================
class ByteDentColors {
  static const darkBlue = Color(0xFF0B1E3B);
  static const lightBlue = Color(0xFF4DA3FF);
  static const panel = Color(0xFF102A4F);
}

class UiChatMessage {
  final bool isUser;
  final String text;

  UiChatMessage({required this.isUser, required this.text});
}

/// =======================================================
/// FLOATING BUTTON
/// =======================================================
class ByteDentChatButton extends StatelessWidget {
  final ByteDentChatMessageApi api;

  const ByteDentChatButton({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ByteDentColors.lightBlue,
      child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => SafeArea(child: ByteDentChatDialog(api: api)),
        );
      },
    );
  }
}

/// =======================================================
/// CHAT DIALOG (SAME UI)
/// =======================================================
class ByteDentChatDialog extends StatefulWidget {
  final ByteDentChatMessageApi api;

  const ByteDentChatDialog({super.key, required this.api});

  @override
  State<ByteDentChatDialog> createState() => _ByteDentChatDialogState();
}

class _ByteDentChatDialogState extends State<ByteDentChatDialog> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<UiChatMessage> _messages = [
    UiChatMessage(
      isUser: false,
      text: "Ask me anything about teeth or ByteDent 🤖🦷",
    ),
  ];

  bool _sending = false;
  String? _conversationId;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _messages.add(UiChatMessage(isUser: true, text: text));
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final reply = await widget.api.sendMessage(
        message: text,
        conversationId: _conversationId,
      );

      if (!mounted) return;

      setState(() {
        /// 🔥 FIX 3: خزّن conversation_id الصحيح فقط
        if (reply.conversationId.isNotEmpty) {
          _conversationId = reply.conversationId;
        }

        _messages.add(UiChatMessage(isUser: false, text: reply.response));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          UiChatMessage(
            isUser: false,
            text: "⚠️ An error occurred while sending",
          ),
        );
      });
    } finally {
      if (!mounted) return;
      setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ByteDentColors.panel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 520,
        height: 640,
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: ByteDentColors.darkBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.medical_services, color: Colors.white),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "ByteDent Chat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // MESSAGES
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(14),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  return Align(
                    alignment:
                        m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 420),
                      decoration: BoxDecoration(
                        color:
                            m.isUser
                                ? ByteDentColors.lightBlue.withOpacity(0.22)
                                : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        m.text,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // INPUT
            Container(
              padding: const EdgeInsets.all(12),
              color: ByteDentColors.darkBlue,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: "Write your question here...",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon:
                        _sending
                            ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                            : const Icon(Icons.send, color: Colors.white),
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
