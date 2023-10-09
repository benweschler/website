My personal website: www.benweschler.dev. Built with Flutter and OpenGL.

## Runing
Requires Flutter 3.13 or higher.

Fetch dependencies:
```
flutter pub get
```

To run locally:

```
flutter run --release --web-renderer canvaskit
```

To build a compiled webpack:

```
flutter build --release --web-renderer canvaskit
```
Flutter's CanvasKit web renderer must be used since the HTML renderer doesn't
support the fragment program API, which is required in order to run GLSL shaders
on the web.

Build artifacts are created in under `/build/web/` by default.

