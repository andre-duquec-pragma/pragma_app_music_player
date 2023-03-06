import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/responsive_utils.dart';

class ExternalVideoPlayer extends StatelessWidget {
  const ExternalVideoPlayer({
    super.key,
    required YoutubePlayerController controller,
    required bool isVisible,
    required double maxWidth,
    Function(YoutubeMetaData metaData)? onEnded
  }) : _controller = controller, _isVisible = isVisible, _maxWidth = maxWidth, _onEnded = onEnded;

  final YoutubePlayerController _controller;
  final bool _isVisible;
  final double _maxWidth;
  final Function(YoutubeMetaData metaData)? _onEnded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _isVisible ? _maxWidth: 0,
      height: _isVisible ? ResponsiveUtils.calculateHeightAspectRatioBasedOn(width: _maxWidth) : 0,
      child: YoutubePlayer(
        controller: _controller,
        onEnded: _onEnded,
      ),
    );
  }
}