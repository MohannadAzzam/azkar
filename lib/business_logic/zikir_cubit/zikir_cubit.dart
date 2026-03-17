import '../../data/models/zikir_category.dart';
import '../../data/repo/zikir_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'zikir_state.dart';

class ZikirCubit extends Cubit<ZikirState> {
  final ZikirRepository zikirRepository;
  ZikirCubit(this.zikirRepository) : super(ZikirInitial());

  void loadAzkar() async {
    emit(ZikirLoading()); // عرض مؤشر تحميل
    try {
      final azkar = await zikirRepository.getAllAzkar();
      emit(ZikirLoaded(azkar)); // إرسال الأذكار للواجهة
    } catch (e) {
      emit(ZikirError(e.toString()));
    }
  }
}
