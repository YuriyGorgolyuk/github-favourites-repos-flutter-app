import 'package:flutter/material.dart';

class ScreenMessage extends StatelessWidget {
  const ScreenMessage({
    super.key,
    this.message = "No data to display",
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
