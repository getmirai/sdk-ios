<p align="center">
  <picture>
    <img alt="Mirai" src="https://artifacts.getmirai.co/social/github/header.jpg" style="max-width: 100%;">
  </picture>
</p>

<a href="https://notebooklm.google.com/notebook/5851ef05-463e-4d30-bd9b-01f7668e8f8f/audio"><img src="https://img.shields.io/badge/Listen-Podcast-red" alt="Listen to our Podcast"></a>
<a href="https://docsend.com/view/x87pcxrnqutb9k2q"><img src="https://img.shields.io/badge/View-Our%20Deck-green" alt="View our Deck"></a>
<a href="mailto:dima@getmirai.co,Alexey@getmirai.co?subject=Interested%20in%20Mirai"><img src="https://img.shields.io/badge/Contact%20Us-Email-blue" alt="Contact Us"></a>

`Mirai` is an SDK for highly optimized on-device LLM inference.

## Usage

### Download model

```swift
import Mirai

let engine = MiraiEngine.shared
let model = ModelsRegistry.llama_3_2_1b_instruct
guard let files = try await engine.storage.download(model: model) else {
    return
}
```

### Create inference session

- You can optionally select a configuration for your specific use case from the following list: `general`, `chat`, `summarization`, `classification`.
- Choosing the appropriate configuration significantly increases inference speed by utilizing specialized optimization techniques.

```swift
let session = try await engine.session(model: model, modelFiles: files)
try await session.updateConfiguration(.forType(.general))
try await session.load()
```

### Run

If you want to get an answer for a specific prompt, use the `text` input:

```swift
try await session.run(input: .text("Ultimate Question of Life, the Universe, and Everything")) { result in
    if result.finished {
        print(result.text)
    }
}
```

You can also use a list of `messages` as an input:

```swift
let messages = [
    Message(text: "Hi", role: .user),
    Message(text: "How can I help you?", role: .assistant),
    Message(text: "Tell me a story", role: .user)
]
try await session.run(input: .messages(messages)) { result in
    if result.finished {
        print(result.text)
    }
}
```

## Thank you!

If you have any questions, just drop us a message at [contact@getmirai.co](mailto:contact@getmirai.co).
