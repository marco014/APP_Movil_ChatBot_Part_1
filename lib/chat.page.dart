import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isConnected = true;

  final String _apiKey = ''; //aqui agregas tu API Key

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _loadMessages();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesJson = prefs.getString('chat_messages');
    if (messagesJson != null) {
      setState(() {
        _messages = (jsonDecode(messagesJson) as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', jsonEncode(_messages));
  }

  Future<void> _sendMessage() async {
    String message = _controller.text.trim();

    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"role": "user", "parts": message});
        _isLoading = true;
        _controller.clear();
      });

      String botResponse = await _getBotResponse(message);

      setState(() {
        _messages.add({"role": "model", "parts": botResponse});
        _isLoading = false;
      });

      _saveMessages();
    }
  }

  Future<String> _getBotResponse(String userMessage) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey');

    // Preparar el historial de mensajes en el formato correcto
    List<Map<String, dynamic>> formattedMessages = _messages.map((message) {
      return {
        "role": message["role"],
        "parts": [
          {"text": message["parts"]}
        ]
      };
    }).toList();

    // Añadir el mensaje actual del usuario
    formattedMessages.add({
      "role": "user",
      "parts": [
        {"text": userMessage}
      ]
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": formattedMessages,
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('candidates') && data['candidates'].isNotEmpty) {
          String botMessage =
              data['candidates'][0]['content']['parts'][0]['text']?.trim() ??
                  'No response from bot';
          return botMessage;
        } else {
          return 'No candidates available in response';
        }
      } catch (e) {
        return 'Error parsing response: $e';
      }
    } else {
      return "Error: ${response.statusCode} ${response.body}";
    }
  }

  

  @override
  Widget build(BuildContext context) {
  const Color pastelPurple = Color(0xFFE1BEE7);
  const Color pastelPink = Color(0xFFF8BBD0);
  const Color accentGreen = Color(0xFF81C784);
  const Color lightBackground = Color(0xFFF5F5F5);
  const Color messageBackground = Color(0xFFE0E0E0);
  const Color botResponseColor = Color(0xFFB3E5FC); // Azul celeste
  const Color whiteColor = Colors.white;

  return Scaffold(
    backgroundColor: lightBackground,
    body: Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = _messages[index]['role'] == 'user';
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 18.0,
                    ),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? messageBackground
                          : botResponseColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(18.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _messages[index]['parts']!,
                      style: TextStyle(
                        color: isUserMessage ? Colors.black87 : whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accentGreen),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Escribe tu mensaje...",
                    hintStyle: const TextStyle(color: Colors.black38),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(
                        color: pastelPurple,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(
                        color: accentGreen,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: whiteColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send, color: accentGreen),
                onPressed: _isConnected ? _sendMessage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
