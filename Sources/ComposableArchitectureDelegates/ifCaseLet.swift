import ComposableArchitecture

extension Reducer {
    @inlinable
    @warn_unqualified_access
    public func ifCaseLet<CaseState, CaseAction, Case: Reducer>(
        _ toCaseState: CaseKeyPath<State, CaseState>,
        action toCaseAction: CaseKeyPath<Action, CaseAction>,
        @ReducerBuilder<CaseState, CaseAction> then case: () -> Case,
        handleDelegateAction delegateHandler: @escaping (inout State, CaseAction.DelegateAction) ->
            Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        State: CasePathable,
        CaseState == Case.State,
        Action: CasePathable,
        CaseAction == Case.Action,
        CaseAction: DelegatingAction
    {
        CombineReducers {
            self.ifCaseLet(
                toCaseState,
                action: toCaseAction,
                then: `case`,
                fileID: _fileID,
                line: _line
            )
            _HandleDelegateReducer(
                toChildAction: AnyCasePath(toCaseAction).extract,
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
    public func ifCaseLet<CaseState, CaseAction, Case: Reducer>(
        _ toCaseState: AnyCasePath<State, CaseState>,
        action toCaseAction: AnyCasePath<Action, CaseAction>,
        @ReducerBuilder<CaseState, CaseAction> then case: () -> Case,
        handleDelegateAction delegateHandler: @escaping (inout State, CaseAction.DelegateAction) ->
            Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where CaseState == Case.State, CaseAction == Case.Action, CaseAction: DelegatingAction {
        CombineReducers {
            self.ifCaseLet(
                toCaseState,
                action: toCaseAction,
                then: `case`,
                fileID: _fileID,
                line: _line
            )
            _HandleDelegateReducer(
                toChildAction: toCaseAction.extract,
                delegateHandler: delegateHandler
            )
        }
    }

    /// This method overrides the `ifCaseLet` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @available(
        *,
        deprecated,
        renamed: "ifCaseLet(_:action:then:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the ifCaseLet overload with handleDelegateAction instead"
    )
    @inlinable
    @warn_unqualified_access
    public func ifCaseLet<CaseState, CaseAction, Case: Reducer>(
        _ toCaseState: AnyCasePath<State, CaseState>,
        action toCaseAction: AnyCasePath<Action, CaseAction>,
        @ReducerBuilder<CaseState, CaseAction> then case: () -> Case,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        CaseState == Case.State,
        CaseAction == Case.Action,
        CaseAction: DelegatingAction
    {
        self.ifCaseLet(
            toCaseState,
            action: toCaseAction,
            then: `case`,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }

    /// This method overrides the `ifCaseLet` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @available(
        *,
        deprecated,
        renamed: "ifCaseLet(_:action:then:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the ifCaseLet overload with handleDelegateAction instead"
    )
    @inlinable
    @warn_unqualified_access
    public func ifCaseLet<CaseState, CaseAction, Case: Reducer>(
        _ toCaseState: CaseKeyPath<State, CaseState>,
        action toCaseAction: CaseKeyPath<Action, CaseAction>,
        @ReducerBuilder<CaseState, CaseAction> then case: () -> Case,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        State: CasePathable,
        CaseState == Case.State,
        Action: CasePathable,
        CaseAction == Case.Action,
        CaseAction: DelegatingAction
    {
        self.ifCaseLet(
            toCaseState,
            action: toCaseAction,
            then: `case`,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }
}
