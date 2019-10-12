import Flutter
import UIKit


public class SwiftNativeHttpRequestPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_http_request", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeHttpRequestPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   print("startt")
   //create the url with NSURL
   let url = URL(string: "https://raw.githubusercontent.com/boapps/e-Szivacs-2/master/README.md")! //change the url kretaglobalmobileapi.ekreta.hu

   //create the session object
   let session = URLSession.shared

   //now create the URLRequest object using the url object
   var request = URLRequest(url: url)

   //request.addValue("7856d350-1fda-45f5-822d-e1a2f3f1acf0", forHTTPHeaderField: "apiKey")
   //request.allHTTPHeaderFields?["apiKey"] = "7856d350-1fda-45f5-822d-e1a2f3f1acf0"
   //print("Header : \(String(describing: request.allHTTPHeaderFields))")

    print("test")
   //create dataTask using the session object to send data to the server
   let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in


       guard error == nil else {
           return
       }

       guard let data = data else {
           return
       }
        if let response = response as? HTTPURLResponse {
            print("statusCode: \(response.statusCode)")
        }

      do {
          print("do")

        DispatchQueue.main.async {

            print(data)
            result(data)
        }
      } catch let error {
        DispatchQueue.main.async {
            print(data)
            result(data)
        }
      }
   })

   task.resume()

    //result("iOS " + UIDevice.current.systemVersion)
  }
}
