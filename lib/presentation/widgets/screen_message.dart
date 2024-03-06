import 'package:flutter/material.dart';

class ScreenMessage extends StatelessWidget {
  const ScreenMessage({
    super.key,
    this.message = "No data to display",
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
