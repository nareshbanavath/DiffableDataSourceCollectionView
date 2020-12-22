//
//  ViewController.swift
//  CollectionViewDiffableDataSourcePractice
//
//  Created by deep chandan on 18/12/20.
//

import UIKit
typealias DataSource = UICollectionViewDiffableDataSource<Section , User>
typealias SnapShot = NSDiffableDataSourceSnapshot<Section , User>

class ViewController: UIViewController , UISearchBarDelegate , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var searchBat: UISearchBar!
    {
        didSet
        {
            searchBat.delegate = self
        }
    }
    var userArray : [User] = []
    public lazy var dataSource = makeDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        userArray = [User(imageName: "user", empName: "Naresh"),User(imageName: "user", empName: "Raresh"),User(imageName: "user", empName: "Tejasvi"),User(imageName: "user", empName: "Naress"),User(imageName: "user", empName: "Ngaresh"),User(imageName: "user", empName: "Nfaresh"),User(imageName: "user", empName: "Ndaresh"),User(imageName: "user", empName: "Nardesh"),User(imageName: "user", empName: "Naryesh"),User(imageName: "user", empName: "Nardsdesh")]
        // Do any additional setup after loading the view.
        let scaleFactor = collectionView.bounds.width/3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: scaleFactor, height: scaleFactor)
        collectionView.collectionViewLayout = layout
        applySnapShot(array: userArray)
    }
    func makeDataSource() -> DataSource
    {
        let dataSource = DataSource(collectionView: collectionView) { [self] (collectionView, indexPath, usr) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.userImageView.image = UIImage (named: self.userArray[indexPath.row].imageName )
            cell.employeeName.text = self.userArray[indexPath.row].empName
            
            return cell
        }
        
        return dataSource
    }
    func applySnapShot(array : [User])
    {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(array)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""
        {
            applySnapShot(array: userArray)
        }
        else {
            let filteredUserArr = userArray.filter({$0.empName.contains(searchText)})
            applySnapShot(array: filteredUserArr)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let scaleFactor = collectionView.bounds.width/3
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    ////defining how much space needed from collectionView  to flowLayout(items) from left right top bottom, try changing the values to see difference in UI ( its like margin how much space needed from all 4 sides in collectionView)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    //this method defines the space between successive items For a vertically scrolling grid, this value represents the minimum spacing between items in the same row. For a horizontally scrolling grid, this value represents the minimum spacing between items in the same column.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //this method provides the space between rows or columns For a vertically scrolling grid, this value represents the minimum spacing between successive rows. For a horizontally scrolling grid, this value represents the minimum spacing between successive columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


}

struct User : Hashable
{
    let uuid = UUID()
    let imageName : String
    let empName : String
}
extension User  {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
enum Section
{
    case main
}
