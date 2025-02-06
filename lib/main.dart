import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:invoice_generator/screens/BillListingScreen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    fullScreen: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.setMaximizable(false);
    await windowManager.setResizable(false);
    await windowManager.setMinimizable(true);
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    windowManager.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BillListingScreen(),
    );
  }
}
