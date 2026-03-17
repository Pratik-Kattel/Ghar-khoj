import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/review_repo.dart';
import 'reviews_event.dart';
import 'reviews_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepo repo;

  ReviewBloc({required this.repo}) : super(ReviewState()) {
    on<FetchReviews>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final reviews = await repo.getReviews(event.houseId);
        emit(state.copyWith(isLoading: false, reviews: reviews));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<FetchAverageRating>((event, emit) async {
      try {
        final result = await repo.getAverageRating(event.houseId);
        emit(state.copyWith(
          averageRating: result["average"],
          totalReviews: result["total"],
        ));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<SubmitReview>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null, message: null));
      try {
        await repo.submitReview(
          event.houseId,
          event.rating,
          event.comment,
        );
        emit(state.copyWith(
          isSubmitting: false,
          hasReviewed: true,
          message: "Review submitted successfully",
        ));
        add(FetchReviews(houseId: event.houseId));
        add(FetchAverageRating(houseId: event.houseId));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, error: e.toString()));
      }
    });

    on<CheckReviewStatus>((event, emit) async {
      try {
        final hasReviewed = await repo.checkReviewStatus(event.houseId);
        emit(state.copyWith(hasReviewed: hasReviewed));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<ResetReviewState>((event, emit) {
      emit(ReviewState());
    });
  }
}