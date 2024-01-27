import 'dart:math';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_cluster/simple_cluster.dart';

Future<List<(String, String)>> ProcessImage(source) async {
  final XFile? gallery_image = await ImagePicker().pickImage(source: source);
  if (gallery_image != null) {
    // path grabbing works for temporary access as such
    final inputImage = InputImage.fromFilePath(gallery_image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    var text = parseBlocks(recognizedText);
    return processText(text);
  }
  return [];
}

List<(String, String)> processText(String text) {
  // Regex breakdown:
  // Attempt to match product name, weight/count data, text-like quantifiers, multiplier, result number
  // \s? is for possible whitespaces
  print(text);
  var item_data = RegExp(
          r"(?!\d)(?<name>[\w\s\d.]*?)(?<price_mult>\d+[,\d]*\s?\w*\s?[x*]\s?[\d,]*\s?[\s=]*)(?<price>\d*,\d*)")
      .allMatches(text);
  List<(String, String)> results = [];
  for (var item in item_data) {
    results
        .add((item.namedGroup('name') ?? '', item.namedGroup('price') ?? ''));
  }
  return results;
}

String parseBlocks(RecognizedText recognizedText) {
  // y,x,text map, attempting to create a single line
  var normalized_text = new Map<int, Map<int, String>>();
  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      // normalize due to possible angling
      var yval = (line.cornerPoints.first.y -
              tan((line.angle ?? 0).toDouble() * pi / 180) *
                  line.cornerPoints.first.x)
          .toInt();
      var xval = line.cornerPoints.first.x;
      if (!normalized_text.containsKey(yval)) {
        normalized_text[yval] = {xval: line.text};
      } else {
        normalized_text[yval]!.addAll({xval: line.text});
      }
    }
  }
  // sort vertically
  var sorted_text = Map.fromEntries(
      normalized_text.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  // create single words for fuzzywuzzy library
  List<String> chunked_text = [];
  for (var line in sorted_text.values) {
    for (var vert in line.values) {
      chunked_text.insertAll(chunked_text.length, vert.split(" "));
    }
  }
  // remove non-important entries by finding bounds
  var top = 0;
  try {
    top = extractOne(query: 'FISKALNY', choices: chunked_text, cutoff: 80)
        .index; // Price data starts from this
  } catch (e) {}
  var bot = 0;
  try {
    var bot_sprzedaz =
        extractOne(query: 'SPRZEDAZ', choices: chunked_text, cutoff: 80).index;
    bot = bot_sprzedaz;
  } catch (e) {}
  // One of these hould be somewhere at the end of the list, but no earlier
  try {
    var bot_pln =
        extractOne(query: 'PLN', choices: chunked_text, cutoff: 80).index;
    var bot_suma =
        extractOne(query: 'SUMA', choices: chunked_text, cutoff: 80).index;
    // A quick check to verify we arent out of bounds
    if (bot < top) {
      if (bot_pln < bot_suma) {
        bot = bot_pln;
      } else {
        bot = bot_suma;
      }
    }
  } catch (e) {}
  // apply boundaries (remember that we need to change words to lines)
  bot = chunked_text.length - bot;
  if (bot > top) {
    for (var i = 0; i < bot; i = i) {
      if (sorted_text.values.last.isEmpty) {
        sorted_text.remove(sorted_text.keys.last).toString();
      } else {
        i += sorted_text.values.last.values.last.split(" ").length;
        sorted_text.values.last.remove(sorted_text.values.last.keys.last).toString();
      }
    }
  }
  for (var i = 0; i < top; i = i) {
    if (sorted_text.values.first.isEmpty) {
      sorted_text.remove(sorted_text.keys.first);
    } else {
      i += sorted_text.values.first.values.first.split(" ").length;
      sorted_text.values.first.remove(sorted_text.values.first.keys.first);
    }
  }
  var grouper = DBSCAN(
      epsilon: recognizedText.blocks[(recognizedText.blocks.length / 2).round()]
          .lines.first.elements.first.boundingBox.height);
  List<List<double>> g_list = [];
  for (var k in sorted_text.keys) {
    g_list.add([k.toDouble()]);
  }
  grouper.run(g_list);
  var grouped_text = new Map<int, Map<int, String>>();
  var targets = grouper.label ?? [];
  for (var i = 0; i < (targets.length); i += 1) {
    if (!grouped_text.containsKey(targets[i])) {
      grouped_text[targets[i]] = sorted_text.values.elementAt(i);
    } else {
      grouped_text[targets[i]]!.addAll(sorted_text.values.elementAt(i));
    }
  }
  String n_res = "";
  for (var line in grouped_text.entries) {
    // sort horizontally
    var res_line = Map.fromEntries(line.value.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    for (var element in res_line.entries) {
      n_res += " " + element.value;
    }
  }
  return n_res;
}
