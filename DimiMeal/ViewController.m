//
//  ViewController.m
//  DimiMeal
//
//  Created by Alfred Woo on 4/5/16.
//  Copyright © 2016 Alfred Woo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([WCSession isSupported]){
        WCSession *transferSession = [WCSession defaultSession];
        transferSession.delegate = self;
        [transferSession activateSession];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    
    NSString *load = [message objectForKey:@"load"];
    __block NSString *localized_load = [[NSString alloc] init];
    
    if([load isEqualToString:@"breakfast"]) {
        localized_load = @"아침";
    } else if([load isEqualToString:@"lunch"]) {
        localized_load = @"점심";
    } else if([load isEqualToString:@"dinner"]) {
        localized_load = @"저녁";
    } else {
        replyHandler(@{@"reply":@"Error (1)"});
        return;
    }
    
    NSURL *url = [NSURL URLWithString:@"http://dimigo.in/pages/dimibob_getdata.php"];
    NSURLSession *fetch_session = [NSURLSession sharedSession];
    [[fetch_session dataTaskWithURL:url
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      if(error) {
                          replyHandler(@{@"menu":@"Error (2)"});
                          return;
                      }
                      
                      error = nil;
                      
                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                      
                      if(error) {
                          replyHandler(@{@"menu":@"Error (3)"});
                          return;
                      }
                      
                      NSString *date = [json valueForKey:@"date"];
                      date = [NSString stringWithFormat:@"%@ %@", [date substringFromIndex:5], localized_load];
                      date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                      NSString *meal_menu = [json valueForKey:load];
                      meal_menu = [meal_menu stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
                      
                      NSMutableDictionary *reply = [[NSMutableDictionary alloc] init];
                      [reply setValue:date forKey:@"date"];
                      [reply setValue:meal_menu forKey:@"menu"];
                      replyHandler(reply);
                  }] resume];
}

@end
