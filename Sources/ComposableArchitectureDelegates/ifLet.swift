import ComposableArchitecture

extension Reducer {
    /// Embeds a child reducer in a parent domain, handling any delegate actions emitted by the child.
    @inlinable
    @warn_unqualified_access
    public func ifLet<WrappedState, WrappedAction, Wrapped: Reducer>(
        _ toWrappedState: WritableKeyPath<State, WrappedState?>,
        action toWrappedAction: CaseKeyPath<Action, WrappedAction>,
        @ReducerBuilder<WrappedState, WrappedAction> then wrapped: () -> Wrapped,
        handleDelegateAction delegateHandler: @escaping (
            inout State, WrappedAction.DelegateAction
        ) -> Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        WrappedState == Wrapped.State, WrappedAction == Wrapped.Action,
        WrappedAction: DelegatingAction
    {
        CombineReducers {
            self.ifLet(
                toWrappedState,
                action: toWrappedAction,
                then: wrapped,
                fileID: _fileID,
                line: _line
            )
            _HandleDelegateReducer(
                toChildAction: AnyCasePath(toWrappedAction).extract,
                delegateHandler: delegateHandler
            )
        }
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
    @inlinable
    @warn_unqualified_access
    public func ifLet<WrappedState, WrappedAction, Wrapped: Reducer>(
        _ toWrappedState: WritableKeyPath<State, WrappedState?>,
        action toWrappedAction: AnyCasePath<Action, WrappedAction>,
        @ReducerBuilder<WrappedState, WrappedAction> then wrapped: () -> Wrapped,
        handleDelegateAction delegateHandler: @escaping (
            inout State, WrappedAction.DelegateAction
        ) -> Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        WrappedState == Wrapped.State, WrappedAction == Wrapped.Action,
        WrappedAction: DelegatingAction
    {
        CombineReducers {
            self.ifLet(
                toWrappedState,
                action: toWrappedAction,
                then: wrapped,
                fileID: _fileID,
                line: _line
            )
            _HandleDelegateReducer(
                toChildAction: toWrappedAction.extract,
                delegateHandler: delegateHandler
            )
        }
    }

    /// This method overrides the `ifLet` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @inlinable
    @warn_unqualified_access
    @available(
        *,
        deprecated,
        renamed: "ifLet(_:action:then:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the ifLet overload with handleDelegateAction instead"
    )
    public func ifLet<WrappedState, WrappedAction, Wrapped: Reducer>(
        _ toWrappedState: WritableKeyPath<State, WrappedState?>,
        action toWrappedAction: AnyCasePath<Action, WrappedAction>,
        @ReducerBuilder<WrappedState, WrappedAction> then wrapped: () -> Wrapped,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        WrappedState == Wrapped.State,
        WrappedAction == Wrapped.Action,
        WrappedAction: DelegatingAction
    {
        self.ifLet(
            toWrappedState,
            action: toWrappedAction,
            then: wrapped,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }

    /// This method overrides the `ifLet` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @inlinable
    @warn_unqualified_access
    @available(
        *,
        deprecated,
        renamed: "ifLet(_:action:then:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the ifLet overload with handleDelegateAction instead"
    )
    public func ifLet<WrappedState, WrappedAction, Wrapped: Reducer>(
        _ toWrappedState: WritableKeyPath<State, WrappedState?>,
        action toWrappedAction: CaseKeyPath<Action, WrappedAction>,
        @ReducerBuilder<WrappedState, WrappedAction> then wrapped: () -> Wrapped,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        WrappedState == Wrapped.State,
        WrappedAction == Wrapped.Action,
        WrappedAction: DelegatingAction
    {
        self.ifLet(
            toWrappedState,
            action: toWrappedAction,
            then: wrapped,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }

    // MARK: PresentationState

    @warn_unqualified_access
    @inlinable
    public func ifLet<DestinationState, DestinationAction, Destination: Reducer>(
        _ toPresentationState: WritableKeyPath<State, PresentationState<DestinationState>>,
        action toPresentationAction: CaseKeyPath<Action, PresentationAction<DestinationAction>>,
        @ReducerBuilder<DestinationState, DestinationAction> destination: () -> Destination,
        handleDelegateAction delegateHandler: @escaping (
            inout State, DestinationAction.DelegateAction
        ) ->
            Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Destination.State == DestinationState, Destination.Action == DestinationAction,
        DestinationAction: DelegatingAction
    {
        CombineReducers {
            self.ifLet(
                toPresentationState,
                action: toPresentationAction,
                destination: destination,
                fileID: _fileID,
                line: _line
            )

            _HandleDelegateReducer(
                toChildAction: AnyCasePath(toPresentationAction.appending(path: \.presented))
                    .extract,
                delegateHandler: delegateHandler
            )
        }
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
    @warn_unqualified_access
    @inlinable
    public func ifLet<DestinationState, DestinationAction, Destination: Reducer>(
        _ toPresentationState: WritableKeyPath<State, PresentationState<DestinationState>>,
        action toPresentationAction: AnyCasePath<Action, PresentationAction<DestinationAction>>,
        @ReducerBuilder<DestinationState, DestinationAction> destination: () -> Destination,
        handleDelegateAction delegateHandler: @escaping (
            inout State, DestinationAction.DelegateAction
        ) ->
            Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Destination.State == DestinationState, Destination.Action == DestinationAction,
        DestinationAction: DelegatingAction
    {
        CombineReducers {
            self.ifLet(
                toPresentationState,
                action: toPresentationAction,
                destination: destination,
                fileID: _fileID,
                line: _line
            )

            _HandleDelegateReducer(
                toChildAction: toPresentationAction.appending(
                    path: /PresentationAction<DestinationAction>.presented
                ).extract,
                delegateHandler: delegateHandler
            )
        }
    }

    /// This method overrides the `ifLet` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @warn_unqualified_access
    @available(
        *,
        deprecated,
        renamed: "ifLet(_:action:destination:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the ifLet overload with handleDelegateAction instead"
    )
    public func ifLet<DestinationState, DestinationAction, Destination: Reducer>(
        _ toPresentationState: WritableKeyPath<State, PresentationState<DestinationState>>,
        action toPresentationAction: CaseKeyPath<Action, PresentationAction<DestinationAction>>,
        @ReducerBuilder<DestinationState, DestinationAction> destination: () -> Destination,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Destination.State == DestinationState,
        Destination.Action == DestinationAction,
        DestinationAction: DelegatingAction
    {
        self.ifLet(
            toPresentationState,
            action: toPresentationAction,
            destination: destination,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }

    /// This method overrides the `ifLet` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @warn_unqualified_access
    @available(
        *,
        deprecated,
        renamed: "ifLet(_:action:destination:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the ifLet overload with handleDelegateAction instead"
    )
    public func ifLet<DestinationState, DestinationAction, Destination: Reducer>(
        _ toPresentationState: WritableKeyPath<State, PresentationState<DestinationState>>,
        action toPresentationAction: AnyCasePath<Action, PresentationAction<DestinationAction>>,
        @ReducerBuilder<DestinationState, DestinationAction> destination: () -> Destination,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Destination.State == DestinationState,
        Destination.Action == DestinationAction,
        DestinationAction: DelegatingAction
    {
        self.ifLet(
            toPresentationState,
            action: toPresentationAction,
            destination: destination,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }
}
