//
//  ViewController.swift
//  AntinoLabs
//
//  Created by Pavan Kalyan Jonnadula on 21/05/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var usersTableView: UITableView!
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    
    func getUsers() {
        WebService.shared.getRequest(urlString: "https://demo8716682.mockable.io/cardData") { (json, response, error) in
            let decoder = JSONDecoder()
            do {
                self.users = try decoder.decode([Users].self, from: json ?? Data())
                self.usersTableView.delegate = self
                self.usersTableView.dataSource = self
                self.usersTableView.reloadData()
            }  catch {
                print("error: ", error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell") as! UsersTableViewCell
        let iteratorUser = users[indexPath.row]
        cell.age.text = "Age : " + iteratorUser.age
        cell.location.text = iteratorUser.location
        cell.userName.text = iteratorUser.name
        let imageUrl = iteratorUser.url.replacingOccurrences(of: "http://", with: "https://")
        print("image url",imageUrl)
        cell.userImage.downloaded(from: imageUrl)
        return cell
    }

}


extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = UIImage(named: "default")
                    }
                    return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class UsersTableViewCell : UITableViewCell{
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var userImage: UIImageView!
}
