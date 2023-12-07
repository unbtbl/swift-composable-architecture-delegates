/// A protocol for actions that are delegating to another reducer.
/// Don't directly conform to this protocol - use the ``Delegating`` attached macro instead.
public protocol DelegatingAction {
    associatedtype DelegateAction

    static func delegate(_: DelegateAction) -> Self
    var delegateAction: DelegateAction? { get }
}

@attached(extension, conformances: DelegatingAction)
@attached(member, names: named(delegateAction))
public macro ActionWithDelegate() =
    #externalMacro(module: "ComposableArchitectureDelegatesMacros", type: "DelegatingActionMacro")
