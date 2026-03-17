import '../../business_logic/zikir_cubit/zikir_cubit.dart';
import '../../constants/strings.dart';
import '../../data/models/zikir_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildQuickAccess() {
  return BlocBuilder<ZikirCubit, ZikirState>(
    builder: (context, state) {
      if (state is ZikirLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is ZikirLoaded) {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: state.azkarList.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              if (state.azkarList[index].category == "أذكار الصباح") {
                return _quickCard(
                  state.azkarList[index].category,
                  Icons.wb_sunny,
                  Colors.orange,
                  context,
                  zikirCategory: state.azkarList[index],
                );
              }
              if (state.azkarList[index].category == "أذكار المساء") {
                return _quickCard(
                  state.azkarList[index].category,
                  Icons.nightlight_round,
                  Colors.indigo,
                  context,
                  zikirCategory: state.azkarList[index],
                );
              }
              if (state.azkarList[index].category == "أذكار النوم") {
                return _quickCard(
                  state.azkarList[index].category,
                  Icons.bedtime,
                  Colors.purple,
                  context,
                  zikirCategory: state.azkarList[index],
                );
              } else {
                return Container(color: Colors.red, height: 20, width: 20);
              }
            },
          ),
        );
      } else {
        return Center(child: Text('حدث خطأ أثناء تحميل الأذكار'));
      }
    },
  );
}

Widget _quickCard(
  String title,
  IconData icon,
  Color color,
  BuildContext context, {
  ZikirCategory? zikirCategory,
}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, azkarScreen, arguments: zikirCategory);
    },
    child: Container(
      width: 140,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}