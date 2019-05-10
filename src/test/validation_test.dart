import 'dart:io';

import 'package:f_orm_m8_sqlite/orm_m8_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'utils/test_file_utils.dart';
import 'package:source_gen_test/source_gen_test.dart';

void main() {
  LibraryReader library_1;
  final path = testFilePath('test', 'src', 'model');
  final caliber0Path =
      testFilePath('test', 'out', 'multiple_datacolumn_on_field.0.caliber');

  setUp(() async {
    library_1 = await initializeLibraryReaderForDirectory(
        path, "bad_multiple_datacolumns_on_field.dart");
  });

  group('Validation tests', () {
    final generator = OrmM8GeneratorForAnnotation();

    test('Test the multiple DataColumn annotations on the same field!',
        () async {
      String output = await generator.generate(library_1, null);

      final expected = await File(caliber0Path).readAsString();
      expect(output, expected);
    });
  });
}
