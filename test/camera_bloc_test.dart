import 'package:camera/camera.dart';
import 'package:camera_camera_2/camera_camera_2.dart';
import 'package:camera_camera_2/src/core/camera_bloc.dart';
import 'package:camera_camera_2/src/core/camera_service.dart';
import 'package:camera_camera_2/src/core/camera_status.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CameraServiceMock extends Mock implements CameraService {}

void main() {
  late CameraBloc controller;
  late CameraService service;
  late Function(String value) onFile;
  setUp(() {
    onFile = (value) {};
    service = CameraServiceMock();
    controller = CameraBloc(
        service: service,
        onPath: onFile,
        cameraSide: CameraSide.all,
        flashModes: [FlashMode.off]);
  });

  group("Test CameraBloc", () {
    test("Get AvailableCameras - success", () {
      controller.getAvailableCameras();
      controller.statusStream.listen(print);
      expectLater(
          controller.statusStream,
          emitsInOrder([
            isInstanceOf<CameraStatusLoading>(),
            isInstanceOf<CameraStatusSuccess>(),
          ]));
    });

    test("Get AvailableCameras - failure", () {
      controller.getAvailableCameras();

      expectLater(
          controller.statusStream,
          emitsInOrder([
            isInstanceOf<CameraStatusFailure>(),
          ]));
    });

    test("changeCamera when status is CameraStatusSuccess", () async {
      controller.getAvailableCameras();
      controller.statusStream.listen((state) => state.when(
          success: (_) {
            controller.changeCamera();
          },
          orElse: () {}));
      await expectLater(
          controller.statusStream,
          emitsInOrder([
            isInstanceOf<CameraStatusLoading>(),
            isInstanceOf<CameraStatusSuccess>(),
            isInstanceOf<CameraStatusSelected>(),
          ]));
      expect(controller.status.selected.indexSelected, 1);
    });

    test("changeCamera for next camera", () async {
      controller.getAvailableCameras();
      controller.statusStream.listen((state) => state.when(
          success: (_) {
            controller.changeCamera();
            controller.changeCamera();
          },
          orElse: () {}));

      await expectLater(
          controller.statusStream,
          emitsInOrder([
            isInstanceOf<CameraStatusLoading>(),
            isInstanceOf<CameraStatusSuccess>(),
            isInstanceOf<CameraStatusSelected>(),
            isInstanceOf<CameraStatusSelected>(),
          ]));
      expect(controller.status.selected.indexSelected, 1);
    });

    test("changeCamera for next camera and return index 0", () async {
      controller.getAvailableCameras();
      controller.statusStream.listen((state) => state.when(
          success: (_) {
            controller.changeCamera();
            controller.changeCamera();
            controller.changeCamera();
          },
          orElse: () {}));

      await expectLater(
          controller.statusStream,
          emitsInOrder([
            isInstanceOf<CameraStatusLoading>(),
            isInstanceOf<CameraStatusSuccess>(),
            isInstanceOf<CameraStatusSelected>(),
            isInstanceOf<CameraStatusSelected>(),
            isInstanceOf<CameraStatusSelected>(),
          ]));
      expect(controller.status.selected.indexSelected, 0);
    });
  });
}
