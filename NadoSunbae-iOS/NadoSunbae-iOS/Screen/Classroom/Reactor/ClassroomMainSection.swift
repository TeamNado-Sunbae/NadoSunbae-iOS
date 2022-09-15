//
//  ClassroomMainSection.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/14.
//

import RxDataSources

enum ClassroomMainSection {
    case imageSection([ClassroomMainSectionItem])
    case reviewPostSection([ClassroomMainSectionItem])
    case questionPostSection([ClassroomMainSectionItem])
}

enum ClassroomMainSectionItem {
    case imageCell
    case reviewPostCell(ReviewPostModel)
    case findPersonHeaderCell
    case findPersonCell
    case recentQuestionHeaderCell
    case questionCell(RecentQuestionTVCReactor)
    case emptyCell
}

// MARK: - ClassroomMainSection
extension ClassroomMainSection: SectionModelType {

    typealias Item = ClassroomMainSectionItem

    var items: [Item] {
        switch self {
        case .imageSection(let items):
            return items
        case .reviewPostSection(let items):
            return items
        case .questionPostSection(let items):
            return items
        }
    }

    init(original: ClassroomMainSection, items: [ClassroomMainSectionItem]) {
        switch original {
        case .imageSection:
            self = .imageSection(items)
        case .reviewPostSection:
            self = .reviewPostSection(items)
        case .questionPostSection:
            self = .questionPostSection(items)
        }
    }
}
