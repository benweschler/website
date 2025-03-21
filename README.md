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
flutter run --release
```

To run on a local web server (using recommended settings):

```shell
flutter run -d web-server --release --web-port 8080 --web-hostname 0.0.0.0
```

To build a compiled webpack:

```shell
flutter build web --release
```

Build artifacts are created under `/build/web/` by default.
