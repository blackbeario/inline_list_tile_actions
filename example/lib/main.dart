import 'package:flutter/material.dart';
import 'package:inline_list_tile_actions/inline_list_tile_actions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inline List Tile Actions Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Inline List Tile Actions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _items = [
    'Inbox',
    'Starred',
    'Sent Mail',
    'Drafts',
    'Spam',
    'Trash',
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteItem(String item) {
    setState(() {
      _items.remove(item);
    });
    _showSnackBar('$item deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Basic Examples',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ..._items.map((item) {
            return InlineListTileActions(
              actions: [
                ActionItem(
                  icon: Icons.delete,
                  label: 'Delete',
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  tooltip: 'Delete this item',
                  onPressed: () => _deleteItem(item),
                ),
                ActionItem(
                  icon: Icons.copy,
                  label: 'Clone',
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  tooltip: 'Clone this item',
                  onPressed: () => _showSnackBar('$item cloned'),
                ),
                ActionItem(
                  icon: Icons.share,
                  label: 'Share',
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  tooltip: 'Share this item',
                  onPressed: () => _showSnackBar('$item shared'),
                ),
              ],
              child: ListTile(
                leading: const Icon(Icons.folder),
                title: Text(item),
                subtitle: const Text('Tap the icon to see actions'),
              ),
            );
          }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Vertical Layout Example',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          InlineListTileActions(
            actionLayout: ActionLayout.column,
            actions: [
              ActionItem(
                icon: Icons.edit,
                label: 'Edit',
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                onPressed: () => _showSnackBar('Edit tapped'),
              ),
              ActionItem(
                icon: Icons.archive,
                label: 'Archive',
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                onPressed: () => _showSnackBar('Archive tapped'),
              ),
            ],
            child: const ListTile(
              leading: Icon(Icons.email),
              title: Text('Important Email'),
              subtitle: Text('Actions displayed vertically'),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Custom Styling',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          InlineListTileActions(
            backgroundColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            animationDuration: const Duration(milliseconds: 500),
            showLabels: false,
            actions: [
              ActionItem(
                icon: Icons.favorite,
                foregroundColor: Colors.pink,
                onPressed: () => _showSnackBar('Favorite tapped'),
              ),
              ActionItem(
                icon: Icons.bookmark,
                foregroundColor: Colors.blue,
                onPressed: () => _showSnackBar('Bookmark tapped'),
              ),
              ActionItem(
                icon: Icons.download,
                foregroundColor: Colors.green,
                onPressed: () => _showSnackBar('Download tapped'),
              ),
            ],
            child: const ListTile(
              leading: Icon(Icons.article),
              title: Text('Custom Styled Actions'),
              subtitle: Text('No labels, custom background, slower animation'),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Different Trigger Icon',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          InlineListTileActions(
            triggerIcon: Icons.menu,
            actions: [
              ActionItem(
                icon: Icons.settings,
                label: 'Settings',
                onPressed: () => _showSnackBar('Settings tapped'),
              ),
              ActionItem(
                icon: Icons.info,
                label: 'Info',
                onPressed: () => _showSnackBar('Info tapped'),
              ),
            ],
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('User Profile'),
              subtitle: Text('Uses menu icon instead of more_vert'),
            ),
          ),
        ],
      ),
    );
  }
}
