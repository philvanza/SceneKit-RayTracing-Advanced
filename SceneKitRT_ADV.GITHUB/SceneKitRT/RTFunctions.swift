//
//  RTFunctions.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import UIKit
import MetalKit

extension GameViewController {
    
    // MARK: Initialize Ray Tracer
    func initializeRayTracer() {
        
        // Cancel some dispatch queue work items
        infoRayTrace.cancel()
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
                let newRenderer = try Renderer(withMetalKitView: mtkView)
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
        
    }
    
    func dispatchWorkItemInfoRayTrace() -> DispatchWorkItem {
        self.infoRayTrace = DispatchWorkItem(block: {
            GameViewController.displayLabelInfo(text: "RAY TRACING OBJECT")
        })
        return self.infoRayTrace
    }
    
    func dispatchWorkItemScheduleTimer() -> DispatchWorkItem {
        self.scheduleTimer = DispatchWorkItem(block: {
            self.elapsedTimer.invalidate()
            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(self.fpsOutput), userInfo: nil, repeats:true)
        })
        return self.scheduleTimer
    }
    
    @objc func fpsOutput() {
        
        GameViewController.secondsCounter += 1
        
        guard let rend = renderer else { return }
        
        let seconds                 : Float = Float(GameViewController.secondsCounter)
        let totalFrames             : Float = Float(rend.frameIndex)
        let frameRate               : Float = Float(totalFrames / seconds)
        let mRaysPrimaryPerSecond   : Float = Float(Float(rend.rayCount) * frameRate / 1000000)
        let mRaysSecondaryPerSecond : Float = Float(mRaysPrimaryPerSecond * (Float(rayBounces - 1)))
        let triangles               : Float = Float(rend.numberOfTriangles)
        
        DispatchQueue.main.async {
            self.labelSeconds.text                  = "SECONDS ELAPSED: "   + String(format:"%.0f", seconds)
            self.labelFrameRate.text                = "FRAMES / SECOND: "   + String(format:"%.1f", frameRate)
            self.labelTotalFrames.text              = "FRAMES RENDERED: "   + String(format:"%.0f", totalFrames)
            self.labelRaysPerSecond.text            = "PRIMARY mRAYS/s: "   + String(format:"%.3f", mRaysPrimaryPerSecond)
            self.labelSecondaryRaysPerSecond.text   = "SECONDARY mRAYS/s: " + String(format:"%.3f", mRaysSecondaryPerSecond)
            self.labelNumberTriangles.text          = "TRIANGLES COUNT: "   + String(format:"%.0f", triangles)
            
            if !GameViewController.isRenderingProgressCompleted {
                if totalFrames >= 1000 {
                    GameViewController.isRenderingProgressCompleted = true
                    GameViewController.displayLabelInfo(text: "RENDERING COMPLETE")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        GameViewController.displayLabelInfo(text: "STILL RENDERING...")
                    }
                    
                }
                self.progressRayTracer.setProgress(totalFrames / 1000, animated: true)
            }
            
        }
        
    }
    
    func resetSettings() {
        cameraDistanceZ     = 3.38 // default Apple
        cameraShiftX        = 0.00 // default Apple
        cameraShiftY        = 1.00 // default Apple
        
        objectScaleFactor     = 1.0
        objectShiftX          = 0.0
        objectShiftY          = 0.0
        objectShiftZ          = 0.0
        objectRotationX       = 0.0
        objectRotationY       = 0.0
        objectRotationZ       = 0.0
        
        sliderScaleObject.setValue(objectScaleFactor, animated: true)
        sliderShiftX.setValue(objectShiftX, animated: true)
        sliderShiftY.setValue(objectShiftY, animated: true)
        sliderShiftZ.setValue(objectShiftZ, animated: true)
        
        sliderRotateX.setValue(objectShiftX, animated: true)
        sliderRotateY.setValue(objectShiftY, animated: true)
        sliderRotateZ.setValue(objectShiftZ, animated: true)
    }
    
    @objc func closeAction() {
        print("RayTracer View Controller dismissed")
        
        resetSettings()
        
        mainInitializer.cancel()
        infoRayTrace.cancel()
        scheduleTimer.cancel()
        
        elapsedTimer.invalidate()
        renderer = nil // NEW
        mtkView = nil // NEW
        dismiss(animated: true, completion: nil)
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
    
    @objc func changeGrayObject(_ sender: UISwitch) {
        isGrayObject = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeColoredBox(_ sender: UISwitch) {
        isColoredBox = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeReflectiveObject(_ sender: UISwitch) {
        isReflectiveObject = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeReflectiveBox(_ sender: UISwitch) {
        isReflectiveBox = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeVisibleLight(_ sender: UISwitch) {
        isNoVisibleLight = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeMaskLight(_ sender: UISwitch) {
        isMaskLight = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeBlackBox(_ sender: UISwitch) {
        isBlackBox = sender.isOn
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeLightPosition(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        
        case 0:  lightPosition = .left
        case 1:  lightPosition = .right
        case 2:  lightPosition = .top
        case 3:  lightPosition = .bottom
        case 4:  lightPosition = .front
        case 5:  lightPosition = .back
        default: lightPosition = .top
        }
        
        initializeRayTracer() // restart ray tracer
    }
    
    @objc func changeObjectShiftX(_ sender: UISlider) {
        objectShiftX = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "X-SHIFT: " + String(format:"%.2f", sender.value), GameViewController.mainColorization)
    }
    
    @objc func changeObjectShiftY(_ sender: UISlider) {
        objectShiftY = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "Y-SHIFT: " + String(format:"%.2f", sender.value), GameViewController.mainColorization)
    }
    
    @objc func changeObjectShiftZ(_ sender: UISlider) {
        objectShiftZ = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "Z-SHIFT: " + String(format:"%.2f", sender.value), GameViewController.mainColorization)
    }
    
    @objc func changeObjectRotationX(_ sender: UISlider) {
        objectRotationX = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "X-ROTATION: " + String(format:"%.2f", sender.value) + "º", GameViewController.mainColorization)
    }
    
    @objc func changeObjectRotationY(_ sender: UISlider) {
        objectRotationY = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "Y-ROTATION: " + String(format:"%.2f", sender.value) + "º", GameViewController.mainColorization)
    }
    
    @objc func changeObjectRotationZ(_ sender: UISlider) {
        objectRotationZ = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "Z-ROTATION: " + String(format:"%.2f", sender.value) + "º", GameViewController.mainColorization)
    }
    
    @objc func changeScaleObject(_ sender: UISlider) {
        objectScaleFactor = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "OBJECT SCALE: " + String(format:"%.2f", sender.value), GameViewController.mainColorization)
    }
    
    @objc func changeRayBounces(_ sender: UISlider) {
        rayBounces = Int(sender.value)
        initializeRayTracer() // restart ray tracer
        
        switch rayBounces {
        case  1...10: GameViewController.displayLabelInfo(text: "RAY BOUNCES: " + String(Int(sender.value)), GameViewController.mainColorization)
        case 11...15: GameViewController.displayLabelInfo(text: "RAY BOUNCES: " + String(Int(sender.value)) + " ⚠️", GameViewController.mainColorization)
        default: break
        }
    }
    
    @objc func changeShadowSharpness(_ sender: UISlider) {
        shadowSharpness = sender.value
        initializeRayTracer() // restart ray tracer
        GameViewController.displayLabelInfo(text: "SHADOW BLUR: " + String(format:"%.2f", sender.value), GameViewController.mainColorization)
    }
    
}
