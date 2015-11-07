//
//  ViewController.swift
//  Tracks
//
//  Created by admin on 02/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate {
    
    
    private struct Constants {
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let LeftCalloutFrame = CGRect(origin: CGPointZero, size: CGSizeMake(50, 50))
        static let ShowImageSegue = "Show Image"
    }

    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }
    
    var gpxURL: NSURL? {
        didSet{
            clearWaypoints()
            if let url = gpxURL{
                GPX.parse(url){
                    if let gpx = $0 {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }
    
    private func clearWaypoints(){
        if mapView?.annotations != nil {mapView.removeAnnotations(mapView.annotations as [MKAnnotation])}
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) {
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue){ note in
                if let url = note.userInfo?[GPXURL.Key]{
                //
                }
            }
        
        gpxURL = NSURL(string: "http://cs193p.stanford.edu/Vacation.gpx")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view: MKAnnotationView! = nil
        view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        view.leftCalloutAccessoryView = nil
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIImageView(frame: Constants.LeftCalloutFrame)
            }
            if waypoint.imageURL != nil {
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
            }
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
            performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let waypoint = view.annotation as? GPX.Waypoint {
            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIImageView {
                if let imageData = NSData(contentsOfURL: waypoint.thumbnailURL!){
                    if let image = UIImage(data: imageData){
                        thumbnailImageView.image = image
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch(identifier){
                case Constants.ShowImageSegue:
                    if let dvc = segue.destinationViewController as? ImageViewController {
                        if let waypoint  = (sender as? MKAnnotationView)?.annotation as? GPX.Waypoint{
                            dvc.imageURL = waypoint.imageURL
                        }
                    }
            default: break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

