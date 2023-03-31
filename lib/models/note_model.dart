class Note {
  String title;
  String description;

  Note(this.title, this.description);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      map['title'],
      map['description'],
    );
  }
}
