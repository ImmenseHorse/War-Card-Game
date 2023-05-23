#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Below is the function stub for deal. Add as many helper functions
    as you like, but the deal function should not be modified. Just
    fill it in.
    
    Test your code by running 'cargo test' from the war_rs directory.
*/


/*
	deal is the function that receives the original permutation and implements the game.
	deal creates 2 vectors resembling 2 players' piles, p1 and p2, and starts the game by inserting numbers into these 2 vectors.
	However, deal will add Ace to these 2 vectors under the value 14, so that Ace is the greatest number in the 2 vectors.
	The order of p1 and p2 is that the top card of each deck will be the first element in vectors.
*/
fn deal(shuf: &[u8; 52]) -> [u8; 52]
{
    let cloned_shuf = {shuf};
	let mut i = 0;
	let mut p1 = vec![];
	let mut p2 = vec![];
	
	for &card in cloned_shuf {
		if i % 2 == 0 {
			if card == 1 { p1.insert(0,14); }
			else { p1.insert(0,card); }
			i += 1;
		} else {
			if card == 1 { p2.insert(0,14); }
			else { p2.insert(0,card); }
			i+= 1;
		}
	}
	
	// The pile on hold.
	let mut on_hold = vec![];
		
	// The implementation of War game
	while !(p1.is_empty() || p2.is_empty()) {		
		let h1 = p1.remove(0);
		let h2 = p2.remove(0);
		on_hold.push(h1);
		on_hold.push(h2);
		on_hold.sort_by(|a, b| b.cmp(a));
		
		if h1 > h2 {			
			p1.extend(on_hold.clone());
			on_hold.clear();
		} else if h1 < h2 {
			p2.extend(on_hold.clone());
			on_hold.clear();
		} else {
			// Handle War scenarios
			if p1.is_empty() {
				p2.extend(on_hold.clone());
				return vec_to_arr(p2);
			} else if p2.is_empty() {
				p1.extend(on_hold.clone());
				return vec_to_arr(p1);
			} else {
				on_hold.push(p1.remove(0));
				on_hold.push(p2.remove(0));
				on_hold.sort_by(|a, b| b.cmp(a));
			}
		}
	}
	
	// Return the winner's deck	
	if p1.is_empty() {
		p2.extend(on_hold.clone());
		vec_to_arr(p2)
	} else if p2.is_empty() {
		p1.extend(on_hold.clone());
		vec_to_arr(p1)
	} else { vec_to_arr(on_hold) }
	
}

/* vec_to_arr does 2 jobs:
	- convert vector to array.
	- preserve the original denomination of Ace as 1.
*/
fn vec_to_arr(vec: Vec<u8>) -> [u8; 52]
{
	let mut arr = [0 as u8; 52];
	for idx in 0..52 {
		if vec[idx] == 14 {
			arr[idx] = 1;
		} else {
			arr[idx] = vec[idx];
		}
	}
	arr
}


#[cfg(test)]
#[path = "tests.rs"]
mod tests;

