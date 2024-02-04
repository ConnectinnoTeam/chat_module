## Chat-SDK

Chat-SDK easy to use gpt request and response chatbot.

## Usage

* Create and chat controller
````dart
  final ChatController _chatController = ChatController(
  provider: ChatGptProvider.completions(
    // Writing delay
    delay: const Duration(milliseconds: 50),
    // Timeout duration
    timeout: const Duration(milliseconds: 500),
    // Request model sub class of BaseCompletionRequest
    request: ChatGptRequest.turbo3_50(
      prompts: [
        // Default prompts
        ChatGptSystemPrompt(
          content: "You are cowboy and you are in the wild west",
        ),
      ],
      temperature: 0.5,
      // Maximum token amount for request
      maxToken: 1500,
    ),
  ),
);
````

* Initialize Controller

````dart
  controller.initialize((headers) => YOUR_AUTHORIZE_CONFIG);
  ----------------------------------------------------------
  ex: controller.initialize((headers) => headers['Authorization'] =
      "Bearer YOUR_API_KEY");
  
````

* Listen its result

````dart
    _chatController.hook((message) async {
      setState(() => YOUR_STATE_STRING += message);
    });
````


* Send Prompt


````dart
        final result = await _chatController.sendMessage(
                      ChatGptUserPrompt(content: "YOUR_PROMPT_MESSAGE"),
                       );
                         
         Result is a finish reason enum
         
         ex:
           enum FinishReason {
             maxLength,
             finished,
             timeout,
             error;
         }

                       
````

