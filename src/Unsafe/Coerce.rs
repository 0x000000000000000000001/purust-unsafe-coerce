// Polymorphic foreign values use the common Value representation. Specialised
// calls are lowered directly by the compiler; this also supports passing the
// polymorphic function itself to a callback.
pub fn Unsafe_Coerce_unsafeCoerce(value: crate::UnknownType) -> crate::UnknownType {
    value
}
