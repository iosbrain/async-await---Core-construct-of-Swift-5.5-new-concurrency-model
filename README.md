# async-await---Core-construct-of-Swift-5.5-new-concurrency-model
**Summary:** Xcode 13 beta project demonstrating Swift 5.5 async/await core concurrency concept in iOS 15 beta

### The goal: readable asynchronous/parallel code ###
In designing the `async`/`await` construct, Apple is hoping to increase the readability, and thus maintainability, of implementing [concurrency/parallelism](http://iosbrain.com/blog/2017/02/06/concurrency-in-ios-queues-and-other-definitions-in-grand-central-dispatch-gcd-with-swift-3/#concurrency) in Swift. What I see in it are attempts:

- to make asynchronous/parallel code _almost_ look like synchronous/sequential code; and,
- to make asynchronous/parallel code much more semantically clear (more readable, less verbose, compact, doing what it says).

These are laudable and ambitious goals, but I'd say Apple's heading in the right direction. I'm glad because I write a lot a asynchronous code to keep my apps responsive -- to create the best possible user experience for my customers. I have a feeling that most of you write a lot of concurrent code, too.

We'll walk through how to use `async`/`await` in detail, but I will limit my discussion to it. You need to understand `async`/`await` before trying to use Swift's other new concurrency features, like actors, continuations, the `AsyncSequence` protocol, the `TaskGroup` generic structure, task cancellation, and a few other concepts.

The Swift team has added hundreds of `async` (or "awaitable") methods to the language, but I'd like you to focus on the _pattern_ I use to implement most any call involving `async`/`await`, not on specific functions. To take an even broader view, I'll compare using Swift's `async`/`await` to using Swift's [Grand Central Dispatch (GCD)](http://iosbrain.com/blog/2018/03/07/concurrency-in-ios-serial-and-concurrent-queues-in-grand-central-dispatch-gcd-with-swift-4/) implementation. Both technologies offer "generic" support for parallelism. In other words, they both can support asynchronous/parallel code in a wide variety of applications, from long-running multi-step mathematical computations to large file downloads that all need to be run in the background. We'll go over a common `async`/`await` beginner's pitfall and finally end with some advice about where to go next with Swift concurrency.

Please note that `async`/`await` is **not unique to Swift**. Javascript, C++, Python, and C# are some examples of languages which support this construct. Also note that while `async`/`await` is nice to have, I wouldn't want to give up access to GCD. It's too powerful, despite its use of closures.

Please download my sample Xcode 13 beta project (right here on GitHub), written in Swift 5.5, essential for getting the most out of this tutorial. The Base SDK is iOS 15 beta and I used an iPhone 12 Pro Max for the base UI layout in my storyboard. ...

CONTINUE READING [FULL ARTICLE](http://iosbrain.com/blog/2021/07/11/asyncawait-a-core-construct-of-swift-5-5s-new-concurrency-model/)...
