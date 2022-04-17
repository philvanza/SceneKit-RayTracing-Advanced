//
//  RTViewController.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import UIKit
import MetalKit
import AVFoundation
import SceneKit

// Our RayTracing View Controller
class GameViewController: UIViewController {

    // MARK: Renderer & Metal View
    var renderer: Renderer!
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
    var switchColorObject                   = UISwitch()
    var labelColorObject                    = UILabel()
    
    var switchColorBox                      = UISwitch()
    var labelColorBox                       = UILabel()
    
    var switchDiffuse                       = UISwitch()
    var labelDiffuse                        = UILabel()
    
    var switchDiffuseBox                    = UISwitch()
    var labelDiffuseBox                     = UILabel()
    
    var switchVisibleLight                  = UISwitch()
    var labelVisibleLight                   = UILabel()
    
    var switchMaskLight                     = UISwitch()
    var labelMaskLight                      = UILabel()
    
    var switchBlackBox                      = UISwitch()
    var labelBlackBox                       = UILabel()
    
    
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
    
    var sliderScaleObject                   = UISlider()
    var labelScaleObject                    = UILabel()
    
    var sliderRayBounces                    = UISlider()
    var labelRayBounces                     = UILabel()
    
    var sliderShadowSharpness               = UISlider()
    var labelShadowSharpness                = UILabel()
    
    // MARK: Counter Labels
    var labelSeconds                        = UILabel()
    var labelFrameRate                      = UILabel()
    var labelTotalFrames                    = UILabel()
    var labelRaysPerSecond                  = UILabel()
    var labelSecondaryRaysPerSecond         = UILabel()
    var labelNumberTriangles                = UILabel()
    
    // MARK: Progress View
    var progressRayTracer                   = UIProgressView()
    var labelProgress                       = UILabel()
    
    // MARK: Segmented Control
    var segmentedControl                    = UISegmentedControl()
    var labelSegmented                      = UILabel()
    
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
    var scheduleTimer                       : DispatchWorkItem! // schedules a timer that can be canceled
    var mainInitializer                     : DispatchWorkItem! // initializes the func: initializeRayTracer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Gesture Handlers
        // for Settings Mode in RayTracer
        // tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // tapGesture.numberOfTapsRequired = 1
        // view.addGestureRecognizer(tapGesture)
        //
        // doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        // doubleTapGesture.numberOfTapsRequired = 2
        // view.addGestureRecognizer(doubleTapGesture)
        //
        // tapGesture.require(toFail: doubleTapGesture) // very important to difference between the two tap gesture recognizers
        
        // for Camera Distance
        // pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        // view.addGestureRecognizer(pinchGesture)
        
        // for Camera Distance
        // panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        // view.addGestureRecognizer(panGesture)
        
        // MARK: Create UI Elements
        createUIElements()
        
        // MARK: Init Dispatch Queue Work Items
        self.scheduleTimer   = dispatchWorkItemScheduleTimer()
        self.infoRayTrace    = dispatchWorkItemInfoRayTrace()
        self.mainInitializer = DispatchWorkItem { self.initializeRayTracer() }
        
        // MARK: Start Ray Tracer
        self.initializeRayTracer()
        
        
        
        // MARK: Initial Message
        //DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
        //    GameViewController.displayLabelInfo(text: "TAP FOR OPTIONS")
        //}
        
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
