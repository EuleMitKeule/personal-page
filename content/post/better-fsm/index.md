---
title: Developing a better finite state machine in C#
# subtitle: Welcome 👋 We know that first impressions are important, so we've populated your new site with some initial content to help you get familiar with everything in no time.

summary: In this article I describe how I developed an encapsulated implementation of the state pattern in C#.

projects: [misadventure]

date: "2020-06-02T00:00:00Z"

lastmod: "2020-06-02T00:00:00Z"

draft: false

featured: false

image:
  caption:
  focal_point: ""
  placement: 2
  preview_only: false

authors:
- admin

tags:
- C#
- state machine
- design pattern
- generics
- object-oriented
- architecture

categories:

---

The state pattern is a very powerful programming technique that is especially useful in game development. It allows developers to outsource different characteristics of an object's behaviour into encapsulated state classes. 

```cs
public class StateA : State
{
    public override void Print()
    {
        Console.WriteLine("The current state is StateA");
    }
}

public class StateB : State
{
    public override void Print()
    {
        Console.WriteLine("The current state is StateB");
    }
}
```

Those classes, which from now on are referred to as states, are then allowed to define transitions from one state to another.<br>

```cs
public abstract class State
{
    Context Context { get; }

    public State(Context context) => Context = context;
}

public class StateA : State
{
    public override void PrintAndSwitch()
    {
        Print();
        Context.SetState(Context.StateB);
    }
}
```

The object whose different behaviours are modelled by the states, which will be referred to as the context, will then store a reference to each possible and also the currently held state.<br>

```cs
public class Context
{
    State CurrentState { get; set; }
    public State StateA { get; }
    public State StateB { get; }
    
    public Context()
    {
        StateA = new StateA(this);
        StateB = new StateB(this);
    }
}
```

The idea from then on is to call the currently held state's implementation of a state-driven method from within the context's implementation of that method, which allows the defined behaviour to alter when the state changes. Each state may also implement an EnterState() and ExitState() method for any setup or teardown logic.<br>

```cs
public class Context
{
    public void Print()
    {
        CurrentState?.Print(); //Will be called in StateA or StateB
    }
}
```

The point of conflict in how this pattern is implemented for me personally lies in the decision, how exactly the state transitions, that are essential to this design pattern, are performed. In most implementations, the state can be changed by calling a method inside the context.

```cs
public class Context
{
    public void SetState(State state)
    {
        CurrentState?.ExitState();
        CurrentState = state;
        CurrentState?.EnterState();
    }
}
```

The thing that annoys me with this approach is that each state needs to hold a reference to its context and each other state, so that the transitions can be executed from within the states and the state that is being changed into can be passed as an argument.<br>

Allowing states to transition into each other while also staying encapsulated can be achieved by using a generic method, basic reflection and C# native events.

```cs
public abstract class State
{
    public event EventHandler<Type> ChangeRequested;

    protected void SetState<TStateType>() where TStateType : State
    {
        ChangeRequested?.Invoke(this, typeof(TStateType));
    }
}
```

The ChangeRequested event will be subscribed to by the context. When a state change is requested, the context will try to change into the state of the provided type if possible.

```cs
public class Context
{
    List<State> States { get; } = new List<State>();

    public Context()
    {
        var stateA = new StateA();
        var stateB = new StateB();

        States.Add(stateA);
        States.Add(stateB);

        stateA.ChangeRequested += OnStateChangeRequested;
        stateB.ChangeRequested += OnStateChangeRequested;
    }

    void OnStateChangeRequested(object sender, Type stateType)
    {
        var state = States.OfType(stateType).First();
        if (state is null) return;

        SetState(state);
    }
}
```

Another upside to this approach is that the individual states referenced by the context don't need to be declared as public members. They also may be stored in a list of their base type.<br>

With this the states only need to execute the protected SetState() method of their base class and specify the type of state to transition into. No references to the context are needed.

```cs
public class StateA : State
{
    public void PrintAndSwitch()
    {
        Print();
        SetState<StateB>();
    }
}
```