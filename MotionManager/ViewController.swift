//
//  ViewController.swift
//  MotionManager
//
//  Created by Xcode on 2017/5/5.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    let time = 0.1
    let motionManager = CMMotionManager()
    let pedoMeter = CMPedometer()
    var storyBoard = UIStoryboard()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageView = UIImageView(image: UIImage(named: "mouse"))
        self.imageView.frame = CGRect(x: 0, y: 0, width: 66, height: 30)
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.imageView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.initAccelerationObserver()
        //        self.initGyroObserver()
        //        self.initMagnetometerObserver()
//        self.initStepCountObsever()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initAccelerationObserver() {
        if !self.motionManager.isAccelerometerAvailable { return }
        self.motionManager.accelerometerUpdateInterval = self.time
        self.motionManager.startAccelerometerUpdates(to: .main) { (accelerometerData, error) in
            if error != nil {
                print("加速器錯誤：\(error!)")
            } else {
                guard let acceleration = accelerometerData?.acceleration else { return }
                print("x: \(acceleration.x), y: \(acceleration.y), z: \(acceleration.z)")
                
                let frameW = UIScreen.main.bounds.width
                let frameH = UIScreen.main.bounds.height
                self.x += CGFloat(acceleration.x * 5)
                if self.x < 0 {
                    self.x = 0
                }
                if self.x > frameW - self.imageView.frame.width {
                    self.x = frameW - self.imageView.frame.width
                }
                self.y -= CGFloat(acceleration.y * 5)
                if self.y < 0 {
                    self.y = 0
                }
                if self.y > frameH - self.imageView.frame.height {
                    self.y = frameH - self.imageView.frame.height
                }
                self.imageView.transform = CGAffineTransform(translationX: self.x, y: self.y)
            }
        }
    }
    
    private func initGyroObserver() {
        if !self.motionManager.isGyroAvailable { return }
        self.motionManager.gyroUpdateInterval = self.time
        self.motionManager.startGyroUpdates(to: .main) { (gyroData, error) in
            if error != nil {
                print("陀螺儀錯誤")
            } else {
                guard let rotationRate = gyroData?.rotationRate else { return }
                print("x: \(rotationRate.x), y: \(rotationRate.y), z: \(rotationRate.z)")
            }
        }
    }
    
    private func initMagnetometerObserver() {
        if !self.motionManager.isMagnetometerAvailable { return }
        self.motionManager.magnetometerUpdateInterval = self.time
        self.motionManager.startMagnetometerUpdates(to: .main) { (magnetometerData, error) in
            if error != nil {
                print("磁力計錯誤")
            } else {
                guard let magneticField = magnetometerData?.magneticField else { return }
                print("x: \(magneticField.x), y: \(magneticField.y), z: \(magneticField.z)")
            }
        }
    }
    
    private func initStepCountObsever() {
        if !CMPedometer.isStepCountingAvailable() { return }
        self.pedoMeter.startUpdates(from: Date()) { (pedometerData, error) in
            if error != nil {
                print("計步器錯誤")
            } else {
                guard let numberOfSteps = pedometerData?.numberOfSteps else { return }
                DispatchQueue.main.async {
                    Utilities.sharedInstance.toast(taget: self, message: "count: \(numberOfSteps.intValue)")
                }
            }
        }
    }
    
}

