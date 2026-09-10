pub fn Test_Probe_scenario() -> i64 {
    std::env::args().nth(1).unwrap_or_else(|| "0".to_owned())
        .parse().expect("integer test scenario")
}

pub fn Test_Probe_hide(value: crate::UnknownType) -> crate::UnknownType {
    value
}

pub fn Test_Probe_callBoundary(function: purust_core::Func1<crate::UnknownType, crate::UnknownType>, value: crate::UnknownType) -> crate::UnknownType {
    function(value)
}
