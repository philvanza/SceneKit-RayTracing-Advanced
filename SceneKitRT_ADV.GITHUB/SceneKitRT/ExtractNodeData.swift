//
//  ExtractNodeData.swift
//  SceneKit RT
//
//  Created by Philipp Zay on 16.04.22.
//

import SceneKit

extension ViewController {
    
    // Use this for built-in geometry objects
    func extractNodeData16(
            _ q:SCNNode,
            _ vertex: inout [SCNVector3],
            _ normal: inout [SCNVector3],
            _ texture: inout [SIMD2<Float>],
            _ indices: inout [UInt32])
        {
            
            func offloadV3(_ sourceIndex:Int, _ destination: inout [SCNVector3]) {
                let vdata = q.geometry!.sources[sourceIndex].vertices
                for i in 0 ..< vdata.count {
                    destination.append(SCNVector3(vdata[i].x,vdata[i].y,vdata[i].z))
                }
            }
            
            func offloadV2(_ sourceIndex:Int, _ destination: inout [simd_float2]) {
                let vdata = q.geometry!.sources[sourceIndex].vertices
                for i in 0 ..< vdata.count {
                    destination.append(SIMD2<Float>(Float(vdata[i].x),Float(vdata[i].y)))
                }
            }
            
            offloadV3(0,&vertex)
            offloadV3(1,&normal)
            offloadV2(2,&texture)
            
            let idata = q.geometry!.elements[0]
            let numBytes = idata.data.count
            let numInts = numBytes / idata.bytesPerIndex
            let vectorData = UnsafeMutablePointer<UInt16>.allocate(capacity:numInts)
            let buffer = UnsafeMutableBufferPointer(start: vectorData, count: numBytes)
            idata.data.copyBytes(to: buffer, from: 0 ..< numBytes)
            for i in stride(from: 0, to: numInts, by:1) { indices.append(UInt32(vectorData[i])) }
            
            for i in 0 ... 2 {
                let data = q.geometry!.sources[i]
                print("source ",i," = ",data.semantic.rawValue  ," #vectors: ",data.vectorCount," shape: ",data.componentsPerVector,"  width: ",data.bytesPerComponent)
                print(data)
            }
    }
    
    // Use this for triangulated, imported geometry objects
    func extractNodeData32(
            _ q:SCNNode,
            _ vertex: inout [SCNVector3],
            _ normal: inout [SCNVector3],
            _ texture: inout [SIMD2<Float>],
            _ indices: inout [UInt32])
        {
            
            func offloadV3(_ sourceIndex:Int, _ destination: inout [SCNVector3]) {
                let vdata = q.geometry!.sources[sourceIndex].vertices
                for i in 0 ..< vdata.count {
                    destination.append(SCNVector3(vdata[i].x,vdata[i].y,vdata[i].z))
                }
            }
            
            func offloadV2(_ sourceIndex:Int, _ destination: inout [simd_float2]) {
                let vdata = q.geometry!.sources[sourceIndex].vertices
                for i in 0 ..< vdata.count {
                    destination.append(SIMD2<Float>(Float(vdata[i].x),Float(vdata[i].y)))
                }
            }
            
            offloadV3(0,&vertex)
            offloadV3(1,&normal)
            offloadV2(2,&texture)
            
            let idata = q.geometry!.elements[0]
            let numBytes = idata.data.count
            let numInts = numBytes / idata.bytesPerIndex
            let vectorData = UnsafeMutablePointer<UInt32>.allocate(capacity:numInts)
            let buffer = UnsafeMutableBufferPointer(start: vectorData, count: numBytes)
            idata.data.copyBytes(to: buffer, from: 0 ..< numBytes)
            for i in stride(from: 0, to: numInts, by:1) { indices.append(UInt32(vectorData[i])) }
            
            for i in 0 ... 2 {
                let data = q.geometry!.sources[i]
                print("source ",i," = ",data.semantic.rawValue  ," #vectors: ",data.vectorCount," shape: ",data.componentsPerVector,"  width: ",data.bytesPerComponent)
                print(data)
            }
    }
    
}

// https://stackoverflow.com/questions/17250501/extracting-vertices-from-scenekit
// https://stackoverflow.com/questions/59024564/extracting-vertices-from-scenekit-ios13-swift-5
extension SCNGeometrySource {
    var vertices: [SCNVector3] {
        let stride = self.dataStride
        let offset = self.dataOffset
        let componentsPerVector = self.componentsPerVector
        let bytesPerVector = componentsPerVector * self.bytesPerComponent

        func vectorFromData<FloatingPoint: BinaryFloatingPoint>(_ float: FloatingPoint.Type, index: Int) -> SCNVector3 {
            assert(bytesPerComponent == MemoryLayout<FloatingPoint>.size)
            let vectorData = UnsafeMutablePointer<FloatingPoint>.allocate(capacity: componentsPerVector)
            let buffer = UnsafeMutableBufferPointer(start: vectorData, count: componentsPerVector)
            let rangeStart = index * stride + offset
            self.data.copyBytes(to: buffer, from: rangeStart..<(rangeStart + bytesPerVector))
            return SCNVector3(
                CGFloat.NativeType(vectorData[0]),
                CGFloat.NativeType(vectorData[1]),
                CGFloat.NativeType(vectorData[2])
            )
        }

        let vectors = [SCNVector3](repeating: SCNVector3Zero, count: self.vectorCount)
        return vectors.indices.map { index -> SCNVector3 in
            switch bytesPerComponent {
            case 4:
                return vectorFromData(Float32.self, index: index)
            case 8:
                return vectorFromData(Float64.self, index: index)
            // case 16:
                // return vectorFromData(Float80.self, index: index)
            default:
                return SCNVector3Zero
            }
        }
    }
}

// NOT USED
// https://stackoverflow.com/questions/29562618/scenekit-extract-data-from-scngeometryelement
//extension SCNGeometryElement {
//
//    func getVertices() -> [SCNVector3] {
//
//        func vectorFromData<UInt: BinaryInteger>(_ float: UInt.Type, index: Int) -> SCNVector3 {
//            assert(bytesPerIndex == MemoryLayout<UInt>.size)
//            let vectorData = UnsafeMutablePointer<UInt>.allocate(capacity: bytesPerIndex)
//            let buffer = UnsafeMutableBufferPointer(start: vectorData, count: primitiveCount)
//            let stride = 3 * index
//            self.data.copyBytes(to: buffer, from: stride * bytesPerIndex..<(stride * bytesPerIndex) + 3)
//            return SCNVector3(
//                CGFloat.NativeType(vectorData[0]),
//                CGFloat.NativeType(vectorData[1]),
//                CGFloat.NativeType(vectorData[2])
//            )
//        }
//
//        let vectors = [SCNVector3](repeating: SCNVector3Zero, count: self.primitiveCount)
//        return vectors.indices.map { index -> SCNVector3 in
//            switch bytesPerIndex {
//                case 2:
//                    return vectorFromData(Int16.self, index: index)
//                case 4:
//                    return vectorFromData(Int.self, index: index)
//                case 8:
//                    return SCNVector3Zero
//                default:
//                    return SCNVector3Zero
//            }
//        }
//    }
//}
