module Test.Runner where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Effect.Ref as Ref
import Test.Assert (assert, assertEqual)
import Test.Go as Go
import Test.Main as Original
import Test.Probe (callBoundary, hide, scenario)
import Unsafe.Coerce (unsafeCoerce)

newtype Count = Count Int
newtype RenamedCount = RenamedCount Int
newtype Text = Text String
newtype RenamedText = RenamedText String
newtype Shape = Shape { count :: Int, label :: String }
newtype RenamedShape = RenamedShape { count :: Int, label :: String }

checks :: Effect Unit
checks = do
  assertEqual { actual: callBoundary unsafeCoerce (hide 42), expected: 42 }
  assertEqual { actual: callBoundary unsafeCoerce (hide 1.25), expected: 1.25 }
  assertEqual { actual: callBoundary unsafeCoerce (hide true), expected: true }
  assertEqual { actual: callBoundary unsafeCoerce (hide 'λ'), expected: 'λ' }
  assertEqual { actual: callBoundary unsafeCoerce (hide "unchanged"), expected: "unchanged" }
  log "[OK] first-class scalar identities"
  let
    RenamedCount count = callBoundary unsafeCoerce (Count 7)
    RenamedText text = callBoundary unsafeCoerce (Text "newtype")
    RenamedShape shape = callBoundary unsafeCoerce (Shape { count: 9, label: "record" })
    values = callBoundary unsafeCoerce [ Count 2, Count 3 ] :: Array RenamedCount
  assertEqual { actual: count, expected: 7 }
  assertEqual { actual: text, expected: "newtype" }
  assertEqual { actual: shape, expected: { count: 9, label: "record" } }
  case values of
    [ RenamedCount a, RenamedCount b ] -> assertEqual { actual: a + b, expected: 5 }
    _ -> assert false
  log "[OK] compatible newtypes, records and collections"
  let
    captured = hide 13
    function = callBoundary unsafeCoerce (\n -> n + captured) :: Int -> Int
  assertEqual { actual: function 2, expected: 15 }
  assertEqual { actual: function 4, expected: 17 }
  ref <- Ref.new 0
  let action = callBoundary unsafeCoerce (Ref.modify (_ + 1) ref) :: Effect Int
  before <- Ref.read ref
  assertEqual { actual: before, expected: 0 }
  first <- action
  second <- action
  after <- Ref.read ref
  assertEqual { actual: first, expected: 1 }
  assertEqual { actual: second, expected: 2 }
  assertEqual { actual: after, expected: 2 }
  log "[OK] captured functions and deferred replayable effects"

main :: Effect Unit
main = case scenario of
  0 -> do
    Original.main
    Go.main
    checks
  1 -> do
    log (callBoundary unsafeCoerce (hide 42) :: String)
    log "UNREACHABLE"
  _ -> assert false
