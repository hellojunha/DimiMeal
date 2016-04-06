//
//  InterfaceController.m
//  DimiMeal WatchKit Extension
//
//  Created by Alfred Woo on 4/5/16.
//  Copyright © 2016 Alfred Woo. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end

@implementation InterfaceController


-(instancetype)init {
    self = [super init];
    
    if (self) {
        if ([WCSession isSupported]) {
            self.watch_session = [WCSession defaultSession];
            self.watch_session.delegate = self;
            [self.watch_session activateSession];
        }
    }
    return self;
}


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self refresh];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)onRefreshClicked {
    [self refresh];
}

- (void)refresh {
    [self setTitle:@""];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:now];
    NSInteger hour = [components hour];
    
    NSString *load = [[NSString alloc] init];

    if(0 <= hour && hour <= 8) {
        // breakfast
        load = @"breakfast";
        [self.meal_label setText:@"아침 메뉴를 로드하는 중.."];
    } else if (hour <= 13) {
        // lunch
        load = @"lunch";
        [self.meal_label setText:@"점심 메뉴를 로드하는 중.."];
    } else if (hour <= 19) {
        // dinner
        load = @"dinner";
        [self.meal_label setText:@"저녁 메뉴를 로드하는 중.."];
    } else {
        [self.meal_label setText:@"For Tomorrow"];
        return;
    }
        
    NSDictionary *dict = @{@"load":load};
    
    [self.watch_session sendMessage:dict
                       replyHandler:^(NSDictionary *replyMessage) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self setTitle:[replyMessage objectForKey:@"date"]];
                               [self.meal_label setText:[replyMessage objectForKey:@"menu"]];
                           });
                       } errorHandler:^(NSError *error) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.meal_label setText:@"Error (4)"];
                           });
                       }];
}

@end



