import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xenobill_flutter/domain/entities/item.dart';
import 'package:xenobill_flutter/application/inventory/inventory_bloc.dart';
import 'package:xenobill_flutter/infrastructure/repositories/repository_impls.dart';
import 'package:xenobill_flutter/presentation/inventory/pages/product_detail_page.dart';

void main() {
  group('ProductDetailPage Widget & Stock Adjustment Tests', () {
    late ProductRepositoryImpl repository;
    late InventoryBloc inventoryBloc;
    const testItem = Item(
      id: 'test_p1',
      businessId: 'biz_1',
      type: ItemType.product,
      name: 'Basmati Rice 5kg',
      category: 'Groceries',
      unit: 'Bag',
      sellingPrice: 320.0,
      purchasePrice: 280.0,
      mrp: 340.0,
      currentStock: 20,
      lowStockLimit: 10,
    );

    setUp(() {
      repository = ProductRepositoryImpl();
      inventoryBloc = InventoryBloc(repository: repository);
    });

    tearDown(() {
      inventoryBloc.close();
    });

    testWidgets('renders product details and stock adjustment controls correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<InventoryBloc>.value(
            value: inventoryBloc,
            child: const ProductDetailPage(item: testItem),
          ),
        ),
      );

      // Verify Header & Product Name
      expect(find.text('Product Details'), findsOneWidget);
      expect(find.text('Basmati Rice 5kg'), findsOneWidget);
      expect(find.text('Stock Management'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('Bag available'), findsOneWidget);

      // Verify Pricing details
      expect(find.text('Pricing & Profit Details'), findsOneWidget);
      expect(find.text('Tax & Specifications'), findsOneWidget);
    });

    testWidgets('increments stock count when + button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<InventoryBloc>.value(
            value: inventoryBloc,
            child: const ProductDetailPage(item: testItem),
          ),
        ),
      );

      // Tap the + button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Expect stock count display to update to 21
      expect(find.text('21'), findsOneWidget);
    });

    testWidgets('decrements stock count when - button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<InventoryBloc>.value(
            value: inventoryBloc,
            child: const ProductDetailPage(item: testItem),
          ),
        ),
      );

      // Tap the - button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Expect stock count display to update to 19
      expect(find.text('19'), findsOneWidget);
    });
  });
}
