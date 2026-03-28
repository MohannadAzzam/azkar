import 'package:azkar/data/models/zikir_category.dart';
import 'package:azkar/data/repo/zikir_by_category.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'zikir_by_category_state.dart';

class ZikirByCategoryCubit extends Cubit<ZikirByCategoryState> {
  final ZikirByCategoryRepository zikirByCategoryRepository;
  ZikirByCategoryCubit(this.zikirByCategoryRepository)
    : super(ZikirByCategoryInitial());

  void loadZikirByCategory() async {
    emit(ZikirLoading());
    try {
      final azkar = await zikirByCategoryRepository.getAllAzkar();
      emit(ZikirLoaded(azkar));
    } catch (e) {
      emit(ZikirError(e.toString()));
    }
  }
}
