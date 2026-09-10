# purescript-unsafe-coerce

[![Latest release](http://img.shields.io/github/release/purescript/purescript-unsafe-coerce.svg)](https://github.com/purescript/purescript-unsafe-coerce/releases)
[![Build status](https://github.com/purescript/purescript-unsafe-coerce/workflows/CI/badge.svg?branch=master)](https://github.com/purescript/purescript-unsafe-coerce/actions?query=workflow%3ACI+branch%3Amaster)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-unsafe-coerce/badge)](https://pursuit.purescript.org/packages/purescript-unsafe-coerce)

A _highly unsafe_ function, which can be used to persuade the type system that any type is the same as any other type. When using this function, it is your (that is, the caller's) responsibility to ensure that the underlying representation for both types is the same.

There are few situations where it is acceptable to use this function, it should only ever appear as an internal implementation detail of a library, never as a function used in a "normal" codebase.

## Installation

```
spago install unsafe-coerce
```

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-unsafe-coerce).

## Rust backend tests

```sh
./bin/test
./bin/test -c
```

The runner uses the sibling `../purust` compiler and its Spago installation, the
TAST-enabled PureScript fork (or the executable selected by `PURS`), and Cargo.
`-c` rebuilds Purust and removes this package's Spago caches. Every invocation
regenerates this package's TAST and Rust output, compiles the Rust FFI, and checks
exact process output. Test processes have a 10-second timeout.

`test/Main.purs` preserves the upstream fixture unchanged. `test/Go.purs`
preserves the Go port's fixture with only its module renamed to `Test.Go`; both
must print `Hello World`. Additional assertions pass `unsafeCoerce` as a
first-class function through a foreign callback and cover scalar identities,
compatible newtypes, records, collections, captured functions, and effects
that remain deferred and can be run repeatedly.

The polymorphic Rust FFI preserves the common `Value` representation. This is
not a conversion between different native layouts: callers still have to
ensure representation compatibility, as required by the upstream API. A
negative subprocess deliberately coerces an `Int` to `String` through the
polymorphic boundary and checks the runtime type failure. That example is an
invalid use of the API; its tested panic does not imply that every invalid
coercion is detected.
