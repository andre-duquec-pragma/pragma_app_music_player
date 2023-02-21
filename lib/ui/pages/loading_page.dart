import 'package:flutter/material.dart';

import '../../blocs/bloc_processing.dart';
import '../../blocs/bloc_responsive.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key? key,
    required this.blocProcessing,
    required this.blocResponsive,
  }) : super(key: key);

  final BlocProcessing blocProcessing;
  final ResponsiveBloc blocResponsive;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: blocProcessing.procesingStream,
        builder: (context, snapshot) {
          if (snapshot.data?.isNotEmpty == true) {
            final primaryColor = Theme.of(context).primaryColor;
            final textColor = Theme.of(context).canvasColor;

            return Opacity(
              opacity: 0.90,
              child: Material(
                color: primaryColor,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(),
                        CircularProgressIndicator(
                          color: textColor,
                          strokeWidth: 7.0,
                        ),
                        SizedBox(
                          height: blocResponsive.gutterWidth,
                        ),
                        Text(
                          snapshot.data ?? 'Loading',
                          style: TextStyle(color: textColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        });
  }
}
