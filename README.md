## Website

My personal website: www.benweschler.dev. Built with Flutter and GLSL.

## Run yourself
In order to deploy locally, navigate to the root directory and run

```
flutter pub get
flutter run --release --web-renderer canvaskit
```

Flutter's CanvasKit web renderer must be used since the HTML renderer doesn't
support the fragment program API, which is required in order to run GLSL shaders
in the web. 

To build a compiled webpack, run

```
flutter build --release --web-renderer canvaskit
```

Build artifacts are created in under `/build/web/` by default.

