---
title: mono-routine
summary: Wrapper class that adds functionality to Coroutines from the Unity Engine Framework.
tags:
date: "2021-07-26T00:00:00Z"

# Optional external URL for project (replaces project detail page).
# external_link: "https://github.com/EuleMitKeule/mono-routine"

image:
  caption:
  focal_point: Smart

links:
- icon: github
  icon_pack: fab
  name: Github
  url: https://github.com/EuleMitKeule/mono-routine
# url_code: ""
# url_pdf: ""
# url_slides: ""
# url_video: ""

# Slides (optional).
#   Associate this project with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides = "example-slides"` references `content/slides/example-slides.md`.
#   Otherwise, set `slides = ""`.
# slides: example
---
Mono-routine is an open-source wrapper class written in C# for use with the coroutine system provided by the Unity Engine's scripting framework.<br>
Its main purpose is to extend the user's capabilities when working with coroutines.<br>

The MonoRoutine class can be instantiated by providing a reference to the coroutine defining IEnumerator. The routine can then easily be started, stopped and paused.<br>

Achieving the start and stop mechanic with builtin means requires a lot of boilerplate code:

```cs
Coroutine Coroutine { get; set; }

void StartSomeRoutine() => Coroutine ??= StartCoroutine(SomeCoroutine());

void StopSomeRoutine()
{
    if (Coroutine == null) return;
    StopCoroutine(Coroutine);
    Coroutine = null;
}

IEnumerator SomeCoroutine() { }
```

Pausing a coroutine is not possible without some tricks which are implemented by the MonoRoutine class.<br>

MonoRoutine works by manually iterating the coroutine defining IEnumerator and yielding any YieldInstructions encountered in the process.
It also checks for requested pausing or stopping before each iteration:

```cs
IEnumerator Wrapper()
{
    var enumerator = Enumerator?.Invoke();

    while (IsRunning)
    {
        if (IsPaused) yield return null;
        else
        {
            if (enumerator != null && enumerator.MoveNext())
            {
                yield return enumerator.Current;
            }
            else
            {
                IsRunning = false;
                Stopped?.Invoke(Behaviour, new MonoRoutineEventArgs(false));
                yield break;
            }
        }
    }
}
```

This also allows the MonoRoutine class to notify listeners via an event when the routine is paused or stopped 
and to provide information whether the stopping occured forcefully by user request or because the routine completed.<br>

The newest addition to mono-routine's capabilities contains the option to specify a generic return type.<br>
The wrapper enumerator used by the MonoRoutine class will then check in each iteration whether the enumerator's current value is of the specified return type
and if so will assume the routine is completed. The return value will provided in the generic MonoRoutineEventArgs argument of the stopped event:

```cs
void Foo()
{
    var routine = new MonoRoutine<string>(SomeCoroutine);
    routine.Stopped += OnRoutineStopped;
}

void OnRoutineStopped(object sender, MonoRoutineEventArgs<string> e)
{
    var returnValue = e.ReturnValue;
}

IEnumerator SomeCoroutine()
{
    //Will be executed

    yield return "Finished";

    //Won't be executed
}

```