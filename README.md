My personal website: www.benweschler.dev. Built with Flutter and GLSL.

## Build it Yourself
Building from source requires Flutter 3.13 or higher. After downloading this
source code, navigate to the root directory.

Fetch dependencies:
```shell
flutter pub get
```

To run locally:

```shell
flutter run --release --web-renderer canvaskit
```

To run on a local web server (using recommended settings):

```shell
flutter run -d web-server --release --web-port 8080 --web-hostname 0.0.0.0 --web-renderer canvaskit
```

To build a compiled webpack:

```shell
flutter build --release --web-renderer canvaskit
```
Flutter's CanvasKit web renderer must be used since the HTML renderer does not
support Flutter's Fragment Program API, which is required to run GLSL fragment
shaders on Flutter web.

Build artifacts are created in under `/build/web/` by default.
