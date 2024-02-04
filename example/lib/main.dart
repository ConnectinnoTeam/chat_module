import 'package:chat_module/controller/chat_controller.dart';
import 'package:chat_module/model/concrete/chat_gpt/chat_gpt_system_prompt.dart';
import 'package:chat_module/model/concrete/chat_gpt/chat_gpt_user_prompt.dart';
import 'package:chat_module/model/concrete/request/chat_gpt_request.dart';
import 'package:chat_module/provider/concrete/chat_gpt_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  String _text = "";
  final ChatController _chatController = ChatController(
    provider: ChatGptProvider.completions(
      delay: const Duration(milliseconds: 50),
      timeout: const Duration(milliseconds: 500),
      request: ChatGptRequest.turbo3_50(
        prompts: [
          ChatGptSystemPrompt(
            content: "You are cowboy and you are in the wild west",
          ),
        ],
        temperature: 0.5,
        maxToken: 1500,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _chatController.initialize((headers) => headers['Authorization'] =
        "Bearer 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");
    _chatController.hook((message) async {
      setState(() => _text += message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ColoredBox(
        color: Colors.red,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (_textEditingController.text.isEmpty) return;
                    final result = await _chatController.sendMessage(
                      ChatGptUserPrompt(content: _textEditingController.text),
                    );
                    print(result);
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(_text),
        ),
      ),
    );
  }
}
