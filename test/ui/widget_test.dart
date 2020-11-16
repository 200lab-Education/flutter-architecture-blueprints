import 'package:app/app.dart';
import 'package:app/constants.dart';
import 'package:app/data/app_error.dart';
import 'package:app/data/model/theme_setting.dart';
import 'package:app/ui/app_theme.dart';
import 'package:app/ui/component/article_item.dart';
import 'package:app/ui/component/loading.dart';
import 'package:app/ui/detail/datail_page.dart';
import 'package:app/ui/home/home_page.dart';
import 'package:app/ui/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

import '../data/dummy/dummy_article.dart';
import '../data/dummy/dummy_news.dart';

class MockAppTheme extends Mock implements AppTheme {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  Get.testMode = true;

  final mockAppTheme = MockAppTheme();
  when(mockAppTheme.setting).thenReturn(ThemeSetting.light);
  when(mockAppTheme.themeData).thenAnswer((_) => Future.value(lightTheme));

  final mockHomeViewModel = MockHomeViewModel();
  when(mockHomeViewModel.fetchNews()).thenAnswer((_) => Future.value());
  when(mockHomeViewModel.news).thenReturn(dummyNews);
  when(mockHomeViewModel.hasArticle).thenReturn(true);
  when(mockHomeViewModel.hasBeenHandled).thenReturn(true);
  when(mockHomeViewModel.getErrorIfNotHandled()).thenReturn(ApiError(Error()));
  when(mockAppTheme.themeData).thenAnswer((_) => Future.value(lightTheme));

  final mockNavigatorObserver = MockNavigatorObserver();

  testWidgets('App widget test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appThemeNotifierProvider.overrideWithValue(mockAppTheme),
        ],
        child: App(),
      ),
    );
  });

  testWidgets('HomePage widget test', (tester) async {
    await provideMockedNetworkImages(() async {
      final page = HomePage();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appThemeNotifierProvider.overrideWithValue(mockAppTheme),
            homeViewModelNotifierProvider.overrideWithValue(mockHomeViewModel),
          ],
          child: GetMaterialApp(
            home: page,
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byWidget(page), findsOneWidget);
    });
  });

  testWidgets('Article widget test', (tester) async {
    final article = ArticleItem(article: dummyArticle);
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(GetMaterialApp(
        home: article,
        routes: {
          Constants.pageDetail: (context) => DetailPage(),
        },
        navigatorObservers: [mockNavigatorObserver],
      ));

      expect(find.byWidget(article), findsOneWidget);
      await tester.tap(find.byType(Hero));
      await tester.pumpAndSettle();
      verify(mockNavigatorObserver.didPush(any, any));
      expect(find.byType(DetailPage), findsOneWidget);
    });
  });

  testWidgets('Loading widget test', (tester) async {
    const loading = Loading();
    await tester.pumpWidget(loading);
    expect(find.byWidget(loading), findsOneWidget);
  });
}
