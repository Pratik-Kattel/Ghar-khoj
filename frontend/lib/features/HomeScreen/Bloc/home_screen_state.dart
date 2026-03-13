import 'package:equatable/equatable.dart';

class HomeScreenState extends Equatable{
  final bool isLoading;
  final String? name;
  final String? place;

  HomeScreenState({
    this.isLoading=false,
    this.name,
    this.place
});

  HomeScreenState copyWith({
    bool? isLoading,
    String? name,
    String? place
}){
    return HomeScreenState(
      isLoading: isLoading??this.isLoading,
      name: name??this.name,
      place: place??this.place
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isLoading,name,place];

}