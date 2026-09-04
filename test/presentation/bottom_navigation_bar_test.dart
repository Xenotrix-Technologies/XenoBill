import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xenobill_flutter/presentation/navigation/xenobiz_bottom_navigation_bar.dart';
import 'package:xenobill_flutter/presentation/navigation/floating_add_invoice_button.dart';
import 'package:xenobill_flutter/presentation/navigation/navigation_item.dart';

void main() {
  group('XenobizBottomNavigationBar Widget Tests', () {
    testWidgets('renders all 4 navigation items and center Add Invoice button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: XenobizBottomNavigationBar(
              selectedIndex: 0,
              onItemTapped: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(FloatingAddInvoiceButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('triggers onItemTapped when navigation items are tapped', (WidgetTester tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: XenobizBottomNavigationBar(
              selectedIndex: 0,
              onItemTapped: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Tap Sales (index 1)
      await tester.tap(find.text('Sales'));
      await tester.pump();
      expect(tappedIndex, equals(1));

      // Tap Add Invoice center button (index 2)
      await tester.tap(find.byType(FloatingAddInvoiceButton));
      await tester.pump();
      expect(tappedIndex, equals(2));

      // Tap Shop (index 3)
      await tester.tap(find.text('Shop'));
      await tester.pump();
      expect(tappedIndex, equals(3));

      // Tap Settings (index 4)
      await tester.tap(find.text('Settings'));
      await tester.pump();
      expect(tappedIndex, equals(4));

      // Tap Home (index 0)
      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(tappedIndex, equals(0));
    });

    testWidgets('provides correct accessibility semantics and tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: XenobizBottomNavigationBar(
              selectedIndex: 1,
              onItemTapped: (_) {},
            ),
          ),
        ),
      );

      // Verify FloatingAddInvoiceButton tooltip and semantics
      expect(find.byTooltip('Add Invoice'), findsOneWidget);

      // Verify NavigationItem semantics
      final homeItem = tester.widget<NavigationItem>(
        find.widgetWithText(NavigationItem, 'Home'),
      );
      expect(homeItem.semanticLabel, equals('Home'));
      expect(homeItem.isSelected, isFalse);

      final salesItem = tester.widget<NavigationItem>(
        find.widgetWithText(NavigationItem, 'Sales'),
      );
      expect(salesItem.semanticLabel, equals('Sales'));
      expect(salesItem.isSelected, isTrue);
    });
  });
}
