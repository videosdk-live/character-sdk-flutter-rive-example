# 🧠 Rive Character Integration with VideoSDK

A Flutter Rive Example to Showcase Interactive Animated Characters

- [Rive](https://rive.app) is a real-time animation framework that makes it easy to design interactive and responsive animations for apps, games, and websites.
- In this Flutter Rive example, we showcase how Rive characters can serve as dynamic avatars that react to events such as speech, gestures, or user interactions. 

---

## ✨ Features

- 🔊 Real-time voice conversation with AI
- 🎭 Interactive Rive character animations synced to voice state (talking, listening)
- 🧠 Supports persona, memory, multilingual input
- ⚡ Lightweight, voice-only setup — great for audio-first apps
- 🧩 Simple and extendable UI logic
---

## 🚀 Getting Started

### 📦 Prerequisites

- Flutter SDK (3.13.0 or above recommended)
- A [VideoSDK account](https://app.videosdk.live/) and API key

---

### 🛠️ Setup Instructions

1. **Clone the Repository**

```bash
git clone https://github.com/videosdk-live/character-sdk-flutter-rive-example.git
cd flutter-rive-example
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Add Your VideoSDK Token**

Open the file `lib/api_call.dart` and replace the token placeholder with your token:

```js
// lib/api_call.dart
String token = "<Generated-from-Dashboard>"; // <-- Replace this
```

You can generate a token from [VideoSDK Dashboard](https://app.videosdk.live/api-keys).

4. **Start the App**

```bash
flutter run
```

---

## 📁 Project Structure

Currently, the Rive character is provided in the assets folder. However, you can customize it as needed. To do so, visit the [Rive Editor](https://rive.app/editor) or the [Rive Marketplace](https://rive.app/marketplace/), select or create a character, export it, and add it to the assets folder in your project. Once added, you can use the new character in your application.

```
/character-sdk-flutter-rive-example/
├── assets/
│  ├── character.riv           # Rive character exported from rive editor
├── lib/
│   ├── main.dart               # App entry point
│   ├── api_call.dart           # Handles VideoSDK token & meeting creation
│   ├── join_screen.dart        # Onboarding UI for entering name/meeting ID
│   ├── meeting_screen.dart     # Main screen for AI character meeting
│   ├── character_tile.dart     # Widget to render Rive character's video and Audio  
│   └── meeting_controls.dart   # Mute/unmute, leave Meeting Button
```

---

## 💡 Use Case Ideas

- Virtual call center agents  
- AI sales reps & support bots  
- Voice therapist or mental health assistants  
- Language tutors or practice partners  

---

## Demo Example

<div align="center">
  
<video src="https://github.com/user-attachments/assets/9b5fa7d4-427f-4ea2-ad1a-b3aa7a7e064f" />
</div>

## ❓ Need Help?

- 💬 [Join Discord](https://discord.com/invite/f2WsNDN9S5)
- 📧 [Email Support](mailto:support@videosdk.live)

> Built with ❤️ by [VideoSDK](https://videosdk.live)

