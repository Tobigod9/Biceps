import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QrTrainerView extends StatefulWidget {
  @override
  _QrTrainerViewState createState() => _QrTrainerViewState();
}

class _QrTrainerViewState extends State<QrTrainerView> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      _showModalBottomSheet(context, scanData.code).then((value) {
        controller.resumeCamera();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _showModalBottomSheet(
      BuildContext context, String? qrCode) async {
    if (qrCode != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('login')
          .doc('gym1')
          .collection('tutoriales')
          .where('id', isEqualTo: qrCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docSnapshot = querySnapshot.docs.first;
        String videoUrl = docSnapshot.data()['url'];
        String videoId = YoutubePlayer.convertUrlToId(videoUrl)!;

        // ignore: use_build_context_synchronously
        await showModalBottomSheet(
          context: context,
          builder: (context) {
            YoutubePlayerController _controller = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            );

            return Container(
              height: 500,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tutorial",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${docSnapshot.data()['titulo']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Text(
                      "${docSnapshot.data()['descripcion']}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        const CircularProgressIndicator();
      }
    }
  }
}
