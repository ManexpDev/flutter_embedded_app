import 'dart:ui' show FlutterView;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runWidget(
    MultiViewApp(
      viewBuilder: (BuildContext context) {
        final int viewId = View.of(context).viewId;
        return MyApp(key: ValueKey("$viewId"));
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 50;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("EMBEDDED APP"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _counter,
        itemBuilder: (context, index) {
        return ListTile(
          tileColor: Theme.of(context).primaryColor,
          title: Text("TILE $index", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),);
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// Calls [viewBuilder] for every view added to the app to obtain the widget to
/// render into that view. The current view can be looked up with [View.of].
class MultiViewApp extends StatefulWidget {
  const MultiViewApp({super.key, required this.viewBuilder});

  final WidgetBuilder viewBuilder;

  @override
  State<MultiViewApp> createState() => _MultiViewAppState();
}

class _MultiViewAppState extends State<MultiViewApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void didUpdateWidget(MultiViewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Need to re-evaluate the viewBuilder callback for all views.
    _views.clear();
    _updateViews();
  }

  @override
  void didChangeMetrics() {
    _updateViews();
  }

  Map<Object, Widget> _views = <Object, Widget>{};

  void _updateViews() {
    final Map<Object, Widget> newViews = <Object, Widget>{};
    for (final FlutterView view
    in WidgetsBinding.instance.platformDispatcher.views) {
      final Widget viewWidget = _views[view.viewId] ?? _createViewWidget(view);
      newViews[view.viewId] = viewWidget;
    }
    setState(() {
      _views = newViews;
    });
  }

  Widget _createViewWidget(FlutterView view) {
    return View(
      view: view,
      child: Builder(
        builder: widget.viewBuilder,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}
