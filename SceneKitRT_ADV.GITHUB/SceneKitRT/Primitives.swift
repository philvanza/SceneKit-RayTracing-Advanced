//
//  Primitives.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import SceneKit

extension ViewController {
    
    func getIcoSphere() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/ico_sphere.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getZombie() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/zombie.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getSpikyBall() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/spiky_ball.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getStrangeObject() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/strange_object.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getVirus() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/virus.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getExplosion() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/explosion.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getBrillant() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/brillant.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getMonkey() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/monkey.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getTeapot() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/teapot.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
    func getSceneKitRT() -> SCNGeometry {
        
        let node     = SCNNode(named: "art.scnassets/SceneKit_RT.obj")
        let geometry : SCNGeometry = node.childNodes.first!.geometry!
            
        return geometry
    }
    
}
