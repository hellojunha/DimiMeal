//
//  ViewController.h
//  DimiMeal
//
//  Created by Alfred Woo on 4/5/16.
//  Copyright © 2016 Alfred Woo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController : UIViewController <WCSessionDelegate>

@property IBOutlet UILabel *label;

@end

