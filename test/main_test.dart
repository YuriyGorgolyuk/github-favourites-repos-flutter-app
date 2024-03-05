import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_favourites/app.dart';
import 'package:github_favourites/main.dart';

void main() {
  testWidgets('App should be a placeholder', (WidgetTester tester) async {
    await bootstrap(() async {
      return const GitFavouritesApp();
    });

    await tester.pumpAndSettle();

    expect(find.byType(Placeholder), findsOneWidget);
  });
}
