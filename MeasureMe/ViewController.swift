//
//  ViewController.swift
//  MeasureMe
//
//  Created by Macbook on 31/08/2017.
//  Copyright © 2017 Chappy-App. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
	
	@IBOutlet weak var targetView: UIView!
	@IBOutlet weak var measurementLabel: UILabel!
	@IBOutlet weak var theButton: UIButton!
     @IBOutlet var sceneView: ARSCNView!
	
	var firstBox: SCNNode?
	var secondBox: SCNNode?
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
	
        measurementLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
	
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
	@IBAction func buttonTapped(_ sender: Any) {
		
		if firstBox == nil {
			firstBox = addBox()
			if firstBox != nil {
				
			theButton.setTitle("Set End Point", for: .normal)
				
			}
		} else if secondBox == nil {
			secondBox = addBox()
			
			if secondBox != nil {
				calcDistance()
				theButton.setTitle("Reset", for: .normal)
			}
			
		} else {
			firstBox?.removeFromParentNode()
			secondBox?.removeFromParentNode()
			firstBox = nil
			secondBox = nil
			measurementLabel.text = ""
			theButton.setTitle("Set Start Point", for: .normal)
		}
		
	}
	
	func calcDistance() {
		
		if let firstBox = firstBox {
			if let secondBox = secondBox {
				
		let vector = SCNVector3Make(secondBox.position.x - firstBox.position.x,
		                            secondBox.position.y - firstBox.position.y,
		                            secondBox.position.z - firstBox.position.z)
		
		let distance = sqrt(vector.x*vector.x+vector.y*vector.y+vector.z*vector.z)
		measurementLabel.text = "\(distance)m"
				
		}
	}
}
	func addBox() -> SCNNode? {
		
		let userTouch = sceneView.center
		let testResults = sceneView.hitTest(userTouch, types: .featurePoint)
		
		if let theResult = testResults.first {
			let box = SCNBox(width: 0.002, height: 0.0, length: 0.002, chamferRadius: 0.0)
			let material = SCNMaterial()
			material.diffuse.contents = UIColor.green
			box.firstMaterial = material
			
			let boxNode = SCNNode(geometry: box)
			boxNode.position = SCNVector3(theResult.worldTransform.columns.3.x,theResult.worldTransform.columns.3.y,theResult.worldTransform.columns.3.z)
			sceneView.scene.rootNode.addChildNode(boxNode)
			return boxNode
		}
		
		return nil
	}
	
	override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
	
}
