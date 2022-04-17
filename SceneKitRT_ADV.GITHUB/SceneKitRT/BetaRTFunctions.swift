//
//  BetaRTFunctions.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import UIKit
import SceneKit
import MetalKit
import AVFoundation

extension AdvancedGameViewController {
    
    @objc func fpsOutput() {
        
        AdvancedGameViewController.secondsCounter += 1
        
        guard let rend = renderer else { return }
        
        let seconds                 : Float = Float(AdvancedGameViewController.secondsCounter)
        let totalFrames             : Float = Float(rend.frameContinuousIndex)
        let frameRate               : Float = Float(totalFrames / seconds)
        let mRaysPrimaryPerSecond   : Float = Float(Float(rend.rayCount) * frameRate / 1000000)
        let triangles               : Float = Float(rend._triangleCount) // Float(12) // rend.numberOfTriangles)
        
        DispatchQueue.main.async {
            self.labelSeconds.text                  = "SECONDS ELAPSED: "   + String(format:"%.0f", seconds)
            self.labelFrameRate.text                = "FRAMES / SECOND: "   + String(format:"%.1f", frameRate)
            self.labelTotalFrames.text              = "FRAMES RENDERED: "   + String(format:"%.0f", totalFrames)
            self.labelRaysPerSecond.text            = "PRIMARY mRAYS/s: "   + String(format:"%.3f", mRaysPrimaryPerSecond)
            self.labelNumberTriangles.text          = "TRIANGLES COUNT: "   + String(format:"%.0f", triangles)
            
            if !AdvancedGameViewController.isRenderingProgressCompleted {
                if totalFrames >= 10000 {
                    AdvancedGameViewController.isRenderingProgressCompleted = true
                    AdvancedGameViewController.displayLabelInfo(text: "RENDERING COMPLETE")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        AdvancedGameViewController.displayLabelInfo(text: "STILL RENDERING...")
                    }
                    self.labelProgress.text = "RENDERING PROGRESS: COMPLETED"
                }
                self.progressRayTracer.setProgress(totalFrames / 10000, animated: true)
                self.labelProgress.text = "RENDERING PROGRESS: " + String(format:"%.0f", (totalFrames / 10000 * 100)) + "%"
            }
            
        }
        
    }
    
    @objc func closeAction() {
        print("RayTracer View Controller dismissed")
        
        mainInitializer.cancel()
        infoRayTrace.cancel()
        infoBetaRayTrace.cancel()
        scheduleTimer.cancel()
        
        // displayLink.invalidate()
        elapsedTimer.invalidate()
        renderer = nil // NEW
        mtkView = nil // NEW
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func saveAction() {
        print("save action execution")
        
        let context = CIContext()
        guard let texture = renderer.view.currentDrawable?.texture else { return }
        let cImg = CIImage(mtlTexture: texture, options: nil)!
        let cgImg = context.createCGImage(cImg, from: cImg.extent)!
        // let uiImg = UIImage(cgImage: cgImg)
        let uiImg = UIImage(cgImage: cgImg, scale: 1.0, orientation: UIImage.Orientation.downMirrored)
        
        UIImageWriteToSavedPhotosAlbum(uiImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    // Error Handler for Image saving
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            print(error.localizedDescription)
            AdvancedGameViewController.displayLabelInfo(text: "ERROR", UIColor.red)
        } else {
            print("successfully saved image")
            AdvancedGameViewController.displayLabelInfo(text: "IMAGE SAVED")
        }
        
    }
    
    
    
    @objc func changeLightTop(_ sender: UISwitch) {
        isLightTop = sender.isOn
        
        // for Security - one Light must always be enabled
        if !isLightBottom && !isLightLeft && !isLightRight && !isLightBack {
            isLightTop = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE LIGHT REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeLightBottom(_ sender: UISwitch) {
        isLightBottom = sender.isOn
        
        // for Security - one Light must always be enabled
        if !isLightTop && !isLightLeft && !isLightRight && !isLightBack {
            isLightBottom = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE LIGHT REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeLightLeft(_ sender: UISwitch) {
        isLightLeft = sender.isOn
        
        // for Security - one Light must always be enabled
        if !isLightTop && !isLightBottom && !isLightRight && !isLightBack {
            isLightLeft = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE LIGHT REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeLightRight(_ sender: UISwitch) {
        isLightRight = sender.isOn
        
        // for Security - one Light must always be enabled
        if !isLightTop && !isLightBottom && !isLightLeft && !isLightBack {
            isLightRight = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE LIGHT REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeLightBack(_ sender: UISwitch) {
        isLightBack = sender.isOn
        
        // for Security - one Light must always be enabled
        if !isLightTop && !isLightBottom && !isLightLeft && !isLightRight {
            isLightBack = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE LIGHT REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeLightSampling(_ sender: UISwitch) {
        isLightSamplingEnabled = sender.isOn
        
        // for Security - one Sampling must always be enabled
        if !isBSDFSamplingEnabled {
            isLightSamplingEnabled = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE SAMPLER REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeBSDFSampling(_ sender: UISwitch) {
        isBSDFSamplingEnabled = sender.isOn
        
        // for Security - one Sampling must always be enabled
        if !isLightSamplingEnabled {
            isBSDFSamplingEnabled = true
            DispatchQueue.main.async {
                sender.isOn = true
                sender.setOn(true, animated: true)
            }
            AdvancedGameViewController.displayLabelInfo(text: "ONE SAMPLER REQUIRED", UIColor.red)
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeMonochromeBox(_ sender: UISwitch) {
        isMonochromeBox = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeRussianRoulette(_ sender: UISwitch) {
        isRussianRoulette = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeMaterialBox(_ sender: UISegmentedControl) {
        
        globalMaterialBox = sender.selectedSegmentIndex
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeMaterialObject(_ sender: UISegmentedControl) {
        
        globalMaterialObject = sender.selectedSegmentIndex
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeObjectShiftX(_ sender: UISlider) {
        objectShiftX = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "X-SHIFT: " + String(format:"%.2f", sender.value), AdvancedGameViewController.mainColorization)
    }
    
    @objc func changeObjectShiftY(_ sender: UISlider) {
        objectShiftY = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "Y-SHIFT: " + String(format:"%.2f", sender.value), AdvancedGameViewController.mainColorization)
    }
    
    @objc func changeObjectShiftZ(_ sender: UISlider) {
        objectShiftZ = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "Z-SHIFT: " + String(format:"%.2f", sender.value), AdvancedGameViewController.mainColorization)
    }
    
    @objc func changeObjectRotationX(_ sender: UISlider) {
        objectRotationX = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "X-ROTATION: " + String(format:"%.2f", sender.value) + "º", AdvancedGameViewController.mainColorization)
    }
    
    @objc func changeObjectRotationY(_ sender: UISlider) {
        objectRotationY = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "Y-ROTATION: " + String(format:"%.2f", sender.value) + "º", AdvancedGameViewController.mainColorization)
    }
    
    @objc func changeObjectRotationZ(_ sender: UISlider) {
        objectRotationZ = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "Z-ROTATION: " + String(format:"%.2f", sender.value) + "º", AdvancedGameViewController.mainColorization)
    }
    
    @objc func changeScaleObject(_ sender: UISlider) {
        objectScaleFactor = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "OBJECT SCALE: " + String(format:"%.2f", sender.value), AdvancedGameViewController.mainColorization)
    }
    
//    @objc func changeRayBounces(_ sender: UISlider) {
//        rayBounces = Int(sender.value)
//        initializeRayTracer() // restart ray tracer
//
//        switch rayBounces {
//        case   1...6: AdvancedGameViewController.displayLabelInfo(text: "RAY BOUNCES: " + String(Int(sender.value)), AdvancedGameViewController.mainColorization)
//        case   7...9: AdvancedGameViewController.displayLabelInfo(text: "RAY BOUNCES: " + String(Int(sender.value)), UIColor.orange)
//        case 10...12: AdvancedGameViewController.displayLabelInfo(text: "RAY BOUNCES: " + String(Int(sender.value)) + " ⚠️", UIColor.red)
//        default: break
//        }
//    }
    
    @objc func changeBoxRoughness(_ sender: UISlider) {
        boxRoughness = sender.value
        initializeRayTracer() // restart ray tracer
        
        AdvancedGameViewController.displayLabelInfo(text: "BOX ROUGHNESS: " + String(Int(sender.value * 100)) + "%", AdvancedGameViewController.mainColorization)
        
    }
    
    @objc func changeObjectRoughness(_ sender: UISlider) {
        objectRoughness = sender.value
        initializeRayTracer() // restart ray tracer
        
        AdvancedGameViewController.displayLabelInfo(text: "OBJECT ROUGHNESS: " + String(Int(sender.value * 100)) + "%", AdvancedGameViewController.mainColorization)
        
    }
    
    @objc func changeShadowSharpness(_ sender: UISlider) { // change name
        shadowSharpness = sender.value
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "LIGHT SIZE: " + String(format:"%.2f", sender.value), AdvancedGameViewController.mainColorization)
    }
    
    
    @objc func updateObjectColor(_ sender: UISlider) {
        objectHUEValueRT = CGFloat(sender.value)
        objectColorRT = UIColor(hue: objectHUEValueRT, saturation: objectSaturationValueRT, brightness: 1.0, alpha: 1.0)
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "HUE: " + String(format:"%.3f", sender.value), objectColorRT)
    }
    
    @objc func updateObjectSaturation(_ sender: UISlider) {
        objectSaturationValueRT = CGFloat(sender.value)
        objectColorRT = UIColor(hue: objectHUEValueRT, saturation: objectSaturationValueRT, brightness: 1.0, alpha: 1.0)
        initializeRayTracer() // restart ray tracer
        AdvancedGameViewController.displayLabelInfo(text: "SATURATION: " + String(format:"%.3f", sender.value), objectColorRT)
    }
    
    
    @objc func showHideSettings() {
    
    
        isInSettingsMode = !isInSettingsMode
        // impactFeedback(force: 1)
        switch isInSettingsMode {
        case true:
            DispatchQueue.main.async {
                self.showSettingsView()
                GameViewController.displayLabelInfo(text: "CONTROLS")
                // self.doubleTapGesture.isEnabled = false
                // self.panGesture.isEnabled       = false
    
            }
        case false:
            DispatchQueue.main.async {
                self.hideSettingsView()
                // self.doubleTapGesture.isEnabled = true
                // self.panGesture.isEnabled       = true
            }
        }
    }
    
//    // MARK: Tap Gesture
//    @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
//        showHideSettings()
//    }
//
//    @objc func handleDoubleTap(_ gestureRecognize: UITapGestureRecognizer) {
//        cameraDistanceZ     = 3.38 // default Apple
//        cameraShiftX        = 0.00 // default Apple
//        cameraShiftY        = 1.00 // default Apple
//
//        objectScaleFactor     = 1.0
//        objectShiftX          = 0.0
//        objectShiftY          = 0.0
//        objectShiftZ          = 0.0
//        objectRotationX       = 0.0
//        objectRotationY       = 0.0
//        objectRotationZ       = 0.0
//
//        sliderScaleObject.setValue(objectScaleFactor, animated: true)
//        sliderShiftX.setValue(objectShiftX, animated: true)
//        sliderShiftY.setValue(objectShiftY, animated: true)
//        sliderShiftZ.setValue(objectShiftZ, animated: true)
//
//        sliderRotateX.setValue(objectShiftX, animated: true)
//        sliderRotateY.setValue(objectShiftY, animated: true)
//        sliderRotateZ.setValue(objectShiftZ, animated: true)
//
//        initializeRayTracer() // restart ray tracer
//
//        AdvancedGameViewController.displayLabelInfo(text: "CAMERA & OBJECT RESET")
//
//    }
    
    
    
//    @objc func handlePinch(_ gestureRecognize: UIPinchGestureRecognizer) {
//        
//        if gestureRecognize.scale > 1.0 {
//            cameraDistanceZ -= 0.15 // Float(gestureRecognize.scale * 0.1)
//            if cameraDistanceZ <= 1.00 { cameraDistanceZ = 1.00}
//        }
//        
//        if gestureRecognize.scale < 1.0 {
//            cameraDistanceZ += 0.15 // Float(gestureRecognize.scale * 0.1)
//            if cameraDistanceZ >= 5.00 { cameraDistanceZ = 5.00}
//        }
//        
//        mainInitializer.cancel()
//        mainInitializer = DispatchWorkItem { self.initializeRayTracer() }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: mainInitializer)
//        
//        AdvancedGameViewController.displayLabelInfo(text: "DISTANCE: " + String(format:"%.2f", cameraDistanceZ) + " UNITS")
//        
//        gestureRecognize.scale = 1.0
//    }
//    
//    @objc func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
//        
//        switch gestureRecognize.direction{
//         case .rightToLeft:
//            print("rightToLeft")
//            cameraShiftX += 0.01 * cameraDistanceZ; if cameraShiftX >= 1.00 { cameraShiftX = 1.00}
//            AdvancedGameViewController.displayLabelInfo(text: "X-SHIFT: " + String(format:"%.2f", cameraShiftX) + " UNITS")
//         case .leftToRight:
//            print("leftToRight")
//            cameraShiftX -= 0.01 * cameraDistanceZ; if cameraShiftX <= -1.00 { cameraShiftX = -1.00}
//            AdvancedGameViewController.displayLabelInfo(text: "X-SHIFT: " + String(format:"%.2f", cameraShiftX) + " UNITS")
//         case .topToBottom:
//            print("topToBottom")
//            cameraShiftY += 0.01 * cameraDistanceZ; if cameraShiftY >= 2.00 { cameraShiftY = 2.00}
//            AdvancedGameViewController.displayLabelInfo(text: "Y-SHIFT: " + String(format:"%.2f", cameraShiftY) + " UNITS")
//         case .bottomToTop:
//            print("bottomToTop")
//            cameraShiftY -= 0.01 * cameraDistanceZ; if cameraShiftY <= 0.00 { cameraShiftY = 0.00}
//            AdvancedGameViewController.displayLabelInfo(text: "Y-SHIFT: " + String(format:"%.2f", cameraShiftY) + " UNITS")
//         default:
//            print("default")
//        }
//        
//        
//        mainInitializer.cancel()
//        mainInitializer = DispatchWorkItem { self.initializeRayTracer() }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: mainInitializer)
//        
//        
//    }
    
    
    // MARK: Initialize Ray Tracer
    func initializeRayTracer() {
        
        // Cancel some dispatch queue work items
        infoRayTrace.cancel()
        infoBetaRayTrace.cancel()
        scheduleTimer.cancel()
        
        guard let mtkView = self.view as? MTKView else {
            print("View of Gameview controller is not an MTKView")
            return
        }
               
               // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported")
            return
        }
        
               
        mtkView.device = defaultDevice
        mtkView.backgroundColor = UIColor.black
        
        // Dispatch Renderer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            do {
                let newRenderer = try AdvancedRenderer(withMetalKitView: mtkView)
                self.renderer = newRenderer
                self.renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
                mtkView.delegate = self.renderer
                
            } catch {
                print("Renderer cannot be initialized : \(error)")
            }
            
        }
        
        progressRayTracer.setProgress(0.0, animated: true)
        
        self.scheduleTimer = dispatchWorkItemScheduleTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: self.scheduleTimer)
        
        self.infoRayTrace = dispatchWorkItemInfoRayTrace()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1, execute: self.infoRayTrace)
        
        self.infoBetaRayTrace = dispatchWorkItemInfoBetaRayTrace()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1, execute: self.infoBetaRayTrace)
        
    }
    
    func dispatchWorkItemInfoRayTrace() -> DispatchWorkItem {
        self.infoRayTrace = DispatchWorkItem(block: {
            AdvancedGameViewController.displayLabelInfo(text: "RAYTRACING OBJECT")
        })
        return self.infoRayTrace
    }
    
    func dispatchWorkItemInfoBetaRayTrace() -> DispatchWorkItem {
        self.infoBetaRayTrace = DispatchWorkItem(block: {
            AdvancedGameViewController.displayLabelInfo(text: "USING BETA TRACER")
        })
        return self.infoBetaRayTrace
    }
    
    func dispatchWorkItemScheduleTimer() -> DispatchWorkItem {
        self.scheduleTimer = DispatchWorkItem(block: {
            self.elapsedTimer.invalidate()
            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.fpsOutput), userInfo: nil, repeats:true)
        })
        return self.scheduleTimer
    }
    
}
