//
//  SingViewController.swift
//  PerfPitch
//
//  Created by Richard Su on 10/17/15.
//  Copyright © 2015 Richard Su. All rights reserved.
//

import UIKit
import AVFoundation

class SingViewController: UIViewController {

	var pitchIndex = 0
	var count = 2
	var recordingTime = 1000
	var countdownTimer: NSTimer!
	var recordingTimer: NSTimer!
	var audioRecorder: AVAudioRecorder!
	let filename = "recording.wav"
	var fileString: NSString!
	var audioPlayer: AVAudioPlayer!
	var pianoSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("C4", ofType: "wav")!)
	let pitches = ["C","C#/D♭","D","D#/E♭","E","F","F#/G♭","G","G#/A♭","A","A#/B♭","B"]
	let numberToSound = ["C","C#D♭","D","D#E♭","E","F","F#G♭","G","G#A♭","A","A#B♭","B"]
	var recorded = false
	var recordedSound: NSURL!
	var recordPlayer: AVAudioPlayer!
	let session = AVAudioSession.sharedInstance()

	
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var bottomLabel: UILabel!
	@IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var micButton: UIButton!
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var recordTop: UIImageView!
	@IBOutlet weak var recordMiddle: UIImageView!
	@IBOutlet weak var recordBack: UIImageView!
	
	@IBAction func reset()
	{
		self.viewDidLoad()
	}
	
	@IBAction func startRecordingOrPlayback(sender: UIButton)
	{
		if !recorded
		{
			bottomLabel.text = "Get ready to sing..."
			sender.hidden = true
			recordingLabel.hidden = false
			count = 2
			countdownTimer = NSTimer.scheduledTimerWithTimeInterval(0.75, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
		}
		else
		{
			recordPlayer.play()
			while recordPlayer.playing
			{
			}
			audioPlayer.play()
		}
	}
	
	func updateTimer()
	{
		print("boom")
		if count > 0
		{
			recordingLabel.text = String(count--)
		}
		else
		{
			recordingLabel.hidden = true
			bottomLabel.text = "SING NOW!"
			countdownTimer.invalidate()
			hearDatSingin()
		}
	}
	
	func hearDatSingin()
	{
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		let pathArray = [dirPath, filename]
		let filePath = NSURL.fileURLWithPathComponents(pathArray)
		print(filePath)
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
		try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		recordingTime = 115
		audioRecorder.record()
		recordTop.hidden = false
		recordMiddle.hidden = false
		recordBack.hidden = false
		recordingTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("recordingLimit"), userInfo: nil, repeats: true)
	}
	
	func recordingLimit()
	{
		if recordingTime > 0
		{
			recordingTime--
			recordMiddle.frame = CGRectMake(recordTop.frame.origin.x, recordTop.frame.origin.y, recordTop.frame.width, CGFloat(recordingTime * 2));
		}
		else
		{
			recordTop.hidden = true
			recordMiddle.hidden = true
			recordBack.hidden = true
			recordingTimer.invalidate()
			audioRecorder.stop()
			audioRecorder = nil
			bottomLabel.text = "Done!"
			try! session.setCategory(AVAudioSessionCategoryPlayback)
			checkPitch()
		}
	}
	
	func checkPitch()
	{
		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
		let pathArray = [dirPath, filename]
		let filePath = NSURL.fileURLWithPathComponents(pathArray)
		recordedSound = filePath
		do
		{
			print(recordedSound)
			recordPlayer = try AVAudioPlayer(contentsOfURL: recordedSound, fileTypeHint: nil)
			recordPlayer.prepareToPlay()
		}
		catch
		{
			print("Audio Player is nil")
		}
		topLabel.text = "Now let's compare."
		recorded = true
		micButton.hidden = false
		micButton.setImage(UIImage(named: "playButton"), forState: UIControlState.Normal)
		bottomLabel.text = "Tap play to listen again!"
		resetButton.hidden = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pitchIndex = Int(arc4random_uniform(UInt32(pitches.count)))
		if pitchIndex == 4 || pitchIndex == 5 || pitchIndex == 6 || pitchIndex == 9 || pitchIndex == 10
		{
			topLabel.text = "Sing an \(pitches[pitchIndex])!"
		}
		else
		{
			topLabel.text = "Sing a \(pitches[pitchIndex])!"
		}
		bottomLabel.text = "Tap the mic to begin!"
		micButton.userInteractionEnabled = true
		micButton.setImage(UIImage(named: "mic"), forState: UIControlState.Normal)
		recordTop.hidden = true
		recordMiddle.hidden = true
		recordBack.hidden = true
		recordingLabel.text = "3"
		recordingLabel.hidden = true
		resetButton.hidden = true
		recorded = false
		print(pitches[pitchIndex])
		pianoSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(numberToSound[pitchIndex] + "4", ofType: "wav")!)
		do
		{
			print(pianoSound)
			audioPlayer = try AVAudioPlayer(contentsOfURL: pianoSound, fileTypeHint: nil)
			audioPlayer.prepareToPlay()
		}
		catch
		{
			print("Audio Player is nil")
		}
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle
	{
		return .LightContent
	}


}

