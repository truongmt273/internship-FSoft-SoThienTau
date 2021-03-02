import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volume/volume.dart';

class VoiceCall extends StatefulWidget {
  final List<String> getPhoneno;
  VoiceCall({this.getPhoneno});
  @override
  _VoiceCallState createState() => _VoiceCallState();
}
class _VoiceCallState extends State<VoiceCall>{
  AudioManager audioManager;
  bool muted = false;
  bool speaker = false;
  bool isMuted = false;
  bool paused = false;
  int  currentVol;
  Timer _timmerInstance;
  int _start = 0;
  String _timmer = '';
  getcurrentVol() async {
    currentVol = await Volume.getVol;
  }

  void startTimmer() {
    var oneSec = Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
          if (_start < 0) {
            _timmerInstance.cancel();
          } else {
            _start = _start + 1;
            _timmer = getTimerTime(_start);
          }
        }));
  }
  // ignore: missing_return

  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = '0' + minutes.toString();
    } else
      sMinute = minutes.toString();

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = '0' + seconds.toString();
    } else
      sSeconds = seconds.toString();

    return sMinute + ':' + sSeconds;
  }

  @override
  void initState() {
    super.initState();
    startTimmer();
    initVoiceCall();

  }

  Future<void> initVoiceCall() async {
    await Volume.controlVolume(AudioManager.STREAM_VOICE_CALL);
  }
  Future<void> initSpeaker() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }
  setVol(int i) async {
    await Volume.setVol(i);
  }
  Widget _buildChild() {
    if (widget.getPhoneno[3]=='') {
      return Image.asset(
        widget.getPhoneno[3],
        height: 200.0,
        width: 200.0,
      );
    }
    return Icon(
      Icons.person,
      size: 200.0,
      color: Colors.blue,
    );
  }


  @override
  void dispose() {
    _timmerInstance.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.getPhoneno[2],
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                widget.getPhoneno[1],
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                _timmer,
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w300,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(200.0),
                child: _buildChild(),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () async {
                      muted ? await Volume.setVol(0) : await Volume.setVol(currentVol);
                      setState(() {
                        speaker = !speaker;
                      });
                    },
                    child: Icon(
                      speaker ? Icons.phone_in_talk : Icons.phone,
                      color: speaker ? Colors.white : Colors.blueAccent,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: speaker ? Colors.blueAccent : Colors.white,
                    padding: const EdgeInsets.all(14.0),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      setState(() {
                        paused = !paused;
                      });
                    },
                    child: Icon(
                      Icons.pause ,
                      color: paused ? Colors.white : Colors.blueAccent,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: paused ? Colors.redAccent : Colors.white,
                    padding: const EdgeInsets.all(14.0),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      muted ? await Volume.setVol(0) : await Volume.setVol(currentVol);
                      setState(() {
                        muted = !muted;
                      });
                    },
                    child: Icon(
                      muted ? Icons.mic_off : Icons.mic,
                      color: muted ? Colors.white : Colors.blueAccent,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted ? Colors.redAccent : Colors.white,
                    padding: const EdgeInsets.all(14.0),
                  ),
                ],
              ),
              SizedBox(
                height: 120.0,
              ),
              FloatingActionButton(
                elevation: 20.0,
                shape: CircleBorder(side: BorderSide(color: Colors.red)),
                mini: false,
                child: IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.red,
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.red[100],
              )

            ],
          ),
        )
    );
  }
}
