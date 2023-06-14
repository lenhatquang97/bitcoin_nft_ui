import 'package:bitcoin_nft_ui/features/dashboard/presentation/dashboard_screen.dart';
import 'package:bitcoin_nft_ui/features/settings/data/ui_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UiSettings())
      ],
      child: MaterialApp(
        title: 'NFT Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(useMaterial3: true),
        home: const DashboardScreen(),
      ),
    );
  }
}
