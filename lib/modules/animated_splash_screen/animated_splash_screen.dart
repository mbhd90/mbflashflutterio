import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bm_flash/utils/laravel_echo/laravel_echo.dart';

import '../../core/router_name.dart';
import '../authentication/controller/login/login_bloc.dart';
import 'controller/app_setting_cubit/app_setting_cubit.dart';
import 'widgets/animation_splash_widget.dart';
import 'widgets/setting_error_widget.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  final _className = '_SplashScreenState';
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() {
      if (mounted) setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final appSettinBloc = context.read<AppSettingCubit>();
    final loginBloc = context.read<LoginBloc>();
    return Scaffold(
      body: BlocConsumer<AppSettingCubit, AppSettingState>(
        listener: (context, state) {
          log("listener $state", name: _className);
          if (state is AppSettingStateLoaded) {
            if (state.settingModel.maintainTextModel!.status == 0) {
              // PusherConfig(

              // PusherConfig.appId = state.settingModel.pusherInfo.appId;
              // PusherConfig.key = state.settingModel.pusherInfo.appkey;
              // PusherConfig.secret = state.settingModel.pusherInfo.appSecret;
              // PusherConfig.cluster = state.settingModel.pusherInfo.appCluster;
              if (loginBloc.isLogedIn) {
                Navigator.pushReplacementNamed(context, RouteNames.mainPage);
              } else if (appSettinBloc.isOnBoardingShown) {
                Navigator.pushReplacementNamed(
                    context, RouteNames.authenticationScreen);
              } else {
                Navigator.pushReplacementNamed(
                    context, RouteNames.onboardingScreen);
              }
            } else {
              Navigator.pushReplacementNamed(
                  context, RouteNames.maintainScreen);
            }
          }
        },
        builder: (context, state) {
          if (state is AppSettingStateError) {
            return SettingErrorWidget(message: state.meg);
          }
          return AnimationSplashWidget(animation: animation);
        },
      ),
    );
  }
}
