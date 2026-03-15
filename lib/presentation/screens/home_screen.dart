import '../../business_logic/cubit/zikir_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أذكاري'), centerTitle: true),

      body: BlocBuilder<ZikirCubit, ZikirState>(
        builder: (context, state) {
          if (state is ZikirLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ZikirLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.azkarList.length,
              itemBuilder: (context, index) {
                final category = state.azkarList[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20, 
                      vertical: 10,
                    ),

                    title: Text(
                      category.category,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      // سنقوم هنا بالانتقال لصفحة التفاصيل لاحقاً
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('حدث خطأ أثناء تحميل الأذكار'));
          }
        },
      ),
    );
  }
}
