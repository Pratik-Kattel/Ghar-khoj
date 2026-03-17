abstract class ReviewEvent {}

class FetchReviews extends ReviewEvent {
  final String houseId;
  FetchReviews({required this.houseId});
}

class FetchAverageRating extends ReviewEvent {
  final String houseId;
  FetchAverageRating({required this.houseId});
}

class SubmitReview extends ReviewEvent {
  final String houseId;
  final int rating;
  final String comment;
  SubmitReview({
    required this.houseId,
    required this.rating,
    required this.comment,
  });
}

class CheckReviewStatus extends ReviewEvent {
  final String houseId;
  CheckReviewStatus({required this.houseId});
}

class ResetReviewState extends ReviewEvent {}