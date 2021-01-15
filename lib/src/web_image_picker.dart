import 'dart:async';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'dart:html';
class WebImagePicker {
//  Future<Map<String, dynamic>> pickImage() async {
//    final Map<String, dynamic> data = {};
//    final html.FileUploadInputElement input = html.FileUploadInputElement();
//    input..accept = 'image/*';
//    input.click();
//    await input.onChange.first;
//    if (input.files.isEmpty) return null;
//    final reader = html.FileReader();
//    reader.readAsDataUrl(input.files[0]);
//    await reader.onLoad.first;
//    final encoded = reader.result as String;
//    final stripped = encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
//    final imageName = input.files?.first?.name;
//    data.addAll({
//      'name': imageName,
//      'data': stripped,
//      'data_scheme': encoded
//    });
//    return data;
//  }
  Future<Map<String, dynamic>> pickImage() async {
    final Map<String, dynamic> data = {};
    final completer = Completer<List<String>>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..multiple = true
      ..accept = 'image/*';
    input.click();
//    onChange doesn't work in mobile safari
    input.addEventListener('change', (e) async {
      final List<File> files = input.files;
      Iterable<Future<String>> resultsFutures = files.map((file) {
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onError.listen((error) => completer.completeError(error));
        return reader.onLoad.first.then((_) => reader.result as String);
      });
      final results = await Future.wait(resultsFutures);
      completer.complete(results);
    });
    document.body.append(input);
    // input.click(); can be here
    final List<String> images = await completer.future;
//    setState(() {
//      _uploadedImages = images;
//    });
//    input.remove();
    final encoded = images[0];
    final stripped = encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final imageName = input.files?.first?.name;
    data.addAll({
      'name': imageName,
      'data': stripped,
      'data_scheme': encoded
    });
    return data;
  }

  Future<Map<String, dynamic>> pickVideo() async {
    final Map<String, dynamic> data = {};
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input..accept = 'video/*';
    input.click();
    await input.onChange.first;
    if (input.files.isEmpty) return null;
    final reader = html.FileReader();
    reader.readAsDataUrl(input.files[0]);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    final stripped = encoded.replaceFirst(RegExp(r'data:video/[^;]+;base64,'), '');
    final videoName = input.files?.first?.name;
    data.addAll({'name': videoName, 'data': stripped, 'data_scheme': encoded});
    return data;
  }
}
