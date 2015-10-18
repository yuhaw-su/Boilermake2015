//
//  ListenViewController.swift
//  PerfPitch
//
//  Created by Richard Su on 10/17/15.
//  Copyright © 2015 Richard Su. All rights reserved.
//

import UIKit
import AVFoundation

class ListenViewController: UIViewController {

	var score = 0
	var questionCount = 0
	var audioPlayer: AVAudioPlayer!
	var pianoSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("C4", ofType: "wav")!)
	let numbersToSound = ["C","C#D♭","D","D#E♭","E","F","F#G♭","G","G#A♭","A","A#B♭","B"]
	var pitchIndex = 0
	var pitch = "C"
	var octave = 4
	var guessMade = false
	
	func nextQuestion()
	{
		pitchIndex = Int(arc4random_uniform(UInt32(numbersToSound.count)))
		pitch = numbersToSound[pitchIndex]
		octave = Int(arc4random_uniform(3)) + 3
		pianoSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(pitch + "\(octave)", ofType: "wav")!)
	}
	
	func updateScore()
	{
		scoreLabel.text = "\(score)/\(questionCount)"
	}

	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	
	@IBAction func resetScore()
	{
		score = 0
		questionCount = 0
		updateScore()
		self.viewDidLoad()
	}

	@IBAction func playPitchOrProceed()
	{
		if !guessMade
		{
			audioPlayer.play()
		}
		else
		{
			self.viewDidLoad()
		}
	}
	
	@IBAction func guessPitch(sender: UIButton)
	{
		if !guessMade
		{
			let guess = sender.titleLabel!.text!.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
			print(guess)
			if guess != pitch
			{
				sender.setBackgroundImage(UIImage(named: "redKey"), forState: UIControlState.Normal)
				topLabel.text = "Tap the note to try again!"
			}
			if guess == pitch
			{
				score += 1
				topLabel.text = "Correct, now keep going!"
			}
			(self.view.viewWithTag(pitchIndex + 1) as! UIButton).setBackgroundImage(UIImage(named: "greenKey"), forState: UIControlState.Normal)
			questionCount += 1
			guessMade = true
			updateScore()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		nextQuestion()
		guessMade = false
		topLabel.text = "Tap the note to hear the pitch!"
		
		for var i = 0; i < numbersToSound.count; ++i
		{
			var keyColor = "whiteKey"
			if (numbersToSound[i].characters.count > 1)
			{
				keyColor = "blackKey"
			}
			(self.view.viewWithTag(i+1) as! UIButton).setBackgroundImage(UIImage(named: keyColor), forState: UIControlState.Normal)
		}
		
		do
		{
			print(pianoSound)
			audioPlayer = try AVAudioPlayer(contentsOfURL: pianoSound, fileTypeHint: nil)
			audioPlayer.prepareToPlay()
			playPitchOrProceed()
		}
		catch
		{
			print("Audio Player is nil")
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle
	{
		return .LightContent
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
