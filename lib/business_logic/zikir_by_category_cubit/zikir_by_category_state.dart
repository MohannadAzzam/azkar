part of 'zikir_by_category_cubit.dart';

@immutable
sealed class ZikirByCategoryState {}

final class ZikirByCategoryInitial extends ZikirByCategoryState {}

final class ZikirLoading extends ZikirByCategoryState {}

final class ZikirLoaded extends ZikirByCategoryState {
  final List<ZikirCategory> azkarList;
  ZikirLoaded(this.azkarList);
}

class ZikirError extends ZikirByCategoryState {
  final String message;
  ZikirError(this.message);
}
