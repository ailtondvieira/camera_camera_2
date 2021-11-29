import 'package:camera_camera_2/src/presentation/controller/camera_camera_controller.dart';
import 'package:camera_camera_2/src/presentation/widgets/translucent_widget.dart';
import 'package:flutter/material.dart';

class FlashButton extends StatelessWidget {
  const FlashButton({
    Key? key,
    required this.flashIcon,
    required this.controller,
  }) : super(key: key);

  final IconData flashIcon;
  final CameraCameraController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.6),
          ),
          child: TranslucentButton(
            onTap: () {
              controller.changeFlashMode();
            },
            child: Icon(
              flashIcon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
