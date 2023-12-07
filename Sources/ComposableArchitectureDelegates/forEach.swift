import ComposableArchitecture

// MARK: - CaseKeyPath

extension Reducer {
    @warn_unqualified_access
    public func forEach<ElementState, ElementAction, ID: Hashable, Element: Reducer>(
        _ toElementsState: WritableKeyPath<State, IdentifiedArray<ID, ElementState>>,
        action toElementAction: CaseKeyPath<Action, IdentifiedAction<ID, ElementAction>>,
        @ReducerBuilder<ElementState, ElementAction> element: () -> Element,
        handleDelegateAction delegateHandler: @escaping (
            inout State, ID, ElementAction.DelegateAction
        ) ->
            Effect<Action>,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Element.State == ElementState, Element.Action == ElementAction,
        ElementAction: DelegatingAction
    {
        CombineReducers {
            self.forEach(
                toElementsState,
                action: toElementAction,
                element: element,
                fileID: fileID,
                line: line
            )

            // Can't use _HandleDelegateReducer here because we need to pass the ID
            Reduce { state, action in
                guard
                    let childAction = AnyCasePath(toElementAction).extract(from: action),
                    case .element(let id, let action) = childAction,
                    let delegateAction = action.delegateAction
                else { return .none }

                return delegateHandler(&state, id, delegateAction)
            }
        }
    }

    /// This method overrides the `forEach` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @warn_unqualified_access
    @available(
        *,
        deprecated,
        renamed: "forEach(_:action:element:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the forEach overload with handleDelegateAction instead"
    )
    public func forEach<ElementState, ElementAction, ID: Hashable, Element: Reducer>(
        _ toElementsState: WritableKeyPath<State, IdentifiedArray<ID, ElementState>>,
        action toElementAction: CaseKeyPath<Action, IdentifiedAction<ID, ElementAction>>,
        @ReducerBuilder<ElementState, ElementAction> element: () -> Element,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Element.State == ElementState, Element.Action == ElementAction,
        ElementAction: DelegatingAction
    {
        self.forEach(
            toElementsState,
            action: toElementAction,
            element: element,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }
}

// MARK: - AnyCasePath

extension Reducer {
    @available(
        iOS,
        deprecated: 9999,
        message:
            "Use a case key path to an 'IdentifiedAction', instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4"
    )
    @available(
        macOS,
        deprecated: 9999,
        message:
            "Use a case key path to an 'IdentifiedAction', instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4"
    )
    @available(
        tvOS,
        deprecated: 9999,
        message:
            "Use a case key path to an 'IdentifiedAction', instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4"
    )
    @available(
        watchOS,
        deprecated: 9999,
        message:
            "Use a case key path to an 'IdentifiedAction', instead. See the following migration guide for more information:\n\nhttps://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/migratingto1.4"
    )
    @warn_unqualified_access
    public func forEach<ElementState, ElementAction, ID: Hashable, Element: Reducer>(
        _ toElementsState: WritableKeyPath<State, IdentifiedArray<ID, ElementState>>,
        action toElementAction: AnyCasePath<Action, (ID, ElementAction)>,
        @ReducerBuilder<ElementState, ElementAction> element: () -> Element,
        handleDelegateAction delegateHandler: @escaping (
            inout State, ID, ElementAction.DelegateAction
        ) ->
            Effect<Action>,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Element.State == ElementState, Element.Action == ElementAction,
        ElementAction: DelegatingAction
    {
        CombineReducers {
            self.forEach(
                toElementsState,
                action: toElementAction,
                element: element,
                fileID: _fileID,
                line: _line
            )

            // Can't use _HandleDelegateReducer here because we need to pass the ID
            Reduce { state, action in
                guard
                    let childAction = toElementAction.extract(from: action),
                    let delegateAction = childAction.1.delegateAction
                else { return .none }

                return delegateHandler(&state, childAction.0, delegateAction)
            }
        }
    }

    /// This method overrides the `forEach` of `Reducer` to emit a compiler warning if delegate
    /// actions are not handled.
    @warn_unqualified_access
    @available(
        *,
        deprecated,
        renamed: "forEach(_:action:element:handleDelegateAction:)",
        message:
            "Child emits delegate actions - use the forEach overload with handleDelegateAction instead"
    )
    public func forEach<ElementState, ElementAction, ID: Hashable, Element: Reducer>(
        _ toElementsState: WritableKeyPath<State, IdentifiedArray<ID, ElementState>>,
        action toElementAction: AnyCasePath<Action, (ID, ElementAction)>,
        @ReducerBuilder<ElementState, ElementAction> element: () -> Element,
        _fileID: StaticString = #fileID,
        _line: UInt = #line
    ) -> some ReducerOf<Self>
    where
        Element.State == ElementState, Element.Action == ElementAction,
        ElementAction: DelegatingAction
    {
        self.forEach(
            toElementsState,
            action: toElementAction,
            element: element,
            fileID: _fileID,  // Explicitly passed to disambiguate the overload
            line: _line  // Explicitly passed to disambiguate the overload
        )
    }
}
