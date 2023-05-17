import 'dart:io';

import 'package:flutter/material.dart';

import 'music_player.dart';

class Tracks extends StatefulWidget {
_TracksState createState()=>_TracksState();
}
class _TracksState extends State<Tracks> {
  final FlutterAudioQuery audioQuery=FlutterAudioQuery();
  List<SongInfo> songs=[];
  int currentIndex=0;
  final GlobalKey<MusicPlayerState> key=GlobalKey<MusicPlayerState>();
  void initState()  {
    super.initState();
    getTracks();
  }

  void getTracks() async  {
    songs=await audioQuery.getSongs();
    setState(() {
      songs=songs;
    });
  } 
  void changeTrack(bool isNext) {
    if(isNext)  {
      if(currentIndex!=songs.length-1)  {
        currentIndex++;
      }
    } else  {
      if(currentIndex!=0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,leading: Icon(Icons.music_note,color: Colors.black),title: Text('Music App', style: TextStyle(color: Colors.black)),),
      body: ListView.separated(separatorBuilder:(context,index)=>Divider(),itemCount: songs.length,itemBuilder: (context,index)=>ListTile(leading: CircleAvatar(backgroundImage: songs[index].albumArtwork==null?AssetImage('assets/images/music_gradient.jpg'):FileImage(File(songs[index].albumArtwork)),),title: Text(songs[index].title),subtitle: Text(songs[index].artist),onTap: ()  {
currentIndex=index;
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MusicPlayer(changeTrack: changeTrack,songInfo: songs[currentIndex],key: key)));
      },),),
    );
  }
}