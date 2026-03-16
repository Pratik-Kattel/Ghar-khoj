import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/wishlist_repo.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepo repo;

  WishlistBloc({required this.repo}) : super(WishlistState()) {
    on<AddToWishlist>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, message: null));
      try {
        final result = await repo.addToWishlist(event.houseId);
        emit(state.copyWith(
          isLoading: false,
          isWishlisted: result["wishlisted"],
          message: result["message"],
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<FetchWishlist>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, message: null));
      try {
        final wishlist = await repo.getWishlist();
        emit(state.copyWith(isLoading: false, wishlist: wishlist));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<CheckWishlistStatus>((event, emit) async {
      try {
        final wishlisted = await repo.checkWishlistStatus(event.houseId);
        emit(state.copyWith(isWishlisted: wishlisted));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}