@_exported import ComposableArchitecture

public struct _HandleDelegateReducer<ParentState, ParentAction, ChildAction>: Reducer
where ChildAction: DelegatingAction {
    public typealias ToChildAction = (ParentAction) -> ChildAction?
    public typealias DelegateHandler = (
        inout ParentState, ChildAction.DelegateAction
    ) -> Effect<ParentAction>

    var toChildAction: ToChildAction
    var delegateHandler: DelegateHandler

    @usableFromInline init(
        toChildAction: @escaping ToChildAction,
        delegateHandler: @escaping DelegateHandler
    ) {
        self.toChildAction = toChildAction
        self.delegateHandler = delegateHandler
    }

    public func reduce(
        into state: inout ParentState,
        action: ParentAction
    ) -> Effect<ParentAction> {
        guard
            let childAction = toChildAction(action),
            let delegateAction = childAction.delegateAction
        else { return .none }

        return delegateHandler(&state, delegateAction)
    }
}

// MARK: Delegate (replaces Scope)

public struct Delegate<ParentState, ParentAction, Child: Reducer>: Reducer
where Child.Action: DelegatingAction {
    public typealias DelegateHandler = (inout ParentState, Child.Action.DelegateAction) -> Effect<
        ParentAction
    >

    let scope: Scope<ParentState, ParentAction, Child>
    let delegate: _HandleDelegateReducer<ParentState, ParentAction, Child.Action>

    public init<ChildState, ChildAction>(
        state toChildState: CaseKeyPath<ParentState, ChildState>,
        action toChildAction: CaseKeyPath<ParentAction, ChildAction>,
        @ReducerBuilder<ChildState, ChildAction> child: () -> Child,
        handleDelegateAction delegateHandler: @escaping DelegateHandler,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) where ChildState == Child.State, ChildAction == Child.Action {
        scope = Scope(
            state: toChildState,
            action: toChildAction,
            child: child,
            fileID: fileID,
            line: line
        )
        delegate = _HandleDelegateReducer(
            toChildAction: AnyCasePath(toChildAction).extract,
            delegateHandler: delegateHandler
        )
    }

    public init<ChildState, ChildAction>(
        state toChildState: WritableKeyPath<ParentState, ChildState>,
        action toChildAction: CaseKeyPath<ParentAction, ChildAction>,
        @ReducerBuilder<ChildState, ChildAction> child: () -> Child,
        handleDelegateAction delegateHandler: @escaping DelegateHandler
    ) where ChildState == Child.State, ChildAction == Child.Action {
        scope = Scope(state: toChildState, action: toChildAction, child: child)
        delegate = _HandleDelegateReducer(
            toChildAction: AnyCasePath(toChildAction).extract,
            delegateHandler: delegateHandler
        )
    }

    @available(
        iOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    @available(
        macOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    @available(
        tvOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    @available(
        watchOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    public init<ChildState, ChildAction>(
        state toChildState: AnyCasePath<ParentState, ChildState>,
        action toChildAction: AnyCasePath<ParentAction, ChildAction>,
        @ReducerBuilder<ChildState, ChildAction> child: () -> Child,
        handleDelegateAction delegateHandler: @escaping DelegateHandler,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) where ChildState == Child.State, ChildAction == Child.Action {
        scope = Scope(
            state: toChildState,
            action: toChildAction,
            child: child,
            fileID: _fileID,
            line: _line
        )
        delegate = _HandleDelegateReducer(
            toChildAction: toChildAction.extract,
            delegateHandler: delegateHandler
        )
    }

    @available(
        iOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    @available(
        macOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    @available(
        tvOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    @available(
        watchOS,
        deprecated: 9999,
        message:
            "Use the version of this operator with case key paths, instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4#Using-case-key-paths"
    )
    public init<ChildState, ChildAction>(
        state toChildState: WritableKeyPath<ParentState, ChildState>,
        action toChildAction: AnyCasePath<ParentAction, ChildAction>,
        @ReducerBuilder<ChildState, ChildAction> child: () -> Child,
        handleDelegateAction delegateHandler: @escaping DelegateHandler
    ) where ChildState == Child.State, ChildAction == Child.Action {
        scope = Scope.init(state: toChildState, action: toChildAction, child: child)
        delegate = _HandleDelegateReducer(
            toChildAction: toChildAction.extract,
            delegateHandler: delegateHandler
        )
    }

    public var body: some Reducer<ParentState, ParentAction> {
        scope
        delegate
    }
}
