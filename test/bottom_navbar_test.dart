import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/bottom_navbar.dart';

void main() {
  testWidgets(
    'active item expands while every navigation cell stays separate',
    (tester) async {
      var selectedIndex = 0;

      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              bottomNavigationBar: BottomNavBar(
                currentIndex: selectedIndex,
                onTap: (index) => setState(() => selectedIndex = index),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const Key('bottom-navigation-cell-0'))).width,
        109.44,
      );

      await tester.tap(find.byKey(const Key('bottom-navigation-profile')));
      await tester.pump(const Duration(milliseconds: 210));

      final midAnimationCells = List.generate(
        5,
        (index) =>
            tester.getRect(find.byKey(Key('bottom-navigation-cell-$index'))),
      );
      for (var index = 1; index < midAnimationCells.length; index++) {
        expect(
          midAnimationCells[index - 1].right,
          closeTo(midAnimationCells[index].left, 0.01),
        );
      }

      await tester.pumpAndSettle();
      expect(selectedIndex, 4);
      expect(
        tester.getSize(find.byKey(const Key('bottom-navigation-cell-4'))).width,
        109.44,
      );
      expect(find.text('Profile'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
