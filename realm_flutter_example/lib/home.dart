import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:realm_flutter_example/models/quotes.dart';
import 'package:realm_flutter_example/provider/quotes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showAddQuoteDialog(BuildContext context, Quotes? quote) {
    showDialog(
      context: context,
      builder: (context) {
        final quoteTF = TextEditingController(text: quote?.quote ?? '');
        final authorTF = TextEditingController(text: quote?.authorName ?? '');
        return SimpleDialog(
          title: const Text("Add Quote"),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 14,
          ),
          children: [
            TextField(
              controller: quoteTF,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quote',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: authorTF,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Author Name',
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                if (quote == null) {
                  Provider.of<QuotesNotifier>(context, listen: false)
                      .addQuote(quoteTF.text, authorTF.text);
                } else {
                  Provider.of<QuotesNotifier>(context, listen: false)
                      .updateQuote(
                    quote,
                    quote: quoteTF.text,
                    authorName: authorTF.text,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(quote == null ? "Save" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quoteNotifier = Provider.of<QuotesNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Quotes"),
      ),
      body: StreamBuilder<RealmResultsChanges<Quotes>>(
        stream: quoteNotifier.realm
            .query<Quotes>("TRUEPREDICATE SORT(_id ASC)")
            .changes,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data?.results;
            return ListView.builder(
              itemCount: results == null ? 0 : results.length,
              itemBuilder: (context, index) {
                final data = results?[index];
                return Dismissible(
                  key: Key("$index"),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      if (data != null) {
                        quoteNotifier.deleteQuote(data);
                      }
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text('Move to trash',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(data?.quote ?? ""),
                    subtitle: Text(data?.authorName ?? ""),
                    onLongPress: () {
                      showAddQuoteDialog(context, data);
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddQuoteDialog(context, null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
