// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/ui/page/common/splash.dart';
import 'package:flutter_twitter_clone/ui/page/homePage.dart';
import 'package:flutter_twitter_clone/ui/page/profile/profilePage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import '../helper/customRoute.dart';
import '../ui/page/feed/feedPostDetail.dart';
import '../ui/page/feed/composeTweet/composeTweet.dart';
import '../ui/page/feed/composeTweet/state/composeTweetState.dart';

class Routes {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static Map<String, WidgetBuilder> route() {
    return {
      'SplashPage': (BuildContext context) => const SplashPage(),
      'HomePage': (BuildContext context) => const HomePage(),
    };
  }

  static void sendNavigationEventToFirebase(String? name) {
    analytics.setCurrentScreen(screenName: name);
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    sendNavigationEventToFirebase(settings.name);
    final List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "ComposeTweetPage":
        bool isRetweet = false;
        bool isTweet = false;
        if (pathElements.length == 3 && pathElements[2].contains('retweet')) {
          isRetweet = true;
        } else if (pathElements.length == 3 && pathElements[2].contains('tweet')) {
          isTweet = true;
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<ComposeTweetState>(
                  create: (_) => ComposeTweetState(),
                  child: ComposeTweetPage(isRetweet: isRetweet, isTweet: isTweet),
                ));
      case "FeedPostDetail":
        var postId = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => FeedPostDetail(
                  postId: postId,
                ),
            settings: const RouteSettings(name: 'FeedPostDetail'));
      case "ProfilePage":
        String profileId;
        if (pathElements.length > 2) {
          profileId = pathElements[2];
          return CustomRoute<bool>(
              builder: (BuildContext context) => ProfilePage(
                    profileId: profileId,
                  ));
        }
        return CustomRoute(builder: (BuildContext context) => const HomePage());
      default:
        return onUnknownRoute(const RouteSettings(name: '/Feature'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(settings.name!.split('/')[1]),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name!.split('/')[1]} Coming soon..'),
        ),
      ),
    );
  }
}
