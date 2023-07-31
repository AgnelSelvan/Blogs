// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Quotes extends _Quotes with RealmEntity, RealmObjectBase, RealmObject {
  Quotes(
    ObjectId id,
    String quote,
    String authorName,
    DateTime createdAt,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'quote', quote);
    RealmObjectBase.set(this, 'author_name', authorName);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Quotes._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get quote => RealmObjectBase.get<String>(this, 'quote') as String;
  @override
  set quote(String value) => RealmObjectBase.set(this, 'quote', value);

  @override
  String get authorName =>
      RealmObjectBase.get<String>(this, 'author_name') as String;
  @override
  set authorName(String value) =>
      RealmObjectBase.set(this, 'author_name', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Quotes>> get changes =>
      RealmObjectBase.getChanges<Quotes>(this);

  @override
  Quotes freeze() => RealmObjectBase.freezeObject<Quotes>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Quotes._);
    return const SchemaObject(ObjectType.realmObject, Quotes, 'Quotes', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('quote', RealmPropertyType.string),
      SchemaProperty('authorName', RealmPropertyType.string,
          mapTo: 'author_name'),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }
}
