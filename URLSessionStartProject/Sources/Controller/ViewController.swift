//
//  ViewController.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29.11.2021.
//

import UIKit

final class ViewController: UIViewController {

    @IBAction func TapButton(_ sender: Any) {
        executeCall()
    }
    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<Cards> = { result, response in
            guard let responseUnwrapped = response else { return }

            //print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let card):
                for i in 0..<min(5, card.cards.count) {
                    let card = card.cards[i]
                    print("Name card: \(card.name ?? "")")
                    print("Artist: \(card.artist ?? "")")
                    print("ManaCost: \(card.manaCost ?? "")")
                    print("SetName: \(card.setName ?? "")")
                    print("Type: \(card.type ?? "") \n")
                }
                
            case .failure(let error):
                print(error)
            }
        }
        endpointClient.executeRequest(endpoint, completion: completion)
    }
}

final class GetNameEndpoint: ObjectResponseEndpoint<Cards> {
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/cards" }
//    override var queryItems: [URLQueryItem(name: "id", value: "1")]?
    
    override init() {
        super.init()

        queryItems = [URLQueryItem(name: "name", value: "Black Lotus"),
                      //URLQueryItem(name: "name", value: "Opt")
        ]
    }
}

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["cards"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}
