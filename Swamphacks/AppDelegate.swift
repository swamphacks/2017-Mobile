//
//  AppDelegate.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/23/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
  var window: UIWindow?
  fileprivate(set) var app: App!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    FIRApp.configure()
    
    if UserDefaults.standard.object(forKey: "freshOpen") == nil {
      if let auth = FIRAuth.auth(), let user = auth.currentUser {
        user.purgeInfo()
        user.purgeQRCode()
        try? auth.signOut()
      }
      UserDefaults.standard.set("no", forKey: "freshOpen")
    }
    
    /*
    //Clear keychain on first run in case of reinstallation
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
      // Delete values from keychain here
      [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    */
    
    UNUserNotificationCenter.current().delegate = self
    FIRMessaging.messaging().remoteMessageDelegate = self
        
    connectToFCM()

    NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification(_:)),
                                           name: Notification.Name.firInstanceIDTokenRefresh,
                                           object: nil)
    setUpUI()
    
    app = App()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = app.root
    window!.makeKeyAndVisible()
    
    addStatusBarView()
    
    return true
  }
  
  //MARK: Notifications
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
  {
    FIRMessaging.messaging().appDidReceiveMessage(userInfo)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
  {
    FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .unknown)
  }
  
  func tokenRefreshNotification(_ notification: NSNotification)
  {
    if let refreshedToken = FIRInstanceID.instanceID().token()
    {
      print("InstanceID token: \(refreshedToken)")
    }
    connectToFCM()
  }
  
  func connectToFCM()
  {
    guard FIRInstanceID.instanceID().token() != nil else { return }
    
    print("InstanceID token: \(FIRInstanceID.instanceID().token())")
    
    FIRMessaging.messaging().connect { (error) in
      if (error != nil)
      {
        print("Unable to connect with FCM. \(error?.localizedDescription)")
      }
      else
      {
        print("Connected to FCM.")
      }
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication)
  {
    connectToFCM()
  }
  
  //MARK: FIRMessagingDelegate
  
  func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    print("RECEIVED MESSAGE: \(remoteMessage.appData)")
  }
  
  //MARK: Set Up
  
  fileprivate func setUpUI() {
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().barTintColor = .turquoise
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
  }
  
  fileprivate func addStatusBarView() {
    let statusBarView = UIView(frame: .zero)
    statusBarView.backgroundColor = .turquoise
    
    statusBarView.translatesAutoresizingMaskIntoConstraints = false
    window!.addSubview(statusBarView)
    
    let top = statusBarView.topAnchor.constraint(equalTo: window!.topAnchor)
    let left = statusBarView.leftAnchor.constraint(equalTo: window!.leftAnchor)
    let right = statusBarView.rightAnchor.constraint(equalTo: window!.rightAnchor)
    let height = statusBarView.heightAnchor.constraint(equalToConstant: 20)
    
    NSLayoutConstraint.activate([top, left, right, height])
  }
  
}

