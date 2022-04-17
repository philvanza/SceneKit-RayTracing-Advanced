//
//  BetaRTViewController.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import UIKit
import MetalKit
import AVFoundation


var boxRoughness                        : Float = 1.000
var objectRoughness                     : Float = 0.005

var objectHUEValueRT                    : CGFloat = 0.0
var objectSaturationValueRT             : CGFloat = 0.0
var objectColorRT                       = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0) // white, default

var isLightTop                          : Bool  = true
var isLightBottom                       : Bool  = false
var isLightLeft                         : Bool  = false
var isLightRight                        : Bool  = false
var isLightBack                         : Bool  = false

var globalMaterialBox                   : Int   = 0 // 0 = Plastic, 1 = Metallic (Conductor)
var globalMaterialObject                  : Int   = 2 // 0 = Plastic, 1 = Metallic (Conductor), 2 = Transparent (Dielectric)

var isLightSamplingEnabled              : Bool  = true
var isBSDFSamplingEnabled               : Bool  = true // Bidirectional Scattering Distrubution Function

var isMonochromeBox                     : Bool  = false
var isRussianRoulette                   : Bool  = false


// Our iOS specific view controller
class AdvancedGameViewController: UIViewController {

    // MARK: Renderer & Metal View
    var renderer: AdvancedRenderer!
    var mtkView: MTKView!
    
    // MARK: Timering for Statistics
    var elapsedTimer                        = Timer()
    static var secondsCounter               : uint = 0
    
    // MARK: The Main Settings UIView
    var settingsView                        = UIView()
    
    // MARK: Buttons
    var closeButton                         = UIButton()
    var uiImageClose                        = UIImage(named: "ButtonCloseRed.png")
    
    var settingsButton                      = UIButton()
    var uiImageSettings                     = UIImage(named: "ButtonSettingsRed.png")
    
    // MARK: Switches
    var switchLightTop                      = UISwitch()
    var labelLightTop                       = UILabel()
     
    var switchLightBottom                   = UISwitch()
    var labelLightBottom                    = UILabel()
     
    var switchLightLeft                     = UISwitch()
    var labelLightLeft                      = UILabel()
     
    var switchLightRight                    = UISwitch()
    var labelLightRight                     = UILabel()
     
    var switchLightBack                     = UISwitch()
    var labelLightBack                      = UILabel()
     
    var switchLightSampling                 = UISwitch()
    var labelLightSampling                  = UILabel()
    
    var switchBSDFSampling                  = UISwitch()
    var labelBSDFSampling                   = UILabel()
    
    var switchMonochromeBox                 = UISwitch()
    var labelMonochromeBox                  = UILabel()
    
    var switchRussianRoulette               = UISwitch()
    var labelRussianRoulette                = UILabel()
    
    
    // MARK: Sliders
    var sliderRotateX                       = UISlider()
    var labelRotateX                        = UILabel()
    
    var sliderRotateY                       = UISlider()
    var labelRotateY                        = UILabel()
    
    var sliderRotateZ                       = UISlider()
    var labelRotateZ                        = UILabel()
    
    var sliderShiftX                        = UISlider()
    var labelShiftX                         = UILabel()
        
    var sliderShiftY                        = UISlider()
    var labelShiftY                         = UILabel()
        
    var sliderShiftZ                        = UISlider()
    var labelShiftZ                         = UILabel()
    
    var sliderScaleObject                     = UISlider()
    var labelScaleObject                      = UILabel()
    
    var sliderBoxRoughness                  = UISlider()
    var labelBoxRoughness                   = UILabel()
    
    var sliderObjectRoughness                 = UISlider()
    var labelObjectRoughness                  = UILabel()
    
    var sliderShadowSharpness               = UISlider()
    var labelShadowSharpness                = UILabel()
    
    var sliderObjectColor                     = UISlider()
    var labelObjectColor                      = UILabel()
    
    var sliderObjectSaturation                = UISlider()
    var labelObjectSaturation                 = UILabel()
    
    // MARK: Counter Labels
    var labelSeconds                        = UILabel()
    var labelFrameRate                      = UILabel()
    var labelTotalFrames                    = UILabel()
    var labelRaysPerSecond                  = UILabel()
    var labelNumberTriangles                = UILabel()
    
    // MARK: Progress View
    var progressRayTracer                   = UIProgressView()
    var labelProgress                       = UILabel()
    
    // MARK: Segmented Control
    var segmentedControlBox                 = UISegmentedControl()
    var labelSegmentedBox                   = UILabel()
    
    var segmentedControlObject                = UISegmentedControl()
    var labelSegmentedObject                  = UILabel()
    
    // MARK: Audio Player
    var audioPlayer = AVAudioPlayer()
    
    // MARK: THE INFO DISPLAY LABEL
    static var trackingLabel                = UILabel()
    
    // MARK: Main Interface Colorization / Main UI Font Name
    static let mainColorization             = UIColor.red
    let mainUIFontName:String               = "Helvetica-Bold" // Build in Font
    
    // MARK: For Status Control
    var isInSettingsMode                    : Bool = false
    static var isRenderingProgressCompleted : Bool = false
    
//    // MARK: Gesture Recognizers
//    var tapGesture                          = UITapGestureRecognizer()
//    var doubleTapGesture                    = UITapGestureRecognizer()
//    var panGesture                          = UIPanGestureRecognizer()
//    var pinchGesture                        = UIPinchGestureRecognizer()
    
    // DispatchQueue Work Items
    var infoRayTrace                        : DispatchWorkItem! // displays info message that can be canceled
    var infoBetaRayTrace                    : DispatchWorkItem! // displays info message about Beta RayTracer that can be canceled
    var scheduleTimer                       : DispatchWorkItem! // schedules a timer that can be canceled
    var mainInitializer                     : DispatchWorkItem! // initializes the func: initializeRayTracer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Gesture Handlers
//        // for Settings Mode in RayTracer
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tapGesture)
//        
//        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
//        doubleTapGesture.numberOfTapsRequired = 2
//        view.addGestureRecognizer(doubleTapGesture)
//        
//        tapGesture.require(toFail: doubleTapGesture) // very important to difference between the two tap gesture recognizers
//        
//        // for Camera Distance
//        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        view.addGestureRecognizer(pinchGesture)
//        
//        // for Camera Distance
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        view.addGestureRecognizer(panGesture)
//        
        // MARK: Create UI Elements
        createUIElements()
        
        // MARK: Init Dispatch Queue Work Items
        self.scheduleTimer       = dispatchWorkItemScheduleTimer()
        self.infoRayTrace        = dispatchWorkItemInfoRayTrace()
        self.infoBetaRayTrace    = dispatchWorkItemInfoBetaRayTrace()
        self.mainInitializer     = DispatchWorkItem { self.initializeRayTracer() }
        
        // MARK: Start Ray Tracer
        initializeRayTracer()
        
//        // MARK: Initial Message
//        DispatchQueue.main.asyncAfter(deadline: .now() + 8.1) {
//            AdvancedGameViewController.displayLabelInfo(text: "TAP FOR OPTIONS")
//        }
        
        // MARK: - END OF VIEW DID LOAD
    }
    
//    deinit {
//        print("deinit called")
//        self.renderer = nil
//        self.mtkView = nil
//    }
    
    // MARK: - Default Overrides
    override var  shouldAutorotate: Bool                                        { return true       }
    override var  prefersStatusBarHidden: Bool                                  { return true       }
    override var  prefersHomeIndicatorAutoHidden: Bool                          { return true       }
    override var  supportedInterfaceOrientations: UIInterfaceOrientationMask    { return .all }
    override func didReceiveMemoryWarning()                                     { print("Memory Warning!!!") }
    
}
