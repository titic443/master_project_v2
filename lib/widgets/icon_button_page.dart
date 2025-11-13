import 'package:flutter/material.dart';

class IconButtonDemo extends StatefulWidget {
  const IconButtonDemo({super.key});

  @override
  State<IconButtonDemo> createState() => _IconButtonDemoState();
}

class _IconButtonDemoState extends State<IconButtonDemo> {
  bool _isFavorite = false;
  bool _isLiked = false;
  int _volume = 50;
  String _selectedView = 'grid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IconButton Demo'),
        actions: [
          IconButton(
            key: const Key('search_button'),
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search pressed')),
              );
            },
          ),
          IconButton(
            key: const Key('more_button'),
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem(
                    value: 'about',
                    child: Text('About'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic IconButtons',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            key: const Key('home_icon_button'),
                            icon: const Icon(Icons.home),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Home pressed')),
                              );
                            },
                          ),
                          IconButton(
                            key: const Key('settings_icon_button'),
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Settings pressed')),
                              );
                            },
                          ),
                          IconButton(
                            key: const Key('delete_icon_button'),
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete'),
                                  content: const Text('Are you sure?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            key: const Key('disabled_icon_button'),
                            icon: const Icon(Icons.block),
                            onPressed: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Toggle IconButtons',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                key: const Key('favorite_icon_button'),
                                icon: Icon(
                                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                },
                              ),
                              Text(
                                key: const Key('favorite_status_text'),
                                _isFavorite ? 'Favorited' : 'Not Favorite',
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                key: const Key('like_icon_button'),
                                icon: Icon(
                                  _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                  color: _isLiked ? Colors.blue : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLiked = !_isLiked;
                                  });
                                },
                              ),
                              Text(
                                key: const Key('like_status_text'),
                                _isLiked ? 'Liked' : 'Not Liked',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Volume Control',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            key: const Key('volume_down_button'),
                            icon: const Icon(Icons.volume_down),
                            onPressed: _volume > 0
                                ? () {
                                    setState(() {
                                      _volume = (_volume - 10).clamp(0, 100);
                                    });
                                  }
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            key: const Key('volume_text'),
                            '$_volume%',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            key: const Key('volume_up_button'),
                            icon: const Icon(Icons.volume_up),
                            onPressed: _volume < 100
                                ? () {
                                    setState(() {
                                      _volume = (_volume + 10).clamp(0, 100);
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'View Switcher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            key: const Key('grid_view_button'),
                            icon: const Icon(Icons.grid_view),
                            color: _selectedView == 'grid'
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            onPressed: () {
                              setState(() {
                                _selectedView = 'grid';
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            key: const Key('list_view_button'),
                            icon: const Icon(Icons.view_list),
                            color: _selectedView == 'list'
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            onPressed: () {
                              setState(() {
                                _selectedView = 'list';
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            key: const Key('column_view_button'),
                            icon: const Icon(Icons.view_column),
                            color: _selectedView == 'column'
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            onPressed: () {
                              setState(() {
                                _selectedView = 'column';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          key: const Key('selected_view_text'),
                          'View: $_selectedView',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Icon Button Sizes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                key: const Key('small_icon_button'),
                                icon: const Icon(Icons.star, size: 16),
                                iconSize: 16,
                                onPressed: () {},
                              ),
                              const Text('Small'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                key: const Key('medium_icon_button'),
                                icon: const Icon(Icons.star, size: 24),
                                iconSize: 24,
                                onPressed: () {},
                              ),
                              const Text('Medium'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                key: const Key('large_icon_button'),
                                icon: const Icon(Icons.star, size: 32),
                                iconSize: 32,
                                onPressed: () {},
                              ),
                              const Text('Large'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
