//
//  Resolver+Services.swift
//  MicroApp
//
//  Created by Tosun, Irem on 15.01.2024.
//

import Nasa
import Quiz
import Resolver

extension Resolver: ResolverRegistering {
    func registerServices() {
        register(AsteriodService.self) { AsteriodServiceImpl() }
        register(ApodService.self) { ApodServiceImpl() }
        register(QuizService.self) { QuizServiceImpl() }
    }

    func registerManagers() {
        register(ScoreManager.self) { ScoreManagerImpl() }
        register(QuizManager.self) { QuizManagerImpl() }
    }

    public static func registerAllServices() {
        Resolver.main.registerServices()
        Resolver.main.registerManagers()
    }
}
