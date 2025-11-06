import '../../flutter_flow/flutter_flow_util.dart';
import '../../custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'reload_page_model.dart';
export 'reload_page_model.dart';

class ReloadPageWidget extends StatefulWidget {
  const ReloadPageWidget({super.key});

  static String routeName = 'ReloadPage';
  static String routePath = '/reloadPage';

  @override
  State<ReloadPageWidget> createState() => _ReloadPageWidgetState();
}

class _ReloadPageWidgetState extends State<ReloadPageWidget> {
  late ReloadPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReloadPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.loadHomePageAction(
        context,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
      ),
    );
  }
}
