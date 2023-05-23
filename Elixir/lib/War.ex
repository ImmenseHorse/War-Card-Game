defmodule War do
  
  @moduledoc """    
	The `War` module applies function “overloading” (pattern matching on the signature) 
	on the function deal. The deal function will generate two players' piles from the 
	already-shuffled deck. When one player wins the round, either instantly or after war(s), 
	cards on the warchest will be added to the bottom of that player's deck. These cards 
	should be added in decreasing order by rank, i.e., first place the highest ranked card 
	on the bottom, then place the next highest ranked card beneath that. Ace, denoted as 1, 
	has the highest rank, Two, denoted as 2, has the lowest. The deal function will return 
	the pile of the winner. This pile will contain all 52 integers from the original input 
	permutation and be in the correct order, i.e, pass all 21 test cases.
	"""


  @doc """
	Function stub for deal/1 is given below. Feel free to add 
    as many additional helper functions as you want. 
    The tests for the deal function can be found in test/war_test.exs. 
    You can add your five test cases to this file.
    Run the tester by executing 'mix test' from the war directory 
    (the one containing mix.exs)
	"""


  # deal/1 is the main function receiving the original permutation.
  # deal/1 generates 2 piles, a1 and a2, and starts the game.
  # The order of a1 and a2 is that the top card of each deck will be the first element in list.
  def deal(shuf) do
	p1 = List.flatten(Enum.chunk_every(shuf,1,2))
	p2 = List.flatten(Enum.chunk_every(tl(shuf),1,2))
	a1 = Enum.reverse(Enum.map(p1, fn x -> if x == 1, do: 14, else: x end))
	a2 = Enum.reverse(Enum.map(p2, fn x -> if x == 1, do: 14, else: x end))
	Enum.map(deal(a1, a2, []), fn x -> if x == 14, do: 1, else: x end)
  end
  
  
  #deal/3 manages the scenario when player 1 has no cards left.
  #Player 2 wins and the pile onHold will be added to the bottom of player 2's pile.
  #The scenario that p2 may also be empty can also be handled in this function.
  #The winner's pile will be returned.
  def deal([], p2, onHold) do
	p2 ++ onHold
  end
  
  
  #deal/3 manages the scenario when player 2 has no cards left.
  #Player 1 wins and the pile onHold will be added to the bottom of player 1's pile.
  #The scenario that p1 may also be empty can also be handled in this function.
  #The winner's pile will be returned.  
  def deal(p1, [], onHold) do
	p1 ++ onHold
  end
  
  
  #deal/3 manages the scenario when both players have non-empty decks.
  def deal([h1|t1], [h2|t2], onHold) do
	onHold = Enum.sort(onHold ++ [h2] ++ [h1], :desc)
	cond do
		#Non-war situation
		h1 < h2 ->
			deal(t1, t2 ++ onHold, [])
		
		#Non-war situation
		h2 < h1 ->
			deal(t1 ++ onHold, t2, [])
		
		#War!!!	
		h1 == h2 ->
			cond do	
				#Handle empty scenario with grace
				Enum.empty?(t1) or Enum.empty?(t2) ->
					deal(t1, t2, onHold)
				
				#Both decks are non-empty
				true ->
					onHold = Enum.sort(onHold ++ [hd(t1)] ++ [hd(t2)], :desc)
					deal(tl(t1), tl(t2), onHold)
			end
	end
  
  end

end
