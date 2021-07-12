//
//  ViewController.swift
//  Swift iOS Concurrency
//
//  Created by Andrew Jaffee on 6/17/21.
/*
 
 Copyright (c) 2021 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageViewStellar: UIImageView!
    @IBOutlet weak var counterTextField: UITextField!
    var counter: Int = 0
    var images:[UIImage] = []
    
    // NASA images used pursuant to https://www.nasa.gov/multimedia/guidelines/index.html
    let imageURLs: [String] = ["https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1509a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1501a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1107a.jpg",
       "https://cdn.spacetelescope.org/archives/images/large/heic0715a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1608a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/potw1345a.jpg",
       "https://cdn.spacetelescope.org/archives/images/large/heic1307a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0817a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/opo0328a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0506a.jpg",
       "https://cdn.spacetelescope.org/archives/images/large/heic0503a.jpg",
       "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1509a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1501a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1107a.jpg",
          "https://cdn.spacetelescope.org/archives/images/large/heic0715a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic1608a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/potw1345a.jpg",
          "https://cdn.spacetelescope.org/archives/images/large/heic1307a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0817a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/opo0328a.jpg",
          "https://cdn.spacetelescope.org/archives/images/publicationjpg/heic0506a.jpg",
          "https://cdn.spacetelescope.org/archives/images/large/heic0503a.jpg"]

    // NASA images used pursuant to https://www.nasa.gov/multimedia/guidelines/index.html
    let imageAltURLs: [String] = ["https://esahubble.org/media/archives/images/original/heic1712a.tif",
        "https://cdn.spacetelescope.org/archives/images/large/opo0328a.jpg",
        "https://cdn.spacetelescope.org/archives/images/screen/heic1917a.jpg",
        "https://cdn.spacetelescope.org/archives/images/large/heic1520a.jpg",
        "https://cdn.spacetelescope.org/archives/images/screen/potw1714a.jpg",
        "https://cdn.spacetelescope.org/archives/images/large/potw1751a.jpg"]
    
    // This is a SYNCHRONOUS method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        counter = 0;
        counterTextField.text = "0"

    } // end func viewDidLoad()

    // MARK: GCD example

    // example of GCD asynchronous code; as
    // soon as an image download is queued, control
    // flows immediately onwards
    func downloadImageGCD(for url: String, with index:Int) -> Void {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            _ = self.isCodeOnMainThread(named: "start GCD image \(index) downloading...")
            let imageURL = URL(string: url)
            // this call blocks until the image data is downloaded,
            // BUT we're running in the background
            let imageData = NSData(contentsOf: imageURL!)
            // convert the data into an image
            let image = UIImage(data: imageData! as Data)
            
            DispatchQueue.main.async {
                self.imageViewStellar.image = image
                self.imageViewStellar.setNeedsDisplay()
                print("GCD image \(index) downloaded/displayed")
            }
            
        } // end DispatchQueue.global(qos: ...
        
    } // end func downloadImageGCD
    
    // This is a SYNCHRONOUS method that
    // makes use of GCD's concurrency support
    func startGCDAsyncImageDownload()
    {
        for index in 0..<imageURLs.count
        {
            downloadImageGCD(for: imageURLs[index], with: index)
        }
    } // end func startGCDAsyncImageDownload()
    
    // MARK: async/await examples

    enum HTTPError : Error {
        case withIdentifier(_ statusCode: Int)
    }

    // This is an ASYNCHRONOUS method. It
    // suspends while waiting for an image to
    // download. Other work can be
    // done during the await.
    func downloadImageAsync(for url: String, with index:Int) async throws -> UIImage {
        
        _ = isCodeOnMainThread(named: "start awaitable image \(index) downloading...")
        let request = URLRequest(url: URL(string: url)!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw HTTPError.withIdentifier((response as! HTTPURLResponse).statusCode) }
        let downloadedImage = UIImage(data: data)
        return downloadedImage!
        
    } // end func downloadImageAsync
    
    // this method is a misguided attempt to
    // call a bunch of blocking calls all at once
    func startWrongNewAsyncImageDownload()
    {
        
        async {
            
            for index in 0..<imageURLs.count {
                let url = imageURLs[index]
                let downloadedImage = try! await self.downloadImageAsync(for: url, with: index)
                imageViewStellar.image = downloadedImage
                print("awaitable image \(index) downloaded/displayed")
            }
            
        } // end async
        
    } // end func startWrongNewAsyncImageDownload()
    
    // these downloads occur SEQUENTIALLY because we
    // start each download with the "await" keyword
    func startRightNewSimpleSyncImageDownload() async -> Void {
        
        let stellarImage0 = try! await downloadImageAsync(for: imageURLs[0], with: 0)
        let stellarImage1 = try! await downloadImageAsync(for: imageURLs[1], with: 1)
        let stellarImage2 = try! await downloadImageAsync(for: imageURLs[2], with: 2)

        _ = isCodeOnMainThread(named: "startRightNewAsyncImageDownload")
        
        // no await is needed
        updateImageView(with: stellarImage0)
        print("stellarImage0 with index 0 downloaded")
        updateImageView(with: stellarImage1)
        print("stellarImage1 with index 1 downloaded")
        updateImageView(with: stellarImage2)
        print("stellarImage2 with index 2 downloaded")

    } // end func startRightNewSimpleSyncImageDownload
    
    // each download occurs asynchronously -- even simultaneously
    func startRightNewSimpleAsyncImageDownload() async -> Void {
        
        async let stellarImage0 = try! downloadImageAsync(for: imageURLs[0], with: 0)
        async let stellarImage1 = try! downloadImageAsync(for: imageURLs[1], with: 1)
        async let stellarImage2 = try! downloadImageAsync(for: imageURLs[2], with: 2)

        _ = isCodeOnMainThread(named: "startRightNewAsyncImageDownload")
        
        updateImageView(with: await stellarImage0)
        print("stellarImage0 with index 0 downloaded")
        updateImageView(with: await stellarImage1)
        print("stellarImage1 with index 1 downloaded")
        updateImageView(with: await stellarImage2)
        print("stellarImage2 with index 2 downloaded")

    } // end func startRightNewSimpleAsyncImageDownload
    
    func startExperimentAsyncImageDownload() async -> Void {
        
//        var stellarImages: [UIImage] = []
        
        for index in 0..<imageURLs.count
        {
            print("start async download of image")
            async let stellarImage = try! downloadImageAsync(for: imageURLs[index], with: index)
            print("wait for async download of image")
            //await stellarImages.append(stellarImage)
            await updateImageView(with: stellarImage)
            print("finished waiting async download of image")
        }
        
//        for image in stellarImages {
//            updateImageView(with: image)
//        }
        
    } // end func startExperimentAsyncImageDownload

    // new Swift structured concurrency using
    // tasks and task groups
    func startTaskGroupAsyncImageDownload() async -> Void {
        
        _ = self.isCodeOnMainThread(named: "startRightNewAsyncImageDownload started")
        
        await withTaskGroup(of: UIImage.self) { taskGroup in
            
            for index in 0..<imageURLs.count {
                taskGroup.async {
                    //_ = await self.isCodeOnMainThread(named: "task for image \(index) downloading started...")
                    let downloadedImage = try! await self.downloadImageAsync(for: self.imageURLs[index], with: index)
                    return downloadedImage
                }
            }
            
            // "To collect the results of tasks that
            // were added to the group, you can use
            // the following pattern:"
            for await image in taskGroup {
                _ = self.isCodeOnMainThread(named: "task awaited image downloaded")
                // notice I didn't have to jump
                // on the main queue to update the UI
                self.imageViewStellar.image = image
                print("task awaited image displayed")
                // DispatchQueue.main.async {
                //      self.imageViewStellar.image = downloadedImage
                // }
            }
            
        } // end withTaskGroup

    } // end func startTaskGroupAsyncImageDownload()
            
    // MARK: Utilities
    
    // always update the UI on the MAIN thread
    func updateImageView(with image: UIImage) -> Void {
        DispatchQueue.main.async {
            self.imageViewStellar.image = image
            self.imageViewStellar.setNeedsDisplay()
        }
    }
    
    // running on main thread or background thread?
    func isCodeOnMainThread(named codeDescription:String) -> Bool {
        if Thread.isMainThread {
            print("\(codeDescription) ON MAIN THREAD")
            return true
        } else {
            print("\(codeDescription) ON BACKGROUND THREAD")
            return false
        }
    }
    
    // MARK: User interactions
    
    // This is a SYNCHRONOUS method that calls GCD
    @IBAction func startGCDDownloadingButtonClicked(_ sender: Any) {
        
        counter = 0;
        counterTextField.text = "0"
        imageViewStellar.image = nil
        
        startGCDAsyncImageDownload()
                
    } // end func startGCDDownloadingButtonClicked
    
    // This is a SYNCHRONOUS method that can call
    // ASYNCHRONOUS methods
    @IBAction func startImproperAwaitableDownloadingButtonClicked(_ sender: Any) {
        
        counter = 0;
        counterTextField.text = "0"
        imageViewStellar.image = nil
        
        // awkward use of async/await
        startWrongNewAsyncImageDownload()
        
    } // end func startImproperAwaitableDownloadingButtonClicked
      
    // This is a SYNCHRONOUS method that can call
    // ASYNCHRONOUS methods
    @IBAction func startProperAwaitableDownloadingButtonClicked(_ sender: Any) {

        counter = 0;
        counterTextField.text = "0"
        imageViewStellar.image = nil
        
        async {
            
            let image = try! await downloadImageAsync(for: imageAltURLs[0], with: 0)
            updateImageView(with: image)
            print("GIANT FILE FINALLY DOWNLOADED")
            //await startRightNewSimpleSyncImageDownload()
            //await startRightNewSimpleAsyncImageDownload()
            //await startExperimentAsyncImageDownload()
            //await startTaskGroupAsyncImageDownload()
        }

    } // end startProperAwaitableDownloadingButtonClicked
    
    // increment the counter and display the updated
    // value on screen; this is SYNCHRONOUS
    @IBAction func incrementBtnClicked(_ sender: Any) {
        counter += 1;
        counterTextField.text = String(counter)
    }
    
} // end class ViewController
