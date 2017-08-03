//
//  Utilities.swift
//  Toast
//
//  Created by smallHappy on 2017/4/6.
//  Copyright © 2017年 SmallHappy. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    private static let instance = Utilities()
    static var sharedInstance: Utilities {
        return self.instance
    }
    
    // toast
    var timer: Timer?
    var target: UIViewController?
    
    // UIDevice
    static let device = Device()
}

extension Utilities {
    
    func showAlertView(title: String? = nil, message: String? = nil, target: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "確認", style: .default, handler: handler)
        alert.addAction(confirmButton)
        DispatchQueue.main.async { target.present(alert, animated: true, completion: nil) }
    }
    
    func showAlertView(title: String? = nil, message: String? = nil, target: UIViewController, cancelHandler: ((UIAlertAction) -> Void)? = nil, confirmHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "取消", style: .default, handler: cancelHandler)
        alert.addAction(cancelButton)
        let confirmButton = UIAlertAction(title: "確認", style: .default, handler: confirmHandler)
        alert.addAction(confirmButton)
        DispatchQueue.main.async { target.present(alert, animated: true, completion: nil) }
    }
    
}

extension Utilities {
    
    enum ToastLength: Double {
        case long = 3.5, short = 2.0
    }
    
    enum ToastStyle {
        case label, view
    }
    
    func toast(taget: UIViewController, style: ToastStyle = .view, message: String, length: ToastLength = .short) {
        let frameW = taget.view.frame.width
        let frameH = taget.view.frame.height
        let gap: CGFloat = 10
        let labelH: CGFloat = 21
        switch style {
        case .label:
            let label = UILabel(frame: CGRect(x: 0, y: frameH - labelH - gap, width: frameW, height: labelH))
            label.text = message
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.transform = CGAffineTransform(translationX: 0, y: labelH + gap)
            taget.view.addSubview(label)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                label.transform = CGAffineTransform.identity
            }, completion: { (isFinish) in
                UIView.animate(withDuration: length.rawValue, animations: {
                    label.alpha = 0.0
                }, completion: { (isFinish) in
                    label.removeFromSuperview()
                })
            })
        case .view:
            let viewH: CGFloat = labelH + gap * 2
            let _view = UIView(frame: CGRect(x: gap, y: frameH - viewH - gap, width: frameW - gap * 2, height: viewH))
            _view.backgroundColor = UIColor.black
            _view.alpha = 0.85
            _view.transform = CGAffineTransform(translationX: 0, y: viewH + gap)
            _view.layer.cornerRadius = 8.0
            taget.view.addSubview(_view)
            let label = UILabel(frame: CGRect(x: gap * 2, y: frameH - labelH - gap * 2, width: frameW - gap * 4, height: labelH))
            label.text = message
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.transform = CGAffineTransform(translationX: 0, y: labelH + gap * 2)
            taget.view.addSubview(label)
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { 
                _view.transform = CGAffineTransform.identity
                label.transform = CGAffineTransform.identity
            }, completion: { (isFinish) in
                UIView.animate(withDuration: length.rawValue, animations: {
                    _view.alpha = 0.0
                    label.alpha = 0.0
                }, completion: { (isFinish) in
                    _view.removeFromSuperview()
                    label.removeFromSuperview()
                })
            })
        }
    }
    
}

extension Utilities {
    
    func showSnow(target: UIViewController) {
        self.target = target
        self.timer = Timer.scheduledTimer(timeInterval: 1.75, target: self, selector: #selector(self.onTimerTick), userInfo: nil, repeats: true)
    }
    
    func stopSnow() {
        self.target = nil
        self.timer?.invalidate()
    }
    
    func onTimerTick() {
        if self.target == nil { return }
        let frameW = self.target!.view.frame.width
        let frameH = self.target!.view.frame.height
        let flakeStartX = CGFloat(Int(arc4random()) % Int(frameW)) // 0.0~frameW
        let flakeEndX = CGFloat(Int(arc4random()) % Int(frameH)) // 0.0~frameW
        var flakeS = CGFloat(Int(arc4random()) % 100) / 100.0 // 0.0~1.0
        flakeS += 0.5 // 0.5~1.5
        flakeS *= 25.0 // 12.5~27.5
        
        let flakeImageView = UIImageView(image: UIImage(named: "flake"))
        flakeImageView.frame = CGRect(x: flakeStartX, y: -50.0, width: flakeS, height: flakeS)
        flakeImageView.alpha = 0.4
        self.target!.view.addSubview(flakeImageView)
        
        var speed = Double(Int(arc4random()) % 100) / 100.0 // 0.0~1.0
        speed += 1.0 // 1.0~2.0
        speed *= 15.0 // 5.0~10.0
        
        UIView.animate(withDuration: speed, animations: {
            UIView.setAnimationCurve(.easeOut)
            flakeImageView.frame.origin = CGPoint(x: flakeEndX, y: frameH - 20)
        }) { (isFinish) in
            UIView.animate(withDuration: 2.5, animations: {
                flakeImageView.alpha = 0.0
            }, completion: { (isFinish) in
                flakeImageView.removeFromSuperview()
            })
        }
    }
    
}

extension Utilities {
    
    class Device {
        
        var uuid: String {
            // device + app => Unique Device Identifier(設備唯一標識符)
            return UIDevice.current.identifierForVendor!.uuidString
        }
        
        var systemName: String {
            // 作業系統名稱
            return UIDevice.current.systemName
        }
        
        var systemVersion: String {
            // 作業系統版本
            return UIDevice.current.systemVersion
        }
        
        var name: String {
            // 例如：某某某的iphone
            return UIDevice.current.name
        }
        
        var model: String {
            // 型號
            return UIDevice.current.model
        }
        
        var localizedModel: String {
            return UIDevice.current.localizedModel
        }
        
        var orientation: String {
            switch UIDevice.current.orientation {
            case .faceUp:
                return "faceUp"
            case .faceDown:
                return "faceDown"
            case .landscapeLeft:
                return "landscapeLeft"
            case .landscapeRight:
                return "landscapeRight"
            case .portrait:
                return "portrait"
            case .portraitUpsideDown:
                return "portraitUpsideDown"
            case .unknown:
                return "unknown"
            }
        }
        
        var userInterfaceIdiom: String {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return "phone"
            case .pad:
                return "pad"
            case .tv:
                return "tv"
            case .carPlay:
                return "carPlay"
            case .unspecified:
                return "unspecified"
            }
        }
        
        var batteryState: String {
            UIDevice.current.isBatteryMonitoringEnabled = true
            if !UIDevice.current.isBatteryMonitoringEnabled {
                return "Battery monitoring is not Enabled."
            }
            switch UIDevice.current.batteryState {
            case .unknown:
                return "unknown"
            case .unplugged:
                return "unplugged"
            case .charging:
                return "charging"
            case .full:
                return "full"
            }
        }
        
        var batteryLevel: Float {
            UIDevice.current.isBatteryMonitoringEnabled = true
            return UIDevice.current.batteryLevel
        }
        
        var proximityState: Bool? {
            if !UIDevice.current.isProximityMonitoringEnabled {
                return nil
            }
            return UIDevice.current.proximityState
        }
        
        var multitaskingSupported: Bool {
            return UIDevice.current.isMultitaskingSupported
        }
        
    }
    
}
