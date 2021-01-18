class Movie {
  final String id;
  final String title;
  final String image;
  final String type;
  final List episode;
  final List description;

  Movie(this.id,
      this.title,
      this.image,
      this.type,
      this.episode,
      this.description
      );

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? "",
        title = json["title"] ?? "",
        image = json["image"] ?? "",
        type = json["type"] ?? "",
        episode = json["episode"] ?? [],
        description = json["description"] ?? []
  ;
  @override
  String toString() {
    return 'Movie{id: $id, title: $title, image: $image, type: $type, episode: $episode, description: $description}';
  }
}
