//
//  PRVRootTabBarController.swift
//  PRIVY
//
//  Created by Michael MacCallum on 1/17/16.
//  Copyright © 2016 Michael MacCallum. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if animated {
            registerPushNotifications()
        }
    }

    private func registerPushNotifications() {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Alert, .Badge, .Sound],
            categories: nil
        )

        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
