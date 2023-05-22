// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'src/data/models/partObjectModel.dart';
import 'src/data/models/scenePartModel.dart';
import 'src/data/models/screenShootModel.dart';
import 'src/data/models/softwareModel.dart';
import 'src/data/models/videoModel.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 5922885288332288138),
      name: 'PartObjectModel',
      lastPropertyId: const IdUid(13, 2118667474981069231),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2499940764790309662),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8539448575626686583),
            name: 'left',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1756235525460106639),
            name: 'right',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4027477781195997805),
            name: 'top',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3528762213549066877),
            name: 'bottom',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7879993695700189823),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2790378843541322856),
            name: 'imageName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7818238208987796591),
            name: 'path',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 533588271424915937),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 918939126606934192),
            name: 'label',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 4788626507602896507),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 194160298915799660),
            name: 'status',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 2118667474981069231),
            name: 'actionKind',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 1511157904358265259),
      name: 'ScenePartModel',
      lastPropertyId: const IdUid(11, 2380622141480846707),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1962129822223855595),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5161238095427950572),
            name: 'left',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 851009505196112053),
            name: 'right',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4985530005039131169),
            name: 'top',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 8120794572590322291),
            name: 'bottom',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 849727135604059823),
            name: 'color',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 4114126750303806628),
            name: 'imageName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 7355176820899515523),
            name: 'path',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 5844064191119127598),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 7324499478361269917),
            name: 'label',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2380622141480846707),
            name: 'status',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(1, 7154955083376384755),
            name: 'partObjects',
            targetId: const IdUid(1, 5922885288332288138))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 1597679080181769401),
      name: 'ScreenShootModel',
      lastPropertyId: const IdUid(7, 3350676040812579837),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8563603067741121587),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 292102565215588503),
            name: 'imageName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 1319629608762230992),
            name: 'path',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 754001611922789193),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3434340765512382439),
            name: 'label',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3220529532867476599),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 3350676040812579837),
            name: 'status',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(2, 7096364116743183016),
            name: 'sceneParts',
            targetId: const IdUid(2, 1511157904358265259))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 3071344233334664377),
      name: 'SoftwareModel',
      lastPropertyId: const IdUid(7, 1576951636825092240),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 913838930232164171),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 762380834622339688),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2344305387419992394),
            name: 'companyId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5456851054820624921),
            name: 'companyName',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 6265991732107459666),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 7927146172863663854),
            name: 'icon',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1576951636825092240),
            name: 'companyLogo',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(3, 3142818417267476908),
            name: 'allVideos',
            targetId: const IdUid(5, 8704043719060779501))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 8704043719060779501),
      name: 'VideoModel',
      lastPropertyId: const IdUid(5, 4568898860801454124),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 9014292450817808013),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1784800348298360510),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2635845138829844197),
            name: 'path',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 8023234655259261754),
            name: 'time',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(4, 3601124264196646975),
            name: 'screenShoots',
            targetId: const IdUid(3, 1597679080181769401))
      ],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Store openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) =>
    Store(getObjectBoxModel(),
        directory: directory,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(5, 8704043719060779501),
      lastIndexId: const IdUid(1, 2805705393685960525),
      lastRelationId: const IdUid(4, 3601124264196646975),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [2805705393685960525],
      retiredPropertyUids: const [4568898860801454124],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    PartObjectModel: EntityDefinition<PartObjectModel>(
        model: _entities[0],
        toOneRelations: (PartObjectModel object) => [],
        toManyRelations: (PartObjectModel object) => {},
        getId: (PartObjectModel object) => object.id,
        setId: (PartObjectModel object, int id) {
          object.id = id;
        },
        objectToFB: (PartObjectModel object, fb.Builder fbb) {
          final colorOffset =
              object.color == null ? null : fbb.writeString(object.color!);
          final imageNameOffset = object.imageName == null
              ? null
              : fbb.writeString(object.imageName!);
          final pathOffset =
              object.path == null ? null : fbb.writeString(object.path!);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final labelOffset =
              object.label == null ? null : fbb.writeString(object.label!);
          final typeOffset =
              object.type == null ? null : fbb.writeString(object.type!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          final actionKindOffset = object.actionKind == null
              ? null
              : fbb.writeString(object.actionKind!);
          fbb.startTable(14);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addFloat64(1, object.left);
          fbb.addFloat64(2, object.right);
          fbb.addFloat64(3, object.top);
          fbb.addFloat64(4, object.bottom);
          fbb.addOffset(5, colorOffset);
          fbb.addOffset(6, imageNameOffset);
          fbb.addOffset(7, pathOffset);
          fbb.addOffset(8, descriptionOffset);
          fbb.addOffset(9, labelOffset);
          fbb.addOffset(10, typeOffset);
          fbb.addOffset(11, statusOffset);
          fbb.addOffset(12, actionKindOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PartObjectModel()
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
            ..left = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 6)
            ..right = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 8)
            ..top = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 10)
            ..bottom = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 12)
            ..color = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 14)
            ..imageName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 16)
            ..path = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 18)
            ..description = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 20)
            ..label = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 22)
            ..type = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 24)
            ..status = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 26)
            ..actionKind = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 28);

          return object;
        }),
    ScenePartModel: EntityDefinition<ScenePartModel>(
        model: _entities[1],
        toOneRelations: (ScenePartModel object) => [],
        toManyRelations: (ScenePartModel object) =>
            {RelInfo<ScenePartModel>.toMany(1, object.id!): object.partObjects},
        getId: (ScenePartModel object) => object.id,
        setId: (ScenePartModel object, int id) {
          object.id = id;
        },
        objectToFB: (ScenePartModel object, fb.Builder fbb) {
          final colorOffset =
              object.color == null ? null : fbb.writeString(object.color!);
          final imageNameOffset = object.imageName == null
              ? null
              : fbb.writeString(object.imageName!);
          final pathOffset =
              object.path == null ? null : fbb.writeString(object.path!);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final labelOffset =
              object.label == null ? null : fbb.writeString(object.label!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          fbb.startTable(12);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addFloat64(1, object.left);
          fbb.addFloat64(2, object.right);
          fbb.addFloat64(3, object.top);
          fbb.addFloat64(4, object.bottom);
          fbb.addOffset(5, colorOffset);
          fbb.addOffset(6, imageNameOffset);
          fbb.addOffset(7, pathOffset);
          fbb.addOffset(8, descriptionOffset);
          fbb.addOffset(9, labelOffset);
          fbb.addOffset(10, statusOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ScenePartModel()
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
            ..left = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 6)
            ..right = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 8)
            ..top = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 10)
            ..bottom = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 12)
            ..color = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 14)
            ..imageName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 16)
            ..path = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 18)
            ..description = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 20)
            ..label = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 22)
            ..status = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 24);
          InternalToManyAccess.setRelInfo<ScenePartModel>(object.partObjects,
              store, RelInfo<ScenePartModel>.toMany(1, object.id!));
          return object;
        }),
    ScreenShootModel: EntityDefinition<ScreenShootModel>(
        model: _entities[2],
        toOneRelations: (ScreenShootModel object) => [],
        toManyRelations: (ScreenShootModel object) => {
              RelInfo<ScreenShootModel>.toMany(2, object.id!): object.sceneParts
            },
        getId: (ScreenShootModel object) => object.id,
        setId: (ScreenShootModel object, int id) {
          object.id = id;
        },
        objectToFB: (ScreenShootModel object, fb.Builder fbb) {
          final imageNameOffset = object.imageName == null
              ? null
              : fbb.writeString(object.imageName!);
          final pathOffset =
              object.path == null ? null : fbb.writeString(object.path!);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final labelOffset =
              object.label == null ? null : fbb.writeString(object.label!);
          final typeOffset =
              object.type == null ? null : fbb.writeString(object.type!);
          final statusOffset =
              object.status == null ? null : fbb.writeString(object.status!);
          fbb.startTable(8);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, imageNameOffset);
          fbb.addOffset(2, pathOffset);
          fbb.addOffset(3, descriptionOffset);
          fbb.addOffset(4, labelOffset);
          fbb.addOffset(5, typeOffset);
          fbb.addOffset(6, statusOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ScreenShootModel()
            ..id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
            ..imageName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 6)
            ..path = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 8)
            ..description = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10)
            ..label = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 12)
            ..type = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 14)
            ..status = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 16);
          InternalToManyAccess.setRelInfo<ScreenShootModel>(object.sceneParts,
              store, RelInfo<ScreenShootModel>.toMany(2, object.id!));
          return object;
        }),
    SoftwareModel: EntityDefinition<SoftwareModel>(
        model: _entities[3],
        toOneRelations: (SoftwareModel object) => [],
        toManyRelations: (SoftwareModel object) =>
            {RelInfo<SoftwareModel>.toMany(3, object.id): object.allVideos},
        getId: (SoftwareModel object) => object.id,
        setId: (SoftwareModel object, int id) {
          object.id = id;
        },
        objectToFB: (SoftwareModel object, fb.Builder fbb) {
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          final companyIdOffset = object.companyId == null
              ? null
              : fbb.writeString(object.companyId!);
          final companyNameOffset = object.companyName == null
              ? null
              : fbb.writeString(object.companyName!);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          final iconOffset =
              object.icon == null ? null : fbb.writeString(object.icon!);
          final companyLogoOffset = object.companyLogo == null
              ? null
              : fbb.writeString(object.companyLogo!);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, titleOffset);
          fbb.addOffset(2, companyIdOffset);
          fbb.addOffset(3, companyNameOffset);
          fbb.addOffset(4, descriptionOffset);
          fbb.addOffset(5, iconOffset);
          fbb.addOffset(6, companyLogoOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SoftwareModel(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 10),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 12),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 14),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 16));
          InternalToManyAccess.setRelInfo<SoftwareModel>(object.allVideos,
              store, RelInfo<SoftwareModel>.toMany(3, object.id));
          return object;
        }),
    VideoModel: EntityDefinition<VideoModel>(
        model: _entities[4],
        toOneRelations: (VideoModel object) => [],
        toManyRelations: (VideoModel object) =>
            {RelInfo<VideoModel>.toMany(4, object.id): object.screenShoots},
        getId: (VideoModel object) => object.id,
        setId: (VideoModel object, int id) {
          object.id = id;
        },
        objectToFB: (VideoModel object, fb.Builder fbb) {
          final nameOffset =
              object.name == null ? null : fbb.writeString(object.name!);
          final pathOffset =
              object.path == null ? null : fbb.writeString(object.path!);
          final timeOffset =
              object.time == null ? null : fbb.writeString(object.time!);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, pathOffset);
          fbb.addOffset(3, timeOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = VideoModel(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 10));
          InternalToManyAccess.setRelInfo<VideoModel>(object.screenShoots,
              store, RelInfo<VideoModel>.toMany(4, object.id));
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [PartObjectModel] entity fields to define ObjectBox queries.
class PartObjectModel_ {
  /// see [PartObjectModel.id]
  static final id =
      QueryIntegerProperty<PartObjectModel>(_entities[0].properties[0]);

  /// see [PartObjectModel.left]
  static final left =
      QueryDoubleProperty<PartObjectModel>(_entities[0].properties[1]);

  /// see [PartObjectModel.right]
  static final right =
      QueryDoubleProperty<PartObjectModel>(_entities[0].properties[2]);

  /// see [PartObjectModel.top]
  static final top =
      QueryDoubleProperty<PartObjectModel>(_entities[0].properties[3]);

  /// see [PartObjectModel.bottom]
  static final bottom =
      QueryDoubleProperty<PartObjectModel>(_entities[0].properties[4]);

  /// see [PartObjectModel.color]
  static final color =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[5]);

  /// see [PartObjectModel.imageName]
  static final imageName =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[6]);

  /// see [PartObjectModel.path]
  static final path =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[7]);

  /// see [PartObjectModel.description]
  static final description =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[8]);

  /// see [PartObjectModel.label]
  static final label =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[9]);

  /// see [PartObjectModel.type]
  static final type =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[10]);

  /// see [PartObjectModel.status]
  static final status =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[11]);

  /// see [PartObjectModel.actionKind]
  static final actionKind =
      QueryStringProperty<PartObjectModel>(_entities[0].properties[12]);
}

/// [ScenePartModel] entity fields to define ObjectBox queries.
class ScenePartModel_ {
  /// see [ScenePartModel.id]
  static final id =
      QueryIntegerProperty<ScenePartModel>(_entities[1].properties[0]);

  /// see [ScenePartModel.left]
  static final left =
      QueryDoubleProperty<ScenePartModel>(_entities[1].properties[1]);

  /// see [ScenePartModel.right]
  static final right =
      QueryDoubleProperty<ScenePartModel>(_entities[1].properties[2]);

  /// see [ScenePartModel.top]
  static final top =
      QueryDoubleProperty<ScenePartModel>(_entities[1].properties[3]);

  /// see [ScenePartModel.bottom]
  static final bottom =
      QueryDoubleProperty<ScenePartModel>(_entities[1].properties[4]);

  /// see [ScenePartModel.color]
  static final color =
      QueryStringProperty<ScenePartModel>(_entities[1].properties[5]);

  /// see [ScenePartModel.imageName]
  static final imageName =
      QueryStringProperty<ScenePartModel>(_entities[1].properties[6]);

  /// see [ScenePartModel.path]
  static final path =
      QueryStringProperty<ScenePartModel>(_entities[1].properties[7]);

  /// see [ScenePartModel.description]
  static final description =
      QueryStringProperty<ScenePartModel>(_entities[1].properties[8]);

  /// see [ScenePartModel.label]
  static final label =
      QueryStringProperty<ScenePartModel>(_entities[1].properties[9]);

  /// see [ScenePartModel.status]
  static final status =
      QueryStringProperty<ScenePartModel>(_entities[1].properties[10]);

  /// see [ScenePartModel.partObjects]
  static final partObjects =
      QueryRelationToMany<ScenePartModel, PartObjectModel>(
          _entities[1].relations[0]);
}

/// [ScreenShootModel] entity fields to define ObjectBox queries.
class ScreenShootModel_ {
  /// see [ScreenShootModel.id]
  static final id =
      QueryIntegerProperty<ScreenShootModel>(_entities[2].properties[0]);

  /// see [ScreenShootModel.imageName]
  static final imageName =
      QueryStringProperty<ScreenShootModel>(_entities[2].properties[1]);

  /// see [ScreenShootModel.path]
  static final path =
      QueryStringProperty<ScreenShootModel>(_entities[2].properties[2]);

  /// see [ScreenShootModel.description]
  static final description =
      QueryStringProperty<ScreenShootModel>(_entities[2].properties[3]);

  /// see [ScreenShootModel.label]
  static final label =
      QueryStringProperty<ScreenShootModel>(_entities[2].properties[4]);

  /// see [ScreenShootModel.type]
  static final type =
      QueryStringProperty<ScreenShootModel>(_entities[2].properties[5]);

  /// see [ScreenShootModel.status]
  static final status =
      QueryStringProperty<ScreenShootModel>(_entities[2].properties[6]);

  /// see [ScreenShootModel.sceneParts]
  static final sceneParts =
      QueryRelationToMany<ScreenShootModel, ScenePartModel>(
          _entities[2].relations[0]);
}

/// [SoftwareModel] entity fields to define ObjectBox queries.
class SoftwareModel_ {
  /// see [SoftwareModel.id]
  static final id =
      QueryIntegerProperty<SoftwareModel>(_entities[3].properties[0]);

  /// see [SoftwareModel.title]
  static final title =
      QueryStringProperty<SoftwareModel>(_entities[3].properties[1]);

  /// see [SoftwareModel.companyId]
  static final companyId =
      QueryStringProperty<SoftwareModel>(_entities[3].properties[2]);

  /// see [SoftwareModel.companyName]
  static final companyName =
      QueryStringProperty<SoftwareModel>(_entities[3].properties[3]);

  /// see [SoftwareModel.description]
  static final description =
      QueryStringProperty<SoftwareModel>(_entities[3].properties[4]);

  /// see [SoftwareModel.icon]
  static final icon =
      QueryStringProperty<SoftwareModel>(_entities[3].properties[5]);

  /// see [SoftwareModel.companyLogo]
  static final companyLogo =
      QueryStringProperty<SoftwareModel>(_entities[3].properties[6]);

  /// see [SoftwareModel.allVideos]
  static final allVideos =
      QueryRelationToMany<SoftwareModel, VideoModel>(_entities[3].relations[0]);
}

/// [VideoModel] entity fields to define ObjectBox queries.
class VideoModel_ {
  /// see [VideoModel.id]
  static final id =
      QueryIntegerProperty<VideoModel>(_entities[4].properties[0]);

  /// see [VideoModel.name]
  static final name =
      QueryStringProperty<VideoModel>(_entities[4].properties[1]);

  /// see [VideoModel.path]
  static final path =
      QueryStringProperty<VideoModel>(_entities[4].properties[2]);

  /// see [VideoModel.time]
  static final time =
      QueryStringProperty<VideoModel>(_entities[4].properties[3]);

  /// see [VideoModel.screenShoots]
  static final screenShoots = QueryRelationToMany<VideoModel, ScreenShootModel>(
      _entities[4].relations[0]);
}
