import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'my_houses_event.dart';
part 'my_houses_state.dart';

class MyHousesBloc extends Bloc<MyHousesEvent, MyHousesState> {
  MyHousesBloc() : super(MyHousesInitial()) {
    on<MyHousesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
