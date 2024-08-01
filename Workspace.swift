//
//  Workspace.swift
//  2024-MC3-A16-PalangPalangManifests
//
//  Created by 박혜운 on 7/29/24.
//

import Foundation
import ProjectDescription

let workspace = Workspace(
    name: "PalangPalang",
    projects: [
        "PalangPalang/**"
    ],
    schemes: [] // 빈 배열로 설정하여 기본 스킴을 비활성화
)
