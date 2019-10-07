import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    struct TotalButton {
        var title = String()
        var images = [String]()
        var label = [String]()
        var seeAllbtn = String()
    }
    @IBOutlet weak var seeAllbtn: UIButton!

    let buttons = [
        TotalButton(title:  NSLocalizedString("myBilling", comment: ""),
                    images: ["Icons_24px_AwaitingPayment",
                             "Icons_24px_AwaitingShipment",
                             "Icons_24px_Shipped",
                             "Icons_24px_AwaitingReview"],
                    label: [NSLocalizedString("waitPay", comment: ""),
                            NSLocalizedString("waitdelivery", comment: ""),
                            NSLocalizedString("waitReceive", comment: ""),
                            NSLocalizedString("waitComent", comment: "")],
                    seeAllbtn: NSLocalizedString("seeAllbtn", comment: "")),
        
        TotalButton(title: NSLocalizedString("moreService", comment: ""),
                    images: ["Icons_24px_Starred",
                             "Icons_24px_Notification",
                             "Icons_24px_Refunded",
                             "Icons_24px_Address",
                             "Icons_24px_CustomerService",
                             "Icons_24px_SystemFeedback",
                             "Icons_24px_RegisterCellphone",
                             "Icons_24px_Settings"],
                    label: [NSLocalizedString("get", comment: ""),
                            NSLocalizedString("notification", comment: ""),
                            NSLocalizedString("returnMoney", comment: ""),
                            NSLocalizedString("adress", comment: ""),
                            NSLocalizedString("Customer", comment: ""),
                            NSLocalizedString("systemMessage", comment: ""),
                            NSLocalizedString("phoneBind", comment: ""),
                            NSLocalizedString("setting", comment: "")],
                    seeAllbtn: "")
    ]

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return buttons.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons[section].images.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath)
        -> UICollectionReusableView {
        var reusableview: UICollectionReusableView!

        if kind == UICollectionView.elementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "userHeader", for: indexPath)
            
            guard let title = reusableview.viewWithTag(1) as? UILabel else {
                return UICollectionReusableView()
            }
            title.text = buttons[indexPath.section].title

            guard let seeAllbutton = reusableview.viewWithTag(2) as? UIButton else {
                return UICollectionReusableView()
            }
            if buttons[indexPath.section].seeAllbtn == NSLocalizedString("seeAllbtn", comment: ""){
                seeAllbutton.isHidden = false} else {
                seeAllbutton.isHidden = true
            }

        }
        return reusableview
    }

    internal func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waitPayCell", for: indexPath)
        guard let imageView = cell.viewWithTag(1) as? UIImageView else {
            return UICollectionViewCell()
        }
        guard let btnLabel = cell.viewWithTag(2) as? UILabel else {
            return UICollectionViewCell()
        }

        imageView.image = UIImage(named: buttons[indexPath.section].images[indexPath.item])
        btnLabel.text = buttons[indexPath.section].label[indexPath.item]
        btnLabel.adjustsFontSizeToFitWidth = true
        return cell
    }

    @IBOutlet weak var userCollectionView: UICollectionView!

    @IBOutlet weak var userCellController: UICollectionViewFlowLayout!

    let fullScreenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        userCellController.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        userCellController.itemSize = CGSize(width: fullScreenSize.width/8, height: 51)
        userCellController.minimumLineSpacing = 16

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
}
