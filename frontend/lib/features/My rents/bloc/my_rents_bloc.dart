import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'my_rents_event.dart';
part 'my_rents_state.dart';

class MyRentsBloc extends Bloc<MyRentsEvent, MyRentsState> {
  MyRentsBloc() : super(MyRentsInitial()) {
    on<MyRentsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
