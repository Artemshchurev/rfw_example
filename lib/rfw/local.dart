import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';


LocalWidgetLibrary createLocalCustomWidgets() => LocalWidgetLibrary(_materialWidgetsDefinitions);

Map<String, LocalWidgetBuilder> get _materialWidgetsDefinitions =>
    <String, LocalWidgetBuilder>{
      'TextField': (BuildContext context, DataSource source) {

        return TextField(
          onChanged: source.handler(<Object>['onChanged'], (HandlerTrigger trigger) => (Object? value) => trigger(<String, Object?>{'value': value})),
        );
      },
    };