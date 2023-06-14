class Review {
  final String id;
  final String author;
  final String content;
  final String url;
  final DateTime createdAt;
  final double rating;
  final String authorImageUrl; // New property for author image URL

  Review({
    this.id,
    this.author,
    this.content,
    this.url,
    this.createdAt,
    this.rating,
    this.authorImageUrl,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      url: json['url'],
      createdAt: DateTime.parse(json['created_at']),
      rating: json['author_details']['rating']?.toDouble(),
      authorImageUrl: json['author_details']['avatar_path'] != null
          ? 'https://image.tmdb.org/t/p/original${json['author_details']['avatar_path']}'
          : null,
      // createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      // rating: json['rating'] != null ? double.parse(json['rating'].toString()) : null,
      // authorImageUrl: json['author_image_url'], // Replace with the actual JSON key for the image URL
      // authorImageUrl: json['author_image_url'] != null ? 'https://image.tmdb.org/t/p/original/${json['author_image_url']}' : null,
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, author: $author, content: $content, url: $url, createdAt: $createdAt, rating: $rating, authorImageUrl: $authorImageUrl)';
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'url': url,
      'created_at': createdAt?.toIso8601String(),
      'rating': rating,
      'avatar_path': authorImageUrl, // Replace with the desired JSON key for the image URL
    };
  }
}
