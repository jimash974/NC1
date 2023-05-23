//
//  SCNVector3+Extension.swift
//  hidenseek
//
//  Created by Jeremy Christopher on 23/05/23.
//


import Foundation
import SceneKit

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x:left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func *(left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3(x:left.x * right, y: left.y * right, z: left.z * right)
}

func +=( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}
