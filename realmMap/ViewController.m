//
//  ViewController.m
//  realmMap
//
//  Created by Joseph Anderson on 7/30/15.
//  Copyright (c) 2015 Realm. All rights reserved.
//

#import "ViewController.h"
#import <ABFRealmMapView/ABFRealmMapView.h>
#import <RealmSFRestaurantData/SFRestaurantScores.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet ABFRealmMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.mapView.realmPath = ABFRestaurantScoresPath();
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
