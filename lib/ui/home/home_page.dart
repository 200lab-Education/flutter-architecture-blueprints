import 'package:app/util/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_theme.dart';
import '../component/article_item.dart';
import '../component/loading.dart';
import '../error_notifier.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).home),
          actions: [
            // action button
            IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () async => context
                  .read(appThemeNotifierProvider)
                  .toggle()
                  .catchError((error) {
                Get.snackbar('Error Title', 'Failed: Change Theme');
              }),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  context.read(homeViewModelNotifierProvider).fetchNews(),
            ),
          ],
        ),
        body: Center(
          child: HookBuilder(
            builder: (context) {
              final error = useProvider(errorNotifierProvider);
              final homeViewModel = context.read(homeViewModelNotifierProvider);
              final news = useProvider(
                  homeViewModelNotifierProvider.select((value) => value.news));
              final snapshot = useFuture(useMemoized(homeViewModel.fetchNews,
                  // These Keys is very important, so should think carefully.
                  [news.toString(), error.peekContent()?.type]));

              if (!error.hasBeenHandled) {
                return Text('Error Screen: ${error.getErrorIfNotHandled()}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              }

              if (!homeViewModel.hasArticle) {
                return const Text('Empty screen');
              }

              return ListView.builder(
                itemCount: news.articles.length,
                itemBuilder: (_, index) {
                  return ArticleItem(article: news.articles[index]);
                },
              );
            },
          ),
        ));
  }
}
