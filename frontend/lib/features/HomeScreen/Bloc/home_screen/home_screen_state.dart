import 'package:equatable/equatable.dart';

class HomeScreenState extends Equatable{
  final bool isLoading;
  final String? name;
  final String? place;
  final String ? email;

  HomeScreenState({
    this.isLoading=false,
    this.name,
    this.place,
    this.email
  });

  HomeScreenState copyWith({
    bool? isLoading,
    String? name,
    String? place,
    String? email
  }){
    return HomeScreenState(
        isLoading: isLoading??this.isLoading,
        name: name??this.name,
        place: place??this.place,
        email: email ?? this.email
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading,name,place,email];

}