import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DelegatingActionMacro: ExtensionMacro, MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let decl: DeclSyntax =
            """
            extension \(type.trimmed): DelegatingAction {}
            """

        guard let extensionDecl = decl.as(ExtensionDeclSyntax.self) else {
            throw DiagnosticsError(
                message: "Failed to parse generated extension",
                node: decl
            )
        }

        return [extensionDecl]
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw DiagnosticsError(
                message: "@DelegatingAction can only be applied to enums",
                node: declaration
            )
        }

        guard let delegateCase = findCase(named: "delegate", in: enumDecl) else {
            throw DiagnosticsError(
                message: "Enum must have a case named \"delegate\"",
                node: enumDecl
            )
        }

        guard let delegateActionType = extractAssociatedValueType(from: delegateCase) else {
            throw DiagnosticsError(
                message: "Case \"delegate\" must have exactly one associated value",
                node: delegateCase
            )
        }

        let decl: DeclSyntax = """
            public var delegateAction: \(delegateActionType.trimmed)? {
                guard case .delegate(let action) = self else { return nil }
                return action
            }
            """

        return [decl]
    }

    private static func findCase(
        named name: String,
        in enumDecl: EnumDeclSyntax
    ) -> EnumCaseElementSyntax? {
        // Verify that it has a case named "delegate"
        for member in enumDecl.memberBlock.members {
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }

            // Find the case named "delegate"
            for element in caseDecl.elements {
                guard element.name.trimmed.text == name else {
                    continue
                }

                return element
            }
        }

        return nil
    }

    private static func extractAssociatedValueType(
        from element: EnumCaseElementSyntax
    ) -> TypeSyntax? {
        guard let parameterClause = element.parameterClause else { return nil }
        guard parameterClause.parameters.count == 1 else { return nil }
        return parameterClause.parameters.first!.type
    }
}
