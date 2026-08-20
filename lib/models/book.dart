class Book{
  final String id;
  final String title;
  final String? authorId;
  final String? isbn;
  final String? genre;
  final String? coverUrl;
  final int totalCopies;

  Book({
    required this.id,
    required this.title,
    this.authorId,
    this.isbn,
    this.genre,
    this.coverUrl,
    required this.totalCopies,
  });

  // da JSON (lettura da supabase)
  factory Book.fromJson(Map <String, dynamic> json){
    return Book(
      id: json["id"].toString(),
      title: json["title"] as String,
      authorId: json["author_id"] as String?,
      isbn: json["isbn"] as String?,
      genre: json["genre"] as String?,
      coverUrl: json["cover_url"] as String?,
      totalCopies: json["total_copies"] as int,
    );
  }

  // a Json (scrittura su sapabase)
  Map toJson(){
    return{
      'title':title,
      'author_id' : authorId,
      'isbn' : isbn,
      'genre' : genre,
      'cover_url' : coverUrl,
      'total_copies' : totalCopies
    };
  }
}