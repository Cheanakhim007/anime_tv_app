class Movie {
  final String id;
  final String title;
  final String image;
  final String type;

  Movie(this.id,
      this.title,
      this.image,
      this.type
      );

  Movie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        image = json["image"],
        type = json["type"]
  ;
}
