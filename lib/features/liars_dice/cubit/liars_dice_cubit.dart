import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'liars_dice_state.dart';

class LiarsDiceCubit extends Cubit<LiarsDiceState> {
  LiarsDiceCubit() : super(LiarsDiceInitial());
}
