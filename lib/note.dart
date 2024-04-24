class Note {
  int? id;
  String title;
  String content;
  String? noteColor;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.noteColor,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      noteColor: map['noteColor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'noteColor': noteColor,
    };
  }
}