import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_favourites/config/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Constants.appName,
            style: theme.textTheme.titleMedium!
                .copyWith(color: theme.colorScheme.onSecondary),
          ),
          const SizedBox(height: 20.0),
          CupertinoActivityIndicator(
            color: theme.colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
