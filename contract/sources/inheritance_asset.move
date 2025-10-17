module legacy_addr::inheritance_asset {
  use std::signer;
  use std::timestamp;
  use aptos_framework::table::{Table, Self};
  use std::debug;
  use std::vector;

  struct Heir has copy, drop, store { addr: address, share: u64 }
  struct Inheritance has key {
    heirs: vector<Heir>,
    timeout_seconds: u64,
    last_ping: u64,
    triggered: bool,
  }


  fun is_valid_shares(heirs: &vector<Heir>) : bool {
    let total_share: u64 = 0;
    let len = vector::length(heirs);
    let i = 0;

    while (i < len) {
        let heir = *vector::borrow(heirs, i);
        total_share = total_share + heir.share;
        i = i + 1;
    };

    debug::print(&total_share);

    total_share <= 10000
  }

  fun is_valid_caller(caller: address, heirs: vector<Heir>) : bool {
    let found = false;
    let len = vector::length(&heirs);
    let i = 0;
    while (i < len) {
        let heir = *vector::borrow(&heirs, i);
        if (heir.addr == caller) {
            found = true;
        };
        i = i + 1;
    };
    found
  }

  public entry fun create(owner: &signer, heir_addrs: vector<address>, shares: vector<u64>, timeout_seconds: u64) {
    let now : u64 = timestamp::now_seconds();

    // Build heirs from parallel vectors
    let len = vector::length(&heir_addrs);
    assert!(len == vector::length(&shares), 1);

    let heirs = vector::empty<Heir>();
    let i = 0;
    while (i < len) {
      let addr = *vector::borrow(&heir_addrs, i);
      let share = *vector::borrow(&shares, i);
      let h = Heir { addr, share };
      vector::push_back(&mut heirs, h);
      i = i + 1;
    };

    assert!(is_valid_shares(&heirs), 1);

    let inv: Inheritance = Inheritance { heirs, timeout_seconds, last_ping: now, triggered: false };
    move_to(owner, inv);
  }

  public entry fun ping(owner: &signer) acquires Inheritance {
    let addr = signer::address_of(owner);
    let inv = borrow_global_mut<Inheritance>(addr);
    inv.last_ping = timestamp::now_seconds();
  }

  public entry fun trigger(caller: &signer, owner_addr: address) acquires Inheritance {
    let caller_addr = signer::address_of(caller);
    let inv = borrow_global_mut<Inheritance>(owner_addr);

    assert!(is_valid_caller(caller_addr, inv.heirs), 2);

    let now = timestamp::now_seconds();
    assert!(now > inv.last_ping + inv.timeout_seconds, 1);
    inv.triggered = true;
    // either mark assets claimable or emit events with decryption key pointer
  }

  // claim would be done by heirs reading inv and calling functions to move token resources
}
