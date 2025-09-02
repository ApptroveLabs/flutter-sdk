# flutter sdk

## Table of Content

### Integration

- [Quick start guide](#qs-add-trackier-sdk)
  - [Add Flutter SDK to your app ](#qs-add-sdk)
  - [Update Pod Dependencies](#qs-pod-update)
  - [Adding Android install referrer to your app](#qs-add-install-referrer)
  - [Add required permissions](#qs-add-request-permissions)
  - [Getting Google Advertising ID](#qs-getting-gaid)
- [Integrate and Initialize the Trackier SDK](#qs-implement-trackier-sdk)
  - [Retrieve your dev key](#qs-retrieve-dev-key)
  - [Initialize the SDK](#qs-initialize-trackier-sdk)
- [Events Tracking](#qs-track-event)
  - [Retrieve Event Id from dashboard](#qs-retrieve-event-id)
  - [Built-in Events](#qs-built-in)
  - [Customs Events](#qs-customs-events)
  - [Revenue Event Tracking](#qs-track-event-with-currencey)
  - [Pass the custom params in events](#qs-add-custom-parms-event)
  - [Passing User Data to SDK](#qs-add-user-data) 
  - [Passing Additional Data](#qs-add-additional-data)
- [Track Uninstall for Android](#qs-track-uninstall-android)
- [SDK Signing](#qs-sdk-signing)
- [Deep linking](#gs-deeplink)
- [Getting Campaign Data](#gs-campaign-data)
- [Dynamic Deeplinks](#qs-dynamic-deeplinks)
- [Proguard Settings](#qs-progaurd-trackier-sdk)

## <a id="qs-add-trackier-sdk"></a>Quick start guide

We have created a example app for the flutter sdk integration. 

Please check the [Example](https://github.com/trackier/flutter-sdk/tree/master/example) directory for know to how the `Trackier SDK` can be integrated.

### <a id="qs-add-sdk"></a>Add Flutter SDK to your app

Flutter SDK is very easy to integrate in your app. Just need to follow some steps

You can add the flutter sdk in two ways:-


1. By adding the below code in the package `pubspec.yaml` 

```
dependencies:
  trackier_sdk_flutter: ^1.6.75
```

2. By using cli command. you need to run the below command in `terminal/cmd`.

```
$ flutter pub add trackier_sdk_flutter
```
This command will directly add the trackier sdk to your package's `pubspec.yaml`.

After that run the below command to update the packages.

```
  $ flutter packages get
```

### <a id="qs-pod-update"></a>Update Pod Dependencies

For iOS app make sure to go to ios folder and install Cocoapods dependencies:

```
$ cd ios && pod install
```

### <a id="qs-add-install-referrer"></a>Adding Android install referrer to your app

Add the Android Install Referrer as a dependency in your app **`build.gradle`** . You can find the latest version [here](https://developer.android.com/google/play/installreferrer/library)

```gradle
dependencies {
  // make sure to use the latest SDK version:
  implementation 'com.android.installreferrer:installreferrer:2.2'
}
```

### <a id="qs-add-request-permissions"></a>Add required permissions

Trackier SDK need the following below permission in the AndroidManifest.xml

Please add the below permission in your app project AndroidManifest.xml. if they are not added.

```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />

  <!-- Optional : -->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

### <a id="qs-getting-gaid"></a> Getting Google Advertising ID

Trackier SDK need the advertising id from the application.

For achieving this, you need to add some line of code in the build.gradle and also in AndroidManifest.xml for read the Advertising id from the application which is mentioned below:-

- Add the google advertising id dependency in your **android/app/build.gradle**


```gradle
dependencies {
  // This can be added where the SDK dependency has been added
  implementation 'com.google.android.gms:play-services-ads-identifier:18.0.1'
}
```
- Update your Android Manifest file by adding the following permission. This is required if your app is targeting devices with android version 12+

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
```

- Add meta data inside the application tag (If not already added)
```xml
<meta-data
            android:name="com.google.android.gms.version"
            android:value="@integer/google_play_services_version" /> //Add this meta-data in the manifest.xml under Application tag.
```


### <a id="qs-implement-trackier-sdk"></a>Integrate and Initialize the Trackier SDK

### <a id="qs-retrieve-dev-key"></a>Retrieve your dev key

For initialising the Trackier SDk. First, We need to generate the Sdk key from the Trackier MMP panel.

Following below are the steps to retrieve the development key:-

- Login your Trackier Panel
- Select your application and click on Action button and login as
- In the Dashboard, Click on the` SDK Integration` option on the left side of panel. 
- under on the SDK Integration, You will be get the SDK Key.

After follow all steps, Your SDK key look like the below screenshot

Screenshot[1]

<img width="1000" alt="Screenshot 2022-06-10 at 3 46 48 PM" src="https://user-images.githubusercontent.com/16884982/173044860-a540706c-ad10-4174-aaf0-7cf9290fc949.png">

### <a id="qs-initialize-trackier-sdk"></a>Integrate the Trackier SDK in the Flutter Application.

Flutter sdk should be initialized in the `initState()` method under `main.dart` class.

Below are the example of initializing and calling the method of the sdk. 

```dart

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    initilalizeSdk();
  }

  Future<void> initilalizeSdk() async {

    String key ="xxxx-xx-4505-bc8b-xx"; //Please pass your Development key here.

    /*While Initializing the Sdk, You need to pass the two arguments in the TrackierSDKConfig.
         * In First argument, you need to pass the Trackier SDK api key
         * In second argument, you need to pass the environment which can be either "development", "production" or "testing". */

    TrackerSDKConfig trackerSDKConfig = TrackerSDKConfig(key,"production");
    Trackierfluttersdk.initializeSDK(trackerSDKConfig);

  }
}

```

You can also check the below screenshot of the following examples:-

Screenshot [2]

<img width="1000" alt="Screenshot 2022-06-24 at 5 41 12 PM" src="https://user-images.githubusercontent.com/16884982/175531953-9599184c-dff4-4933-9aed-36dd1d9b8315.png">



<p>
Important: it is crucial to use the correct dev key when initializing the SDK. Using the wrong dev key or an
incorrect dev key impact all traffic sent from the SDK and cause attribution and reporting issues.
</p>

## <a id="qs-track-event"></a>Events Tracking

<a id="qs-retrieve-event-id"></a>Trackier events trackings enable to provides the insights into how to user interacts with your app. 
Trackier sdk easily get that insights data from the app. Just follow with the simple events integration process

Trackier provides the `Built-in events` and `Customs events` on the Trackier panel.

####  <a id="qs-built-in"></a> **Built-in Events** - 

Predefined events are the list of constants events which already been created on the dashboard. 

You can use directly to track those events. Just need to implements events in the app projects.

Screenshot[3]

<img width="1000" alt="Screenshot 2022-06-10 at 1 23 01 PM" src="https://user-images.githubusercontent.com/16884982/173018185-3356c117-8b9f-46d1-bfd5-c41653f9ac9e.png">

### Example code for calling Built-in events


```dart
  /*
 * Event Tracking
  <------------->
 * The below code is the example to pass a event to the Trackier SDK.
 * This event requires only 1 Parameter which is the Event ID.
 * Below are the example of built-in events function calling
 * The arguments - "TrackierEvent.LOGIN" passed in the Trackier event class is Events id
 *
 */
  void _eventsTracking(){
    TrackierEvent trackierEvent = TrackierEvent(TrackierEvent.LOGIN);

    /*Below are the function for the adding the extra data,
      You can add the extra data like login details of user or anything you need.
      We have 10 params to add data, Below 5 are mentioned*/
    trackierEvent.param1 = "param1";
    trackierEvent.param2 = "param2";
    trackierEvent.param3 = "param3";
    trackierEvent.param4 = "param4";
    trackierEvent.param5 = "param5";

    trackierEvent.setEventValue("ev1", "eventValue1");
    trackierEvent.setEventValue("ev2", 1);
    Trackierfluttersdk.trackEvent(trackierEvent);

  }

```

Note:- Argument in Trackier event class is event Id.

You can integrate inbuilt params with the event. In-built param list are mentioned below:-

orderId, revenue, currency, param1, param2, param3 ,param4, param5, param6, param7, param8, param9, param10.

Below are the screenshot of following example

Screenshot[4]

<img width="1000" alt="Screenshot 2022-06-27 at 2 09 54 PM" src="https://user-images.githubusercontent.com/16884982/175897459-2d9f0430-7d1c-45c9-972a-c5d1156722d2.png">


#### <a id="qs-customs-events"></a> **Customs Events** - 

Customs events are created by user as per their required business logic. 

You can create the events in the Trackier dashboard and integrate those events in the app project.

Screenshot[5]

<img width="1000" alt="Screenshot 2022-06-29 at 4 09 37 PM" src="https://user-images.githubusercontent.com/16884982/176417552-a8c80137-aa1d-480a-81a3-ea1e03172868.png">


#### Example code for calling Customs Events.

```dart

  /*
 * Event Tracking
  <------------->
 * The below code is the example to pass a event to the Trackier SDK.
 * This event requires only 1 Parameter which is the Event ID.
 * Below are the example of customs events function calling for `AppOpen` event name.
 * The arguments - "sEMWSCTXeu" passed in the Trackier event class is Events id 
 *
 */
  void _eventsTracking(){
    TrackierEvent trackierEvent = TrackierEvent("sEMWSCTXeu");

    /*Below are the function for the adding the extra data,
      You can add the extra data like login details of user or anything you need.
      We have 10 params to add data, Below 5 are mentioned*/
    trackierEvent.param1 = "param1";
    trackierEvent.param2 = "param2";
    trackierEvent.param3 = "param3";
    trackierEvent.param4 = "param4";
    trackierEvent.param5 = "param5";

    trackierEvent.setEventValue("ev1", "eventValue1");
    trackierEvent.setEventValue("ev2", 1);
    Trackierfluttersdk.trackEvent(trackierEvent);

  }

```
Also check the screenshots of the above code.

Screenshot[6]

<img width="1440" alt="Screenshot 2022-06-29 at 4 04 55 PM" src="https://user-images.githubusercontent.com/16884982/176416692-9c31c966-a149-4627-986d-665e0c6e4c45.png">



### <a id="qs-track-event-with-currencey"></a>Revenue Event Tracking

Trackier allow user to pass the revenue data which is generated from the app through Revenue events. It is mainly used to keeping record of generating revenue from the app and also you can pass currency as well.

```swift
    
  void _revenueEventsTracking(){

    // Below are the example of revenue events function calling
    //The arguments - "TrackierEvent.LOGIN" passed in the event class is Events id
    TrackierEvent trackierEvent = TrackierEvent(TrackierEvent.LOGIN);

    //Passing the revenue events be like below example
    trackierEvent.revenue = 10.0; //Pass your generated revenue here.
    trackierEvent.currency = "INR";  //Pass your currency here.
    trackierEvent.orderId = "orderID";
    trackierEvent.param1 = "param1";
    trackierEvent.param2 = "param2";
    trackierEvent.setEventValue("ev1", "eventValue1");
    trackierEvent.setEventValue("ev2", 1);
    Trackierfluttersdk.trackEvent(trackierEvent);

  }

```

### <a id="qs-add-custom-parms-event"></a>Pass the custom params in events

```dart

 void customParamTracking(){
    // Below are the example of revenue events function calling
    //The arguments - "TrackierEvent.LOGIN" passed in the event class is Events id
    TrackierEvent trackierEvent = TrackierEvent(TrackierEvent.LOGIN);

    //Passing the custom params in events be like below example
    var eventCustomParams = Map<String, Object>();
    eventCustomParams={"name":"abcd"};
    eventCustomParams={"age":"28"};
    trackierEvent.evMap=eventCustomParams;
    Trackierfluttersdk.trackEvent(trackierEvent);

  }  


```

- First create a map.
- Pass its reference to trackierEvent.evMap param of event.
- Pass event reference to trackEvent method of TrackierSDK.

### <a id="qs-add-user-data"></a>Passing User Data to SDK 

Trackier allows to pass additional data like Userid, Email to SDK so that same can be correlated to the Trackier Data and logs.

Just need to pass the data of User Id, Email Id and other additional data to Trackier sdk function which is mentioned below:-


```dart

void userDetails(){

    /*Passing the UserId and User EmailId Data */
    Trackierfluttersdk.setUserId("XXXXXXXX"); //Pass the UserId values here
    Trackierfluttersdk.setUserEmail("abc@gmail.com"); //Pass the user email id in the argument.

  }

```

### <a id="qs-add-additional-data"></a> For Passing Additional Data 

Trackier allow for passing the additional user details like UserName, Mobile Number, UserAge, UserGender etc. . You need to first make a hashmap and pass it in setUserAdditionalDetail function. The example are in mentioned below


```dart

  void userDetails(){
    /*Passing the UserId and User EmailId Data */
    Trackierfluttersdk.setUserId("XXXXXXXX"); //Pass the UserId values here
    Trackierfluttersdk.setUserEmail("abc@gmail.com"); //Pass the user email id in the argument.

    /*Passing the additional data */
    var userDetails = Map<String, Object>();
    userDetails={"name":"abcd"}; //You can pass the Username data.
    userDetails={"mobile_number":"872xxxxx87"}; // You can pass user mobile number
    Trackierfluttersdk.setUserAdditonalDetail(userDetails);

  }

```

### <a id="qs-track-uninstall-android"></a> Track Uninstall for Android

 **Before you begin**
* [Install `firebase_core`](https://firebase.flutter.dev/docs/overview) and add the initialization code to your app if you haven't already.
* Add your app to your Firebase project in the [Firebase console](https://console.firebase.google.com/).

#### Add the Analytics SDK to your app

* From the root of your Flutter project, run the following command to install the plugin:
	```sh
	  flutter pub add firebase_analytics
	```
* Once complete, rebuild your Flutter application:
	```sh
	  flutter run
	```
* Once installed, you can access the `firebase_analytics` plugin by importing it in your Dart code:
	```dart
	  import 'package:firebase_analytics/firebase_analytics.dart';
	```
* Create a new Firebase Analytics instance by calling the `instance` getter on `FirebaseAnalytics`:
	```dart
	  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
	```
* Use the `analytics` instance obtained above to set the following user property:
	```dart
    var trackierId = await Trackierfluttersdk.getTrackierId();
	  analytics.setUserProperty(name: "ct_objectId", value: trackierId);
	``` 

* Adding the above code to your app sets up a common identifier. 
* Set the `app_remove` event as a conversion event in Firebase. 
* Use the Firebase cloud function to send uninstall information to Trackier MMP. 
* You can find the support article [here](https://help.trackier.com/support/solutions/articles/31000162841-android-uninstall-tracking).

### <a id="qs-sdk-signing"></a> SDK Signing
Following below are the steps to retrieve the secretId and secretKey :-

- Login your Trackier Panel and select your application.
- In the Dashboard, click on the `SDK Integration` option on the left side of panel. 
- Under on the SDK Integration, click on the Advanced tab. 
- Under the Advanced tab, you will get the secretId and secretKey.

Please check on the below screenshot

Screenshot[7]

<img width="1000" alt="Screenshot 7" src="https://user-images.githubusercontent.com/16884982/185338826-bcf802d0-c493-4a67-adb3-a9b52bae289e.png">

Check below the example code for passing the secretId and secretKey to the SDK

```dart

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    initilalizeSdk();
  }

  Future<void> initilalizeSdk() async {

    String key ="xxxx-xx-4505-bc8b-xx"; //Please pass your Development key here.

    /*While Initializing the Sdk, You need to pass the two arguments in the TrackierSDKConfig.
         * In First argument, you need to pass the Trackier SDK api key
         * In second argument, you need to pass the environment which can be either "development", "production" or "testing". */

    TrackerSDKConfig trackerSDKConfig = TrackerSDKConfig(key,"production");
    trackerSDKConfig.setAppSecret("xxx", "xxx-xx");
    Trackierfluttersdk.initializeSDK(trackerSDKConfig);


  }
}


```

### <a id="gs-deeplink"></a> Deep linking 

Deep linking is a techniques in which the user directly redirect to the specific pages of the application by click on the deeplink url.

There are two types deeplinking

* ***Normal deeplinking*** - Direct deep linking occurs when a user already has your app installed on their device. When this is the case, the deep link will redirect the user to the screen specified in the link.

* ***Deferred deeplinking*** - Deferred deep linking occurs when a user does not have your app installed on their device. When this is the case, the deep link will first send the user to the device app store to install the app. Once the user has installed and opened the app, the SDK will redirect them to the screen specified in the link.

Please check below the Deeplinking scenario 

<img width="705" alt="Screenshot 2022-06-22 at 10 48 20 PM" src="https://user-images.githubusercontent.com/16884982/175099075-349910ce-ce7b-4a71-868c-11c34c4331cd.png">


### Normal Deep linking

If a user already has your app on their device, it will open when they interact with a tracker containing a deep link. You can then parse the deep link information for further use. To do this, you need to choose a desired unique scheme name.

You can set up a specific activity to launch when a user interacts with a deep link. To do this:

* Assign the unique scheme name to the activity in your AndroidManifest.xml file.
* Add the intent-filter section to the activity definition.
* Assign an android:scheme property value with your preferred scheme name.

For example, you could set up an activity called FirstActivity to open like this:
#### AndroidManifest.xml 

```

        <activity
            android:name=".Activity.FirstProduct"
            android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data
                android:host="trackier.u9ilnk.me"
                android:pathPrefix="/product"
                android:scheme="https" />
        </intent-filter>
        </activity>

```

```
https://trackier.u9ilnk.me/product?dlv=FirstProduct&quantity=10&pid=sms
```

### Deferred Deep linking

Deferred deep linking happened, when a user does not have your app installed on their device. When the user clicks a trackier URL, the URL will redirect them to the Play Store to download and install your app. When the user opens the app for the first time, the SDK will read the deep_link content.

The Trackier SDK opens the deferred deep link by default. just need to add some code in application class just after initilazation of Trackier SDk

Below are the example of the code :-

```dart

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    TrackerSDKConfig trackerSDKConfig = new TrackerSDKConfig(
        "0455721b-xxxx-xxxx-xxxx-596d818d910a", "development");

    //Getting deeplink data from the below method
    trackerSDKConfig.deferredDeeplinkCallback = (uri){
      print('The value of deeplinkUrl is: $uri');
    };
    Trackierfluttersdk.initializeSDK(trackerSDKConfig);
  }

```
### <a id="qs-dynamic-deeplinks"></a> Dynamic Deeplinks
We have added support for creating dynamic deep links using Flutter on both Android and iOS platforms.
To generate a dynamic deep link, you need to call the following Dart function from your code:

```dart
Trackierfluttersdk.createDynamicLink(
  templateId: 'wy23Px',
  link: 'https://trackier58.u9ilnk.me',
  domainUriPrefix: 'trackier58.u9ilnk.me',
  deepLinkValue: 'CakeActivity',
  androidRedirect: 'https://play.google.com/store/apps/details?id=com.trackier.vistmarket',
  sdkParameters: {
    'product_id': 'chocochip',
    'quantity': '2',
  },
  attributionParameters: {
    'channel': 'my_channel',
    'media_source': 'at_invite',
    'campaign': 'sanu',
  },
  iosRedirect: 'https://www.example.com/ios',
  desktopRedirect: 'https://trackier.com',
  socialMeta: {
    'title': 'Your Title',
    'description': 'Your Description',
    'imageLink': 'https://www.example.com/image.jpg',
  },
).then((url) {
  // Success callback
  print('Deep Link URL: $url');
}).catchError((err) {
  // Error callback
  print('Failed to create link: $err');
});

```

### <a id="gs-campaign-data"></a> Getting Campaign Data
For getting the campaign data, We have a function that return the campaign data. Please check below the example code.

```dart
_gettingCampaigData() {
    TrackierEvent trackierEvent = new TrackierEvent("1CFfUn3xEY");
    var ad = await Trackierfluttersdk.getAd();
    var getAdID = await Trackierfluttersdk.getAdID();
    var getCampaign = await Trackierfluttersdk.getCampaign();
    var getCampaignID = await Trackierfluttersdk.getCampaignID();
    var getAdSet = await Trackierfluttersdk.getAdSet();
    var getAdSetID = await Trackierfluttersdk.getAdSetID();
    var getP1 = await Trackierfluttersdk.getP1();
    var getP2 = await Trackierfluttersdk.getP2();
    var getP3 = await Trackierfluttersdk.getP3();
    var getP4 = await Trackierfluttersdk.getP4();
    var getP5 = await Trackierfluttersdk.getP5();
    var getClickId = await Trackierfluttersdk.getClickId();
    var getDlv = await Trackierfluttersdk.getDlv();
    var getPid = await Trackierfluttersdk.getPid();
    var getIsRetargeting = await Trackierfluttersdk.getIsRetargeting();
    Trackierfluttersdk.trackerEvent(trackierEvent);
  }

```

### <a id="qs-progaurd-trackier-sdk"></a> Proguard Settings

If your app is using proguard then add these lines to the proguard config file

```
  -keep class com.trackier.sdk.** { *; }
  -keep class com.google.android.gms.common.ConnectionResult {
      int SUCCESS;
  }
  -keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
      com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
  }
  -keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
      java.lang.String getId();
      boolean isLimitAdTrackingEnabled();
  }
  -keep public class com.android.installreferrer.** { *; }
```
