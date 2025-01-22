import 'package:flutter/material.dart';
import 'package:rfw/formats.dart';
import 'package:rfw/rfw.dart';
import 'package:rfw_example/rfw/local.dart';

void main() {
  runApp(const MaterialApp(home: Example()));
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final Runtime _runtime = Runtime();
  final DynamicContent _data = DynamicContent();

  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _runtime.update(const LibraryName(<String>['core', 'widgets']), createCoreWidgets());
    _runtime.update(const LibraryName(<String>['core', 'material']), createMaterialWidgets());
    _runtime.update(const LibraryName(<String>['core', 'local']), createLocalCustomWidgets());
    _updateWidgets();
  }

  Future<void> _updateWidgets() async {
    // String fileName = 'https://raw.githubusercontent.com/flutter/packages/main/packages/rfw/example/remote/remote_widget_libraries/counter_app1.rfwtxt';
    // final HttpClientResponse fileResponse = await (await HttpClient().getUrl(Uri.parse(fileName))).close();
    // final String widgetContent = await fileResponse.transform(utf8.decoder).join();
    //
    // // final Directory home = await getApplicationSupportDirectory();
    // // final File rfwWidgetFile = File(path.join(home.path, 'widget.rfw'));
    // // rfwWidgetFile.writeAsBytesSync(encodeLibraryBlob(parseLibraryFile(widgetContent)));
    //
    // final RemoteWidgetLibrary remoteWidgets = parseLibraryFile(widgetContent);
    //
    // try {
    //   // _runtime.update(const LibraryName(<String>['main']), decodeLibraryBlob(await rfwWidgetFile.readAsBytes()));
    //   _runtime.update(const LibraryName(<String>['main']), remoteWidgets);
    //   setState(() {
    //     _ready = true;
    //   });
    // } catch (e, stack) {
    //   FlutterError.reportError(FlutterErrorDetails(exception: e, stack: stack));
    // }

    final RemoteWidgetLibrary _remoteWidgets = parseLibraryFile('''
    import core.widgets;
    import core.material;
    import core.local;

    widget root = Scaffold(
      appBar: AppBar(title: Text(text: "Demo app")),
      body: Center(
      child: Column(
        mainAxisAlignment: "center",
        children: [
          Text(text: 'Form', textAlign: "center"),
          Text(text: 'd5675ffefe7r', style: {fontSize: 36.0}),
          ListTile(
            title: Text(text: 'List Tile')
          ),
          TextField(),
          TextField(),
          ElevatedButton(
            onPressed: event "increment" { },
            child: Text(text: 'Login')
          )          
        ],
      ),
    ),
    );
    ''');
    _runtime.update(const LibraryName(<String>['main']), _remoteWidgets);
    setState(() {
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget result;

    if (_ready) {
      result = RemoteWidget(
        runtime: _runtime,
        data: _data,
        widget: const FullyQualifiedWidgetName(LibraryName(<String>['main']), 'root'),
      );
    } else {
      result = const Material(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Loading')
          ),
        ),
      );
    }

    return AnimatedSwitcher(duration: const Duration(milliseconds: 1250), switchOutCurve: Curves.easeOut, switchInCurve: Curves.easeOut, child: result);
  }
}
