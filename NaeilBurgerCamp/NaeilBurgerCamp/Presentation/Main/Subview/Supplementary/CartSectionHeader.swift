import UIKit
import SnapKit

class CartSectionHeader: UICollectionReusableView {
    static let identifier = "CartSectionHeader"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주문 내역"
        label.font = .nanumSquareRound(ofSize: 15, weight: .bold)
        label.textColor = .bcPrimary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CartSectionHeader {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        addSubviews(titleLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }
}
