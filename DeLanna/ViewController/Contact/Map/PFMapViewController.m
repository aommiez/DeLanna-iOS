//
//  PFMapViewController.m
//  DeLanna
//
//  Created by Pariwat on 7/15/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFMapViewController.h"

@interface PFMapViewController ()

@end

@implementation PFMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"PFMapViewController";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.canShowCallout = YES;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(getDistance) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
//    UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_lanna.png"]];
//    annotationView.leftCalloutAccessoryView = myCustomImage;
    
    annotationView.image = [UIImage imageNamed:@"arrest.png"];//add any image which you want to show on map instead of red pins
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Map";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Direction" style:UIBarButtonItemStyleDone target:self action:@selector(getDistance)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;

    CLLocationCoordinate2D location;
    location.latitude = 18.789622;
	location.longitude = 98.982788;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location;
    point.title = @"De Lanna Hotel";
    
    [self.mapView addAnnotation:point];
    [self.mapView setCenterCoordinate:location zoomLevel:13 animated:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)getDistance {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    CLLocationCoordinate2D location;
    
	location.latitude = 18.789622;
	location.longitude = 98.982788;
    [self.locationManager stopUpdatingLocation];
    [CMMapLauncher launchMapApp:CMMapAppAppleMaps
              forDirectionsFrom:[CMMapPoint mapPointWithName:@"Origin"
                                                  coordinate:newLocation.coordinate]
                             to:[CMMapPoint mapPointWithName:@"Destination"
                                                  coordinate:location]];
    return;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFMapViewControllerBack)]){
            [self.delegate PFMapViewControllerBack];
        }
    }
}

@end
