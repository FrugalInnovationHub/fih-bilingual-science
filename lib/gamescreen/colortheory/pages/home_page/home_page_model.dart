import '../../backend/schema/enums/enums.dart';
import '../../backend/schema/structs/index.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/instant_timer.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  double cactusXAlignment = 1.0;

  double playerYAlignment = 0.02;

  double playerInitialY = 0.02;

  double cactusInitialX = 1.2;

  bool? jumpIsAscending;

  double jumpPeakHeight = -1.0;

  String currentColor = 'Green';

  String leftButtonVal = 'Green';

  String midButtonVal = 'Yellow';

  String rightButtonVal = 'Red';

  ColorStruct? greenState;
  void updateGreenStateStruct(Function(ColorStruct) updateFn) {
    updateFn(greenState ??= ColorStruct());
  }

  ColorStruct? yellowState;
  void updateYellowStateStruct(Function(ColorStruct) updateFn) {
    updateFn(yellowState ??= ColorStruct());
  }

  ColorStruct? redState;
  void updateRedStateStruct(Function(ColorStruct) updateFn) {
    updateFn(redState ??= ColorStruct());
  }

  ColorStruct? purpleState;
  void updatePurpleStateStruct(Function(ColorStruct) updateFn) {
    updateFn(purpleState ??= ColorStruct());
  }

  ColorStruct? orangeState;
  void updateOrangeStateStruct(Function(ColorStruct) updateFn) {
    updateFn(orangeState ??= ColorStruct());
  }

  ColorStruct? brownState;
  void updateBrownStateStruct(Function(ColorStruct) updateFn) {
    updateFn(brownState ??= ColorStruct());
  }

  ColorStruct? blueState;
  void updateBlueStateStruct(Function(ColorStruct) updateFn) {
    updateFn(blueState ??= ColorStruct());
  }

  ColorStruct? pinkState;
  void updatePinkStateStruct(Function(ColorStruct) updateFn) {
    updateFn(pinkState ??= ColorStruct());
  }

  Color leftButtonColor = Color(4288516853);

  Color midButtonColor = Color(4288516853);

  Color rightButtonColor = Color(4288516853);

  CurrentPageStack? currentPageStack = CurrentPageStack.HOMESTACK;

  bool isGameOver = false;

  bool isInit = false;

  int currentScore = 0;

  ///  State fields for stateful widgets in this page.

  InstantTimer? CactusMovementRestartGame;
  // Stores action output result for [Custom Action - addNewHighScore] action in RestartGameButton widget.
  List<HighScoreInfoStruct>? addNewHighScoreActionResultRestartGame;
  // Stores action output result for [Custom Action - changeColorAction] action in RestartGameButton widget.
  ChangeColorActionResultStruct? changeColorActionResultRestartGame;
  // Stores action output result for [Custom Action - changeColorAction] action in MainMenuButton widget.
  ChangeColorActionResultStruct? changeColorActionResultMainMenu;
  // Stores action output result for [Custom Action - setButtonColorAction] action in LeftButton widget.
  SetButtonColorActionResultStruct? selectedLeftButtonColorEn;
  // Stores action output result for [Custom Action - setButtonColorAction] action in LeftButton widget.
  SetButtonColorActionResultStruct? selectedLeftButtonColorEs;
  InstantTimer? PlayerJumpLeftBtn;
  // Stores action output result for [Custom Action - setButtonColorAction] action in MidButton widget.
  SetButtonColorActionResultStruct? selectedMidButtonColorEn;
  // Stores action output result for [Custom Action - setButtonColorAction] action in MidButton widget.
  SetButtonColorActionResultStruct? selectedMidButtonColorEs;
  InstantTimer? PlayerJumpMidBtn;
  // Stores action output result for [Custom Action - setButtonColorAction] action in RightButton widget.
  SetButtonColorActionResultStruct? selectedRightButtonColorEn;
  // Stores action output result for [Custom Action - setButtonColorAction] action in RightButton widget.
  SetButtonColorActionResultStruct? selectedRightButtonColorEs;
  InstantTimer? PlayerJumpRightBtn;
  InstantTimer? checkLangChangeEn;
  // Stores action output result for [Custom Action - changeColorAction] action in EngButton widget.
  ChangeColorActionResultStruct? changeColorActionResultEnButton;
  InstantTimer? checkLangChangeEs;
  // Stores action output result for [Custom Action - changeColorAction] action in EspButton widget.
  ChangeColorActionResultStruct? changeColorActionResultEspButton;
  InstantTimer? CactusMovementStartGame;
  // Stores action output result for [Custom Action - addNewHighScore] action in StartGameButton widget.
  List<HighScoreInfoStruct>? addNewHighScoreActionResultStartGame;
  // Stores action output result for [Custom Action - changeColorAction] action in StartGameButton widget.
  ChangeColorActionResultStruct? changeColorActionResultStartGame;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    CactusMovementRestartGame?.cancel();
    PlayerJumpLeftBtn?.cancel();
    PlayerJumpMidBtn?.cancel();
    PlayerJumpRightBtn?.cancel();
    checkLangChangeEn?.cancel();
    checkLangChangeEs?.cancel();
    CactusMovementStartGame?.cancel();
  }
}
