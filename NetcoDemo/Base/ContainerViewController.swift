//
//  Created by Vladimir Burdukov on 26/9/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Astrolabe

class ContainerViewController<View: UIScrollView & AccessorView>: ViewController, Accessor {

  let containerView = View()

  override func loadView() {
    super.loadView()

    containerView.source.hostViewController = self
    view.addSubview(containerView)
    containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    containerView.alwaysBounceVertical = true
  }

  var containerSize = CGSize.zero

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    containerSize = containerView.frame.size
  }

}

class GenericCollectionViewController<T: CollectionViewSource>: ContainerViewController<CollectionView<T>> {

  override func loadView() {
    super.loadView()
    containerView.collectionViewLayout = collectionViewLayout()
  }

  func collectionViewLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    return layout
  }

}

typealias CollectionViewController = GenericCollectionViewController<CollectionViewSource>

typealias GenericTableViewController<T: TableViewSource> = ContainerViewController<TableView<T>>
typealias TableViewController = GenericTableViewController<TableViewSource>
