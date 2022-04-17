//
//  ViewController.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import UIKit
import SceneKit

var myScene                                 : SCNScene!
var globalObjectColor                       : SIMD3<Float>!
var lightColor                              = UIColor()

var vv:[SCNVector3]                         = []
var nn:[SCNVector3]                         = []
var tt:[SIMD2<Float>]                       = []
var ii:[UInt32]                             = []

class ViewController: UIViewController, SCNSceneRendererDelegate {
    
    // MARK:  Outlets
    @IBOutlet weak var sceneView            : SCNView!
    @IBOutlet weak var blurView             : UIVisualEffectView!
    
    // MARK: Main Scenekit Node
    var objectNode                          : SCNNode!
    
    // MARK: Control
    var currentGeometry                     : Int  = 14 // SceneKit RT
    var isReflective                        : Bool = true
    
    // MARK: Main Interface Colorization / Main UI Font Name
    static let mainColorization             = UIColor.red
    let mainUIFontName:String               = "Helvetica-Bold" // Build in Font
    
    // MARK: Lights
    let lightNode                           = SCNNode()
    let ambientLightNode                    = SCNNode()
    
    // MARK: UI Elements
    var rayTraceButton                      = UIButton()
    var uiImageRayTrace                     = UIImage(named: "ButtonRaysRed.png")
    
    var rayBetaTraceButton                  = UIButton()
    var uiImageBetaRayTrace                 = UIImage(named: "ButtonBetaRaysRed.png")
    
    var sliderLightColor                    = UISlider()
    var labelLightColor                     = UILabel()
    
    var switchLightColor                    = UISwitch()
    var labelLightColor2                    = UILabel()
    
    var sliderColor                         = UISlider()
    var labelColor                          = UILabel()
    
    var switchDiffuse                       = UISwitch()
    var labelDiffuse                        = UILabel()
    
    var geometryPickerView: UIPickerView    = UIPickerView()
    var geometryData                        : [String] = []
    var labelGeometryPicker                 = UILabel()
    
    // MARK: Main View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Setup the sceneView and delegates
        sceneView.delegate                      = self
        sceneView.antialiasingMode              = .none
        sceneView.isJitteringEnabled            = false
        sceneView.autoenablesDefaultLighting    = false
        sceneView.allowsCameraControl           = true
        sceneView.backgroundColor               = UIColor.black
        
        // MARK: Create and configure the scene to the sceneView
        myScene                                 = SCNScene()
        sceneView.scene                         = myScene
        sceneView.scene?.rootNode.castsShadow   = true
        
        myScene.lightingEnvironment.contents    = UIColor.black
        myScene.background.contents             = UIColor.black
        myScene.wantsScreenSpaceReflection      = true
        
        // MARK: create and add a camera to the scene
        let cameraNode                          = SCNNode()
        cameraNode.camera                       = SCNCamera()
        cameraNode.position                     = SCNVector3(0.0, 0.0, 5.0)
        myScene.rootNode.addChildNode(cameraNode)
        
        // MARK: create and add a light to the scene
        
        lightNode.light                         = SCNLight()
        lightNode.light!.type                   = .directional
        lightNode.light?.color                  = UIColor.white
        lightNode.light?.intensity              = 1000
        lightNode.position                      = SCNVector3(5.0, 5.0, 5.0)
        lightNode.look(at:                      SCNVector3(0.0, 0.0, 0.0))
        myScene.rootNode.addChildNode(lightNode)
        
        // MARK: create and add an ambient light to the scene
        
        ambientLightNode.light                  = SCNLight()
        ambientLightNode.light?.type            = .ambient
        ambientLightNode.light?.color           = UIColor.white
        ambientLightNode.light?.intensity       = 100
        myScene.rootNode.addChildNode(ambientLightNode)
        
        // MARK: Set Global Object Color
        globalObjectColor = simd_float3(1.0, 0.0, 0.0)
        
        // MARK: Add some Content
        objectNode = SCNNode()
        myScene.rootNode.addChildNode(objectNode)
        self.placeContent()
        
        // lightColor = UIColor(hue: lightHUEValue, saturation: lightSaturationValue, brightness: lightBrightnessValue, alpha: 1.0) // initial, white
        lightColor = UIColor.white
        
        // MARK: Create UI Elements
        self.createUIElements()
    }
    
    
    func placeContent() {
        
        var uIntDecision32 : Bool!
        
        // MARK: Purge Arrays
        vv.removeAll()
        nn.removeAll()
        tt.removeAll()
        ii.removeAll()
        
        // MARK: Set Geometry Primitives
        var obj : SCNGeometry!
        switch currentGeometry {
            
        case 0:  obj = SCNSphere(radius: 1.0);                                              uIntDecision32 = false
        case 1:  obj = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0);    uIntDecision32 = false
        case 2:  obj = SCNTorus(ringRadius: 1.0, pipeRadius: 0.25);                         uIntDecision32 = false
        case 3:  obj = SCNCylinder(radius: 1.0, height: 2.0);                               uIntDecision32 = false
        case 4:  obj = SCNPyramid(width: 2.0, height: 2.0, length: 2.0);                    uIntDecision32 = false
            
        case 5:  obj = getIcoSphere();                                                      uIntDecision32 = true
        case 6:  obj = getSpikyBall();                                                      uIntDecision32 = true
        case 7:  obj = getStrangeObject();                                                  uIntDecision32 = true
        case 8:  obj = getVirus();                                                          uIntDecision32 = true
        case 9:  obj = getExplosion();                                                      uIntDecision32 = true
        case 10: obj = getZombie();                                                         uIntDecision32 = true
        case 11: obj = getBrillant();                                                       uIntDecision32 = true
        case 12: obj = getMonkey();                                                         uIntDecision32 = true
        case 13: obj = getTeapot();                                                         uIntDecision32 = true
        case 14: obj = getSceneKitRT();                                                     uIntDecision32 = true
            
        default: return
        }
        
        // MARK: Node Handling
        obj.firstMaterial = sceneMaterial()
        objectNode.geometry = obj
        
        // MARK: Extract Geometry Data into Arrays
        if uIntDecision32 {
            extractNodeData32(objectNode,&vv,&nn,&tt,&ii)
        } else {
            extractNodeData16(objectNode,&vv,&nn,&tt,&ii)
        }
        
        // MARK: Print Debug Information
        // print("vertices --------------------")
        // for i in 0 ..< vv.count {
        //     print(i,":",vv[i])
        // }
        // print("normals --------------------")
        // for i in 0 ..< nn.count {
        //     print(i,":",nn[i])
        // }
        // print("texture --------------------")
        // for i in 0 ..< tt.count {
        //     print(i,":",tt[i])
        // }
        // print("indices --------------------")
        // for i in 0 ..< ii.count {
        //     print(i,":",ii[i])
        // }
        
    }
    
    func sceneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.name                       = "rock"
        material.diffuse.contents           = UIColor(red: CGFloat(globalObjectColor.x), green: CGFloat(globalObjectColor.y), blue: CGFloat(globalObjectColor.z), alpha: 1.0)
        material.metalness.contents         = 0.0
        
        if isReflective {
            material.roughness.contents     = 0.1
        } else {
            material.roughness.contents     = 0.9
        }
        
        material.lightingModel              = .physicallyBased
        material.isDoubleSided              = false
        return material
    }
    
    // MARK: Present Ray Tracing View Controller
    @objc func loadRayTracer() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RayTracer") as! GameViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle   = .coverVertical
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func loadAdvancedRayTracer() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedRayTracer") as! AdvancedGameViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle   = .coverVertical
        self.present(vc, animated: true, completion: nil)
            
    }
    
    // MARK: - Default Overrides
    override var  shouldAutorotate: Bool                                        { return true               }
    override var  prefersStatusBarHidden: Bool                                  { return true               }
    override var  prefersHomeIndicatorAutoHidden: Bool                          { return true               }
    override var  supportedInterfaceOrientations: UIInterfaceOrientationMask    { return .all               }
    override func didReceiveMemoryWarning()                                     { print("!Memory Warning!") }

}
