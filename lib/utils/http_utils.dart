import 'dart:html' as html;
import 'dart:typed_data';

void downloadFileFromBytes(Uint8List bytes, String fileName) {
  // Convert the bytes to a Blob
  final blob = html.Blob([bytes]);

  // Create an object URL from the Blob
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create an anchor element
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName) // Set the download attribute with the desired file name
    ..click(); // Simulate a click event to trigger the download

  // Revoke the object URL to free up resources
  html.Url.revokeObjectUrl(url);
}
