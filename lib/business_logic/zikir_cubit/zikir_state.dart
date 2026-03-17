part of 'zikir_cubit.dart';

@immutable
sealed class ZikirState {}

final class ZikirInitial extends ZikirState {}

final class ZikirLoading extends ZikirState {}

final class ZikirLoaded extends ZikirState {
  final List<ZikirCategory> azkarList;
  ZikirLoaded(this.azkarList);
}

class ZikirError extends ZikirState {
  final String message;
  ZikirError(this.message);
}
