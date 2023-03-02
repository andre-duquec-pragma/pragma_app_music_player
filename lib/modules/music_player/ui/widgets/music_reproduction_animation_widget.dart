import 'package:flutter/material.dart';

class MusicReproductionAnimation extends StatefulWidget {
  const MusicReproductionAnimation({super.key});

  @override
  State<StatefulWidget> createState() => _MusicReproductionAnimation();
}

class _MusicReproductionAnimation extends State<MusicReproductionAnimation> {


  @override
  Widget build(BuildContext context) {
    Color color = Colors.deepPurple.shade200;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MusicReproductionAnimationWave(duration: 650, color: color),
        MusicReproductionAnimationWave(duration: 400, color: color),
        MusicReproductionAnimationWave(duration: 600, color: color),
        MusicReproductionAnimationWave(duration: 550, color: color),
        MusicReproductionAnimationWave(duration: 500, color: color),
        MusicReproductionAnimationWave(duration: 400, color: color),
      ]
    );
  }
}


class MusicReproductionAnimationWave extends StatefulWidget {

  final int duration;
  final Color color;

  const MusicReproductionAnimationWave({super.key, required this.duration, required this.color});

  @override
  State<StatefulWidget> createState() => _MusicReproductionAnimationWave();
}

class _MusicReproductionAnimationWave extends State<MusicReproductionAnimationWave> with SingleTickerProviderStateMixin {

  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    final curvedAnimation = CurvedAnimation(parent: animationController!, curve: Curves.easeInOutCubic);
    
    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)..addListener(() {
      setState(() {

      });
    });
    animationController!.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5)
      ),
      height: (animation?.value ?? 0),
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}