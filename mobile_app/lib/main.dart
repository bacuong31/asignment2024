import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/APIService.dart';
import 'package:mobile_app/model/StaffModel.dart';
import 'package:mobile_app/widget/StaffWidget.dart';
import 'package:http_server/http_server.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
Future<HttpClient> getClient() async {
  // ByteData data = await rootBundle.load('assets/cert.der');
  // SecurityContext context = SecurityContext(withTrustedRoots: false);
  // context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  // HttpClient client = HttpClient(context: context);
  HttpClient client = HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true 
  );
  return client;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = await getClient();
  final APIService apiService = APIService(client: client);
  runApp(MyApp(apiService: apiService,));
}

class MyApp extends StatelessWidget {
  final APIService apiService;
  const MyApp({super.key, required this.apiService});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
       
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: const Text("Staff List"),
      ),
        body: FutureBuilder<List<StaffModel>>(
          future: apiService.getStaffs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return StaffWidget(snapshot.data![i]);
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.apiService});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final APIService apiService;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<StaffModel> models = [];
  Future<void> fetchData() async {
    try {
      // ByteData data = await rootBundle.load('assets/cert.der');
      // SecurityContext context = SecurityContext(withTrustedRoots: false);
      // context.setTrustedCertificatesBytes(data.buffer.asUint8List());
      // HttpClient client = HttpClient(context: context);
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true 
        // // Convert the certificate to DER format
        // var certBytes = cert.pem
        //     .replaceAll('\n', '')
        //     .replaceAll('-----BEGIN CERTIFICATE-----', '')
        //     .replaceAll('-----END CERTIFICATE-----', '');
        // var certDER = base64Decode(certBytes);

        // // Load the pinned certificate
        // var pinnedCertBytes = data.buffer.asUint8List();

        // // Compare the server's certificate with the pinned certificate
        // return listEquals(certDER, pinnedCertBytes);
      );
      HttpClientRequest request =
          await client.getUrl(Uri.parse('https://10.0.2.2:8443/api/staffs'));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        String reply = await response.transform(utf8.decoder).join();
        setState(() {
          var list = jsonDecode(reply) as List;
          models = list.map((item) => StaffModel.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Failed to connect to the server: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView.builder(
              itemCount: models.length,
              itemBuilder: (context, i) {
                return StaffWidget(models[i]);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
