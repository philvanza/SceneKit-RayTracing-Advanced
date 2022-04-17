//
//  UITransitions.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import UIKit

extension ViewController {
    
    // MARK: - Device Orientation Transition
    // Determine if device is in Portrait or Landscape Mode and set Variable
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in self.switchDeviceOrientation() }
    }

    func switchDeviceOrientation() {
        
        DispatchQueue.main.async {
            
            // Adjust Device Orientation
            switch UIDevice.current.orientation {
            case .landscapeLeft:        self.alignUIStuffLandscape()
            case .landscapeRight:       self.alignUIStuffLandscape()
            case .portrait:             self.alignUIStuffPortrait()
            case .portraitUpsideDown:   self.alignUIStuffPortrait()
                
            case .unknown:              self.alignUIStuffPortrait()
            case .faceUp:               self.alignUIStuffPortrait()
            case .faceDown:             self.alignUIStuffPortrait()
            @unknown default:
                fatalError()
            }
            
        }
        
    }
    
    func alignUIStuffPortrait() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            DispatchQueue.main.async {
                
                // Button
                self.rayTraceButton.frame               = CGRect(x: self.view.bounds.width * 0.5 - 125, y: self.view.bounds.height - 125, width: 100, height: 100)
                self.rayBetaTraceButton.frame           = CGRect(x: self.view.bounds.width * 0.5 +  25, y: self.view.bounds.height - 125, width: 100, height: 100)
                
                
                // Slider
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 35.0 // 50.0 // distance between sliders
                
                self.sliderColor.frame                  = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.sliderColor.center                 = CGPoint(x: self.view.bounds.width * 0.5, y: self.view.bounds.height - sliderIncrementer)
                self.labelColor.frame                   = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderLightColor.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.sliderLightColor.center            = CGPoint(x: self.view.bounds.width * 0.5, y: self.view.bounds.height - sliderIncrementer)
                self.labelLightColor.frame              = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10)
                // sliderIncrementer += sliderStepping // NO INCREMENTATION

                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 35.0 // distance between sliders
                
                self.switchDiffuse.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center                = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                  = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightColor.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightColor.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightColor2.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                // switchIncrementer += switchStepping
                
                
                // Picker
                self.geometryPickerView.frame             = CGRect(x: 25, y: 25, width: 200, height: 150)
                
                self.labelGeometryPicker.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelGeometryPicker.center           = CGPoint(x: 15, y: 100)
                
                
            }
            
        case .pad:
            
            DispatchQueue.main.async {
                
                // Button
                self.rayTraceButton.frame               = CGRect(x: self.view.bounds.width * 0.8 - 200, y: self.view.bounds.height - 125, width: 100, height: 100)
                self.rayBetaTraceButton.frame           = CGRect(x: self.view.bounds.width * 0.8 -  50, y: self.view.bounds.height - 125, width: 100, height: 100)
                
                
                // Slider
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 50.0 // 50.0 // distance between sliders
                
                self.sliderColor.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelColor.frame                   = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderLightColor.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelLightColor.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                // sliderIncrementer += sliderStepping // NO INCREMENTATION
   
                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 50.0 // distance between sliders
                
                self.switchDiffuse.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center                = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                  = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightColor.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightColor.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightColor2.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                // switchIncrementer += switchStepping
                
                
                // Picker
                self.geometryPickerView.frame             = CGRect(x: 25, y: 25, width: 200, height: 150)
                self.labelGeometryPicker.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelGeometryPicker.center           = CGPoint(x: 15, y: 100)
                
                
            }
            
        case .unspecified:  break
        case .tv:           break
        case .carPlay:      break
        case .mac:          break
        @unknown default:   break
        
        }
    }


    func alignUIStuffLandscape() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            DispatchQueue.main.async {
                
                // Button
                self.rayTraceButton.frame               = CGRect(x: self.view.bounds.width - 275, y: self.view.bounds.height - 125, width: 100, height: 100)
                self.rayBetaTraceButton.frame           = CGRect(x: self.view.bounds.width - 125, y: self.view.bounds.height - 125, width: 100, height: 100)
                
                
                // Slider
                var sliderIncrementer:CGFloat           = 70.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 35.0 // distance between sliders
                
                self.sliderColor.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 250, height: 35)
                self.labelColor.frame                   = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping // NO INCREMENTATION
                
                self.sliderLightColor.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 250, height: 35)
                self.labelLightColor.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                // sliderIncrementer += sliderStepping // NO INCREMENTATION
                
                // Switches
                var switchIncrementer:CGFloat           = 50.0 // start height from bottom Up
                let switchStepping:CGFloat              = 35.0 // distance between sliders
                
                self.switchDiffuse.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center                = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                  = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightColor.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightColor.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightColor2.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                // switchIncrementer += switchStepping
                
                // Picker
                // self.geometryPickerView.frame             = CGRect(x: self.view.bounds.width * 0.5 + 25, y: -25, width: 200, height: 150)
                self.geometryPickerView.frame             = CGRect(x: 25, y: -25, width: 200, height: 150)
                
                // self.labelGeometryPicker.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                // self.labelGeometryPicker.center           = CGPoint(x: self.view.bounds.width * 0.5 + 15, y: 50)
                
                self.labelGeometryPicker.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelGeometryPicker.center           = CGPoint(x: 15, y: 50)
                
                
            }
            
        case .pad:
            DispatchQueue.main.async {
                
                // Button
                self.rayTraceButton.frame               = CGRect(x: self.view.bounds.width * 0.8 - 200, y: self.view.bounds.height - 125, width: 100, height: 100)
                self.rayBetaTraceButton.frame           = CGRect(x: self.view.bounds.width * 0.8 -  50, y: self.view.bounds.height - 125, width: 100, height: 100)
                
                // Slider
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 50.0 // 50.0 // distance between sliders
                
                self.sliderColor.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelColor.frame                   = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping // NO INCREMENTATION
                
                self.sliderLightColor.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelLightColor.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                // sliderIncrementer += sliderStepping // NO INCREMENTATION
                
                
                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 50.0 // distance between sliders
                
                self.switchDiffuse.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center                = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                  = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightColor.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightColor.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightColor2.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                // Picker
                self.geometryPickerView.frame             = CGRect(x: 25, y: 25, width: 200, height: 150)
                
                self.labelGeometryPicker.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelGeometryPicker.center           = CGPoint(x: 15, y: 100)
                
                
                
            }
            
        case .unspecified:  break
        case .tv:           break
        case .carPlay:      break
        case .mac:          break
        @unknown default:   break
        
        }
    }
    // End Determine if device is in Portrait or Landscape Mode and set Variable
    
}

extension GameViewController {
    
    // MARK: - Device Orientation Transition
    // Determine if device is in Portrait or Landscape Mode and set Variable
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in self.switchDeviceOrientation() }
    }
    
    func switchDeviceOrientation() {
        
        DispatchQueue.main.async {
            
            // Adjust Device Orientation
            switch UIDevice.current.orientation {
            case .landscapeLeft:        self.alignUIStuffLandscape()
            case .landscapeRight:       self.alignUIStuffLandscape()
            case .portrait:             self.alignUIStuffPortrait()
            case .portraitUpsideDown:   self.alignUIStuffPortrait()
                
            case .unknown:              self.alignUIStuffPortrait()
            case .faceUp:               self.alignUIStuffPortrait()
            case .faceDown:             self.alignUIStuffPortrait()
            @unknown default:
                fatalError()
            }
            
        }
        
    }
    
    
    func alignUIStuffPortrait() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                GameViewController.trackingLabel.frame      = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 25)
                GameViewController.trackingLabel.textAlignment = .center
                
                // SEGMENTED CONTROL
                self.segmentedControl.frame             = CGRect(x: 25, y: 305, width: self.view.bounds.width - 50, height: 40)
                self.labelSegmented.frame               = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmented.center              = CGPoint(x: 15, y: 325)
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .left
                self.labelSecondaryRaysPerSecond.textAlignment  = .left
                self.labelRaysPerSecond.textAlignment           = .left
                self.labelTotalFrames.textAlignment             = .left
                self.labelFrameRate.textAlignment               = .left
                self.labelSeconds.textAlignment                 = .left
                
                var labelIncrementer:CGFloat            = 95.0 // start height from top
                let labelStepping:CGFloat               = 17.5 // 35.0 // distance between labels
                
                self.labelSeconds.frame                 = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelSecondaryRaysPerSecond.frame  = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: 100, y: 25, width: 50, height: 50)
                                                       // CGRect(x: self.view.bounds.width - 75, y: 25, width: 50, height: 50)
                
                // Switches
                var switchIncrementer:CGFloat           = 50.0 // start height from bottom Up
                let switchStepping:CGFloat              = 35.0 // distance between sliders
                
                self.switchColorObject.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorObject.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorObject.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchColorBox.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorBox.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorBox.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuse.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuseBox.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuseBox.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuseBox.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchVisibleLight.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchVisibleLight.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelVisibleLight.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchMaskLight.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMaskLight.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelMaskLight.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBlackBox.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBlackBox.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBlackBox.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 70.0 // 85.0 // 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 35.0 // 50.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelShiftZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelShiftY.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelShiftX.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateZ.frame                = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelRotateZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
            
                self.sliderRotateY.frame                = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelRotateY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
            
                self.sliderRotateX.frame                = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelRotateX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderScaleObject.frame            = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelScaleObject.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShadowSharpness.frame        = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelShadowSharpness.frame         = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRayBounces.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width - 50, height: 35)
                self.labelRayBounces.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 25, y: self.view.bounds.height - 20, width: self.view.bounds.width - 50, height: 10)
                self.labelProgress.frame                = CGRect(x: 25, y: self.view.bounds.height - 20 - 15, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .pad:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                GameViewController.trackingLabel.frame      = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 50)
                GameViewController.trackingLabel.textAlignment = .center
                
                // SEGMENTED CONTROL
                self.segmentedControl.frame             = CGRect(x: 25, y: 360, width: 450, height: 40)
                self.labelSegmented.frame               = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmented.center              = CGPoint(x: 15, y: 380)
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .left
                self.labelSecondaryRaysPerSecond.textAlignment  = .left
                self.labelRaysPerSecond.textAlignment           = .left
                self.labelTotalFrames.textAlignment             = .left
                self.labelFrameRate.textAlignment               = .left
                self.labelSeconds.textAlignment                 = .left
                
                var labelIncrementer:CGFloat            = 95.0 // start height from bottom Up
                let labelStepping:CGFloat               = 35.0 // distance between sliders
                
                self.labelSeconds.frame                 = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelSecondaryRaysPerSecond.frame  = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: self.view.bounds.width - 75, y: 25, width: 50, height: 50)
                
                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 50.0 // distance between sliders
                
                self.switchColorObject.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorObject.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorObject.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchColorBox.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorBox.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorBox.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuse.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuseBox.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuseBox.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuseBox.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchVisibleLight.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchVisibleLight.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelVisibleLight.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchMaskLight.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMaskLight.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelMaskLight.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBlackBox.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBlackBox.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBlackBox.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 50.0 // 50.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShiftZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShiftY.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShiftX.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateZ.frame                = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRotateZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
            
                self.sliderRotateY.frame                = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRotateY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
            
                self.sliderRotateX.frame                = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRotateX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderScaleObject.frame            = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelScaleObject.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShadowSharpness.frame        = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShadowSharpness.frame         = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRayBounces.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRayBounces.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 25, y: self.view.bounds.height - 50, width: self.view.bounds.width - 50, height: 10)
                self.labelProgress.frame                = CGRect(x: 25, y: self.view.bounds.height - 65, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .unspecified:  break
        case .tv:           break
        case .carPlay:      break
        case .mac:          break
        @unknown default:   break
        
        }
    }
    
    func alignUIStuffLandscape() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                GameViewController.trackingLabel.frame      = CGRect(x: 100, y: 40, width: self.view.bounds.width, height: 25)
                GameViewController.trackingLabel.textAlignment = .left
                
                // SEGMENTED CONTROL
                self.segmentedControl.frame             = CGRect(x: 100, y: 80, width: self.view.bounds.width * 0.5, height: 40)
                self.labelSegmented.frame               = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmented.center              = CGPoint(x: 90, y: 100)
                
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .right
                self.labelSecondaryRaysPerSecond.textAlignment  = .right
                self.labelRaysPerSecond.textAlignment           = .right
                self.labelTotalFrames.textAlignment             = .right
                self.labelFrameRate.textAlignment               = .right
                self.labelSeconds.textAlignment                 = .right
                
                var labelIncrementer:CGFloat            = 35.0 // start height from bottom Up
                let labelStepping:CGFloat               = 17.5 // 35.0 // distance between sliders
                
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelSecondaryRaysPerSecond.frame  = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelSeconds.frame                 = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: 25, y: self.view.bounds.height - 75, width: 50, height: 50)
                                                       // CGRect(x: self.view.bounds.width - 75, y: 25, width: 50, height: 50)

                
                // Switches
                var switchIncrementer:CGFloat           = 50.0 // 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 35.0 // distance between sliders
                
                self.switchColorObject.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorObject.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorObject.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchColorBox.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorBox.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorBox.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuse.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuseBox.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuseBox.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuseBox.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchVisibleLight.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchVisibleLight.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelVisibleLight.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchMaskLight.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMaskLight.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelMaskLight.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBlackBox.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBlackBox.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBlackBox.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 70.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 35.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShiftZ.frame                  = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftY.frame                 = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShiftY.frame                  = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftX.frame                 = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShiftX.frame                  = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderScaleObject.frame            = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelScaleObject.frame             = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRayBounces.frame             = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRayBounces.frame              = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                sliderIncrementer = 70 // reset
                
                self.sliderRotateZ.frame                = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRotateZ.frame                 = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
            
                self.sliderRotateY.frame                = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRotateY.frame                 = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateX.frame                = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRotateX.frame                 = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShadowSharpness.frame        = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShadowSharpness.frame         = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 100, y: self.view.bounds.height - 20, width: self.view.bounds.width - 200, height: 10)
                self.labelProgress.frame                = CGRect(x: 100, y: self.view.bounds.height - 20 - 15, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .pad:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                GameViewController.trackingLabel.frame      = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 50)
                GameViewController.trackingLabel.textAlignment = .center
                
                // SEGMENTED CONTROL
                self.segmentedControl.frame             = CGRect(x: 25, y: 360, width: 450, height: 40)
                self.labelSegmented.frame               = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmented.center              = CGPoint(x: 15, y: 380)
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .left
                self.labelSecondaryRaysPerSecond.textAlignment  = .left
                self.labelRaysPerSecond.textAlignment           = .left
                self.labelTotalFrames.textAlignment             = .left
                self.labelFrameRate.textAlignment               = .left
                self.labelSeconds.textAlignment                 = .left
                
                var labelIncrementer:CGFloat            = 95.0 // start height from bottom Up
                let labelStepping:CGFloat               = 35.0 // distance between sliders
                
                self.labelSeconds.frame                 = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelSecondaryRaysPerSecond.frame  = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: self.view.bounds.width - 75, y: 25, width: 50, height: 50)
                
                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 50.0 // distance between sliders
                
                self.switchColorObject.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorObject.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorObject.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchColorBox.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchColorBox.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelColorBox.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuse.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuse.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuse.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchDiffuseBox.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchDiffuseBox.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelDiffuseBox.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchVisibleLight.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchVisibleLight.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelVisibleLight.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchMaskLight.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMaskLight.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelMaskLight.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBlackBox.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBlackBox.center               = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBlackBox.frame                 = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 50.0 // 50.0 // distance between sliders
                
                
                self.sliderShiftZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShiftZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShiftY.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShiftX.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRotateZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRotateY.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRotateX.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderScaleObject.frame            = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelScaleObject.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShadowSharpness.frame        = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelShadowSharpness.frame         = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRayBounces.frame             = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 450, height: 35)
                self.labelRayBounces.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 25, y: self.view.bounds.height - 50, width: self.view.bounds.width - 50, height: 10)
                self.labelProgress.frame                = CGRect(x: 25, y: self.view.bounds.height - 65, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .unspecified:  break
        case .tv:           break
        case .carPlay:      break
        case .mac:          break
        @unknown default:   break
        
        }
    }
    // End Determine if device is in Portrait or Landscape Mode and set Variable
    
}

extension AdvancedGameViewController {
    
    // MARK: - Device Orientation Transition
    // Determine if device is in Portrait or Landscape Mode and set Variable
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in self.switchDeviceOrientation() }
    }
    
    func switchDeviceOrientation() {
        
        DispatchQueue.main.async {
            
            // Adjust Device Orientation
            switch UIDevice.current.orientation {
            case .landscapeLeft:        self.alignUIStuffLandscape()
            case .landscapeRight:       self.alignUIStuffLandscape()
            case .portrait:             self.alignUIStuffPortrait()
            case .portraitUpsideDown:   self.alignUIStuffPortrait()
                
            case .unknown:              self.alignUIStuffPortrait()
            case .faceUp:               self.alignUIStuffPortrait()
            case .faceDown:             self.alignUIStuffPortrait()
            @unknown default:
                fatalError()
            }
            
        }
        
    }
    
    
    func alignUIStuffPortrait() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                AdvancedGameViewController.trackingLabel.frame      = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 25)
                AdvancedGameViewController.trackingLabel.textAlignment = .center
                
                // SEGMENTED CONTROL
                self.segmentedControlBox.frame          = CGRect(x: 25, y: 305, width: 100, height: 40)
                self.labelSegmentedBox.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedBox.center           = CGPoint(x: 15, y: 325)
                
                self.segmentedControlObject.frame         = CGRect(x: 150, y: 305, width: 150, height: 40)
                self.labelSegmentedObject.frame           = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedObject.center          = CGPoint(x: 140, y: 325)
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .left
                self.labelRaysPerSecond.textAlignment           = .left
                self.labelTotalFrames.textAlignment             = .left
                self.labelFrameRate.textAlignment               = .left
                self.labelSeconds.textAlignment                 = .left
                
                var labelIncrementer:CGFloat            = 95.0 // start height from top
                let labelStepping:CGFloat               = 17.5 // 35.0 // distance between labels
                
                self.labelSeconds.frame                 = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: 100, y: 25, width: 50, height: 50)
                
                // Switches
                var switchIncrementer:CGFloat           = 50.0 // start height from bottom Up
                let switchStepping:CGFloat              = 35.0 // distance between sliders
                
                self.switchLightTop.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightTop.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightTop.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBottom.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBottom.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBottom.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightLeft.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightLeft.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightLeft.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightRight.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightRight.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightRight.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBack.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBack.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBack.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightSampling.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightSampling.center         = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightSampling.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBSDFSampling.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBSDFSampling.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBSDFSampling.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                // switches in new row, new X-Position
                switchIncrementer = 225.0
                
                self.switchMonochromeBox.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMonochromeBox.center         = CGPoint(x: self.view.bounds.width - 50 - 150, y: switchIncrementer)
                self.labelMonochromeBox.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110 - 150, height: 10)
                switchIncrementer += switchStepping
                
                self.switchRussianRoulette.frame        = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchRussianRoulette.center       = CGPoint(x: self.view.bounds.width - 50 - 150, y: switchIncrementer)
                self.labelRussianRoulette.frame         = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110 - 150, height: 10)
                switchIncrementer += switchStepping
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 70.0 // 85.0 // 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 35.0 // 50.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderShiftZ.center                = CGPoint(x: self.view.bounds.width * 0.25, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelShiftZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                
                self.sliderRotateZ.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderRotateZ.center               = CGPoint(x: self.view.bounds.width * 0.75, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelRotateZ.frame                 = CGRect(x: self.view.bounds.width * 0.5 + 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderShiftY.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderShiftY.center                = CGPoint(x: self.view.bounds.width * 0.25, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelShiftY.frame                  = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                
                self.sliderRotateY.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderRotateY.center               = CGPoint(x: self.view.bounds.width * 0.75, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelRotateY.frame                 = CGRect(x: self.view.bounds.width * 0.5 + 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderShiftX.frame                 = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderShiftX.center                = CGPoint(x: self.view.bounds.width * 0.25, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelShiftX.frame                  = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                
                self.sliderRotateX.frame                = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderRotateX.center               = CGPoint(x: self.view.bounds.width * 0.75, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelRotateX.frame                 = CGRect(x: self.view.bounds.width * 0.5 + 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderScaleObject.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderScaleObject.center             = CGPoint(x: self.view.bounds.width * 0.25, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelScaleObject.frame               = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                
                self.sliderShadowSharpness.frame        = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderShadowSharpness.center       = CGPoint(x: self.view.bounds.width * 0.75, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelShadowSharpness.frame         = CGRect(x: self.view.bounds.width * 0.5 + 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderBoxRoughness.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderBoxRoughness.center          = CGPoint(x: self.view.bounds.width * 0.25, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelBoxRoughness.frame            = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                
                self.sliderObjectRoughness.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderObjectRoughness.center         = CGPoint(x: self.view.bounds.width * 0.75, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelObjectRoughness.frame           = CGRect(x: self.view.bounds.width * 0.5 + 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderObjectColor.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderObjectColor.center             = CGPoint(x: self.view.bounds.width * 0.25, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelObjectColor.frame               = CGRect(x: 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                
                self.sliderObjectSaturation.frame         = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.5 - 50, height: 35) // SPECIAL
                self.sliderObjectSaturation.center        = CGPoint(x: self.view.bounds.width * 0.75, y: self.view.bounds.height - sliderIncrementer) // SPECIAL
                self.labelObjectSaturation.frame          = CGRect(x: self.view.bounds.width * 0.5 + 25, y: self.view.bounds.height - (sliderIncrementer + 15.0), width: self.view.bounds.width - 50, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 25, y: self.view.bounds.height - 20, width: self.view.bounds.width - 50, height: 10)
                self.labelProgress.frame                = CGRect(x: 25, y: self.view.bounds.height - 20 - 15, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .pad:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                AdvancedGameViewController.trackingLabel.frame      = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 50)
                AdvancedGameViewController.trackingLabel.textAlignment = .center
                
                // SEGMENTED CONTROL
                self.segmentedControlBox.frame          = CGRect(x: 25, y: 360, width: 150, height: 40)
                self.labelSegmentedBox.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedBox.center           = CGPoint(x: 15, y: 380)
                
                self.segmentedControlObject.frame         = CGRect(x: 200, y: 360, width: 225, height: 40)
                self.labelSegmentedObject.frame           = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedObject.center          = CGPoint(x: 190, y: 380)
                
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .left
                self.labelRaysPerSecond.textAlignment           = .left
                self.labelTotalFrames.textAlignment             = .left
                self.labelFrameRate.textAlignment               = .left
                self.labelSeconds.textAlignment                 = .left
                
                var labelIncrementer:CGFloat            = 95.0 // start height from bottom Up
                let labelStepping:CGFloat               = 35.0 // distance between sliders
                
                self.labelSeconds.frame                 = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: self.view.bounds.width - 75, y: 25, width: 50, height: 50)
                
                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 50.0 // distance between sliders
                
                self.switchLightTop.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightTop.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightTop.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBottom.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBottom.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBottom.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightLeft.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightLeft.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightLeft.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightRight.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightRight.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightRight.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBack.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBack.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBack.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightSampling.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightSampling.center         = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightSampling.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBSDFSampling.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBSDFSampling.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBSDFSampling.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchMonochromeBox.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMonochromeBox.center         = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelMonochromeBox.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchRussianRoulette.frame        = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchRussianRoulette.center       = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelRussianRoulette.frame         = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 50.0 // 50.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShiftZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderRotateZ.frame                = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelRotateZ.frame                 = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderShiftY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShiftY.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderRotateY.frame                = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelRotateY.frame                 = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderShiftX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShiftX.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderRotateX.frame                = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelRotateX.frame                 = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderScaleObject.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelScaleObject.frame               = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderShadowSharpness.frame        = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShadowSharpness.frame         = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderBoxRoughness.frame           = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelBoxRoughness.frame            = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderObjectRoughness.frame          = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelObjectRoughness.frame           = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderObjectColor.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelObjectColor.frame               = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderObjectSaturation.frame         = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelObjectSaturation.frame          = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 25, y: self.view.bounds.height - 50, width: self.view.bounds.width - 50, height: 10)
                self.labelProgress.frame                = CGRect(x: 25, y: self.view.bounds.height - 65, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .unspecified:  break
        case .tv:           break
        case .carPlay:      break
        case .mac:          break
        @unknown default:   break
        
        }
    }
    
    func alignUIStuffLandscape() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                AdvancedGameViewController.trackingLabel.frame      = CGRect(x: 100, y: 40, width: self.view.bounds.width, height: 25)
                AdvancedGameViewController.trackingLabel.textAlignment = .left
                
                // SEGMENTED CONTROL
                self.segmentedControlBox.frame          = CGRect(x: 100, y: 80, width: 100, height: 40)
                self.labelSegmentedBox.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedBox.center           = CGPoint(x: 90, y: 100)
                
                self.segmentedControlObject.frame         = CGRect(x: 225, y: 80, width: 150, height: 40)
                self.labelSegmentedObject.frame           = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedObject.center          = CGPoint(x: 215, y: 100)
                
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .right
                self.labelRaysPerSecond.textAlignment           = .right
                self.labelTotalFrames.textAlignment             = .right
                self.labelFrameRate.textAlignment               = .right
                self.labelSeconds.textAlignment                 = .right
                
                var labelIncrementer:CGFloat            = 35.0 // start height from bottom Up
                let labelStepping:CGFloat               = 17.5 // 35.0 // distance between sliders
                
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelSeconds.frame                 = CGRect(x: 25, y: self.view.bounds.height - labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: 25, y: self.view.bounds.height - 75, width: 50, height: 50)
                
                
                // Switches
                var switchIncrementer:CGFloat           = 50.0 // 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 35.0 // distance between sliders
                
                self.switchLightTop.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightTop.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightTop.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBottom.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBottom.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBottom.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightLeft.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightLeft.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightLeft.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightRight.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightRight.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightRight.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBack.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBack.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBack.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightSampling.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightSampling.center         = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightSampling.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBSDFSampling.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBSDFSampling.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBSDFSampling.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                // switches in new row, new X-Position
                switchIncrementer = 50.0
                
                self.switchMonochromeBox.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMonochromeBox.center         = CGPoint(x: self.view.bounds.width - 200, y: switchIncrementer)
                self.labelMonochromeBox.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 260, height: 10)
                switchIncrementer += switchStepping
                
                self.switchRussianRoulette.frame        = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchRussianRoulette.center       = CGPoint(x: self.view.bounds.width - 200, y: switchIncrementer)
                self.labelRussianRoulette.frame         = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 260, height: 10)
                switchIncrementer += switchStepping
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 70.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 35.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShiftZ.frame                  = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftY.frame                 = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShiftY.frame                  = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShiftX.frame                 = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShiftX.frame                  = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderScaleObject.frame              = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelScaleObject.frame               = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderBoxRoughness.frame           = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelBoxRoughness.frame            = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderObjectColor.frame              = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelObjectColor.frame               = CGRect(x: 100, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                sliderIncrementer = 70 // reset
                
                self.sliderRotateZ.frame                = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRotateZ.frame                 = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
            
                self.sliderRotateY.frame                = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRotateY.frame                 = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderRotateX.frame                = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelRotateX.frame                 = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderShadowSharpness.frame        = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelShadowSharpness.frame         = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderObjectRoughness.frame          = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelObjectRoughness.frame           = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                self.sliderObjectSaturation.frame          = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.25, height: 35)
                self.labelObjectSaturation.frame           = CGRect(x: 100 + self.view.bounds.width * 0.3, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10)
                sliderIncrementer += sliderStepping
                
                
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 100, y: self.view.bounds.height - 20, width: self.view.bounds.width - 200, height: 10)
                self.labelProgress.frame                = CGRect(x: 100, y: self.view.bounds.height - 20 - 15, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .pad:
            
            DispatchQueue.main.async {
                
                // For the New Settings View
                self.settingsView.frame = self.view.frame
                
                AdvancedGameViewController.trackingLabel.frame      = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 50)
                AdvancedGameViewController.trackingLabel.textAlignment = .center
                
                // SEGMENTED CONTROL
                self.segmentedControlBox.frame          = CGRect(x: 25, y: 360, width: 150, height: 40)
                self.labelSegmentedBox.frame            = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedBox.center           = CGPoint(x: 15, y: 380)
                
                self.segmentedControlObject.frame         = CGRect(x: 200, y: 360, width: 225, height: 40)
                self.labelSegmentedObject.frame           = CGRect(x: 0, y: 0, width: 25, height: 100)
                self.labelSegmentedObject.center          = CGPoint(x: 190, y: 380)
                
                
                // Counter Labels
                self.labelNumberTriangles.textAlignment         = .left
                self.labelRaysPerSecond.textAlignment           = .left
                self.labelTotalFrames.textAlignment             = .left
                self.labelFrameRate.textAlignment               = .left
                self.labelSeconds.textAlignment                 = .left
                
                var labelIncrementer:CGFloat            = 95.0 // start height from bottom Up
                let labelStepping:CGFloat               = 35.0 // distance between sliders
                
                self.labelSeconds.frame                 = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelFrameRate.frame               = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelTotalFrames.frame             = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelRaysPerSecond.frame           = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                self.labelNumberTriangles.frame         = CGRect(x: 25, y: labelIncrementer, width: self.view.bounds.width - 50, height: 10)
                labelIncrementer += labelStepping
                
                
                // Buttons
                self.closeButton.frame                  = CGRect(x: 25, y: 25, width: 50, height: 50)
                self.settingsButton.frame               = CGRect(x: self.view.bounds.width - 75, y: 25, width: 50, height: 50)
                
                // Switches
                var switchIncrementer:CGFloat           = 100.0 // start height from bottom Up
                let switchStepping:CGFloat              = 50.0 // distance between sliders
                
                self.switchLightTop.frame               = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightTop.center              = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightTop.frame                = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBottom.frame            = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBottom.center           = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBottom.frame             = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightLeft.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightLeft.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightLeft.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightRight.frame             = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightRight.center            = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightRight.frame              = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightBack.frame              = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightBack.center             = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightBack.frame               = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                self.switchLightSampling.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchLightSampling.center         = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelLightSampling.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                 
                self.switchBSDFSampling.frame           = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchBSDFSampling.center          = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelBSDFSampling.frame            = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
            
                self.switchMonochromeBox.frame          = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchMonochromeBox.center         = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelMonochromeBox.frame           = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
            
                self.switchRussianRoulette.frame        = CGRect(x: 0, y: 0, width: self.view.bounds.width - 50, height: 35)
                self.switchRussianRoulette.center       = CGPoint(x: self.view.bounds.width - 50, y: switchIncrementer)
                self.labelRussianRoulette.frame         = CGRect(x: 25, y: (switchIncrementer - 5), width: self.view.bounds.width - 110, height: 10)
                switchIncrementer += switchStepping
                
                
                
                // SLIDERS
                var sliderIncrementer:CGFloat           = 150.0 // start height from bottom Up
                let sliderStepping:CGFloat              = 50.0 // 50.0 // distance between sliders
                
                self.sliderShiftZ.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShiftZ.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderRotateZ.frame                = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelRotateZ.frame                 = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderShiftY.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShiftY.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderRotateY.frame                = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelRotateY.frame                 = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderShiftX.frame                 = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShiftX.frame                  = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderRotateX.frame                = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelRotateX.frame                 = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderScaleObject.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelScaleObject.frame               = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderShadowSharpness.frame        = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelShadowSharpness.frame         = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderBoxRoughness.frame           = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelBoxRoughness.frame            = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderObjectRoughness.frame          = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelObjectRoughness.frame           = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                self.sliderObjectColor.frame              = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelObjectColor.frame               = CGRect(x: 25, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                
                self.sliderObjectSaturation.frame         = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: 200, height: 35) // SPECIAL
                self.labelObjectSaturation.frame          = CGRect(x: 275, y: self.view.bounds.height - sliderIncrementer, width: self.view.bounds.width * 0.5, height: 10) // SPECIAL
                sliderIncrementer += sliderStepping
                
                
                // PROGRESS VIEW
                self.progressRayTracer.frame            = CGRect(x: 25, y: self.view.bounds.height - 50, width: self.view.bounds.width - 50, height: 10)
                self.labelProgress.frame                = CGRect(x: 25, y: self.view.bounds.height - 65, width: self.view.bounds.width - 50, height: 10)
                
            }
            
        case .unspecified:  break
        case .tv:           break
        case .carPlay:      break
        case .mac:          break
        @unknown default:   break
        
        }
    }
    
}
