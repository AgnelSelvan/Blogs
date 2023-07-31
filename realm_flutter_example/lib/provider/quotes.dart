import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:realm_flutter_example/models/quotes.dart';

class QuotesNotifier extends ChangeNotifier {
  late Realm realm;

  QuotesNotifier(User user) {
    realm = Realm(Configuration.flexibleSync(user, [Quotes.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(realm.all<Quotes>());
    });
  }

  void addQuote(String quote, String authorName) {
    realm.write(() {
      return realm.add(Quotes(ObjectId(), quote, authorName, DateTime.now()));
    });
  }

  void deleteQuote(Quotes quote) {
    realm.write(() => realm.delete(quote));
  }

  void updateQuote(Quotes quotes, {String? quote, String? authorName}) {
    realm.write(() {
      if (quote != null) {
        quotes.quote = quote;
      }
      if (authorName != null) {
        quotes.authorName = authorName;
      }
    });
  }
}
