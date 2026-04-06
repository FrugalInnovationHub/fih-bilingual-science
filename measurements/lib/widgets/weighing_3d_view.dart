import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart' as three;

class Weighing3DView extends StatefulWidget {
  final String emoji;
  final int blocks;
  final int target;

  const Weighing3DView({
    super.key,
    required this.emoji,
    required this.blocks,
    required this.target,
  });

  @override
  State<Weighing3DView> createState() => _Weighing3DViewState();
}

class _Weighing3DViewState extends State<Weighing3DView> {
  FlutterGlPlugin? _gl;
  three.WebGLRenderer? _renderer;
  three.Scene? _scene;
  three.PerspectiveCamera? _camera;

  three.Group? _beamGroup;
  three.Group? _blocksGroup;
  three.Object3D? _itemObject;

  double _width = 0;
  double _height = 0;
  double _dpr = 1.0;
  bool _initialized = false;
  bool _disposed = false;
  bool _glReady = false;
  Timer? _renderTimer;
  String? _initError;

  int? _textureId;
  dynamic _sourceTexture;
  late final three.WebGLRenderTarget _renderTarget;

  @override
  void didUpdateWidget(covariant Weighing3DView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      _updateScene();
      _render();
    }
  }

  Future<void> _init(Size size) async {
    if (_initialized) return;
    _width = size.width;
    _height = size.height;
    _dpr = MediaQuery.of(context).devicePixelRatio;

    try {
      _gl = FlutterGlPlugin();
      await _gl!.initialize(options: {
        "antialias": true,
        "alpha": true,
        "width": _width.toInt(),
        "height": _height.toInt(),
        "dpr": _dpr,
      });

      if (!mounted) return;
      setState(() {
        _textureId = _gl!.textureId;
      });

      await _gl!.prepareContext();
      if (_disposed) return;
      _glReady = true;
      if (mounted) {
        setState(() {});
      }

      if (kIsWeb) {
        final dynamic canvas = _gl!.element;
        if (canvas != null) {
          canvas.width = (_width * _dpr).toInt();
          canvas.height = (_height * _dpr).toInt();
          canvas.style.width = '${_width}px';
          canvas.style.height = '${_height}px';
        }
      }

      _initRenderer();
      _initScene();
      _initialized = true;
      _updateScene();
      _startRenderLoop();
    } catch (e) {
      _initError = e.toString();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _initRenderer() {
    final options = {
      "width": _width,
      "height": _height,
      "gl": _gl!.gl,
      "antialias": true,
      "canvas": _gl!.element,
    };
    _renderer = three.WebGLRenderer(options);
    _renderer!.setPixelRatio(_dpr);
    _renderer!.setSize(_width, _height, false);
    _renderer!.outputEncoding = three.sRGBEncoding;
    _renderer!.setClearColor(three.Color(0x3c1d78), 1);

    if (!kIsWeb) {
      final pars = three.WebGLRenderTargetOptions({"format": three.RGBAFormat});
      _renderTarget = three.WebGLRenderTarget(
        (_width * _dpr).toInt(),
        (_height * _dpr).toInt(),
        pars,
      );
      _renderTarget.samples = 4;
      _renderer!.setRenderTarget(_renderTarget);
      _sourceTexture = _renderer!.getRenderTargetGLTexture(_renderTarget);
    }
  }

  void _initScene() {
    _scene = three.Scene();
    _scene!.fog = three.Fog(0x3c1d78, 6, 20);

    _camera = three.PerspectiveCamera(40, _width / _height, 0.1, 100);
    _camera!.position.set(0, 4.2, 8.5);
    _camera!.lookAt(three.Vector3(0, 1.5, 0));

    final ambient = three.AmbientLight(0xffffff, 0.7);
    _scene!.add(ambient);
    final keyLight = three.DirectionalLight(0xffffff, 0.9);
    keyLight.position.set(5, 8, 4);
    _scene!.add(keyLight);
    final fillLight = three.DirectionalLight(0xffd8ff, 0.4);
    fillLight.position.set(-5, 4, 4);
    _scene!.add(fillLight);

    final floor = three.Mesh(
      three.PlaneGeometry(30, 20),
      three.MeshStandardMaterial({"color": 0x5b2fb8, "roughness": 0.9}),
    );
    floor.rotation.x = -math.pi / 2;
    floor.position.y = -0.1;
    _scene!.add(floor);

    final grid = three.GridHelper(30, 20, 0xffffff, 0xffffff);
    (grid.material as three.Material).opacity = 0.15;
    (grid.material as three.Material).transparent = true;
    grid.position.y = 0;
    _scene!.add(grid);

    final scaleGroup = three.Group();
    _scene!.add(scaleGroup);

    final base = three.Mesh(
      three.BoxGeometry(2.2, 0.3, 1.2),
      three.MeshStandardMaterial({"color": 0xf7a344}),
    );
    base.position.set(0, 0.3, 0);
    scaleGroup.add(base);

    final pillar = three.Mesh(
      three.CylinderGeometry(0.15, 0.2, 1.4, 24),
      three.MeshStandardMaterial({"color": 0xffc06b}),
    );
    pillar.position.set(0, 1.1, 0);
    scaleGroup.add(pillar);

    _beamGroup = three.Group();
    _beamGroup!.position.set(0, 1.7, 0);
    scaleGroup.add(_beamGroup!);

    final beam = three.Mesh(
      three.BoxGeometry(5.2, 0.2, 0.4),
      three.MeshStandardMaterial({"color": 0xe0e0e0}),
    );
    _beamGroup!.add(beam);

    final leftPlate = three.Mesh(
      three.CylinderGeometry(0.7, 0.7, 0.1, 30),
      three.MeshStandardMaterial({"color": 0xb0b0b0}),
    );
    leftPlate.position.set(-2.2, -0.55, 0);
    _beamGroup!.add(leftPlate);

    final rightPlate = leftPlate.clone();
    rightPlate.position.set(2.2, -0.55, 0);
    _beamGroup!.add(rightPlate);

    _blocksGroup = three.Group();
    _blocksGroup!.position.set(2.2, 0.15, 0);
    _beamGroup!.add(_blocksGroup!);

    _itemObject = _createItemObject(widget.emoji);
    _itemObject!.position.set(-2.2, 0.2, 0);
    _beamGroup!.add(_itemObject!);
  }

  three.Object3D _createItemObject(String emoji) {
    three.MeshStandardMaterial mat(int color,
        {double roughness = 0.45, double metalness = 0.05}) {
      return three.MeshStandardMaterial({
        "color": color,
        "roughness": roughness,
        "metalness": metalness,
      });
    }

    if (emoji.contains('🐘')) {
      final group = three.Group();
      final body = three.Mesh(three.SphereGeometry(0.62, 28, 28), mat(0x8db1c8));
      body.position.set(0, 0.15, 0);
      final head = three.Mesh(three.SphereGeometry(0.4, 24, 24), mat(0x7fa3ba));
      head.position.set(0.65, 0.25, 0);
      final trunk = three.Mesh(three.CylinderGeometry(0.08, 0.12, 0.5, 16), mat(0x7fa3ba));
      trunk.rotation.z = math.pi / 2;
      trunk.position.set(0.98, 0.1, 0);
      final earLeft = three.Mesh(three.CylinderGeometry(0.18, 0.18, 0.04, 20), mat(0x9bbcd0));
      earLeft.rotation.x = math.pi / 2;
      earLeft.position.set(0.45, 0.35, 0.38);
      final earRight = earLeft.clone();
      earRight.position.set(0.45, 0.35, -0.38);
      for (int i = 0; i < 4; i++) {
        final leg = three.Mesh(three.CylinderGeometry(0.09, 0.12, 0.4, 12), mat(0x7fa3ba));
        final x = i < 2 ? -0.25 : 0.25;
        final z = i % 2 == 0 ? -0.2 : 0.2;
        leg.position.set(x, -0.2, z);
        group.add(leg);
      }
      final eyeMat = mat(0x111111, roughness: 0.2);
      final eye1 = three.Mesh(three.SphereGeometry(0.03, 12, 12), eyeMat);
      final eye2 = eye1.clone();
      eye1.position.set(0.75, 0.32, 0.14);
      eye2.position.set(0.75, 0.32, -0.14);
      group.add(eye1);
      group.add(eye2);
      group.add(body);
      group.add(head);
      group.add(trunk);
      group.add(earLeft);
      group.add(earRight);
      group.scale.set(1.25, 1.25, 1.25);
      return group;
    }

    if (emoji.contains('🚗')) {
      final group = three.Group();
      final base = three.Mesh(three.BoxGeometry(1.35, 0.4, 0.75), mat(0x4cd964));
      final hood = three.Mesh(three.BoxGeometry(0.5, 0.18, 0.7), mat(0x5fe37a));
      hood.position.set(0.4, 0.25, 0);
      final cabin = three.Mesh(three.BoxGeometry(0.7, 0.32, 0.68), mat(0x6eea80));
      cabin.position.set(-0.2, 0.4, 0);
      final window = three.Mesh(three.BoxGeometry(0.45, 0.22, 0.6), mat(0xaadcf9));
      window.position.set(-0.2, 0.42, 0);
      final wheelMat = mat(0x222222, roughness: 0.9);
      final rimMat = mat(0xaaaaaa, roughness: 0.2, metalness: 0.4);
      final wheel = three.Mesh(three.CylinderGeometry(0.16, 0.16, 0.2, 16), wheelMat);
      wheel.rotation.x = math.pi / 2;
      final rim = three.Mesh(three.CylinderGeometry(0.09, 0.09, 0.21, 12), rimMat);
      rim.rotation.x = math.pi / 2;
      final wheel2 = wheel.clone();
      final wheel3 = wheel.clone();
      final wheel4 = wheel.clone();
      final rim2 = rim.clone();
      final rim3 = rim.clone();
      final rim4 = rim.clone();
      wheel.position.set(0.55, -0.08, 0.38);
      wheel2.position.set(0.55, -0.08, -0.38);
      wheel3.position.set(-0.45, -0.08, 0.38);
      wheel4.position.set(-0.45, -0.08, -0.38);
      rim.position.copy(wheel.position);
      rim2.position.copy(wheel2.position);
      rim3.position.copy(wheel3.position);
      rim4.position.copy(wheel4.position);
      final headlight = three.Mesh(three.BoxGeometry(0.08, 0.06, 0.2), mat(0xffd60a, roughness: 0.2));
      headlight.position.set(0.72, 0.18, 0.22);
      final headlight2 = headlight.clone();
      headlight2.position.set(0.72, 0.18, -0.22);
      final bumper = three.Mesh(three.BoxGeometry(0.08, 0.08, 0.7), mat(0xcccccc, roughness: 0.3));
      bumper.position.set(0.72, 0.06, 0);
      group.add(base);
      group.add(hood);
      group.add(cabin);
      group.add(window);
      group.add(headlight);
      group.add(headlight2);
      group.add(bumper);
      group.add(wheel);
      group.add(wheel2);
      group.add(wheel3);
      group.add(wheel4);
      group.add(rim);
      group.add(rim2);
      group.add(rim3);
      group.add(rim4);
      group.scale.set(1.25, 1.25, 1.25);
      return group;
    }

    if (emoji.contains('📚')) {
      final group = three.Group();
      final book1 = three.Mesh(three.BoxGeometry(1.0, 0.22, 0.65), mat(0x5ac8fa));
      final book2 = three.Mesh(three.BoxGeometry(0.95, 0.22, 0.6), mat(0xff9500));
      final book3 = three.Mesh(three.BoxGeometry(0.9, 0.22, 0.55), mat(0xaf52de));
      book1.position.set(0, 0.0, 0);
      book2.position.set(0, 0.22, 0.02);
      book3.position.set(0, 0.44, -0.02);
      group.add(book1);
      group.add(book2);
      group.add(book3);
      group.scale.set(1.25, 1.25, 1.25);
      return group;
    }

    if (emoji.contains('🍎')) {
      final group = three.Group();
      final apple = three.Mesh(three.SphereGeometry(0.55, 24, 24), mat(0xff3b30));
      final stem = three.Mesh(three.CylinderGeometry(0.05, 0.07, 0.22, 12), mat(0x6b4f2a));
      stem.position.set(0, 0.52, 0);
      final leaf = three.Mesh(three.ConeGeometry(0.16, 0.3, 12), mat(0x34c759));
      leaf.position.set(0.12, 0.55, 0);
      leaf.rotation.z = -0.5;
      final shine = three.Mesh(three.SphereGeometry(0.12, 12, 12), mat(0xff8a80, roughness: 0.2));
      shine.position.set(-0.15, 0.15, 0.35);
      group.add(apple);
      group.add(stem);
      group.add(leaf);
      group.add(shine);
      return group;
    }

    if (emoji.contains('🍉')) {
      final group = three.Group();
      final rind = three.Mesh(three.SphereGeometry(0.6, 24, 24), mat(0x2ecc71, roughness: 0.35));
      final flesh = three.Mesh(three.SphereGeometry(0.52, 24, 24), mat(0xff5a5f, roughness: 0.4));
      final stripeMat = mat(0x1f8a4c, roughness: 0.4);
      for (int i = -1; i <= 1; i++) {
        final stripe = three.Mesh(three.TorusGeometry(0.55 + i * 0.03, 0.02, 12, 24), stripeMat);
        stripe.rotation.x = math.pi / 2;
        stripe.rotation.z = i * 0.35;
        group.add(stripe);
      }
      final seedMat = mat(0x2d2d2d, roughness: 0.8);
      for (int i = 0; i < 5; i++) {
        final seed = three.Mesh(three.SphereGeometry(0.035, 12, 12), seedMat);
        seed.position.set(-0.12 + i * 0.07, 0.12, 0.32);
        group.add(seed);
      }
      group.add(rind);
      group.add(flesh);
      return group;
    }

    if (emoji.contains('🧸')) {
      final group = three.Group();
      final body = three.Mesh(three.SphereGeometry(0.55, 24, 24), mat(0xd8a06f));
      final head = three.Mesh(three.SphereGeometry(0.36, 24, 24), mat(0xe1b48a));
      head.position.set(0, 0.52, 0);
      final ear = three.Mesh(three.SphereGeometry(0.15, 16, 16), mat(0xe1b48a));
      final ear2 = ear.clone();
      ear.position.set(-0.2, 0.7, 0.12);
      ear2.position.set(0.2, 0.7, 0.12);
      final belly = three.Mesh(three.SphereGeometry(0.3, 20, 20), mat(0xf1d2b0));
      belly.position.set(0, 0.16, 0.32);
      final nose = three.Mesh(three.SphereGeometry(0.05, 12, 12), mat(0x3a2a1a));
      nose.position.set(0, 0.5, 0.28);
      final eye1 = three.Mesh(three.SphereGeometry(0.03, 12, 12), mat(0x111111));
      final eye2 = eye1.clone();
      eye1.position.set(-0.1, 0.55, 0.26);
      eye2.position.set(0.1, 0.55, 0.26);
      group.add(body);
      group.add(head);
      group.add(ear);
      group.add(ear2);
      group.add(belly);
      group.add(nose);
      group.add(eye1);
      group.add(eye2);
      return group;
    }

    return three.Mesh(three.BoxGeometry(0.9, 0.6, 0.6), mat(0xffcc00));
  }


  int _emojiToColor(String emoji) {
    if (emoji.contains('🐘')) return 0x8db1c8;
    if (emoji.contains('🧸')) return 0xd8a06f;
    if (emoji.contains('🍉')) return 0xff5a5f;
    if (emoji.contains('🍎')) return 0xff3b30;
    if (emoji.contains('🚗')) return 0x4cd964;
    if (emoji.contains('📚')) return 0x5ac8fa;
    return 0xffcc00;
  }

  void _updateScene() {
    if (_beamGroup == null || _blocksGroup == null) return;
    final diff = (widget.blocks - widget.target).clamp(-3, 3);
    _beamGroup!.rotation.z = -diff * 0.1;

    while (_blocksGroup!.children.isNotEmpty) {
      _blocksGroup!.remove(_blocksGroup!.children.first);
    }
    for (int i = 0; i < widget.blocks; i++) {
      final block = three.Mesh(
        three.BoxGeometry(0.5, 0.24, 0.5),
        three.MeshStandardMaterial({"color": 0xff9f43}),
      );
      block.position.set(0, i * 0.26, 0);
      _blocksGroup!.add(block);
    }

    if (_itemObject != null) {
      _beamGroup!.remove(_itemObject!);
    }
    _itemObject = _createItemObject(widget.emoji);
    _itemObject!.position.set(-2.2, 0.2, 0);
    _beamGroup!.add(_itemObject!);
  }

  void _render() {
    if (_renderer == null || _scene == null || _camera == null) return;
    _renderer!.render(_scene!, _camera!);
    final gl = _gl!.gl;
    gl.flush();
    if (!kIsWeb) {
      _gl!.updateTexture(_sourceTexture);
    }
  }

  void _startRenderLoop() {
    _renderTimer?.cancel();
    _renderTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_disposed) return;
      _render();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_initialized && constraints.maxWidth > 0 && constraints.maxHeight > 0) {
          unawaited(_init(Size(constraints.maxWidth, constraints.maxHeight)));
        }
        final hasView = _textureId != null && _glReady;
        final view = hasView
            ? (kIsWeb
                ? HtmlElementView(viewType: _textureId!.toString())
                : Texture(textureId: _textureId!))
            : Container(color: Colors.black12);
        return Stack(
          children: [
            Positioned.fill(child: view),
            if (!hasView || _initError != null)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _initError ??
                        '3D loading... glReady=$_glReady textureId=${_textureId ?? "null"}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _renderTimer?.cancel();
    _gl?.dispose();
    super.dispose();
  }
}
