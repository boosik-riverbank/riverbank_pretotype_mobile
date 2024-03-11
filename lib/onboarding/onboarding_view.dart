import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/onboarding/onboarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    Onboarding().onboardData().then((goBalance) {
      if (goBalance) {
        context.go('/balance');
      } else {
        context.go("/login");
      }
    });

    return Scaffold(
      body: Center(
        child: SvgPicture.asset('asset/image/splash_logo.svg'),
      )
    );
  }

}