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

    func registerUsecases() {
        register(ScoreManager.self) { ScoreManagerImpl() }
    }

    public static func registerAllServices() {
        Resolver.main.registerServices()
        Resolver.main.registerUsecases()
    }
}
