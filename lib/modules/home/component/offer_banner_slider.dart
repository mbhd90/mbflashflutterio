import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '/utils/constants.dart';
import '../model/slider_model.dart';
import 'single_offer_banner.dart';

class OfferBannerSlider extends StatefulWidget {
  const OfferBannerSlider({
    Key? key,
    required this.sliders,
  }) : super(key: key);

  final List<SliderModel> sliders;

  @override
  State<OfferBannerSlider> createState() => _OfferBannerSliderState();
}

class _OfferBannerSliderState extends State<OfferBannerSlider> {
  final double height0 = 144;
  final int initialPage = 0;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.sliders.isNotEmpty) {
      final double x2 = MediaQuery.of(context).size.width;
      final double x = 740;
      final double h = 500;
      final double height = (x2 * h) / x;
      return Container(
        color: const Color(0xffF6F6F6),
        child: Container(
          margin: const EdgeInsets.only(top: 15, bottom: 20),
          height: height,
          child: Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 1,
                  initialPage: initialPage,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                items: widget.sliders
                    .map((i) => SingleOfferBanner(slider: i))
                    .toList(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 4,
                child: DotsIndicator(
                  dotsCount: widget.sliders.length,
                  key: UniqueKey(),
                  decorator: DotsDecorator(
                    activeColor: lightningYellowColor,
                    color: Colors.white,
                    activeSize: const Size(14.0, 4.0),
                    size: const Size(14.0, 4.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  position: _currentIndex.toDouble(),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
}
