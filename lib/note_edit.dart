import 'package:flutter/material.dart';
import 'note.dart';

class NoteEdit extends StatefulWidget {
  final Note note;
  final Function(Note) onSave;

  const NoteEdit({super.key, required this.note, required this.onSave});

  @override
  _NoteEditState createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _noteColor;

  final List<String> _undoStack = [];
  final List<String> _redoStack = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _noteColor = widget.note.noteColor;

    _pushToUndoStack();
  }

  void _pushToUndoStack() {
    String currentState = _titleController.text + _contentController.text;
    _undoStack.add(currentState);
  }

  void _undo() {
    if (_undoStack.length > 1) {
      String currentState = _titleController.text + _contentController.text;
      _redoStack.add(currentState);
      String previousState = _undoStack.removeLast();
      _applyState(previousState);
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      String currentState = _titleController.text + _contentController.text;
      _undoStack.add(currentState);
      String nextState = _redoStack.removeLast();
      _applyState(nextState);
    }
  }

  void _applyState(String state) {
    _titleController.text = state.substring(0, widget.note.title.length);
    _contentController.text =
        state.substring(widget.note.title.length, state.length);
  }

  void _saveNote() {
    widget.note.title = _titleController.text;
    widget.note.content = _contentController.text;
    widget.note.noteColor = _noteColor;

    widget.onSave(widget.note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _redo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _pushToUndoStack(),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _pushToUndoStack(),
              ),
            ),
            DropdownButton<String>(
              value: _noteColor,
              items: const [
                DropdownMenuItem(value: 'red', child: Text('Red')),
                DropdownMenuItem(value: 'blue', child: Text('Blue')),
                DropdownMenuItem(value: 'green', child: Text('Green')),
              ],
              onChanged: (String? value) {
                setState(() {
                  _noteColor = value;
                  _pushToUndoStack();
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        tooltip: 'Save Note',
        child: const Icon(Icons.save),
      ),
    );
  }
}
