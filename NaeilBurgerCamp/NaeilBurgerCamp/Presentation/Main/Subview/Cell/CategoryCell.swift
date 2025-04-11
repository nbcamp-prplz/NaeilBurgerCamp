import UIKit

final class CategoryCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.nanumSquareRound(ofSize: 13, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .bcPrimary

        return label
    }()

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

    private func updateAppearance() {
        titleLabel.textColor = isSelected ? .bcText4 : .bcPrimary
        backgroundColor = isSelected ? .bcBackground2 : .bcBackground3
    }
}

private extension CategoryCell {
    func configure() {
        setLayout()
        setHierarchy()
        setConstraints()
    }

    func setLayout() {
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .bcBackground3
    }

    func setHierarchy() {
        addSubviews(titleLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
