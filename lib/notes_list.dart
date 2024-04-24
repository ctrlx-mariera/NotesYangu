import 'package:flutter/material.dart';
import 'note.dart';
import 'database_helper.dart';
import 'note_edit.dart';
import 'settings_screen.dart'; // Import the settings screen file

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  late List<Note> _notes;
  late List<Note> _filteredNotes;
  late DatabaseHelper _dbHelper;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late Note _deletedNote = Note(
    title: 'Deleted Note',
    content: 'This note has been deleted',
  );

  @override
  void initState() {
    super.initState();
    _notes = [];
    _filteredNotes = [];
    _dbHelper = DatabaseHelper.instance;
    _updateNotes();
  }

  void _updateNotes() async {
    _notes = await _dbHelper.queryAllNotes();
    _filteredNotes = List.from(_notes);
    setState(() {});
  }

  void _addNote() async {
    Note newNote = Note(title: '', content: '');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEdit(note: newNote, onSave: _saveNote)),
    );
  }

  void _saveNote(Note note) async {
    if (note.id == null) {
      await _dbHelper.insert(note);
    } else {
      await _dbHelper.update(note);
    }
    _updateNotes();
  }

  void _editNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEdit(note: note, onSave: _saveNote)),
    );
    _updateNotes();
  }

  void _deleteNote(Note note) async {
    _deletedNote = note;
    await _dbHelper.delete(note);
    _updateNotes();
    _showUndoSnackBar();
  }

  void _restoreDeletedNote() async {
    await _dbHelper.insert(_deletedNote);
    _updateNotes();
    _deletedNote = Note(
      title: 'Deleted Note',
      content: 'This note has been deleted',
    );
  }

  void _searchNotes(String query) {
    setState(() {
      _filteredNotes = _notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    if (_filteredNotes.isEmpty && query.isNotEmpty) {
      _showNoResultsDialog(context);
    }
  }

  void _showNoResultsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Results'),
          content: const Text('No notes found with the provided search query. Please try again with a different search term.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUndoSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _showRestoreConfirmationDialog();
          },
        ),
      ),
    );
  }

  void _showRestoreConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restore Note?'),
          content: const Text('Are you sure you want to restore the deleted note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restoreDeletedNote();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC8A2C8),
        title: const Text('NotesYangu'),
        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _searchNotes('');
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
          IconButton(
            icon: const Icon(Icons.settings), // Add settings icon
            onPressed: _navigateToSettings, // Navigate to settings screen
          ),
        ],
      ),
      body: _isSearching
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _searchNotes,
                    decoration: const InputDecoration(
                      hintText: 'Search notes...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_filteredNotes.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                          Note note = _filteredNotes[index];
                          return Card(
                            child: ListTile(
                              title: Text(note.title),
                              subtitle: Text(note.content),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteNote(note),
                              ),
                              onTap: () => _editNote(note),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                Note note = _notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNote(note),
                    ),
                    onTap: () => _editNote(note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
