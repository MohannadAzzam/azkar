import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  final String _currentTasbih = "سبحان الله";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // إضافة اهتزاز بسيط عند الضغط
    HapticFeedback.lightImpact();
    
    // هنا يمكنك استدعاء دالة التحديث في قاعدة البيانات
    // _dbHelper.updateTasbihCount(_currentTasbih, _counter);
  }

  void _resetCounter() {
    setState(() => _counter = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المسبحة الإلكترونية"), backgroundColor: Colors.teal),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentTasbih, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 40),
            
            // تصميم زر التسبيح الكبير
            GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.withValues( alpha: 0.1),
                  border: Border.all(color: Colors.teal, width: 5),
                ),
                child: Center(
                  child: Text(
                    '$_counter',
                    style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
              label: const Text("إعادة ضبط"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}