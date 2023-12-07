import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ComposableArchitectureDelegatesMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DelegatingActionMacro.self
    ]
}
