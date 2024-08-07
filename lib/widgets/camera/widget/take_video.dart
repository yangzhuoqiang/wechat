import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'count_down.dart';
import 'package:flutter/material.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

// ignore: must_be_immutable
class TakeVideoPage extends StatefulWidget {
  Duration get _defaultMaxVideoDuration => const Duration(seconds: 30);

  Duration? maxVideoDuration;

  TakeVideoPage(
      {Key? key, required this.cameraState, Duration? maxVideoDuration})
      : super(key: key) {
    this.maxVideoDuration = maxVideoDuration ?? _defaultMaxVideoDuration;
  }

  final CameraState cameraState;

  //
  //
  // Duration? maxVideoDuration = const Duration(seconds: 30);

  @override
  State<TakeVideoPage> createState() => _TakeVideoPageState();
}

class _TakeVideoPageState extends State<TakeVideoPage> {
  @override
  void initState() {
    super.initState();
    widget.cameraState.captureState$.listen((event) async {
      if (event != null && event.status == MediaCaptureStatus.success) {
        // String filePath = event.filePath;
        String filePath = event.toString();
        String fileTitle = filePath.split("/").last;

        File file = File(filePath);

        // 压缩视频
        // CompressMediaFile getCompressMediaFile =await DuCompress.video(file);

        // 获取压缩后的视频文件
        // File? getVideoFile = getCompressMediaFile.video?.file;

        // if(getVideoFile==null){
        //   throw "VideoFile error";
        // }

        // 转换为AssetEntity
        AssetEntity? asset = await PhotoManager.editor.saveVideo(
          // getVideoFile,
          file,
          title: fileTitle,
        );

        // 删除临时文件
        await file.delete();
        // await getVideoFile.delete();

        Navigator.pop(
          context,
          asset,
        );
      }
    });
  }

  Widget _rightArea() {
    //如果cameraState处于正在录制的状态即cameraState是VideoRecordingCameraState，那么才会出现倒计时的组件
    if (widget.cameraState is VideoRecordingCameraState &&
        widget.maxVideoDuration != null) {
      return Countdown(
          time: widget.maxVideoDuration,
          callback: () {
            (widget.cameraState as VideoRecordingCameraState).stopRecording();
          });
    } else {
      return const SizedBox(
        width: 32 + 20 * 2,
      );
    }
  }

  Widget _mainView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black54,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AwesomeCameraSwitchButton(state: widget.cameraState),
            AwesomeCaptureButton(state: widget.cameraState),
            //倒计时
            _rightArea(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
