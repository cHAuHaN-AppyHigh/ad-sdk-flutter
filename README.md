# Ad SDK Flutter
A wrapper class to facilitate easy and standardized implementation of latest Admob SDK

## Initialization
#### AdSdk
##### initialize
```
//Call 'initialize'function with the AdSdk class object  
@param defaultAdSdkAppConfig -> Pass the details in the form of AdSdkAppConfig class, Export it from `https://admobdash-v2.apyhi.com/`. (required parameter).  
@param userId -> Pass the userId being used in parent app. (required parameter)  
@param adSdkConfiguration -> Pass the details of list of applovinTestDevices, googleAdsTestDevices, personalisedAds, isTestMode and personalisedAds as AdSdkConfiguration class.(default -> null)
@param isDebug -> You can pass if the debug mode is on or off by passing the boolean value.(default is false)
@param appLovinKey -> You can pass you appLovinKey to initialize AppLovinMAX
AdSdk.initialise(
    defaultAdSdkAppConfig: DefaultAdSdkOptions.currentPlatform,
    userId:user_id,)
//Admob and AppLovin are initialized with this function
```

### AdViewEntity 
##### loadAd
AdViewEntity is used for Widget less ads like Interstitial, AppOpen, Rewarded. 
```
//Call 'loadAd' function to load the Ad.
@param onAdLoaded -> pass voidCallBack function that needs to be executed if ad gets loaded successfully.(required)
@param onAdFailedToLoad -> pass voidCallBack function that needs to be executed if ad is not loaded.(required).

AdViewEntity(id).loadAd(onAdLoaded: () {
    ///When ad load is successful
}, onAdFailedToLoad: () {
    ///When ad load failed
})
//pass appyhighId in place of id
```

##### showAd
```
//Call 'showAd' function to display the ad.
@param adShowListener -> pass instance of CustomAdShowListener class 

adViewEntity.showAd(CustomAdShowListener(onAdClosedSuccess: () {
      }, onAdShowFailure: () {
        ///When ad couldn't be shown due to sdk issue
      }, onAdSuccessful: () {
        ///When ad successful
        ///For rewarded when user has got the reward
        ///For Interstitial and App open, when ad was shown
      }));
```
### AdWidgetEntity
##### AdWidget

##### loadAd
AdWidgetEntity is used for Widget Ads like Native, Banner
```
//Call 'loadAd' function to load the Ad.
@param onAdLoaded -> pass voidCallBack function that needs to be executed if ad gets loaded successfully.(required)
@param onAdFailedToLoad -> pass voidCallBack function that needs to be executed if ad is not loaded.(required).

AdViewEntity(id).loadAd(onAdLoaded: () {
    ///When ad load is successful
}, onAdFailedToLoad: () {
    ///When ad load failed
})
//pass appyhighId in place of id
```

```
// To show ad widget
@param adEntity -> AdWidgetEntity class to build the ad. (required)
@param onLoadingWidget -> widget to be shown when ad is loading.
@param onErrorWidget -> widget to be shown when ad fails to load.

final AdWidgetEntity _adHandler = AdWidgetEntity(id);
//pass appyhigh id in place of id
AdWidget(adEntity: adWidgetEntity, onLoadingWidget: Text('Sponsored'))
````
