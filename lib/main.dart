import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Devtrio Rive Animation',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigoAccent,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 32),
              minimumSize: const Size(250, 56),
            ),
          ),
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    final data =
        await rootBundle.load('assets/animations/dash_flutter_muscot.riv');
    try {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'birb');
      if (controller != null) {
        artboard.addController(controller);
        isDance = controller.findSMI('dance');
        isLookUp = controller.findSMI('look up');
      }
      setState(() => riveArtboard = artboard);
    } catch (e) {
      print(e);
    }
  }

  void _onDropdownChanged(String? newValue) {
    if (newValue == 'Look Up') {
      isLookUp?.fire();
    } else if (newValue == 'Dance') {
      isDance?.value = true;
    } else if (newValue == 'Stop') {
      isDance?.value = false;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Rive Animation'),
          centerTitle: true,
        ),
        body: riveArtboard == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(child: Rive(artboard: riveArtboard!)),
                  Container(
                    margin: const EdgeInsets.only(bottom: 90),
                    child: DropdownButton<String>(
                      value: 'Stop',
                      items: ['Look Up', 'Dance', 'Stop']
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: _onDropdownChanged,
                    ),
                  ),
                ],
              ),
      );
}
