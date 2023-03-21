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
}
