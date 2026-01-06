import 'dart:io';

import 'package:characterexample/character_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

import './meeting_controls.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final String token;
  String? name;

  MeetingScreen(
      {super.key, required this.meetingId, required this.token, this.name});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  late Room _room;
  var micEnabled = true;
  var camEnabled = true;
  var showCharacter = false;
  bool _moreThan2Participants = false;
  bool joined = false;

  Map<String, Participant> participants = {};

  @override
  void initState() {
    super.initState();
    // create room

    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: widget.name!,
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: 1,
    );

    setMeetingEventListener();
    _room.join();
  }

  void setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      if (_room.participants.length > 1) {
        setState(() {
          _moreThan2Participants = true;
        });
      } else {
        setState(() {
          joined = true;
          participants[_room.localParticipant.id] = _room.localParticipant;
        });
      }
    });

    _room.on(Events.roomLeft, () {
      participants.clear();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
    _room.on(
        Events.participantLeft,
        (participant) => {
              if (_moreThan2Participants)
                {
                  if (_room.participants.length < 2)
                    {
                      setState(() {
                        joined = true;
                        _moreThan2Participants = false;
                      }),
                    }
                }
            });
  }

  Future<bool> _onWillPop() async {
    _room.leave();
    return true;
  }

  void toggleCharacterView() {
    setState(() {
      showCharacter = !showCharacter;
    });
  }

  @override
  void dispose() {
    _room.off(Events.roomJoined, () {});
    _room.off(Events.roomLeft, () {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Character Sdk"),
        ),
        body: joined
            ? Column(
                children: [
                  Column(
                    children: [
                      if (!kIsWeb &&
                          (Platform.isIOS || Platform.isAndroid) &&
                          !Platform.isMacOS &&
                          !Platform.isWindows)
                        SizedBox(
                          child: CharacterTile(
                            room: _room,
                          ),
                        ),
                      if (kIsWeb || Platform.isWindows || Platform.isMacOS)
                        SizedBox(
                          child: CharacterTile(
                            room: _room,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  MeetingControls(
                    onToggleMicButtonPressed: () {
                      micEnabled ? _room.muteMic() : _room.unmuteMic();
                      setState(() {
                        micEnabled = !micEnabled;
                      });
                    },
                    onLeaveButtonPressed: () {
                      _room.leave();
                    },
                  ),
                ],
              )
            : _moreThan2Participants
                ? Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "More than 2 participants Joined",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Joining...",
                      style: TextStyle(fontSize: 16),
                    )),
      ),
    );
  }
}
