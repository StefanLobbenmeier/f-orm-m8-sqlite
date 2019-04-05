library orm_m8_generator.core;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutter_orm_m8/flutter_orm_m8.dart';
import 'package:flutter_sqlite_m8_generator/exceptions/exception_expander.dart';
import 'package:flutter_sqlite_m8_generator/generator/core.dart';
import 'package:flutter_sqlite_m8_generator/generator/writers/entity_writer_factory.dart';
import 'package:source_gen/source_gen.dart';

class OrmM8GeneratorForAnnotation extends GeneratorForAnnotation<DataTable> {
  List<EmittedEntity> emittedEntities;

  OrmM8GeneratorForAnnotation() {
    emittedEntities = List<EmittedEntity>();
  }

  OrmM8GeneratorForAnnotation.withEmitted(emittedEntities) {
    this.emittedEntities = emittedEntities;
  }

  @override
  Future<String> generateForAnnotatedElement(final Element element,
      ConstantReader annotation, BuildStep buildStep) async {
    try {
      checkAllowedElementType(element);

      final String modelName = element.name;
      final String entityName =
          annotation.objectValue.getField('name').toStringValue();
      print("Generating entity for $modelName ... $entityName");

      ModelParser modelParser = ModelParser(element, entityName);
      final EmittedEntity emittedEntity = modelParser.getEmittedEntity();

      emittedEntities.add(emittedEntity);
      final entityWriter = EntityWriterFactory().getWriter(emittedEntity);

      return entityWriter.toString();
    } catch (exception, stack) {
      return ExceptionExpander(exception, stack).toString();
    }
  }

  void checkAllowedElementType(Element element) {
    if (element is! ClassElement) {
      throw Exception("@DataTable annotation must be defined on a class. Current type is ${element.runtimeType.toString()}");
    }
  }
}
