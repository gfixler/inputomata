## Vim FSMs and You

##### In the Beginning Was the getchar()

Inputomata.tim provides a general-purpose, event-driven finite-state machine
triggered by user key presses, with states defined in TimL maps.

### What?

See: http://en.wikipedia.org/wiki/Finite-state_machine

Put simply, you define one or more states of a finite-state machine (FSM) in a
[Clojure-like] TimL map, providing each with one or more triggers. Triggers are
single characters that you can press on the keyboard while in the FSM, which
can either transfer you to another state, run a function, or exit the FSM.

### Why is it called "Inputomata"?

Two reasons:

1. [Names are hard](http://martinfowler.com/bliki/TwoHardThings.html).
2. It's a [portmanteau][] of "input" and "[automata][]."

[portmanteau]: http://en.wikipedia.org/wiki/Portmanteau
[automata]: http://en.wikipedia.org/wiki/Automata_theory

### How do I pronounce it?

However you like. I say it sort of like "imp pedometer," sans terminal "r."

Other [half-rhymes]:

* in-pajama-*duh*
* int-[Mahna-Mahna]
* ink-phenomenon

[half-rhymes]: http://en.wikipedia.org/wiki/Half_rhyme
[Mahna-Mahna]: http://muppet.wikia.com/wiki/Mahna_Mahna_%28character%29

### Features

* Implemented in Tim Pope's awesome, Clojure-like TimL language.
* State maps are very easy to define via Clojure-like TimL maps.
* The implementation is super small, because TimL is expressive.
* Allows continuous Vim<->user interaction without any mappings.
* All of these bullet points have the same number of characters.

### Requirements

[TimL](https://github.com/tpope/timl), Vim, a computer (w/ keyboard),
sentience, free time, and maybe free will.

### Vim/VimL/TimL interop

* Your FSMs can interact with Vim/VimL/TimL in the same way that TimL can.
* Input from the user - on a key-by-key basis - can trigger state transfer, or
  can call any arbitrary TimL function (currently without state change).
* Inputomata.tim uses Vim's getchar in a loop, trapping the user until they
  find an exit condition (provided in your states map), or they hit ctrl+c, or
  they realize their computer doesn't own them, and they can just get up and
  leave whenever they want.
* Because the entirety of the interaction takes place in a TimL loop/recur, no
  changes need to be made to Vim, e.g. no mappings are set/changed.

### Getting started

This plugin is set up in the standard Vim fashion. Masochists can install it
manually, others may use Pathogen, Vundle, NeoBundle, etc...

I recommend installing [pathogen.vim][], then copying and pasting this (you
know where):

    cd ~/.vim/bundle
    git clone git://github.com/tpope/timl.git

[pathogen.vim]: https://github.com/tpope/vim-pathogen

### Examples

##### The Flyover States

The simplest example is the empty states map. State names are TimL keywords,
and a nil value is a terminating condition. This FSM would start, immediately
exit, and display "done" in the status line. Note that all states maps must at
least have a :start state; it is an error otherwise.

    (use 'inputomata.core) ; we'll presume this line for the remaining examples
    (fsm {:start nil})

##### Two States, and a Bridge Betwixt

The following FSM allows jumping to :a or :b states on start, then between :a
and :b as often as you like, with the ability to quit out at any point. The
messages let you know where you are at all times. Though optional, they're a
good idea. It gets disorienting and lonely to state-hop with no feedback.

    (fsm {:start {:msg "Press 'a' or 'b', or 'q' to quit"
                  \a :a
                  \b :b
                  \q nil}
          :a {:msg "State 'a'. Press 'b' ('q' to quit)"
              \b :b
              \q nil}
          :b {:msg "State 'b'. Press 'a' ('q' to quit)"
              \a :a
              \q nil}})

##### I Put Some State in Your States...

Your state machines can interact with the state around them, which is to say
that your FSMs can interact with things in their scope, or any scope they can
access. A nice, local way to do this is to wrap the FSM itself in a let, as
we've done below.

There are a few new things happening here. First, we're using a TimL atom, so
we can `swap!` the value with the result of applying a function on it
(`dec`/`inc` here), and dereference it (`@value`) to get its current value.
Second, this shows off Inputomata's ability to use the result of a function
call as the current state's message. Note that on valid key presses, the FSM
recurs; this is the seam that allows for in-state message updates.

    (let [value (atom 0)]
      (fsm {:start
            {:msg #(str "dec/inc value (" @value ") with j/k, q to quit")
             \j #(swap! value dec)
             \k #(swap! value inc)
             \q nil}}))

### License

Copyright © Gary Fixler.

The use and distribution terms for this software are covered by the [Eclipse
Public License 1.0](http://opensource.org/licenses/eclipse-1.0.php), which can
be found in the file epl-v10.html at the root of this distribution.

By using this software in any fashion, you are agreeing to be bound by the
terms of this license.  You must not remove this notice, or any other, from
this software.

