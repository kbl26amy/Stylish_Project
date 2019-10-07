import UIKit
import Kingfisher
import CRRefresh

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MarketManagerDelegate {
    
    func otherManager(_ manager: MarketManager, didGet marketingHots: [Product]?, didFailWith error: Error?) {
        
        if marketingHots != nil {
            hotsData = marketingHots!
            
        } else {
            
        }
    }
    

    @IBAction func backSegue(segue: UIStoryboardSegue) {
        guard segue.source is DetailViewController else {return}
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromHome", sender: self)
    }

    var hotsData: [Product] = []
   
    func manager(_ manager: MarketManager, didGet marketingHots: [Product]) {
        hotsData = marketingHots
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.cr.endHeaderRefresh()
        }
    }
    
    func manager(_ manager: MarketManager, didFailWith error: Error) {
        print(error)
    }
    func manager(_ manager: MarketManager, didGet marketingfemale: [FemaleObject]) {
    }

    @IBOutlet weak var tableView: UITableView!

    func numberOfSections(in tableView: UITableView) -> Int {
        return hotsData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotsData[section].products.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 280
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24)
        headerView.backgroundColor = UIColor.white

        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = hotsData[section].title
        titleLabel.frame = CGRect(x: 16, y: 8, width: tableView.frame.width, height: 32)
        headerView.addSubview(titleLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row % 2 == 0 {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell1", for: indexPath) as? FirstTableViewCell else {
                    return UITableViewCell()
            }
            cell.firstTitleLabel.text = hotsData[indexPath.section].products[indexPath.row].title
            cell.firstDetailLabel.text = hotsData[indexPath.section].products[indexPath.row].description

            let url = URL(string: hotsData[indexPath.section].products[indexPath.row].mainImage)
            cell.mainImage.kf.setImage(with: url)
            cell.mainImage.kf.indicatorType = .activity

      return cell
        } else {

            guard let cell =
                tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? SecondTableViewCell else {
                    return UITableViewCell()
            }

            cell.secondTitleLabel.text = hotsData[indexPath.section].products[indexPath.row].title
            cell.secondDetailLabel.text = hotsData[indexPath.section].products[indexPath.row].description

            let url1 = URL(string: hotsData[indexPath.section].products[indexPath.row].images[0])
            cell.leftImage.kf.setImage(with: url1)
            cell.leftImage.kf.indicatorType = .activity

            let url2 = URL(string: hotsData[indexPath.section].products[indexPath.row].images[1])
            cell.middleTopImage.kf.setImage(with: url2)
            cell.middleTopImage.kf.indicatorType = .activity

            let url3 = URL(string: hotsData[indexPath.section].products[indexPath.row].images[2])
            cell.middleBottomImage.kf.setImage(with: url3)
            cell.middleBottomImage.kf.indicatorType = .activity

            let url4 = URL(string: hotsData[indexPath.section].products[indexPath.row].images[3])
            cell.rightImage.kf.setImage(with: url4)
            cell.rightImage.kf.indicatorType = .activity

            return cell
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let viewController = segue.destination as? DetailViewController else {return}
        if let section = tableView.indexPathForSelectedRow?.section {
            if let row = tableView.indexPathForSelectedRow?.row {
                 viewController.passedProduct = hotsData[section].products[row]
                print(222222222)
        }
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let marketManager = MarketManager()
        marketManager.getMarketingHots()
        marketManager.delegate = self

        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [] in
            marketManager.getMarketingHots()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
            })
        }
        tableView.cr.beginHeaderRefresh()

        self.tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller

        self.tabBarController?.tabBar.isHidden = false
    }

}
