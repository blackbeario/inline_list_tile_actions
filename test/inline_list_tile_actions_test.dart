import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inline_list_tile_actions/inline_list_tile_actions.dart';

void main() {
  group('InlineListTileActions', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actions: const [],
              child: const ListTile(
                title: Text('Test Title'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('displays trigger icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actions: const [],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('displays custom trigger icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              triggerIcon: Icons.menu,
              actions: const [],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('expands and shows actions when trigger is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actionPosition: ActionPosition.below,
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () {},
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Actions should not be visible initially (in below mode)
      expect(find.text('Delete'), findsNothing);

      // Tap the trigger icon
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Actions should now be visible
      expect(find.text('Delete'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('executes action callback when action is tapped',
        (WidgetTester tester) async {
      bool actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () => actionPressed = true,
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Expand the actions
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap the action
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(actionPressed, true);
    });

    testWidgets('closes actions after tapping action when closeOnActionTap is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actionPosition: ActionPosition.below,
              closeOnActionTap: true,
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () {},
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Expand the actions
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);

      // Tap the action
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Actions should be hidden (in below mode)
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('keeps actions open when closeOnActionTap is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              closeOnActionTap: false,
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () {},
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Expand the actions
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap the action
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Actions should still be visible
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('displays multiple actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () {},
                ),
                ActionItem(
                  icon: Icons.share,
                  label: 'Share',
                  onPressed: () {},
                ),
                ActionItem(
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: () {},
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Expand the actions
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('hides labels when showLabels is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              showLabels: false,
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () {},
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Expand the actions
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('uses column layout when specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InlineListTileActions(
              actionLayout: ActionLayout.column,
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: () {},
                ),
                ActionItem(
                  icon: Icons.share,
                  label: 'Share',
                  onPressed: () {},
                ),
              ],
              child: const ListTile(
                title: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Expand the actions
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });
  });

  group('ActionItem', () {
    test('creates action item with required parameters', () {
      final action = ActionItem(
        icon: Icons.delete,
        onPressed: () {},
      );

      expect(action.icon, Icons.delete);
      expect(action.label, null);
      expect(action.backgroundColor, null);
      expect(action.foregroundColor, null);
    });

    test('creates action item with optional parameters', () {
      final action = ActionItem(
        icon: Icons.delete,
        label: 'Delete',
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Delete item',
        onPressed: () {},
      );

      expect(action.icon, Icons.delete);
      expect(action.label, 'Delete');
      expect(action.backgroundColor, Colors.red);
      expect(action.foregroundColor, Colors.white);
      expect(action.tooltip, 'Delete item');
    });
  });
}
