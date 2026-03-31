part of 'prayer_time_cubit.dart';

@immutable
sealed class PrayerTimeState {}

final class PrayerTimeInitial extends PrayerTimeState {}

final class PrayerTimeLoading extends PrayerTimeState {}

final class PrayerTimeLoaded extends PrayerTimeState {
  final PrayerTimes prayerTimes;
  final String locationName; // لتخزين اسم المدينة (اختياري)

  PrayerTimeLoaded({required this.prayerTimes, required this.locationName});
}

final class PrayerTimeError extends PrayerTimeState {
  final String message;

  PrayerTimeError(this.message);
}
