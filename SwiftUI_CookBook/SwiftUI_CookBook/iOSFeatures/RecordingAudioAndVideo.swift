/**
 Recording audio and video with SwiftUI is a breeze. With the AVFoundation framework and some SwiftUI views, you can easily capture audio and video data through your device’s microphone and camera. In this cookbook entry, you’ll learn how to use AVCaptureSession to capture audio and video, AVCaptureDeviceInput to set up inputs for the session and AVCaptureFileOutput to write a file to disk.

 Here’s an example implementation:
 */


import AVFoundation
import Photos
import SwiftUI

struct CameraPreview: UIViewRepresentable {
  @Binding var session: AVCaptureSession

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    let previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
      layer.session = session
      layer.frame = uiView.bounds
    }
  }
}

struct RecordingAudioAndVideo: View {
  @StateObject private var recorder = Recorder()

  var body: some View {
    VStack {
      CameraPreview(session: $recorder.session)
        .frame(height: 400) // Adjust the height to your needs
      HStack {
        Button(action: {
          recorder.startRecording()
        }) {
          Text("Start Recording")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .disabled(recorder.isRecording)

        Button(action: {
          recorder.stopRecording()
        }) {
          Text("Stop Recording")
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .disabled(!recorder.isRecording)
      }

      if recorder.isRecording {
        Text("Recording...")
          .foregroundColor(.red)
      }
    }
  }
}

class Recorder: NSObject, AVCaptureFileOutputRecordingDelegate, ObservableObject {
  @Published var session = AVCaptureSession() // session is now @Published
  @Published var isRecording = false
  private let movieOutput = AVCaptureMovieFileOutput()

  override init() {
    super.init()
    addAudioInput()
    addVideoInput()
    if session.canAddOutput(movieOutput) {
      session.addOutput(movieOutput)
    }
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.session.startRunning()
    }
  }

  private func addAudioInput() {
    guard let device = AVCaptureDevice.default(for: .audio) else { return }
    guard let input = try? AVCaptureDeviceInput(device: device) else { return }
    if session.canAddInput(input) {
      session.addInput(input)
    }
  }

  private func addVideoInput() {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    guard let input = try? AVCaptureDeviceInput(device: device) else { return }
    if session.canAddInput(input) {
      session.addInput(input)
    }
  }

  func startRecording() {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else { return }
    if movieOutput.isRecording == false {
      if FileManager.default.fileExists(atPath: url.path) {
        try? FileManager.default.removeItem(at: url)
      }
      movieOutput.startRecording(to: url, recordingDelegate: self)
      isRecording = true
    }
  }

  func stopRecording() {
    if movieOutput.isRecording {
      movieOutput.stopRecording()
      isRecording = false
    }
  }

  func fileOutput(_ output: AVCaptureFileOutput,
                  didStartRecordingTo fileURL: URL,
                  from connections: [AVCaptureConnection]) {
    // Handle actions when recording starts
  }

  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    // Check for recording error
    if let error = error {
      print("Error recording: \(error.localizedDescription)")
      return
    }

    // Save video to Photos
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
    }) { saved, error in
      if saved {
        print("Successfully saved video to Photos.")
      } else if let error = error {
        print("Error saving video to Photos: \(error.localizedDescription)")
      }
    }
  }
}

/**
 Here’s what’s happening in this code:

 The ContentView is a SwiftUI view that displays a CameraPreview view, which is a UIViewRepresentable wrapper around a AVCaptureVideoPreviewLayer. It also contains start and stop recording buttons, and a text view indicating the recording status.

 The Recorder class is an ObservableObject responsible for managing the AVCaptureSession and recording state. It handles adding the necessary audio and video inputs to the session, starting and stopping the recording and saving the recorded video to the Photo Library.

 init initializes the AVCaptureSession, adds audio and video inputs and starts running the session.
 addAudioInput and addVideoInput try to add an audio and a video capture device input to the session respectively.
 startRecording checks if a recording is in progress. If not, it removes any existing file at the output URL, starts recording to this URL and sets isRecording to true.
 stopRecording stops an in-progress recording and sets isRecording to false.
 fileOutput(_:didStartRecordingTo:from:) can be used to handle actions when recording starts. Currently, it’s empty in the provided code, but you could, for example, change the state of a user interface element here.
 fileOutput(_:didFinishRecordingTo:from:error:) is called when a recording ends. It checks for any errors that occurred during recording and saves the recorded video to the Photo Library.
 To test, you should run the app on a real device, as the simulator does not support camera inputs. You need to ensure you have allowed camera and microphone access in your device’s settings for this app.

 You’ll also need to add the necessary privacy permissions —NSCameraUsageDescription, NSMicrophoneUsageDescription, and NSPhotoLibraryAddUsageDescription — to Info.plist. Here’s how:

 In your Xcode project navigator, click on the Info.plist file. This file usually resides in the root of your project folder. Info.plist stands for Information Property List file and it contains key-value pairs that store the properties of your app.
 Once you have Info.plist open in the editor, right click anywhere and choose Add Row to add a new key-value pair.
 After clicking on Add Row, a new row will appear with two fields: one for the key and another for the value. Click on the key field (which may default to a suggestion like Bundle version string, short) and start typing NSCameraUsageDescription then select it when it auto-populates. If you see keys like Privacy - Camera Usage Description, you can change to Raw Keys and Values by right-clicking anywhere and selecting this option from the shortcut menu that appears.
 Now, click on the value field corresponding to the NSCameraUsageDescription key and type in a description. This is the string that will be shown to the user when the app first requests access to the camera. For example, you could put “This app requires access to the camera for video recording”.
 Repeat the process for Privacy - Microphone Usage Description and Privacy - Photo Library Usage Description, supplying the texts the user will see when your app requests access to the device’s microphone and Photo Library.
 Once these steps are complete, your app will request access to the camera and the microphone when it needs to use them, and the descriptions you entered will be displayed in the access prompt to give context to the user. This allows the user to understand why your app is requesting these permissions.

 This is a basic setup for audio and video recording in SwiftUI. It can be extended further to add features like audio and video compression, camera and microphone toggles and more.
 */

#Preview {
  RecordingAudioAndVideo()
}
