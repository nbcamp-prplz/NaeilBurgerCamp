import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let categoryTitles = ["단품", "세트", "사이드", "음료"]
    private var selectedCategoryIndex = 0

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .horizontalLogo

        return imageView
    }()

    private let menuCategoryContainerView = MenuCategoryContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension MainViewController {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
        setActions()
        setBinding()
    }
    
    func setLayout() {
        view.backgroundColor = .bcBackground1
    }
    
    func setHierarchy() {
        view.addSubviews(logoImageView, menuCategoryContainerView)
    }
    
    func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(170)
            make.height.equalTo(40)
        }

        menuCategoryContainerView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(28)
        }
    }
    
    func setActions() {

    }
    
    func setBinding() {
        menuCategoryContainerView.categoryView.setCollectionView(self, self, at: IndexPath(item: 0, section: 0)) // 초기 상태값 설정
    }


}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == selectedCategoryIndex {
            cell.isSelected = true
        }
        cell.configure(with: categoryTitles[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item // 확장성 고려해서 선택된 item을 변경
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 28)
    }
}
