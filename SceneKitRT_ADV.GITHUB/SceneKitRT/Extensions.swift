//
//  Extensions.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import SceneKit

extension SCNVector4 { func xyz() -> simd_float3 { return simd_float3(x:self.x, y:self.y, z:self.z) } }

// For loading Geometries from Files
extension SCNNode {
    convenience init(named name: String) {
        self.init()
        guard let scene = SCNScene(named: name) else {return}
        for childNode in scene.rootNode.childNodes {addChildNode(childNode)}
    }
}


extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 1.0
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func pulseDownUp() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 1.0
        pulse.toValue = 0.8
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
//    func pulseUp() {
//        let pulse = CASpringAnimation(keyPath: "transform.scale")
//        pulse.duration = 0.1
//        pulse.fromValue = 0.9
//        pulse.toValue = 1.0
//        pulse.autoreverses = false
//        pulse.repeatCount = 0
//        pulse.initialVelocity = 0.5
//        pulse.damping = 1.0
//
//        layer.add(pulse, forKey: nil)
//    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension UIColor
{
    var redValue:   Float{ return Float(CIColor(color: self).red)   }
    var greenValue: Float{ return Float(CIColor(color: self).green) }
    var blueValue:  Float{ return Float(CIColor(color: self).blue)  }
    var alphaValue: Float{ return Float(CIColor(color: self).alpha) }
}
