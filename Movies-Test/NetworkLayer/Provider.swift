//
//  Alamo.swift
//  AlamofireNetworkingTemp
//
//  Created by Amr Fawaz on 02/06/2023.
//

import Foundation
import Alamofire
import MBProgressHUD

/// - Parameter allHostsMustBeEvaluated: it configures certificate pinning behaviour
/// if true: Alamofire will only allow communication with hosts defined in evaluators and matching defined Certificates.
/// if false: Alamofire will check certificates only for hosts defined in evaluators dictionary. Communication with other hosts than defined will not use Certificate pinning
#if DEBUG
let allHostsMustBeEvaluated = false
#else
let allHostsMustBeEvaluated = false
#endif


enum ParamEncoding{
    case urlEncodingDefault
    case jsonEncodingDefault
    case queryString
}
enum HeaderType: String{
    case authorization = "Authorization"
    case yodawiSignature = "X-Yodawy-Signature"
    case specialFormat = "special-format"
    case accept = "Accept"
    case contentType = "Content-Type"
}
protocol Service {
    func  getRequest<ExpectedParsedJsonType: Decodable, ExpectedParsedErrorJsonType: Decodable>(url: String,
                                                        _: ExpectedParsedJsonType.Type,
                                                        _: ExpectedParsedErrorJsonType.Type,
                                                        headers: HTTPHeaders,
                                                        params: [String: Any],
                                                        parameterEncoding: ParamEncoding,
                                                        validationRange: Range<Int>,
                                                        userConcernedErrorCodes: Range<Int>,
                                                        showProgressBar: Bool,
                                                        completion: @escaping (ExpectedParsedJsonType?, ExpectedParsedErrorJsonType?)->())
    func postRequest<ExpectedParsedJsonType: Decodable>(url: String,
                                                        withExpectedResponseOfType: ExpectedParsedJsonType.Type,
                                                        headers: HTTPHeaders,
                                                        parameters: [String: Any],
                                                        parameterEncoding: ParamEncoding,
                                                        validationRange: Range<Int>,
                                                        userConcernedErrorCodes: Range<Int>,
                                                        showProgressBar: Bool,
                                                        completion: @escaping (ExpectedParsedJsonType?)->())
}

struct Provider: Service {
    
    private var defaultHeaders: HTTPHeaders = [:]
    private let jsonEncodingDefault = JSONEncoding.default
    private let urlEncodingDefault = URLEncoding.default
    private let session: Session
    private var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
//    private let pinnedCertificates =  PinnedCertificatesTrustEvaluator(certificates: [Certificates.neqabtyProduction], acceptSelfSignedCertificates: false, performDefaultValidation: true, validateHost: true)
    private let pinnedPublicKeys = PublicKeysTrustEvaluator(
        performDefaultValidation: true, validateHost: true)
//    private let certificates: [String: ServerTrustEvaluating]
    private let publicKey: [String: ServerTrustEvaluating]

    func buildHeaders(headerDictionary: [HeaderType: String])-> HTTPHeaders{
        var headers = HTTPHeaders()
        for (key, value) in headerDictionary {
            headers.add(name: key.rawValue, value: value)
        }
        return headers
    }
    init() {
//        certificates = ["seha.neqabty.com": pinnedCertificates, "community.neqabty.com": pinnedCertificates]
        publicKey = ["seha.neqabty.com": pinnedPublicKeys, "community.neqabty.com": pinnedPublicKeys]
        _ = ServerTrustManager(
            allHostsMustBeEvaluated: allHostsMustBeEvaluated,
            evaluators: publicKey
        )
        
        session = Session()
    }
    private func alamofireRequestWith(url: String,
                                      method: HTTPMethod = .get,
                                      headers: HTTPHeaders = [:],
                                      params: [String: Any] = [:],
                                      parameterEncoding: ParamEncoding = .urlEncodingDefault,
                                      vaildationRange: Range<Int> = 200..<299,
                                      userConcernedErrorCodes: Range<Int> = 300..<599,
                                      showProgressBar: Bool = true,
                                      completion: @escaping (_ response: Data?, _ error: Data?)->()){
        guard isInternetAvailable else {
            //            showMessage(message: )
            UIApplication.shared.keyWindow?.rootViewController?.showAlert(title: "فشل بالاتصال",message: "من فضلك قم بالاتصال بالإنترنت ثم حاول مجددا",action: UIAlertAction(title: "حسنا", style: .cancel, handler: { _ in
                alamofireRequestWith(url: url,
                                     method: method,
                                     headers: headers,
                                     params: params,
                                     parameterEncoding: parameterEncoding,
                                     vaildationRange: vaildationRange,
                                     userConcernedErrorCodes: userConcernedErrorCodes,
                                     completion: completion)
            }))
            return
        }
        ShowActivityIndicatorInStatusBar(shouldShowHUD: showProgressBar)
        
        session.request(url,method: method, parameters: params, encoding: getParamEncoding(param: parameterEncoding), headers: headers)
            .validate(statusCode: vaildationRange)
            .responseJSON { response in
                self.HideActivityIndicatorInStatusBar(shouldShowHUD: showProgressBar)
                switch response.result {
                case .success:
                    //                                    print(String(data: response.request!.httpBody ?? Data(), encoding: String.Encoding.utf8))
                    
                    switch response.result {
                    case .success(_):
                        completion(response.data, nil)
                    case .failure:
                        completion(response.data, nil)
                    }
                    
                    
                case.failure(let error):
                    safeLog(error)
                    guard let statusCode = response.response?.statusCode else {
                        completion(nil, nil)
                        return
                    }
                     userConcernedErrorCodes.contains(statusCode) ?
                    completion(nil, response.data) : completion(response.data, nil)
                }
            }
    }
    func getParamEncoding(param: ParamEncoding)-> ParameterEncoding {
        switch param {
        case .urlEncodingDefault:
            return URLEncoding.default
        case.jsonEncodingDefault:
            return JSONEncoding.default
        case.queryString:
            return URLEncoding.queryString
        }
    }
    func parseJSON<ParsedResponseType: Decodable>(response: Data) -> ParsedResponseType? {
        do {
            let parsedResponse: ParsedResponseType = try JSONDecoder().decode(ParsedResponseType.self, from: response)
            return parsedResponse
            
        } catch(let err) {
            safeLog("json parsing error: ", err)
        }
        
        return nil
    }
    func getRequest<ExpectedParsedJsonType: Decodable, ExpectedParsedErrorJsonType: Decodable>(url: String,
                                                       _: ExpectedParsedJsonType.Type,
                                                       _: ExpectedParsedErrorJsonType.Type,
                                                       headers: HTTPHeaders ,
                                                       params: [String: Any] = [:],
                                                       parameterEncoding: ParamEncoding = .urlEncodingDefault,
                                                       validationRange: Range<Int> = 200 ..< 299,
                                                       userConcernedErrorCodes: Range<Int> = 300 ..< 599,
                                                       showProgressBar: Bool = true,
                                                       completion: @escaping (ExpectedParsedJsonType?, ExpectedParsedErrorJsonType?)->()) {
        alamofireRequestWith(url: url,
                             method: .get,
                             headers: headers.isEmpty ? defaultHeaders: headers,
                             params: params,
                             vaildationRange: validationRange,
                             userConcernedErrorCodes: userConcernedErrorCodes,
                             showProgressBar: showProgressBar) { responseData, errorData  in
            guard let responseData = responseData else {
                
                guard let errorData = errorData else {
                    return completion(nil, nil)
                }

                let errorObj: ExpectedParsedErrorJsonType? = self.parseJSON(response: errorData)
                completion(nil, errorObj)
                return
            }
            let parsedObj: ExpectedParsedJsonType? = self.parseJSON(response: responseData)
            completion(parsedObj, nil)
        }
    }
    
    func postRequest<ExpectedParsedJsonType: Decodable>(url: String,
                                                        withExpectedResponseOfType: ExpectedParsedJsonType.Type,
                                                        headers: HTTPHeaders ,
                                                        parameters: [String: Any] = [:],
                                                        parameterEncoding: ParamEncoding = .urlEncodingDefault,
                                                        validationRange: Range<Int> = 200 ..< 299,
                                                        userConcernedErrorCodes: Range<Int> = 300 ..< 599,
                                                        showProgressBar: Bool = true,
                                                        completion: @escaping (ExpectedParsedJsonType?)->()) {
        
        alamofireRequestWith( url: url,
                              method: .post,
                              headers: headers.isEmpty ? defaultHeaders: headers,
                              params: parameters,
                              parameterEncoding: parameterEncoding,
                              vaildationRange: validationRange,
                              userConcernedErrorCodes: userConcernedErrorCodes,
                              showProgressBar: showProgressBar) { responseData, errorData  in
            //                                print(responseData ?? "")
            guard let responseData = responseData else {
                if let errorData = errorData{
                    let parsedObj: ExpectedParsedJsonType? = self.parseJSON(response: errorData)
                    completion(parsedObj)
                    return
                }
                completion(nil)
                return
            }
            let parsedObj: ExpectedParsedJsonType? = self.parseJSON(response: responseData)
            completion(parsedObj)
        }
    }
    
    func uploadMultiPartRequest<ExpectedParsedJsonType: Decodable>(url: String,
                                                                   withExpectedResponseOfType: ExpectedParsedJsonType.Type,
                                                                   headers: HTTPHeaders = [:],
                                                                   images: [Data],
                                                                   imageParamKey: String,
                                                                   parameters: [String: Any] = [:],
                                                                   parameterEncoding: ParamEncoding = .jsonEncodingDefault,
                                                                   validationRange: Range<Int> = 200 ..< 300,
                                                                   showProgressBar: Bool = true,
                                                                   completion: @escaping (ExpectedParsedJsonType?)->()) {
        
        
        
        ShowActivityIndicatorInStatusBar(shouldShowHUD: showProgressBar)
        
        
        AF.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in images {
                multipartFormData.append(imageData, withName: imageParamKey, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append(((value) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url,
        headers:headers.isEmpty ? defaultHeaders: headers)
        .validate(statusCode: validationRange)
        .responseJSON { response in
            self.HideActivityIndicatorInStatusBar(shouldShowHUD: showProgressBar)
            //            response.data?.printJSON()
            switch response.result {
            case .success:
                guard let responseData = response.data else {
                    completion(nil)
                    return
                }
                let parsedObj: ExpectedParsedJsonType? = self.parseJSON(response: responseData)
                completion(parsedObj)
            case.failure(let error):
                safeLog(error)
                completion(nil)
                
            }
        }
    }
    
    func ShowActivityIndicatorInStatusBar( shouldShowHUD : Bool ) {
        
        if shouldShowHUD{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            guard let window = UIApplication.shared.keyWindow else {return}
            let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
            progressHUD.animationType = .fade
            progressHUD.bezelView.color = #colorLiteral(red: 0.07685596447, green: 0.07685596447, blue: 0.07685596447, alpha: 1)
            progressHUD.bezelView.style = .solidColor
            progressHUD.contentColor = .white
            progressHUD.mode = .indeterminate
            //            progressHUD.label.text = "Loading..."
        }
    }
    
    func HideActivityIndicatorInStatusBar(shouldShowHUD : Bool) {
        if shouldShowHUD{
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
        }
    }
    
}

class WildcardServerTrustPolicyManager: ServerTrustManager {
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        if let policy = evaluators[host] {
            return policy
        }
        var domainComponents = host.split(separator: ".")
        if domainComponents.count > 2 {
            domainComponents[0] = "*"
            let wildcardHost = domainComponents.joined(separator: ".")
            return evaluators[wildcardHost]
        }
        return nil
    }
}
//func showMessage(message: String){
//    let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
//    hud.mode = .text
//    hud.isUserInteractionEnabled = false
//    hud.label.text = message
//    hud.label.font = UIFont(name: FONT_CAIRO_REGULAR, size: 13)
//    hud.margin = 10
//    hud.offset.y = 150
//    hud.hide(animated: true, afterDelay: 1.5)
//    hud.removeFromSuperViewOnHide = true
//    print(message)
//}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        safeLog("=======================================")
        safeLog(self)
        safeLog("=======================================")
        #endif
        return self
    }
}
extension Data
{
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            #if DEBUG
            safeLog(JSONString)
            #endif
        }
    }
}
func safeLog(_ items: Any..., separator: String = " ", terminator: String = "\n"){
    #if DEBUG
    debugPrint(items)
    #endif
}
