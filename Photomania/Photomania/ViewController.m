//
//  ViewController.m
//  Photomania
//
//  Created by admin on 24/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "ViewController.h"
#import "FlickrFetcher.h"
@import UIKit;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FlickrFetcher *fetcher = [[FlickrFetcher alloc] init];
    [FlickrFetcher URLforTopPlaces];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
