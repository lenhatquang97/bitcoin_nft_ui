import 'package:bitcoin_nft_ui/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFT Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}
