import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({Key? key, required this.username}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, String>> _items =
      []; // List of maps to hold title and content
  final Duration _duration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _items.clear(); // Ensure the list is empty when opened
  }

  void _addItem(int index) {
    _listKey.currentState?.insertItem(index, duration: _duration);
  }

  void _addNewItem() {
    // Function to show modal for adding a new note (title + content)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController contentController = TextEditingController();

        return AlertDialog(
          title: Text("Add New Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Enter note title"),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: "Enter note content"),
                maxLines: 5,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newTitle = titleController.text.isEmpty
                      ? "New Note ${_items.length + 1}"
                      : titleController.text;
                  String newContent = contentController.text.isEmpty
                      ? "No content"
                      : contentController.text;

                  _items.add({
                    "title": newTitle,
                    "content": newContent
                  }); // Add new note with title and content
                });

                // Trigger the insertion animation for the new item
                _addItem(
                    _items.length - 1); // Add the new item at the last position
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _editItem(int index) {
    TextEditingController titleController =
        TextEditingController(text: _items[index]["title"]);
    TextEditingController contentController =
        TextEditingController(text: _items[index]["content"]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Enter note title"),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: "Enter note content"),
                maxLines: 5,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _items[index] = {
                    "title": titleController.text,
                    "content": contentController.text
                  }; // Update note with new title and content
                });
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Method to remove a note
  void _removeItem(int index) {
    String removedItem = _items[index]["title"] ?? "";
    setState(() {
      _items.removeAt(index); // Remove the note from the list
    });

    // Trigger the removal animation
    _listKey.currentState?.removeItem(index, (context, animation) {
      return SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 1))
                .animate(animation),
        child: Card(
          elevation: 5.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            title: Text(removedItem),
          ),
        ),
      );
    }, duration: _duration);
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
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animation),
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_items[index]["title"] ?? ""),
                      SizedBox(height: 4),
                      Text(
                        _items[index]["content"] ?? "",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeItem(
                          index); // Remove note when delete icon is tapped
                    },
                  ),
                  onTap: () {
                    _editItem(
                        index); // Open the edit dialog when the list item is tapped
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem, // Show modal to add new note
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
