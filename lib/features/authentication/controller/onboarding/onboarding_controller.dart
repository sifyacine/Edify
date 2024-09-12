import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../screens/signin/signin_screen.dart';


class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  /// variables
  final pagecontroller = PageController();
  Rx<int> currentPageIndex = 0.obs;



  /// Update Current Index When Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump To A Specific Dot Selected Page
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pagecontroller.jumpTo(index);
  }

  /// Update The Current Index And Jump To The Next Page
  void nextPage(){
    if(currentPageIndex.value == 2){
      Get.offAll(const LoginScreen());
    }else{
      int page = currentPageIndex.value + 1;
      pagecontroller.jumpToPage(page);
    }
  }

  /// Update The Current Index And Jump To The Last Page
  void skipPage(){
    currentPageIndex.value = 2;
    pagecontroller.jumpToPage(2);
  }

}