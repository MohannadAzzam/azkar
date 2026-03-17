  import 'package:flutter/material.dart';

Widget buildDailyQuote({required String todayAya}) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white70, size: 24),
          const SizedBox(height: 10),
          Text(
            todayAya
            ,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const Text(
          //   "سورة الرعد",
          //   style: const TextStyle(color: Colors.white60, fontSize: 12),
          // ),
        ],
      ),
    );
  }