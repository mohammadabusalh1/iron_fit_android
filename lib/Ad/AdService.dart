// lib/services/ad_service.dart
// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iron_fit/constants/AdConstants.dart';
import 'package:iron_fit/utils/logger.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  bool _isInitialized = false;
  bool _isCurrentlyLoading = false;
  DateTime? _lastLoadAttemptTime;

  // Min time between ad load attempts
  static const Duration _minLoadInterval = Duration(seconds: 5);

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> loadAd(BuildContext context) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Check if a previous ad is still loading or available
    if (_interstitialAd != null || _isCurrentlyLoading) return;

    // Enforce minimum time between load attempts
    if (_lastLoadAttemptTime != null) {
      final timeSinceLastAttempt =
          DateTime.now().difference(_lastLoadAttemptTime!);
      if (timeSinceLastAttempt < _minLoadInterval) {
        Logger.info('Throttling ad load request. Will try again later.');
        return;
      }
    }

    // Mark as loading and update last attempt time
    _isCurrentlyLoading = true;
    _lastLoadAttemptTime = DateTime.now();

    Logger.info(
        'Loading interstitial ad for ${Platform.isIOS ? 'iOS' : 'Android'}');

    await InterstitialAd.load(
      adUnitId: Platform.isIOS ? AdConstants.adUnitIdIOS : AdConstants.adUnitId,
      request: AdConstants.request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _isCurrentlyLoading = false;
          _interstitialAd!.setImmersiveMode(true);
          Logger.info('Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (LoadAdError error) {
          Logger.error(
              'Interstitial ad failed to load: ${error.message} ${error.code} AdService.dart line 68');
          _isCurrentlyLoading = false;
          _handleAdFailedToLoad(error, context);
        },
      ),
    );
  }

  void _handleAdFailedToLoad(LoadAdError error, BuildContext context) {
    _numInterstitialLoadAttempts += 1;
    _interstitialAd = null;

    if (_numInterstitialLoadAttempts < AdConstants.maxFailedLoadAttempts) {
      // Exponential backoff with minimum 3 seconds (3000ms)
      int delay = max(3000, (1 << (_numInterstitialLoadAttempts - 1)) * 1000);
      Logger.info(
          'Retrying to load ad in $delay ms. Attempt: $_numInterstitialLoadAttempts');
      Timer(Duration(milliseconds: delay), () => loadAd(context));
    } else {
      Logger.error('Failed to load interstitial ad after multiple attempts');
      // Reset for future attempts, but wait at least 30 seconds
      _numInterstitialLoadAttempts = 0;
      Timer(const Duration(seconds: 30), () {
        // Reset the loading state after the timeout
        _isCurrentlyLoading = false;
      });
    }
  }

  void showInterstitialAd(BuildContext context) {
    if (_interstitialAd == null) {
      Logger.info('Attempted to show ad but no ad was loaded');
      loadAd(context);
      return;
    }

    Logger.info('Showing interstitial ad');
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        Logger.info('Interstitial ad showed full screen content');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Logger.info('Interstitial ad dismissed');
        ad.dispose();
        // Wait a bit before loading the next ad
        Timer(const Duration(seconds: 2), () {
          loadAd(context);
        });
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        Logger.error('Interstitial ad failed to show: ${error.message}');
        ad.dispose();
        // Wait a bit before loading the next ad
        Timer(const Duration(seconds: 2), () {
          loadAd(context);
        });
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // Helper function to get max value
  int max(int a, int b) {
    return a > b ? a : b;
  }
}
