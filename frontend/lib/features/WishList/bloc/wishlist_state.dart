import 'package:equatable/equatable.dart';
import '../Model/wishlist_model.dart';

class WishlistState extends Equatable {
  final bool isLoading;
  final bool isWishlisted;
  final List<WishlistModel> wishlist;
  final String? error;
  final String? message;

  WishlistState({
    this.isLoading = false,
    this.isWishlisted = false,
    this.wishlist = const [],
    this.error,
    this.message,
  });

  WishlistState copyWith({
    bool? isLoading,
    bool? isWishlisted,
    List<WishlistModel>? wishlist,
    String? error,
    String? message,
  }) {
    return WishlistState(
      isLoading: isLoading ?? this.isLoading,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      wishlist: wishlist ?? this.wishlist,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isWishlisted, wishlist, error, message];
}