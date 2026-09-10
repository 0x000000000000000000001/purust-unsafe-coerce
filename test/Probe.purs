module Test.Probe where

foreign import scenario :: Int
-- Keep first-class functions and values observable at the FFI boundary.
foreign import hide :: forall a. a -> a
foreign import callBoundary :: forall a b. (a -> b) -> a -> b
