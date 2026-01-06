import 'package:characterexample/api_call.dart';
import 'package:characterexample/meeting_screen.dart';
import 'package:flutter/material.dart';

class JoinScreen extends StatefulWidget {
  JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Character Rive Example",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await createMeeting().then((meetingId) {
                    if (!context.mounted) return;
                    if (_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your name"),
                        ),
                      );
                      return;
                    }
                    if (meetingId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error creating meeting"),
                        ),
                      );
                      return;
                    }
                    var name = _nameController.text;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            //AnimationScreen(),
                            MeetingScreen(
                          meetingId: meetingId,
                          token: token,
                          name: name,
                        ),
                      ),
                    );
                    _nameController.clear();
                  });
                },
                child: Text("Start An Interaction")),
          ],
        ),
      ),
    );
  }
}
