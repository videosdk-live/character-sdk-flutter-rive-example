import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:videosdk/videosdk.dart';

class CharacterTile extends StatefulWidget {
  final Room room;
  const CharacterTile({super.key, required this.room});
  @override
  State<StatefulWidget> createState() {
    return _CharacterTileState();
  }
}

class _CharacterTileState extends State<CharacterTile> {
  Stream? videoStream;
  Stream? audioStream;
  late Character character;
  bool characterJoined = false;
  CharacterState? characterState;
  Artboard? riveArtboard;

  late RiveAnimationController _TalkingController;
  late RiveAnimationController _BlinkingController;

  @override
  void initState() {
    super.initState();

    CharacterConfig characterConfig = CharacterConfig.newInteraction(
      characterId: "rive-character",
      displayName: "Isha",
      characterRole: "teacher",
      characterMode: CharacterMode.AUTO_PILOT,
    );
    character = widget.room.createCharacter(characterConfig: characterConfig);
    registerCharacterEvents();
    character.join();
  }

  Future<void> _initRive() async {
    await RiveFile.initialize();

    rootBundle.load('assets/character.riv').then(
      (data) {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;

          _BlinkingController = SimpleAnimation('Blinking');
          _TalkingController = SimpleAnimation('Talking');
          artboard.addController(_BlinkingController);

          setState(() {
            riveArtboard = artboard;
          });
        } catch (e) {
          print('Rive error: $e');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // While the artboard is still loading
    if (riveArtboard == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      );
    }

    // Once artboard is ready
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          characterJoined
              ? "Character: ${character.displayName} | State : ${characterState?.name}"
              : "Character Joining...",
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: kIsWeb || Platform.isWindows || Platform.isMacOS ? 600 : 600,
          height: kIsWeb || Platform.isWindows || Platform.isMacOS ? 500 : 450,
          child: Rive(
            artboard: riveArtboard!,
          ),
        ),
        const SizedBox(height: 5),
        if (characterJoined)
          ElevatedButton(
            onPressed: () {
              character.interrupt();
            },
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
            ),
            child: const Text(
              'Interrupt Character',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  void registerCharacterEvents() {
    character.on(Events.characterJoined, (Character character) {
      

      setState(() {
        characterJoined = true;
      });
      _initRive();
    });

    character.on(Events.characterStateChanged, (CharacterState state) {
      setState(() {
        characterState = state;
      });

      if (state.name == "CHARACTER_LISTENING") {
        _TalkingController.isActive = false;
      } else if (state.name == "CHARACTER_SPEAKING") {
        _TalkingController = SimpleAnimation('Talking');
        riveArtboard?.addController(_TalkingController);
      } else if (state.name == "CHARACTER_THINKING") {
        _TalkingController.isActive = false;
      }
    });
  }
}
