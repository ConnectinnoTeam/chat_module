## Chat-SDK

Chat-SDK easy to use gpt request and response chatbot.

## ChatController Usage

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

## ChatController with Langchain Example Usage

1. You have to create a ChatPromptTemplate.
   
````dart
   final promptTemplate = ChatPromptTemplate.fromPromptMessages([
    SystemChatMessagePromptTemplate.fromTemplate(
      'You are a helpful chatbot',
    ),
    const MessagesPlaceholder(variableName: 'history'),
    HumanChatMessagePromptTemplate.fromTemplate('{input}'),
  ]);

````

2. Create a LangChainChatService object with the parameters.
   
    * delay -> delay of the stream output
    * apiKey -> api key of the selected LLM model
    * llmEnum -> LLM (Large Language Model) enum. LLMEnum.chatOpenAI uses the completions endpoint of open_ai.
    * selectedTemplate -> prompt template of the service. This takes ChatPromptTemplate type .
    * maxToken -> sets the limit for the total number of tokens LLM model.
    * temperature -> Temperature is a parameter ranging from 0 to 1, which defines the randomness of LLM responses. The higher the temperature, the more diverse and creative the output would   be. On the opposite, when the temperature is low, an LLM will deliver more conservative and deterministic results.
   * memory -> In memory data structure of the chat service. You can manipulate or load previous messages to remember the conversation. MemorySizes.medium stores 50 chat messages. 


   ````dart
      final chatService = LangChainChatService(
          delay: const Duration(milliseconds: 5),
          apiKey: 'YOUR-API-KEY',
          llmEnum: LLMEnum.chatOpenAI,
          selectedTemplate: promptTemplate,
          maxToken: 500,
          temperature: 0.5,
          memory: ConversationBufferWindowMemory(
            returnMessages: true,
            k: MemorySizes.medium,
          ),
        );
  ````

3.Listen its result:
  
  ````dart
     chatService.hook( hook: (text) => { str += text!}, onDone: (reason) => {});
  ````

Result is a finish reason enum. "ChatCompletionFinishReason.finished" is a successful chat finish reason. 
         
           enum ChatCompletionFinishReason {
             maxLength,
             nullResponse,
             finished,
             timeout,
             error;
         }


4. Send user prompt. Wait for the reason. Reason is a finish_reason enum. 

````dart
    final reason = await chatService.sendMessage(humanMessage1); 
````
5. Save conversation to memory. You should clear the output string (str here) before sending other user prompt!

````dart
    await chatService.saveMemory(ChatMessage.humanText(humanMessage1), ChatMessage.ai(str));
````
   
6. You can also cancel a stream. If you cancel a stream, you should not add the input & output messages to the memory. 
   
````dart
    chatService.cancelStream();
````

7. You can clear the memory, if you don't want to save the history messages. 
   
````dart
   chatService.clearMemory();
````

8. You can get all the memory messages ( type of List<ChatMessage>) and save the local cache or send to backend:

````dart
   await chatService.getHistory(); 
````
   
