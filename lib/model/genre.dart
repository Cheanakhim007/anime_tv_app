class Genre {
  final String id;
  final String name;

  Genre(this.id,
         this.name);

  Genre.fromJson(Map<String, dynamic> json)
      : id = json["link"],
        name = json["title"];

  @override
  String toString() {
    return 'Genre{id: $id, name: $name}';
  }
}
