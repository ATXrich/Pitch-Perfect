//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Richard Reed on 12/22/15.
//  Copyright © 2015 Richard Reed. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playbackRecording(sender: UIButton) {
        resetPlayer()
        audioPlayer.currentTime = 0
        stopButton.hidden = false
        slowButton.enabled = false
        fastButton.enabled = false
        chipmunkButton.enabled = false
        darthVaderButton.enabled = false
        
        if let playback = Playback(rawValue: sender.tag) {
            switch (playback) {
                case .slow: playAudioWithVariableSpeed(0.5)
                case .fast: playAudioWithVariableSpeed(1.5)
                case .chipmunk: playAudioWithVariablePitch(1000)
                case .darthVader: playAudioWithVariablePitch(-500)

            }
        }
        
    }

    @IBAction func stopPlayback(sender: UIButton) {
        
        resetPlayer()
        
        stopButton.hidden = true
        slowButton.enabled = true
        fastButton.enabled = true
        chipmunkButton.enabled = true
        darthVaderButton.enabled = true
    }
    
    func playAudioWithVariableSpeed(speed: Float){
        resetPlayer()
        audioPlayer.rate = speed
        audioPlayer.play()
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        resetPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func resetPlayer() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
}
