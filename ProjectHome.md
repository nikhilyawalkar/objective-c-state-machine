A state machine written in objective-c.
This is a simplistic approach, that uses NSPredicate to decide on the next state to move to.
- The predicate executes against a target object.
- Each state also has a selector that executes once the state is entered.