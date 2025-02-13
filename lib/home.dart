import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({Key? key, required this.username}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = ["New Note", "New Note", "New Note"];
  final Duration _duration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    // Add items with delay for animation effect
    for (int i = 0; i < _items.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        _addItem(i);
      });
    }
  }

  void _addItem(int index) {
    _listKey.currentState?.insertItem(index, duration: _duration);
  }

  void _addNewItem() {
    setState(() {
      String newItem =
          "New Note ${_items.length + 1}"; // +1 for correct numbering
      _items.add(newItem); // Add the new note to the list
    });

    // Trigger the insertion animation for the new item
    _addItem(_items.length - 1); // Add the new item at the last position
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${widget.username}'),
        backgroundColor: Colors.purple,
        elevation: 0.1,
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: 0,
        itemBuilder: (context, index, animation) {
          // Floating effect with Card, SlideTransition, and ScaleTransition
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(
                  0, 1), // Start position (off-screen at the bottom)
              end: Offset.zero, // End position (normal location)
            ).animate(animation),
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: Card(
                elevation: 5.0, // Elevation to create a floating effect
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                child: ListTile(
                  leading: Icon(Icons.import_contacts),
                  title: Text(_items[index]), // Display the note name
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
