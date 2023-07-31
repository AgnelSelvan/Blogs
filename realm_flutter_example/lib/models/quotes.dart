import 'package:realm/realm.dart';

part 'quotes.g.dart';

@RealmModel()
class _Quotes {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;

  late String quote;

  @MapTo('author_name')
  late String authorName;

  late DateTime createdAt;
}
