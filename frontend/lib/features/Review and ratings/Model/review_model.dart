class ReviewModel {
  final String reviewId;
  final String tenantName;
  final int rating;
  final String comment;
  final String createdAt;

  ReviewModel({
    required this.reviewId,
    required this.tenantName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json["review_id"] ?? "",
      tenantName: json["tenant_name"] ?? "Unknown",
      rating: (json["ratings"] as num?)?.toInt() ?? 0,
      comment: json["comment"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }
}