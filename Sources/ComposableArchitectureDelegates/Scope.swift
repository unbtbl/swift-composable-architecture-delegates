import ComposableArchitecture

/// This method overrides the `init` of `Scope` to emit a compiler warning if delegate actions
/// are not handled.
@available(
    *,
    deprecated,
    renamed: "Delegate",
    message: "Child emits delegate actions - use Delegate instead of Scope"
)
// Note: Too much generic arguments on purpose, so the compiler considers this as being more
// specialized compared to the Scope init.
public func Scope<ParentState, ParentAction, Child: Reducer, ChildState, ChildAction>(
    state toChildState: WritableKeyPath<ParentState, ChildState>,
    action toChildAction: CasePath<ParentAction, ChildAction>,
    @ReducerBuilder<ChildState, ChildAction> child: () -> Child
) -> ComposableArchitecture.Scope<ParentState, ParentAction, Child>
where Child.State == ChildState, Child.Action == ChildAction, ChildAction: DelegatingAction {
    .init(state: toChildState, action: toChildAction, child: child)
}

/// This method overrides the `init` of `Scope` to emit a compiler warning if delegate actions
/// are not handled.
@available(
    *,
    deprecated,
    renamed: "Delegate",
    message: "Child emits delegate actions - use Delegate instead of Scope"
)
// Note: Too much generic arguments on purpose, so the compiler considers this as being more
// specialized compared to the Scope init.
public func Scope<ParentState, ParentAction, Child: Reducer, ChildState, ChildAction>(
    state toChildState: CasePath<ParentState, ChildState>,
    action toChildAction: CasePath<ParentAction, ChildAction>,
    @ReducerBuilder<ChildState, ChildAction> child: () -> Child,
    _fileID: StaticString = #fileID,
    _line: UInt = #line
) -> ComposableArchitecture.Scope<ParentState, ParentAction, Child>
where Child.State == ChildState, Child.Action == ChildAction, ChildAction: DelegatingAction {
    .init(state: toChildState, action: toChildAction, child: child, fileID: _fileID, line: _line)
}
