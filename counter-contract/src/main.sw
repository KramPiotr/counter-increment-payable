contract;

use std::{
    context::msg_amount,
};

storage {
    counter: u64 = 0,
}

abi Counter {
    #[storage(read, write), payable]
    fn increment();

    #[storage(read)]
    fn count() -> u64;
}

impl Counter for Contract {
    #[storage(read)]
    fn count() -> u64 {
        storage.counter.read()
    }

    #[storage(read, write), payable]
    fn increment() {
        assert(msg_amount() >= 10000000);
        let current_counter = storage.counter.read();
        require(current_counter >= 0, "Counter can't be negative");
        require(current_counter <= 1000, "Counter can't be more than 1000");
        let incremented = current_counter + 1;
        storage.counter.write(incremented);
    }
}

#[test]
fn test_count() {
    let caller = abi(Counter, CONTRACT_ID);
    let count = caller.count();
    assert(count == 0);
}

#[test]
fn test_increment() {
    let caller = abi(Counter, CONTRACT_ID);

    let count = caller.count();
    assert(count == 0);

    caller.increment();

    let count = caller.count();
    assert(count == 1);
}

#[test(should_revert)]
fn test_less_than_or_equal_1000() {
    let caller = abi(Counter, CONTRACT_ID);

    let mut i = 0;
    while i < 1002 {
        caller.increment();
        i = i + 1;
    }
}