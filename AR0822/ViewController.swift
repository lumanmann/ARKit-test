//
//  ViewController.swift
//  AR0822
//
//  Created by WY NG on 22/8/2018.
//  Copyright © 2018 lumanman. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 增加一個方形到畫面
        addbox(x: 0, y: 0, z: -2)
    
        addTapGesture()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        // 進入AR畫面
        sceneView.session.run(configuration, options: options)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 離開AR畫面
        sceneView.session.pause()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addbox(x: Float, y: Float, z: Float) {
        //  chamfer ＝ 倒角
        // 也可以用 SCNShape、SCNText 等等
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode()
        boxNode.geometry = box
        // z 愈大 物件會愈近（大）
        // https://developer.apple.com/documentation/arkit/arsessionconfiguration/worldalignment/gravity
        boxNode.position = SCNVector3(x, y, z)
        // 把box加到畫面上
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    // 每點一下屏幕增加一個方形到畫面
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        // dectect tap location
        let taplocation = sender.location(in: sceneView)
        
        let hitTests = sceneView.hitTest(taplocation, options: [:])
        // 沒有東西便加一個方形到畫面
        guard let node = hitTests.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(taplocation, types: .featurePoint)
            if let hitTestResultsWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultsWithFeaturePoints.worldTransform.translation
                addbox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        // 本來有東西便把它移除
        node.removeFromParentNode()
    }
}

// float4x4 是一個矩陣
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
