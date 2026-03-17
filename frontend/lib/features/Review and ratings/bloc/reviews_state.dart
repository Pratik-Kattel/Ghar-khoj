import 'package:equatable/equatable.dart';

import '../Model/review_model.dart';

class ReviewState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final bool hasReviewed;
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalReviews;
  final String? error;
  final String? message;

  ReviewState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.hasReviewed = false,
    this.reviews = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.error,
    this.message,
  });

  ReviewState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? hasReviewed,
    List<ReviewModel>? reviews,
    double? averageRating,
    int? totalReviews,
    String? error,
    String? message,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasReviewed: hasReviewed ?? this.hasReviewed,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    hasReviewed,
    reviews,
    averageRating,
    totalReviews,
    error,
    message,
  ];
}
