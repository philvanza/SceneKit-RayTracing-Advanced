//
//  MaterialLibraryRT.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import Foundation

extension AdvancedRenderer {
    
    // MARK: For the Light Source(s) - Emissive Material
    func rtMaterialLightSource() -> Material {
        var material = Material()
        material.diffuse       = simd_float3(1.0, 1.0, 1.0) // white, ignored
        material.specular      = simd_float3(1.0, 1.0, 1.0) // white, ignored
        material.transmittance = simd_float3(1.0, 1.0, 1.0) // white, ignored
        material.emissive      = simd_float3(lightColor.redValue * 50.0, lightColor.greenValue * 40.0, lightColor.blueValue * 30.0) // EMISSIVE VALUE Ke // simd_float3(5.0, 4.0, 3.0)
        material.roughness     = 0.005 // is recommended minimum value, ignored
        material.type          = uint(MATERIAL_DIFFUSE)
        material.intIOR        = 1.5 // glass, ignored
        material.extIOR        = 1.0 // air, should not be more or less than 1.0, ignored
        return material
    }
    
    // For the Cornell-Box - Diffuse White
//    func rtMaterialCornellBox() -> Material {
//        var material = Material()
//        // material.diffuse       = simd_float3(0.7250, 0.7100, 0.6800) // default gray
//        material.diffuse       = simd_float3(0.784, 0.268, 0.666) // simd_float3(1.0, 1.0, 1.0)
//        material.specular      = simd_float3(1.0, 1.0, 1.0)
//        material.transmittance = simd_float3(1.0, 1.0, 1.0)
//        material.emissive      = simd_float3(0.0, 0.0, 0.0)
//        material.roughness     = boxRoughness // 0.005 // is recommended minimum value
//        material.type          = uint(MATERIAL_DIFFUSE)
//        material.intIOR        = 1.5 // glass
//        material.extIOR        = 1.0 // air, should not be more or less than 1.0
//        return material
//    }
    
    // MARK: Cornell-Box Faces
    func rtMaterialCornellBoxNegX() -> Material {
        var material = Material()
        // material.diffuse       = simd_float3(1.0, 0.0, 0.0) // RED
        // material.specular      = simd_float3(1.0, 0.0, 0.0)
        material.transmittance = simd_float3(1.0, 1.0, 1.0)
        material.emissive      = simd_float3(0.0, 0.0, 0.0)
        material.roughness     = boxRoughness // 0.005 // is recommended minimum value
        // material.type          = uint(MATERIAL_PLASTIC)
        material.intIOR        = 1.5 // glass
        material.extIOR        = 1.0 // air, should not be more or less than 1.0
        
        switch isMonochromeBox {
        case true:
            material.diffuse       = simd_float3(0.8, 0.8, 0.8) // GRAY
            material.specular      = simd_float3(0.8, 0.8, 0.8)
        case false:
            material.diffuse       = simd_float3(1.0, 0.0, 0.0) // RED
            material.specular      = simd_float3(1.0, 0.0, 0.0)
        }
        
        switch globalMaterialBox {
        case 0:  material.type = uint(MATERIAL_PLASTIC)
        case 1:  material.type = uint(MATERIAL_CONDUCTOR)
        default: material.type = uint(MATERIAL_DIFFUSE)
        }
        
        return material
    }
    
    func rtMaterialCornellBoxPosX() -> Material {
        var material = Material()
        // material.diffuse       = simd_float3(0.0, 1.0, 0.0) // GREEN
        // material.specular      = simd_float3(0.0, 1.0, 0.0)
        material.transmittance = simd_float3(1.0, 1.0, 1.0)
        material.emissive      = simd_float3(0.0, 0.0, 0.0)
        material.roughness     = boxRoughness // 0.005 // is recommended minimum value
        // material.type          = uint(MATERIAL_PLASTIC)
        material.intIOR        = 1.5 // glass
        material.extIOR        = 1.0 // air, should not be more or less than 1.0
        
        switch isMonochromeBox {
        case true:
            material.diffuse       = simd_float3(0.8, 0.8, 0.8) // GRAY
            material.specular      = simd_float3(0.8, 0.8, 0.8)
        case false:
            material.diffuse       = simd_float3(0.0, 1.0, 0.0) // GREEN
            material.specular      = simd_float3(0.0, 1.0, 0.0)
        }
        
        switch globalMaterialBox {
        case 0:  material.type = uint(MATERIAL_PLASTIC)
        case 1:  material.type = uint(MATERIAL_CONDUCTOR)
        default: material.type = uint(MATERIAL_DIFFUSE)
        }
        
        return material
    }
    
    func rtMaterialCornellBoxNegY() -> Material {
        var material = Material()
        // material.diffuse       = simd_float3(0.0, 0.0, 1.0) // BLUE
        // material.specular      = simd_float3(0.0, 0.0, 1.0)
        material.transmittance = simd_float3(1.0, 1.0, 1.0)
        material.emissive      = simd_float3(0.0, 0.0, 0.0)
        material.roughness     = boxRoughness // 0.005 // is recommended minimum value
        // material.type          = uint(MATERIAL_PLASTIC)
        material.intIOR        = 1.5 // glass
        material.extIOR        = 1.0 // air, should not be more or less than 1.0
        
        switch isMonochromeBox {
        case true:
            material.diffuse       = simd_float3(0.8, 0.8, 0.8) // GRAY
            material.specular      = simd_float3(0.8, 0.8, 0.8)
        case false:
            material.diffuse       = simd_float3(0.0, 0.0, 1.0) // BLUE
            material.specular      = simd_float3(0.0, 0.0, 1.0)
        }
        
        switch globalMaterialBox {
        case 0:  material.type = uint(MATERIAL_PLASTIC)
        case 1:  material.type = uint(MATERIAL_CONDUCTOR)
        default: material.type = uint(MATERIAL_DIFFUSE)
        }
        
        return material
    }
    
    func rtMaterialCornellBoxPosY() -> Material {
        var material = Material()
        // material.diffuse       = simd_float3(1.0, 1.0, 0.0) // YELLOW
        // material.specular      = simd_float3(1.0, 1.0, 0.0)
        material.transmittance = simd_float3(1.0, 1.0, 1.0)
        material.emissive      = simd_float3(0.0, 0.0, 0.0)
        material.roughness     = boxRoughness // 0.005 // is recommended minimum value
        // material.type          = uint(MATERIAL_PLASTIC)
        material.intIOR        = 1.5 // glass
        material.extIOR        = 1.0 // air, should not be more or less than 1.0
        
        switch isMonochromeBox {
        case true:
            material.diffuse       = simd_float3(0.8, 0.8, 0.8) // GRAY
            material.specular      = simd_float3(0.8, 0.8, 0.8)
        case false:
            material.diffuse       = simd_float3(1.0, 1.0, 0.0) // YELLOW
            material.specular      = simd_float3(1.0, 1.0, 0.0)
        }
        
        switch globalMaterialBox {
        case 0:  material.type = uint(MATERIAL_PLASTIC)
        case 1:  material.type = uint(MATERIAL_CONDUCTOR)
        default: material.type = uint(MATERIAL_DIFFUSE)
        }
        
        return material
    }
    
    func rtMaterialCornellBoxNegZ() -> Material {
        var material = Material()
        // material.diffuse       = simd_float3(0.8, 0.8, 0.8) // GRAY
        // material.specular      = simd_float3(0.8, 0.8, 0.8)
        material.transmittance = simd_float3(1.0, 1.0, 1.0)
        material.emissive      = simd_float3(0.0, 0.0, 0.0)
        material.roughness     = boxRoughness // 0.005 // is recommended minimum value
        // material.type          = uint(MATERIAL_PLASTIC)
        material.intIOR        = 1.5 // glass
        material.extIOR        = 1.0 // air, should not be more or less than 1.0
        
        switch isMonochromeBox {
        case true:
            material.diffuse       = simd_float3(0.5, 0.5, 0.5) // GRAY (same)
            material.specular      = simd_float3(0.5, 0.5, 0.5)
        case false:
            material.diffuse       = simd_float3(0.8, 0.8, 0.8) // GRAY (same)
            material.specular      = simd_float3(0.8, 0.8, 0.8)
        }
        
        switch globalMaterialBox {
        case 0:  material.type = uint(MATERIAL_PLASTIC)
        case 1:  material.type = uint(MATERIAL_CONDUCTOR)
        default: material.type = uint(MATERIAL_DIFFUSE)
        }
        
        return material
    }
    
    
    
    // MARK: For the Metaball Object - Transparent
    func rtMaterialMetaballObject() -> Material {
        var material = Material()
        // material.diffuse       = simd_float3(1.0, 1.0, 1.0)
        // material.specular      = simd_float3(1.0, 1.0, 1.0)
        // material.transmittance = simd_float3(1.0, 1.0, 1.0)
        
        material.diffuse       = simd_float3(objectColorRT.redValue, objectColorRT.greenValue, objectColorRT.blueValue)
        material.specular      = simd_float3(objectColorRT.redValue, objectColorRT.greenValue, objectColorRT.blueValue)
        material.transmittance = simd_float3(objectColorRT.redValue, objectColorRT.greenValue, objectColorRT.blueValue)
        
        material.emissive      = simd_float3(0.0, 0.0, 0.0)
        material.roughness     = objectRoughness // 0.005 // is recommended minimum value
        // material.type          = uint(MATERIAL_DIELECTRIC)
        material.intIOR        = 1.5 // glass
        material.extIOR        = 1.0 // air, should not be more or less than 1.0
        
        switch globalMaterialObject {
        case 0:  material.type = uint(MATERIAL_PLASTIC)
        case 1:  material.type = uint(MATERIAL_CONDUCTOR)
        case 2:  material.type = uint(MATERIAL_DIELECTRIC)
        default: material.type = uint(MATERIAL_DIFFUSE)
        }
        
        return material
    }
    
//    // For the Metaball Object - Mirror
//    func rtMaterialMetaballObject() -> Material {
//        var material = Material()
//        material.diffuse       = simd_float3(1.0, 1.0, 1.0)
//        material.specular      = simd_float3(1.0, 1.0, 1.0)
//        material.transmittance = simd_float3(1.0, 1.0, 1.0)
//        material.emissive      = simd_float3(0.0, 0.0, 0.0)
//        material.roughness     = 0.005 // is recommended minimum value
//        material.type          = uint(MATERIAL_CONDUCTOR)
//        material.intIOR        = 1.5 // glass
//        material.extIOR        = 1.0 // air, should not be more or less than 1.0
//        return material
//    }
    
    
    //        // Reflective Mirror Red
    //        var material2 = Material()
    //        material2.diffuse       = simd_float3(1.0, 0.0, 0.0) // red
    //        material2.specular      = simd_float3(1.0, 0.0, 0.0)
    //        material2.transmittance = simd_float3(1.0, 1.0, 1.0)
    //        material2.emissive      = simd_float3(0.0, 0.0, 0.0)
    //        material2.roughness     = 0.005 // is recommended minimum value
    //        material2.type          = uint(MATERIAL_CONDUCTOR)
    //        material2.intIOR        = 1.5 // glass
    //        material2.extIOR        = 1.0 // air, should not be more or less than 1.0
    //        materialData.append(material2)
    
    
    
    
}
