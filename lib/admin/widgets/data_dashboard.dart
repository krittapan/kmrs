import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DataDashboard extends StatefulWidget {
  const DataDashboard({Key? key}) : super(key: key);

  @override
  State<DataDashboard> createState() => _DataDashboardState();
}

class _DataDashboardState extends State<DataDashboard> {
  late Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();

    //_iframeElement.height = '600';
    //_iframeElement.width = '800';

    _iframeElement.src =
        'https://datastudio.google.com/embed/reporting/873b3f9a-cbf7-4334-aec5-4ac2684ccee7/page/TghnC';
    _iframeElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Center(
            child: SizedBox(
              height: 600,
              width: 800,
              child: _iframeWidget,
            ),
          ),
        ),
      ),
    );
  }
}
