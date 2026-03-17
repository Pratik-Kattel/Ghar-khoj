abstract class WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final String houseId;
  AddToWishlist({required this.houseId});
}

class FetchWishlist extends WishlistEvent {}

class CheckWishlistStatus extends WishlistEvent {
  final String houseId;
  CheckWishlistStatus({required this.houseId});
}

class ResetWishlistState extends WishlistEvent {}