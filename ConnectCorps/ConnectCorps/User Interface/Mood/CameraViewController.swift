//
//  CameraViewController.swift
//

import UIKit
import AVFoundation
import Alamofire

class CameraViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    var captureLayer: AVCaptureVideoPreviewLayer!
    var session: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!

    var detectedShake: Bool!
    var moods: [Mood]!
    var actualMood: Mood?

    var isCancelled = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            self.startCountdown()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                DispatchQueue.main.async {
                    self.startCountdown()
                }
            }
        }
    }

    func startCountdown() {
        session = AVCaptureSession()
        session.beginConfiguration()

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            actualMood = .neutral
            performSegue(withIdentifier: "summarySegue", sender: nil)
            return
        }
        let input = try! AVCaptureDeviceInput(device: device)
        session.addInput(input)

        photoOutput = AVCapturePhotoOutput()
        session.sessionPreset = .photo
        session.addOutput(photoOutput)

        session.commitConfiguration()

        captureLayer = AVCaptureVideoPreviewLayer(session: session)
        captureLayer.videoGravity = .resizeAspectFill
        captureLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(captureLayer)

        session.startRunning()

        for i in (0...5).reversed() {
            let delay = 5 - i
            let interval = DispatchTimeInterval.seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                guard !self.isCancelled else { return }
                self.timeLabel?.text = "\(i) second\(i == 1 ? "" : "s")"
                if i == 0 {
                    self.takePicture()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCancelled = true
    }

    func takePicture() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captureLayer?.frame = cameraView.layer.bounds
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SummaryViewController
        dest.detectedShake = detectedShake
        dest.moods = moods
        dest.actualMood = actualMood!
    }

}

struct ParalleldotsResponse: Decodable {
    struct Entry: Decodable {
        let tag: Mood
        let score: Double
    }
    let entries: [Entry]

    private enum CodingKeys: String, CodingKey {
        case entries = "facial_emotion"
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()!

        upload(multipartFormData: { formData in
            formData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: "http://apis.paralleldots.com/v3/facial_emotion?api_key=9qMRljk8IoqCnFC2XuZezPaQ4FVw0O5trGQnbAm9wRM", method: .post, encodingCompletion: { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .success(let req, _, _):
                req.response { resp in
                    guard let decoded = (try? resp.data.map({ try JSONDecoder().decode(ParalleldotsResponse.self, from: $0) })) ?? nil else {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        return
                    }
                    let entry = decoded.entries.filter { $0.tag != .neutral }.max { $0.score < $1.score }!
                    self.actualMood = entry.tag
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "summarySegue", sender: nil)
                    }
                }
                req.resume()
            }
        })
    }

}
