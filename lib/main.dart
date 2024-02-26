// ignore_for_file: avoid_print, use_build_context_synchronously
//keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
import 'dart:convert';
import 'dart:io';
import 'package:com_celesoft_notasieo/convivencia_provider.dart';
import 'package:com_celesoft_notasieo/estud_provider.dart';
import 'package:com_celesoft_notasieo/estudiante_provider.dart';
import 'package:com_celesoft_notasieo/inasistencias_provider.dart';
import 'package:com_celesoft_notasieo/notas_provider.dart';
import 'package:com_celesoft_notasieo/total_estudiantes_provider.dart';
import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:com_celesoft_notasieo/widgets/entrada_app.dart';
import 'package:com_celesoft_notasieo/widgets/entrada_docentes.dart';
import 'package:com_celesoft_notasieo/year_provider.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'widgets/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String urlbase = 'https://app.iedeoccidente.com';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  try {} catch (e) {
    print(e);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EstudianteProvider()),
        ChangeNotifierProvider(create: (context) => NotasProvider()),
        ChangeNotifierProvider(create: (context) => InasistenciasProvider()),
        ChangeNotifierProvider(create: (context) => EstudProvider()),
        ChangeNotifierProvider(create: (context) => ConvivenciaProvider()),
        ChangeNotifierProvider(create: (context) => TotalEstudiantesProvider()),
        ChangeNotifierProvider(create: (context) => YearProvider())
        // Agrega más providers si es necesario
      ],
      child: const MainApp(),
    ),
  );
  if (Platform.isWindows) {
    DesktopWindow.setWindowSize(const Size(480, 1040));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: EasySplashScreen(
        logo: Image.network('https://app.iedeoccidente.com/escudoNuevo2.png'),
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
        durationInSeconds: 2,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
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
  bool docente = false;
  String nombresDocente = "";
  String asignacionDocente = "";
  String periodo = "";
  late String estud;
  bool iniciando = false;
  List<String> years = [];
  //variables de estado
  TextEditingController usuarioController =
      TextEditingController(text: '1033789444');
  TextEditingController passwordController =
      TextEditingController(text: '1033789444*.*');
  TextEditingController yearController = TextEditingController();
  String theYear = DateTime.now().year.toString();

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

  Future getYears() async {
    final url = Uri.parse('$urlbase/getYearsData.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final theyears = json.decode(response.body);
      final List<String> years = theyears
          .map((item) => (item as Map<String, dynamic>)['year'].toString())
          .toList()
          .cast<String>();
      return years;
    } else {
      return [DateTime.now().year.toString()];
    }
  }

  Future<bool> fetchDataFromJson() async {
    final yearProvider = Provider.of<YearProvider>(context, listen: false);
    print({"yearProvider Main.dart": yearProvider.year});
    if (yearProvider.year.isEmpty) {
      yearProvider.setYear(DateTime.now().year.toString());
    }
    final url = Uri.parse('$urlbase/est/php/login.php');
    print({"url": url});
    final bodyData = json.encode({
      'identificacion': usuarioController.text,
      'pass': passwordController.text,
      'year': yearProvider.year
    });

    print({"bodyData": bodyData});

    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('docente')) {
        print({"docente": jsonResponse});
        docente = true;
        nombresDocente = jsonResponse['nombres'];
        asignacionDocente = jsonResponse['asignacion'];
        periodo = jsonResponse['periodo'];
        return true;
      } else if (jsonResponse['acceso'] == 'si') {
        final urlInasistencias = Uri.parse('$urlbase/est/php/getInasist.php');
        final bodyDataInasistencias = json.encode(
            {'estudiante': usuarioController.text, 'year': yearProvider.year});
        final responseInasistencias =
            await http.post(urlInasistencias, body: bodyDataInasistencias);
        final jsonResponseInasistencias =
            json.decode(responseInasistencias.body);
        print(jsonResponse);
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

        guardarValorLocal(estudianteProvider.estudiante);
      }
      return jsonResponse['acceso'] == 'si';
    } // ...
    return false;
  }

  void init() {
    estud = '-1';
    iniciando = false;
    setState(() {});
    final estudProvider = Provider.of<EstudProvider>(context, listen: false);
    //yearProvider.setYear(DateTime.now().year.toString());
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
        getYears().then((value) {
          print({value});
          years = value;
          setState(() {});
        });
        /*  usuarioController.text = '';
        passwordController.text = ''; */
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
      // init();
      final yearProvider = Provider.of<YearProvider>(context, listen: false);
      print({"yp": yearProvider.year});
      if (yearProvider.year.isEmpty) {
        yearProvider.setYear(DateTime.now().year.toString());
      }
      setState(() {
        login = true;
      });
      bool acceso = (await fetchDataFromJson());
      setState(() {
        login = false;
      });
      if (acceso) {
        if (docente) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntradaDocentes(
                docente: usuarioController.text,
                nombresDocente: nombresDocente,
                asignacionDocente: asignacionDocente,
                periodo: periodo,
                year: yearProvider.year,
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EntradaApp(
                        elPeriodo: '',
                      )));
        }
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
          login: login,
          years: years,
        ));
  }
}
