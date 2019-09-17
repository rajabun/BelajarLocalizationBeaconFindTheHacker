//
//  ViewController.swift
//  BelajarLocalizationBeaconFindTheHacker
//
//  Created by Muhammad Rajab Priharsanto on 17/09/19.
//  Copyright © 2019 Muhammad Rajab Priharsanto. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    //bikin objek untuk location manager
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //setPermission()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways
        {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)
            {
                if CLLocationManager.isRangingAvailable()
                {
                    // do stuff
                    startScanning()
                }
            }
        }
    }
    func startScanning()
    {
        let uuid = UUID(uuidString: "CB10023F-A318-3394-4199-A8730C7C1AEC")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 222, minor: 155, identifier: "Hacker")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity)
    {
        UIView.animate(withDuration: 0.8)
        {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
            
            @unknown default:
                self.view.backgroundColor = .black
                self.distanceReading.text = "WHOA!"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
    {
        if let beacon = beacons.first
        {
            update(distance: beacon.proximity)
        }
        else
        {
            update(distance: .unknown)
        }
    }

}
