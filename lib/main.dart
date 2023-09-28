// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:notas_ie/convivencia_provider.dart';
import 'package:notas_ie/estud_provider.dart';
import 'package:notas_ie/estudiante_provider.dart';
import 'package:notas_ie/inasistencias_provider.dart';
import 'package:notas_ie/notas_provider.dart';
import 'package:notas_ie/widgets/custom_alert.dart';
import 'package:notas_ie/widgets/entrada_app.dart';
import 'package:provider/provider.dart';
import 'widgets/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String urlbase = 'https://app.iedeoccidente.com';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EstudianteProvider()),
        ChangeNotifierProvider(create: (context) => NotasProvider()),
        ChangeNotifierProvider(create: (context) => InasistenciasProvider()),
        ChangeNotifierProvider(create: (context) => EstudProvider()),
        ChangeNotifierProvider(create: (context) => ConvivenciaProvider())

        // Agrega más providers si es necesario
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EasySplashScreen(
        logo: Image.network('https://app.iedeoccidente.com/esc.png'),
        title: const Text(
          "Institución Educativa de Occidente.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade100,
        showLoader: true,
        loadingText: const Text("Cargando..."),
        navigator: const PaginaPrincipal(),
        durationInSeconds: 3,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  LocalStorage storage = LocalStorage('app.json');
  bool login = false;
  late String estud;
  bool iniciando = false;
  //variables de estado
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String> obtenerValorLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getString(
        'estudiante'); // Reemplaza 'clave' por la clave que utilizaste al guardar el valor
    return valor ?? ''; // Valor predeterminado si no se encuentra la clave
  }

  Future<void> guardarValorLocal(String estudiante) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('estudiante',
        estudiante); // Reemplaza 'clave' por tu clave y true por el valor que desees almacenar
  }

  Future<bool> fetchDataFromJson() async {
    final url = Uri.parse('$urlbase/est/php/login.php');

    final bodyData = json.encode({
      'identificacion': usuarioController.text,
      'pass': passwordController.text
    });

    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['acceso'] == 'si') {
        final urlInasistencias = Uri.parse('$urlbase/est/php/getInasist.php');
        final bodyDataInasistencias = json.encode({
          'estudiante': usuarioController.text,
        });
        final responseInasistencias =
            await http.post(urlInasistencias, body: bodyDataInasistencias);
        final jsonResponseInasistencias =
            json.decode(responseInasistencias.body);
        //  print(jsonResponse);
        final misNotas = Provider.of<NotasProvider>(context, listen: false);
        final dataNotas = jsonResponse['dataNotas'] as List<dynamic>;

// Convierte dataNotas a una lista de Map<String, dynamic>
        final listaNotas =
            dataNotas.map((item) => item as Map<String, dynamic>).toList();

        misNotas.setData(listaNotas);

        final estudianteProvider =
            Provider.of<EstudianteProvider>(context, listen: false);

        estudianteProvider.setNombresEstudiante(jsonResponse['nombres']);
        estudianteProvider.setEstudiante(jsonResponse['estudiante']);
        estudianteProvider.setPeriodo(jsonResponse['periodo']);
        estudianteProvider.setGrado(jsonResponse['grado']);

        final inasistenciasProvider =
            Provider.of<InasistenciasProvider>(context, listen: false);
        final dataInasistencias = jsonResponseInasistencias as List<dynamic>;
        final listaInasistencias = dataInasistencias
            .map((item) => item as Map<String, dynamic>)
            .toList();
        inasistenciasProvider.setData(listaInasistencias);
        print({'inas1': inasistenciasProvider.data.length});

        final urlConvivencia =
            Uri.parse('$urlbase/consolidadoConvivenciaEstudiante.php');
        final bodyDataConvivencia = json.encode({
          'estudiante': usuarioController.text,
          'year': (DateTime.now()).year.toString()
        });
        final responseConvivencia =
            await http.post(urlConvivencia, body: bodyDataConvivencia);
        final jsonResponseConvivencia = json.decode(responseConvivencia.body);
        final dataConvivencia = jsonResponseConvivencia as List<dynamic>;
        final listaConvivencia = dataConvivencia
            .map((item) => item as Map<String, dynamic>)
            .toList();

        final convivenciaProvider =
            Provider.of<ConvivenciaProvider>(context, listen: false);
        convivenciaProvider.setData(listaConvivencia);

        guardarValorLocal(estudianteProvider.estudiante);
      }
      return jsonResponse['acceso'] == 'si';
    } // ...
    return false;
  }

  @override
  void initState() {
    super.initState();
    /*  usuarioController.text = "1016719618";
    passwordController.text = "1016719618"; */
    estud = '-1';
    iniciando = false;
    setState(() {});
    final estudProvider = Provider.of<EstudProvider>(context, listen: false);
    obtenerValorLocal().then((value) {
      estud = value;
      if (estud != '') {
        iniciando = true;
        login = true;
        setState(() {});
        estudProvider.setEstud(estud);
        usuarioController.text = estud;
        passwordController.text = estud;
        fetchDataFromJson().then((value) {
          print({'estud': estud});
          if (estud != "") {
            print("ingresando");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EntradaApp(elPeriodo: '')));
          }
        });
      } else {
        usuarioController.text = '';
        passwordController.text = '';
      }
    });
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void haceralgo() {
    print('hacer algo');
  }

  @override
  Widget build(BuildContext context) {
    void mostrarAlert(BuildContext context, String title, String text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            key: const Key('alert'),
            title: title,
            content: text,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }

    void ingresar() async {
      setState(() {
        login = true;
      });
      bool acceso = (await fetchDataFromJson());
      setState(() {
        login = false;
      });
      if (acceso) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EntradaApp(elPeriodo: '')));
      } else {
        mostrarAlert(
            context, 'Acceso Denegado', 'Estudiante o contraseña erróneas');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('I.E. de Occidente'),
          backgroundColor: const Color.fromARGB(255, 80, 137, 15),
          foregroundColor: Colors.white,
        ),
        // ignore: unnecessary_null_comparison
        body: Login(
            usController: usuarioController,
            passController: passwordController,
            onIngresar: ingresar,
            login: login));
  }
}
