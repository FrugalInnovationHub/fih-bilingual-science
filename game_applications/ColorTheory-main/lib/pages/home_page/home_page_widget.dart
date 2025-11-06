import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.greenState = ColorStruct(
        name: 'Green',
        isVisible: true,
      );
      _model.yellowState = ColorStruct(
        name: 'Yellow',
      );
      _model.redState = ColorStruct(
        name: 'Red',
      );
      _model.purpleState = ColorStruct(
        name: 'Purple',
      );
      _model.orangeState = ColorStruct(
        name: 'Orange',
      );
      _model.brownState = ColorStruct(
        name: 'Brown',
      );
      _model.blueState = ColorStruct(
        name: 'Blue',
      );
      _model.pinkState = ColorStruct(
        name: 'Pink',
      );
      _model.isInit = true;
      safeSetState(() {});
      if (animationsMap['imageOnActionTriggerAnimation1'] != null) {
        animationsMap['imageOnActionTriggerAnimation1']!.controller.repeat();
      }
      if (animationsMap['imageOnActionTriggerAnimation2'] != null) {
        animationsMap['imageOnActionTriggerAnimation2']!.controller.repeat();
      }
      await Future.delayed(
        Duration(
          milliseconds: 200,
        ),
      );
      await actions.attachAppLifecycleAudioObserver();
      if (FFAppState().enableSound == true) {
        unawaited(
          () async {
            await actions.playAudioPlayerAsset(
              FFAppState().mainMenuAudioRef,
              FFAppState().soundVolumeBg,
              true,
            );
          }(),
        );
      }
    });

    animationsMap.addAll({
      'imageOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: null,
      ),
      'imageOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: null,
      ),
      'imageOnActionTriggerAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: null,
      ),
      'imageOnActionTriggerAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: null,
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF64B5F6),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/colortheory/images/cloud-final.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ).animateOnActionTrigger(
                animationsMap['imageOnActionTriggerAnimation1']!,
                effects: [
                  MoveEffect(
                    curve: Curves.linear,
                    delay: 0.0.ms,
                    duration: 14000.0.ms,
                    begin: Offset(0.0, 0.0),
                    end: Offset(
                        valueOrDefault<double>(
                          -MediaQuery.sizeOf(context).width,
                          0.0,
                        ),
                        0.0),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/colortheory/images/cloud-final.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ).animateOnActionTrigger(
                animationsMap['imageOnActionTriggerAnimation2']!,
                effects: [
                  MoveEffect(
                    curve: Curves.linear,
                    delay: 0.0.ms,
                    duration: 14000.0.ms,
                    begin: Offset(
                        valueOrDefault<double>(
                          MediaQuery.sizeOf(context).width,
                          0.0,
                        ),
                        0.0),
                    end: Offset(0.0, 0.0),
                  ),
                ],
              ),
              if (FFAppConstants.EnableDebug)
                Align(
                  alignment: AlignmentDirectional(-1.0, -1.0),
                  child: Container(
                    width: 500.0,
                    height: 100.0,
                    decoration: BoxDecoration(),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (responsiveVisibility(
                          context: context,
                          tabletLandscape: false,
                          desktop: false,
                        ))
                          Text(
                            'PlayerYAlignment: ${_model.playerYAlignment.toString()}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        if (responsiveVisibility(
                          context: context,
                          tabletLandscape: false,
                          desktop: false,
                        ))
                          Text(
                            'CactusXAlignment: ${_model.cactusXAlignment.toString()}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        Text(
                          'enableSound ${FFAppState().enableSound.toString()}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        Text(
                          'pauseSound: ${FFAppState().pauseSound.toString()}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                        if (responsiveVisibility(
                          context: context,
                          desktop: false,
                        ))
                          Text(
                            'currentColor: ${_model.currentColor}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        if (responsiveVisibility(
                          context: context,
                          desktop: false,
                        ))
                          Text(
                            'green:${_model.greenState?.isVisible.toString()}yellow:${_model.yellowState?.isVisible.toString()}red:${_model.redState?.isVisible.toString()}purple:${_model.purpleState?.isVisible.toString()}orange:${_model.orangeState?.isVisible.toString()}brown:${_model.brownState?.isVisible.toString()}blue:${_model.blueState?.isVisible.toString()}pink:${_model.pinkState?.isVisible.toString()}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        Text(
                          valueOrDefault<String>(
                            FFAppState()
                                .highScoreList
                                .firstOrNull
                                ?.score
                                .toString(),
                            '0',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              Builder(
                builder: (context) {
                  if (_model.currentPageStack == CurrentPageStack.GAMESTACK) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            'assets/colortheory/images/ground.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['imageOnActionTriggerAnimation3']!,
                          effects: [
                            MoveEffect(
                              curve: Curves.linear,
                              delay: 0.0.ms,
                              duration: 3500.0.ms,
                              begin: Offset(0.0, 0.0),
                              end: Offset(
                                  valueOrDefault<double>(
                                    -MediaQuery.sizeOf(context).width,
                                    0.0,
                                  ),
                                  0.0),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.asset(
                            'assets/colortheory/images/ground.png',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['imageOnActionTriggerAnimation4']!,
                          effects: [
                            MoveEffect(
                              curve: Curves.linear,
                              delay: 0.0.ms,
                              duration: 3500.0.ms,
                              begin: Offset(
                                  valueOrDefault<double>(
                                    MediaQuery.sizeOf(context).width,
                                    0.0,
                                  ),
                                  0.0),
                              end: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(
                              -1.0,
                              valueOrDefault<double>(
                                _model.playerYAlignment,
                                0.06,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0.0),
                            child: Image.asset(
                              'assets/colortheory/images/dino-final.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                              alignment: Alignment(0.0, 0.0),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(
                              valueOrDefault<double>(
                                _model.cactusXAlignment,
                                0.0,
                              ),
                              0.08),
                          child: Container(
                            width: 200.0,
                            height: 200.0,
                            child: Stack(
                              children: [
                                if (_model.greenState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/cactus.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.pinkState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/mushroom.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.blueState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/wave.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.brownState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/wood.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.orangeState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/lava-final.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.purpleState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/snake.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.redState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/bomb-final.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                                if (_model.yellowState?.isVisible ?? true)
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/colortheory/images/flame.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                        alignment: Alignment(0.0, 0.0),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_model.isGameOver)
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      valueOrDefault<double>(
                                        FFAppConstants.RestartGameButtonPadding
                                            .toDouble(),
                                        0.0,
                                      ),
                                      0.0,
                                      0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      _model.cactusXAlignment = 1.0;
                                      _model.playerYAlignment = 0.02;
                                      _model.isGameOver = !_model.isGameOver;
                                      safeSetState(() {});
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation3'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation3']!
                                            .controller
                                            .reset();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation4'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation4']!
                                            .controller
                                            .reset();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation1'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation1']!
                                            .controller
                                            .reset();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation2'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation2']!
                                            .controller
                                            .reset();
                                      }
                                      _model.leftButtonColor =
                                          FFAppConstants.DefaultButtonColor;
                                      _model.midButtonColor =
                                          FFAppConstants.DefaultButtonColor;
                                      _model.rightButtonColor =
                                          FFAppConstants.DefaultButtonColor;
                                      _model.currentScore = 0;
                                      safeSetState(() {});
                                      FFAppState().pauseSound = false;
                                      if (FFAppState().enableSound == true) {
                                        unawaited(
                                          () async {
                                            await actions.playAudioPlayerAsset(
                                              FFAppState().mainMenuAudioRef,
                                              FFAppState().soundVolumeBg,
                                              true,
                                            );
                                          }(),
                                        );
                                      }
                                      await Future.delayed(
                                        Duration(
                                          milliseconds: 250,
                                        ),
                                      );
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation3'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation3']!
                                            .controller
                                          ..reset()
                                          ..repeat();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation4'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation4']!
                                            .controller
                                          ..reset()
                                          ..repeat();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation1'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation1']!
                                            .controller
                                          ..reset()
                                          ..repeat();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation2'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation2']!
                                            .controller
                                          ..reset()
                                          ..repeat();
                                      }
                                      _model.CactusMovementRestartGame =
                                          InstantTimer.periodic(
                                        duration: Duration(milliseconds: 10),
                                        callback: (timer) async {
                                          _model.cactusXAlignment =
                                              _model.cactusXAlignment + -0.01;
                                          _model.currentScore =
                                              _model.currentScore + 1;
                                          safeSetState(() {});
                                          if ((_model.cactusXAlignment <= -0.79) &&
                                              (_model.cactusXAlignment >=
                                                  -1.2) &&
                                              (_model.playerYAlignment >=
                                                  -0.35) &&
                                              (_model.playerYAlignment <=
                                                  _model.playerInitialY)) {
                                            _model.CactusMovementRestartGame
                                                ?.cancel();
                                            _model.PlayerJumpLeftBtn?.cancel();
                                            _model.PlayerJumpMidBtn?.cancel();
                                            _model.PlayerJumpRightBtn?.cancel();
                                            if (animationsMap[
                                                    'imageOnActionTriggerAnimation3'] !=
                                                null) {
                                              animationsMap[
                                                      'imageOnActionTriggerAnimation3']!
                                                  .controller
                                                  .stop();
                                            }
                                            if (animationsMap[
                                                    'imageOnActionTriggerAnimation4'] !=
                                                null) {
                                              animationsMap[
                                                      'imageOnActionTriggerAnimation4']!
                                                  .controller
                                                  .stop();
                                            }
                                            if (animationsMap[
                                                    'imageOnActionTriggerAnimation1'] !=
                                                null) {
                                              animationsMap[
                                                      'imageOnActionTriggerAnimation1']!
                                                  .controller
                                                  .stop();
                                            }
                                            if (animationsMap[
                                                    'imageOnActionTriggerAnimation2'] !=
                                                null) {
                                              animationsMap[
                                                      'imageOnActionTriggerAnimation2']!
                                                  .controller
                                                  .stop();
                                            }
                                            if (FFAppState().enableSound ==
                                                true) {
                                              unawaited(
                                                () async {
                                                  await actions
                                                      .pauseAudioPlayerAsset(
                                                    FFAppState()
                                                        .mainMenuAudioRef,
                                                  );
                                                }(),
                                              );
                                              unawaited(
                                                () async {
                                                  await actions
                                                      .playAudioPlayerAsset(
                                                    FFAppState()
                                                        .gameOverAudioRef,
                                                    FFAppState().soundVolumeBg,
                                                    false,
                                                  );
                                                }(),
                                              );
                                            }
                                            _model.isGameOver =
                                                !_model.isGameOver;
                                            safeSetState(() {});
                                            _model.addNewHighScoreActionResultRestartGame =
                                                await actions.addNewHighScore(
                                              FFAppState()
                                                  .highScoreList
                                                  .toList(),
                                              _model.currentScore,
                                            );
                                            FFAppState().pauseSound = true;
                                            FFAppState().highScoreList = _model
                                                .addNewHighScoreActionResultRestartGame!
                                                .toList()
                                                .cast<HighScoreInfoStruct>();
                                          }
                                          if (_model.cactusXAlignment <= -1.5) {
                                            _model.changeColorActionResultRestartGame =
                                                await actions.changeColorAction(
                                              _model.currentColor,
                                              _model.greenState!,
                                              _model.yellowState!,
                                              _model.redState!,
                                              _model.purpleState!,
                                              _model.orangeState!,
                                              _model.brownState!,
                                              _model.blueState!,
                                              _model.pinkState!,
                                              FFLocalizations.of(context)
                                                  .languageCode,
                                            );
                                            _model.cactusXAlignment =
                                                _model.cactusInitialX;
                                            _model.currentColor = _model
                                                .changeColorActionResultRestartGame!
                                                .currentColor;
                                            _model.greenState = _model
                                                .changeColorActionResultRestartGame
                                                ?.greenState;
                                            _model.yellowState = _model
                                                .changeColorActionResultRestartGame
                                                ?.yellowState;
                                            _model.redState = _model
                                                .changeColorActionResultRestartGame
                                                ?.redState;
                                            _model.purpleState = _model
                                                .changeColorActionResultRestartGame
                                                ?.purpleState;
                                            _model.orangeState = _model
                                                .changeColorActionResultRestartGame
                                                ?.orangeState;
                                            _model.brownState = _model
                                                .changeColorActionResultRestartGame
                                                ?.brownState;
                                            _model.blueState = _model
                                                .changeColorActionResultRestartGame
                                                ?.blueState;
                                            _model.pinkState = _model
                                                .changeColorActionResultRestartGame
                                                ?.pinkState;
                                            _model.leftButtonVal = _model
                                                .changeColorActionResultRestartGame!
                                                .leftButtonVal;
                                            _model.midButtonVal = _model
                                                .changeColorActionResultRestartGame!
                                                .midButtonVal;
                                            _model.rightButtonVal = _model
                                                .changeColorActionResultRestartGame!
                                                .rightButtonVal;
                                            _model.leftButtonColor =
                                                FFAppConstants
                                                    .DefaultButtonColor;
                                            _model.midButtonColor =
                                                FFAppConstants
                                                    .DefaultButtonColor;
                                            _model.rightButtonColor =
                                                FFAppConstants
                                                    .DefaultButtonColor;
                                            safeSetState(() {});
                                          }
                                        },
                                        startImmediately: true,
                                      );

                                      safeSetState(() {});
                                    },
                                    text: FFLocalizations.of(context).getText(
                                      '1ntr7h2c' /* Restart Game */,
                                    ),
                                    options: FFButtonOptions(
                                      width: 250.0,
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FFAppConstants.DefaultButtonColor,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Silkscreen',
                                            color: Colors.white,
                                            fontSize: 21.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      valueOrDefault<double>(
                                        FFAppConstants.StartGameButtonPadding
                                            .toDouble(),
                                        0.0,
                                      ),
                                      0.0,
                                      0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation3'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation3']!
                                            .controller
                                            .reset();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation4'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation4']!
                                            .controller
                                            .reset();
                                      }
                                      _model.changeColorActionResultMainMenu =
                                          await actions.changeColorAction(
                                        _model.currentColor,
                                        _model.greenState!,
                                        _model.yellowState!,
                                        _model.redState!,
                                        _model.purpleState!,
                                        _model.orangeState!,
                                        _model.brownState!,
                                        _model.blueState!,
                                        _model.pinkState!,
                                        FFLocalizations.of(context)
                                            .languageCode,
                                      );
                                      _model.greenState = _model
                                          .changeColorActionResultMainMenu
                                          ?.greenState;
                                      _model.yellowState = _model
                                          .changeColorActionResultMainMenu
                                          ?.yellowState;
                                      _model.redState = _model
                                          .changeColorActionResultMainMenu
                                          ?.redState;
                                      _model.purpleState = _model
                                          .changeColorActionResultMainMenu
                                          ?.purpleState;
                                      _model.orangeState = _model
                                          .changeColorActionResultMainMenu
                                          ?.orangeState;
                                      _model.brownState = _model
                                          .changeColorActionResultMainMenu
                                          ?.brownState;
                                      _model.blueState = _model
                                          .changeColorActionResultMainMenu
                                          ?.blueState;
                                      _model.pinkState = _model
                                          .changeColorActionResultMainMenu
                                          ?.pinkState;
                                      _model.currentPageStack =
                                          CurrentPageStack.HOMESTACK;
                                      _model.isGameOver = !_model.isGameOver;
                                      _model.cactusXAlignment =
                                          _model.cactusInitialX;
                                      _model.playerYAlignment =
                                          _model.playerInitialY;
                                      _model.leftButtonColor =
                                          FFAppConstants.DefaultButtonColor;
                                      _model.midButtonColor =
                                          FFAppConstants.DefaultButtonColor;
                                      _model.rightButtonColor =
                                          FFAppConstants.DefaultButtonColor;
                                      _model.currentColor = _model
                                          .changeColorActionResultMainMenu!
                                          .currentColor;
                                      _model.leftButtonVal = _model
                                          .changeColorActionResultMainMenu!
                                          .leftButtonVal;
                                      _model.midButtonVal = _model
                                          .changeColorActionResultMainMenu!
                                          .midButtonVal;
                                      _model.rightButtonVal = _model
                                          .changeColorActionResultMainMenu!
                                          .rightButtonVal;
                                      safeSetState(() {});
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation1'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation1']!
                                            .controller
                                            .repeat();
                                      }
                                      if (animationsMap[
                                              'imageOnActionTriggerAnimation2'] !=
                                          null) {
                                        animationsMap[
                                                'imageOnActionTriggerAnimation2']!
                                            .controller
                                            .repeat();
                                      }
                                      if (FFAppState().enableSound == true) {
                                        unawaited(
                                          () async {
                                            await actions.playAudioPlayerAsset(
                                              FFAppState().mainMenuAudioRef,
                                              FFAppState().soundVolumeBg,
                                              true,
                                            );
                                          }(),
                                        );
                                      }
                                      FFAppState().pauseSound = false;

                                      safeSetState(() {});
                                    },
                                    text: FFLocalizations.of(context).getText(
                                      '7hulvhkl' /* Main Menu */,
                                    ),
                                    options: FFButtonOptions(
                                      width: 250.0,
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FFAppConstants.DefaultButtonColor,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Silkscreen',
                                            color: Colors.white,
                                            fontSize: 21.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.65),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  if (FFLocalizations.of(context)
                                          .languageCode ==
                                      'en') {
                                    _model.selectedLeftButtonColorEn =
                                        await actions.setButtonColorAction(
                                      FFAppConstants.ColorOrder.toList(),
                                      FFAppConstants.ColorCodeOrder.toList(),
                                      _model.leftButtonVal,
                                      FFAppConstants.DefaultButtonColor,
                                    );
                                    _model.leftButtonColor = _model
                                        .selectedLeftButtonColorEn!.colorCode!;
                                    safeSetState(() {});
                                    if (FFAppState().enableSound == true) {
                                      unawaited(
                                        () async {
                                          await actions.playAudioPlayerAtIndex(
                                            FFAppState()
                                                .colorAudioEnRef
                                                .toList(),
                                            _model.selectedLeftButtonColorEn!
                                                .colorIndex,
                                            FFAppState().soundVolumeGame,
                                          );
                                        }(),
                                      );
                                    }
                                  } else {
                                    _model.selectedLeftButtonColorEs =
                                        await actions.setButtonColorAction(
                                      FFAppConstants.ColorOrderEs.toList(),
                                      FFAppConstants.ColorCodeOrder.toList(),
                                      _model.leftButtonVal,
                                      FFAppConstants.DefaultButtonColor,
                                    );
                                    _model.leftButtonColor = _model
                                        .selectedLeftButtonColorEs!.colorCode!;
                                    safeSetState(() {});
                                    if (FFAppState().enableSound == true) {
                                      unawaited(
                                        () async {
                                          await actions.playAudioPlayerAtIndex(
                                            FFAppState()
                                                .colorAudioEsRef
                                                .toList(),
                                            _model.selectedLeftButtonColorEs!
                                                .colorIndex,
                                            FFAppState().soundVolumeGame,
                                          );
                                        }(),
                                      );
                                    }
                                  }

                                  if (_model.currentColor ==
                                      _model.leftButtonVal) {
                                    _model.jumpIsAscending = true;
                                    safeSetState(() {});
                                    _model.PlayerJumpLeftBtn =
                                        InstantTimer.periodic(
                                      duration: Duration(milliseconds: 20),
                                      callback: (timer) async {
                                        if (_model.jumpIsAscending!) {
                                          _model.playerYAlignment =
                                              _model.playerYAlignment + -0.035;
                                          safeSetState(() {});
                                          if (_model.playerYAlignment <=
                                              _model.jumpPeakHeight) {
                                            _model.jumpIsAscending = false;
                                            safeSetState(() {});
                                          }
                                        } else {
                                          _model.playerYAlignment =
                                              _model.playerYAlignment + 0.035;
                                          safeSetState(() {});
                                          if (_model.playerYAlignment >=
                                              _model.playerInitialY) {
                                            _model.jumpIsAscending = null;
                                            _model.playerYAlignment =
                                                _model.playerInitialY;
                                            safeSetState(() {});
                                            _model.PlayerJumpLeftBtn?.cancel();
                                          }
                                        }
                                      },
                                      startImmediately: true,
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: _model.leftButtonVal,
                                options: FFButtonOptions(
                                  width: 140.0,
                                  height: 80.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: _model.leftButtonColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                    fontFamily: 'Silkscreen',
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF364E5C),
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  var _shouldSetState = false;
                                  if (FFLocalizations.of(context)
                                          .languageCode ==
                                      'en') {
                                    _model.selectedMidButtonColorEn =
                                        await actions.setButtonColorAction(
                                      FFAppConstants.ColorOrder.toList(),
                                      FFAppConstants.ColorCodeOrder.toList(),
                                      _model.midButtonVal,
                                      FFAppConstants.DefaultButtonColor,
                                    );
                                    _shouldSetState = true;
                                    _model.midButtonColor = _model
                                        .selectedMidButtonColorEn!.colorCode!;
                                    safeSetState(() {});
                                    if (FFAppState().enableSound == true) {
                                      unawaited(
                                        () async {
                                          await actions.playAudioPlayerAtIndex(
                                            FFAppState()
                                                .colorAudioEnRef
                                                .toList(),
                                            _model.selectedMidButtonColorEn!
                                                .colorIndex,
                                            FFAppState().soundVolumeGame,
                                          );
                                        }(),
                                      );
                                    }
                                  } else {
                                    _model.selectedMidButtonColorEs =
                                        await actions.setButtonColorAction(
                                      FFAppConstants.ColorOrderEs.toList(),
                                      FFAppConstants.ColorCodeOrder.toList(),
                                      _model.midButtonVal,
                                      FFAppConstants.DefaultButtonColor,
                                    );
                                    _shouldSetState = true;
                                    _model.midButtonColor = _model
                                        .selectedMidButtonColorEs!.colorCode!;
                                    safeSetState(() {});
                                    if (FFAppState().enableSound == true) {
                                      unawaited(
                                        () async {
                                          await actions.playAudioPlayerAtIndex(
                                            FFAppState()
                                                .colorAudioEsRef
                                                .toList(),
                                            _model.selectedMidButtonColorEs!
                                                .colorIndex,
                                            FFAppState().soundVolumeGame,
                                          );
                                        }(),
                                      );
                                    }
                                  }

                                  if (_model.currentColor ==
                                      _model.midButtonVal) {
                                    _model.jumpIsAscending = true;
                                    safeSetState(() {});
                                    _model.PlayerJumpMidBtn =
                                        InstantTimer.periodic(
                                      duration: Duration(milliseconds: 20),
                                      callback: (timer) async {
                                        if (_model.jumpIsAscending!) {
                                          _model.playerYAlignment =
                                              _model.playerYAlignment + -0.035;
                                          safeSetState(() {});
                                          if (_model.playerYAlignment <=
                                              _model.jumpPeakHeight) {
                                            _model.jumpIsAscending = false;
                                            safeSetState(() {});
                                          }
                                        } else {
                                          _model.playerYAlignment =
                                              _model.playerYAlignment + 0.035;
                                          safeSetState(() {});
                                          if (_model.playerYAlignment >=
                                              _model.playerInitialY) {
                                            _model.jumpIsAscending = null;
                                            _model.playerYAlignment =
                                                _model.playerInitialY;
                                            safeSetState(() {});
                                            _model.PlayerJumpMidBtn?.cancel();
                                          }
                                        }
                                      },
                                      startImmediately: true,
                                    );
                                  } else {
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }

                                  if (_shouldSetState) safeSetState(() {});
                                },
                                text: _model.midButtonVal,
                                options: FFButtonOptions(
                                  width: 140.0,
                                  height: 80.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: _model.midButtonColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                    fontFamily: 'Silkscreen',
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF364E5C),
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  var _shouldSetState = false;
                                  if (FFLocalizations.of(context)
                                          .languageCode ==
                                      'en') {
                                    _model.selectedRightButtonColorEn =
                                        await actions.setButtonColorAction(
                                      FFAppConstants.ColorOrder.toList(),
                                      FFAppConstants.ColorCodeOrder.toList(),
                                      _model.rightButtonVal,
                                      FFAppConstants.DefaultButtonColor,
                                    );
                                    _shouldSetState = true;
                                    _model.rightButtonColor = _model
                                        .selectedRightButtonColorEn!.colorCode!;
                                    safeSetState(() {});
                                    if (FFAppState().enableSound == true) {
                                      unawaited(
                                        () async {
                                          await actions.playAudioPlayerAtIndex(
                                            FFAppState()
                                                .colorAudioEnRef
                                                .toList(),
                                            _model.selectedRightButtonColorEn!
                                                .colorIndex,
                                            FFAppState().soundVolumeGame,
                                          );
                                        }(),
                                      );
                                    }
                                  } else {
                                    _model.selectedRightButtonColorEs =
                                        await actions.setButtonColorAction(
                                      FFAppConstants.ColorOrderEs.toList(),
                                      FFAppConstants.ColorCodeOrder.toList(),
                                      _model.rightButtonVal,
                                      FFAppConstants.DefaultButtonColor,
                                    );
                                    _shouldSetState = true;
                                    _model.rightButtonColor = _model
                                        .selectedRightButtonColorEs!.colorCode!;
                                    safeSetState(() {});
                                    if (FFAppState().enableSound == true) {
                                      unawaited(
                                        () async {
                                          await actions.playAudioPlayerAtIndex(
                                            FFAppState()
                                                .colorAudioEsRef
                                                .toList(),
                                            _model.selectedRightButtonColorEs!
                                                .colorIndex,
                                            FFAppState().soundVolumeGame,
                                          );
                                        }(),
                                      );
                                    }
                                  }

                                  if (_model.currentColor ==
                                      _model.rightButtonVal) {
                                    _model.jumpIsAscending = true;
                                    safeSetState(() {});
                                    _model.PlayerJumpRightBtn =
                                        InstantTimer.periodic(
                                      duration: Duration(milliseconds: 20),
                                      callback: (timer) async {
                                        if (_model.jumpIsAscending!) {
                                          _model.playerYAlignment =
                                              _model.playerYAlignment + -0.035;
                                          safeSetState(() {});
                                          if (_model.playerYAlignment <=
                                              _model.jumpPeakHeight) {
                                            _model.jumpIsAscending = false;
                                            safeSetState(() {});
                                          }
                                        } else {
                                          _model.playerYAlignment =
                                              _model.playerYAlignment + 0.035;
                                          safeSetState(() {});
                                          if (_model.playerYAlignment >=
                                              _model.playerInitialY) {
                                            _model.jumpIsAscending = null;
                                            _model.playerYAlignment =
                                                _model.playerInitialY;
                                            safeSetState(() {});
                                            _model.PlayerJumpRightBtn?.cancel();
                                          }
                                        }
                                      },
                                      startImmediately: true,
                                    );
                                  } else {
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }

                                  if (_shouldSetState) safeSetState(() {});
                                },
                                text: _model.rightButtonVal,
                                options: FFButtonOptions(
                                  width: 140.0,
                                  height: 80.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: _model.rightButtonColor,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                    fontFamily: 'Silkscreen',
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF364E5C),
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            ].divide(SizedBox(width: 150.0)),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      FFAppConstants.CurrentScoreLeftPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    valueOrDefault<double>(
                                      FFAppConstants.CurrentScoreTopPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText(
                                    'bhm1blwh' /* SCORE */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Silkscreen',
                                        color: Colors.white,
                                        fontSize: 21.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      FFAppConstants.CurrentScoreLeftPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0,
                                    0.0),
                                child: Text(
                                  formatNumber(
                                    _model.currentScore,
                                    formatType: FormatType.custom,
                                    format: '0000000',
                                    locale: '',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Silkscreen',
                                        color: Colors.white,
                                        fontSize: 21.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (_model.currentPageStack ==
                      CurrentPageStack.TRANSLATIONSTACK) {
                    return Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 100.0, 0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Image.asset(
                                    'assets/colortheory/images/color_theory_trans_icon-final.png',
                                    width: 400.0,
                                    height: 300.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: (FFLocalizations.of(context)
                                              .languageCode ==
                                          'en')
                                      ? null
                                      : () async {
                                          setAppLanguage(context, 'en');
                                          _model.checkLangChangeEn =
                                              InstantTimer.periodic(
                                            duration:
                                                Duration(milliseconds: 100),
                                            callback: (timer) async {
                                              if (FFLocalizations.of(context)
                                                      .languageCode ==
                                                  'en') {
                                                _model.updateGreenStateStruct(
                                                  (e) => e..name = 'Green',
                                                );
                                                _model.updateYellowStateStruct(
                                                  (e) => e..name = 'Yellow',
                                                );
                                                _model.updateRedStateStruct(
                                                  (e) => e..name = 'Red',
                                                );
                                                _model.updatePurpleStateStruct(
                                                  (e) => e..name = 'Purple',
                                                );
                                                _model.updateOrangeStateStruct(
                                                  (e) => e..name = 'Orange',
                                                );
                                                _model.updateBrownStateStruct(
                                                  (e) => e..name = 'Brown',
                                                );
                                                _model.updateBlueStateStruct(
                                                  (e) => e..name = 'Blue',
                                                );
                                                _model.updatePinkStateStruct(
                                                  (e) => e..name = 'Pink',
                                                );
                                                safeSetState(() {});
                                                if (_model.isInit) {
                                                  _model.leftButtonVal =
                                                      'Green';
                                                  _model.midButtonVal =
                                                      'Yellow';
                                                  _model.rightButtonVal = 'Red';
                                                  _model.currentColor = 'Green';
                                                  safeSetState(() {});
                                                } else {
                                                  _model.changeColorActionResultEnButton =
                                                      await actions
                                                          .changeColorAction(
                                                    _model.currentColor,
                                                    _model.greenState!,
                                                    _model.yellowState!,
                                                    _model.redState!,
                                                    _model.purpleState!,
                                                    _model.orangeState!,
                                                    _model.brownState!,
                                                    _model.blueState!,
                                                    _model.pinkState!,
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                                  );
                                                  _model.greenState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.greenState;
                                                  _model.yellowState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.yellowState;
                                                  _model.redState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.redState;
                                                  _model.purpleState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.purpleState;
                                                  _model.orangeState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.orangeState;
                                                  _model.brownState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.brownState;
                                                  _model.blueState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.blueState;
                                                  _model.pinkState = _model
                                                      .changeColorActionResultEnButton
                                                      ?.pinkState;
                                                  _model.currentColor = _model
                                                      .changeColorActionResultEnButton!
                                                      .currentColor;
                                                  _model.leftButtonVal = _model
                                                      .changeColorActionResultEnButton!
                                                      .leftButtonVal;
                                                  _model.midButtonVal = _model
                                                      .changeColorActionResultEnButton!
                                                      .midButtonVal;
                                                  _model.rightButtonVal = _model
                                                      .changeColorActionResultEnButton!
                                                      .rightButtonVal;
                                                  safeSetState(() {});
                                                }

                                                _model.checkLangChangeEn
                                                    ?.cancel();
                                              }
                                            },
                                            startImmediately: true,
                                          );

                                          safeSetState(() {});
                                        },
                                  text: FFLocalizations.of(context).getText(
                                    '6dnqp9fq' /* ENGLISH */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                    disabledColor: Color(0xFFC6C2F3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: (FFLocalizations.of(context)
                                              .languageCode ==
                                          'es')
                                      ? null
                                      : () async {
                                          setAppLanguage(context, 'es');
                                          _model.checkLangChangeEs =
                                              InstantTimer.periodic(
                                            duration:
                                                Duration(milliseconds: 100),
                                            callback: (timer) async {
                                              if (FFLocalizations.of(context)
                                                      .languageCode ==
                                                  'es') {
                                                _model.updateGreenStateStruct(
                                                  (e) => e..name = 'Verde',
                                                );
                                                _model.updateYellowStateStruct(
                                                  (e) => e..name = 'Amarillo',
                                                );
                                                _model.updateRedStateStruct(
                                                  (e) => e..name = 'Rojo',
                                                );
                                                _model.updatePurpleStateStruct(
                                                  (e) => e..name = 'Morado',
                                                );
                                                _model.updateOrangeStateStruct(
                                                  (e) => e..name = 'Naranja',
                                                );
                                                _model.updateBrownStateStruct(
                                                  (e) => e..name = 'Marrón',
                                                );
                                                _model.updateBlueStateStruct(
                                                  (e) => e..name = 'Azul',
                                                );
                                                _model.updatePinkStateStruct(
                                                  (e) => e..name = 'Rosa',
                                                );
                                                safeSetState(() {});
                                                if (_model.isInit) {
                                                  _model.leftButtonVal =
                                                      'Verde';
                                                  _model.midButtonVal =
                                                      'Amarillo';
                                                  _model.rightButtonVal =
                                                      'Rojo';
                                                  _model.currentColor = 'Verde';
                                                  safeSetState(() {});
                                                } else {
                                                  _model.changeColorActionResultEspButton =
                                                      await actions
                                                          .changeColorAction(
                                                    _model.currentColor,
                                                    _model.greenState!,
                                                    _model.yellowState!,
                                                    _model.redState!,
                                                    _model.purpleState!,
                                                    _model.orangeState!,
                                                    _model.brownState!,
                                                    _model.blueState!,
                                                    _model.pinkState!,
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                                  );
                                                  _model.greenState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.greenState;
                                                  _model.yellowState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.yellowState;
                                                  _model.redState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.redState;
                                                  _model.purpleState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.purpleState;
                                                  _model.orangeState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.orangeState;
                                                  _model.brownState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.brownState;
                                                  _model.blueState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.blueState;
                                                  _model.pinkState = _model
                                                      .changeColorActionResultEspButton
                                                      ?.pinkState;
                                                  _model.currentColor = _model
                                                      .changeColorActionResultEspButton!
                                                      .currentColor;
                                                  _model.leftButtonVal = _model
                                                      .changeColorActionResultEspButton!
                                                      .leftButtonVal;
                                                  _model.midButtonVal = _model
                                                      .changeColorActionResultEspButton!
                                                      .midButtonVal;
                                                  _model.rightButtonVal = _model
                                                      .changeColorActionResultEspButton!
                                                      .rightButtonVal;
                                                  safeSetState(() {});
                                                }

                                                _model.checkLangChangeEs
                                                    ?.cancel();
                                              }
                                            },
                                            startImmediately: true,
                                          );

                                          safeSetState(() {});
                                        },
                                  text: FFLocalizations.of(context).getText(
                                    'mtpsq7iy' /* SPANISH */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                    disabledColor: Color(0xFFC6C2F3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.currentPageStack =
                                        CurrentPageStack.HOMESTACK;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    '0fsb3od0' /* MAIN MENU */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (_model.currentPageStack ==
                      CurrentPageStack.SOUNDSTACK) {
                    return Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 100.0, 0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Image.asset(
                                    'assets/colortheory/images/color_theory_trans_icon-final.png',
                                    width: 400.0,
                                    height: 300.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: (FFAppState().enableSound == true)
                                      ? null
                                      : () async {
                                          unawaited(
                                            () async {
                                              await actions
                                                  .playAudioPlayerAsset(
                                                FFAppState().mainMenuAudioRef,
                                                FFAppState().soundVolumeBg,
                                                true,
                                              );
                                            }(),
                                          );
                                          FFAppState().enableSound = true;
                                          safeSetState(() {});
                                        },
                                  text: FFLocalizations.of(context).getText(
                                    '7u3xay9i' /* On */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                    disabledColor: Color(0xFFC6C2F3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: (FFAppState().enableSound == false)
                                      ? null
                                      : () async {
                                          if (FFAppState().mainMenuAudioRef !=
                                              null) {
                                            await actions.pauseAudioPlayerAsset(
                                              FFAppState().mainMenuAudioRef,
                                            );
                                            FFAppState().enableSound = false;
                                            safeSetState(() {});
                                          }
                                        },
                                  text: FFLocalizations.of(context).getText(
                                    'yl3f8tio' /* Off */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                    disabledColor: Color(0xFFC6C2F3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.currentPageStack =
                                        CurrentPageStack.HOMESTACK;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'yojnlnie' /* MAIN MENU */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (_model.currentPageStack ==
                      CurrentPageStack.HIGHSCORESTACK) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              150.0,
                              valueOrDefault<double>(
                                FFAppConstants.HighScoreStackTitlePaddingTop
                                    .toDouble(),
                                0.0,
                              ),
                              150.0,
                              valueOrDefault<double>(
                                FFAppConstants.HighScoreStackTitlePaddingTop
                                    .toDouble(),
                                0.0,
                              )),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'fx0yucmj' /* Rank */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Silkscreen',
                                      color: Colors.white,
                                      fontSize: 56.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  'mfq4dl6r' /* Score */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Silkscreen',
                                      color: Colors.white,
                                      fontSize: 56.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '64joki1t' /* Date */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Silkscreen',
                                      color: Colors.white,
                                      fontSize: 56.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              0.0,
                              0.0,
                              valueOrDefault<double>(
                                FFAppConstants.HighScoreStackTitlePaddingTop
                                    .toDouble(),
                                0.0,
                              )),
                          child: Builder(
                            builder: (context) {
                              final highScoreList =
                                  FFAppState().highScoreList.toList();

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: highScoreList.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 16.0),
                                itemBuilder: (context, highScoreListIndex) {
                                  final highScoreListItem =
                                      highScoreList[highScoreListIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        200.0, 0.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            (highScoreListIndex + 1).toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Silkscreen',
                                                  color: Colors.white,
                                                  fontSize: 26.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    200.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              highScoreListItem.score
                                                  .toString(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Silkscreen',
                                                        color: Colors.white,
                                                        fontSize: 26.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    230.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              highScoreListItem.datetime,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Silkscreen',
                                                        color: Colors.white,
                                                        fontSize: 26.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              valueOrDefault<double>(
                                FFAppConstants.StartGameButtonPadding
                                    .toDouble(),
                                0.0,
                              ),
                              0.0,
                              0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              _model.currentPageStack =
                                  CurrentPageStack.HOMESTACK;
                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              '0qmfdaid' /* MAIN MENU */,
                            ),
                            options: FFButtonOptions(
                              width: 250.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FFAppConstants.DefaultButtonColor,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Silkscreen',
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 100.0, 0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Image.asset(
                                    'assets/colortheory/images/color_theory_trans_icon-final.png',
                                    width: 400.0,
                                    height: 300.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.currentPageStack =
                                        CurrentPageStack.GAMESTACK;
                                    _model.isInit = false;
                                    _model.currentScore = 0;
                                    safeSetState(() {});
                                    await actions.refreshPageAction(
                                      context,
                                    );
                                    await Future.delayed(
                                      Duration(
                                        milliseconds: 250,
                                      ),
                                    );
                                    if (animationsMap[
                                            'imageOnActionTriggerAnimation3'] !=
                                        null) {
                                      animationsMap[
                                              'imageOnActionTriggerAnimation3']!
                                          .controller
                                        ..reset()
                                        ..repeat();
                                    }
                                    if (animationsMap[
                                            'imageOnActionTriggerAnimation4'] !=
                                        null) {
                                      animationsMap[
                                              'imageOnActionTriggerAnimation4']!
                                          .controller
                                        ..reset()
                                        ..repeat();
                                    }
                                    _model.CactusMovementStartGame =
                                        InstantTimer.periodic(
                                      duration: Duration(milliseconds: 10),
                                      callback: (timer) async {
                                        _model.cactusXAlignment =
                                            _model.cactusXAlignment + -0.01;
                                        _model.currentScore =
                                            _model.currentScore + 1;
                                        safeSetState(() {});
                                        if ((_model.cactusXAlignment <= -0.79) &&
                                            (_model.cactusXAlignment >= -1.2) &&
                                            (_model.playerYAlignment >=
                                                -0.35) &&
                                            (_model.playerYAlignment <=
                                                _model.playerInitialY)) {
                                          _model.CactusMovementStartGame
                                              ?.cancel();
                                          _model.PlayerJumpLeftBtn?.cancel();
                                          _model.PlayerJumpMidBtn?.cancel();
                                          _model.PlayerJumpRightBtn?.cancel();
                                          if (animationsMap[
                                                  'imageOnActionTriggerAnimation3'] !=
                                              null) {
                                            animationsMap[
                                                    'imageOnActionTriggerAnimation3']!
                                                .controller
                                                .stop();
                                          }
                                          if (animationsMap[
                                                  'imageOnActionTriggerAnimation4'] !=
                                              null) {
                                            animationsMap[
                                                    'imageOnActionTriggerAnimation4']!
                                                .controller
                                                .stop();
                                          }
                                          if (animationsMap[
                                                  'imageOnActionTriggerAnimation1'] !=
                                              null) {
                                            animationsMap[
                                                    'imageOnActionTriggerAnimation1']!
                                                .controller
                                                .stop();
                                          }
                                          if (animationsMap[
                                                  'imageOnActionTriggerAnimation2'] !=
                                              null) {
                                            animationsMap[
                                                    'imageOnActionTriggerAnimation2']!
                                                .controller
                                                .stop();
                                          }
                                          _model.isGameOver =
                                              !_model.isGameOver;
                                          safeSetState(() {});
                                          FFAppState().pauseSound = true;
                                          if (FFAppState().enableSound ==
                                              true) {
                                            unawaited(
                                              () async {
                                                await actions
                                                    .pauseAudioPlayerAsset(
                                                  FFAppState().mainMenuAudioRef,
                                                );
                                              }(),
                                            );
                                            unawaited(
                                              () async {
                                                await actions
                                                    .playAudioPlayerAsset(
                                                  FFAppState().gameOverAudioRef,
                                                  FFAppState().soundVolumeBg,
                                                  false,
                                                );
                                              }(),
                                            );
                                          }
                                          _model.addNewHighScoreActionResultStartGame =
                                              await actions.addNewHighScore(
                                            FFAppState().highScoreList.toList(),
                                            _model.currentScore,
                                          );
                                          FFAppState().highScoreList = _model
                                              .addNewHighScoreActionResultStartGame!
                                              .toList()
                                              .cast<HighScoreInfoStruct>();
                                          safeSetState(() {});
                                        }
                                        if (_model.cactusXAlignment <= -1.5) {
                                          _model.changeColorActionResultStartGame =
                                              await actions.changeColorAction(
                                            _model.currentColor,
                                            _model.greenState!,
                                            _model.yellowState!,
                                            _model.redState!,
                                            _model.purpleState!,
                                            _model.orangeState!,
                                            _model.brownState!,
                                            _model.blueState!,
                                            _model.pinkState!,
                                            FFLocalizations.of(context)
                                                .languageCode,
                                          );
                                          _model.cactusXAlignment =
                                              _model.cactusInitialX;
                                          _model.currentColor = _model
                                              .changeColorActionResultStartGame!
                                              .currentColor;
                                          _model.greenState = _model
                                              .changeColorActionResultStartGame
                                              ?.greenState;
                                          _model.yellowState = _model
                                              .changeColorActionResultStartGame
                                              ?.yellowState;
                                          _model.redState = _model
                                              .changeColorActionResultStartGame
                                              ?.redState;
                                          _model.purpleState = _model
                                              .changeColorActionResultStartGame
                                              ?.purpleState;
                                          _model.orangeState = _model
                                              .changeColorActionResultStartGame
                                              ?.orangeState;
                                          _model.brownState = _model
                                              .changeColorActionResultStartGame
                                              ?.brownState;
                                          _model.blueState = _model
                                              .changeColorActionResultStartGame
                                              ?.blueState;
                                          _model.pinkState = _model
                                              .changeColorActionResultStartGame
                                              ?.pinkState;
                                          _model.leftButtonVal = _model
                                              .changeColorActionResultStartGame!
                                              .leftButtonVal;
                                          _model.midButtonVal = _model
                                              .changeColorActionResultStartGame!
                                              .midButtonVal;
                                          _model.rightButtonVal = _model
                                              .changeColorActionResultStartGame!
                                              .rightButtonVal;
                                          _model.leftButtonColor =
                                              FFAppConstants.DefaultButtonColor;
                                          _model.midButtonColor =
                                              FFAppConstants.DefaultButtonColor;
                                          _model.rightButtonColor =
                                              FFAppConstants.DefaultButtonColor;
                                          safeSetState(() {});
                                        }
                                      },
                                      startImmediately: true,
                                    );

                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'zjy8k2fl' /* Start Game */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.currentPageStack =
                                        CurrentPageStack.HIGHSCORESTACK;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    '2c2jl43u' /* Highscore */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.currentPageStack =
                                        CurrentPageStack.TRANSLATIONSTACK;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'ncvlfxxc' /* Language */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    valueOrDefault<double>(
                                      FFAppConstants.StartGameButtonPadding
                                          .toDouble(),
                                      0.0,
                                    ),
                                    0.0,
                                    0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    _model.currentPageStack =
                                        CurrentPageStack.SOUNDSTACK;
                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    '5ov1ctv1' /* Sound */,
                                  ),
                                  options: FFButtonOptions(
                                    width: 250.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FFAppConstants.DefaultButtonColor,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Silkscreen',
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
