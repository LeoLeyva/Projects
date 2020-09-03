(**The code within State was inspired by Assignment 2/3. *)


(** type [t] consists of the properties shots_left, which is the number of shots 
    the player has left. It also contains ships_sunk which represents the
    ships that the player has sunk of their opponents and opp_sunk, which 
    represents the ships that the opposing player has sunk of the current 
    players. Type [t] also contains must_place, which is a list of the ships 
    still needed to be placed by the current player and opp_place, which is a 
    list of the ships the opposing player still needs to place. 
    It also contains my_views, which is the view of the player's board 
    (his/her own board as well as a version of the opposing board) and 
    opp_views is the same as my_views, except for the other player. Lastly, it 
    contains opp_pending_special, which is a list of the special spaces on the 
    board that the opposing player has received.*)
type t 


(**Represents the starting state of the game*)
val og_state:t


(**[get_shots_left st] gets the shots left in state [st]*)
val get_shots_left: t -> int


(**[get_ships_sunk st] gets the ships sunk of the opposing player in state [st]
*)
val get_ships_sunk: t -> Battleship.ship_name list


(**[get_opp_sunk st] gets the ships sunk of the current player in state [st]*)
val get_opp_sunk: t ->  Battleship.ship_name list


(**[get_must_place st] gets the ships that still need to be placed by the 
   current player in state [st]*)
val get_must_place: t -> Battleship.ship_name list


(**[get_opp_place st] gets the ships that still need to be placed by the 
   opposing player in state [st]*)
val get_opp_place: t -> Battleship.ship_name list


(**[get_my_views st] gets the boards of the current player in state [st]*)
val get_my_views: t -> Battleship.board list


(**[get_opp_views st] gets the boards of the opposing player in state [st]*)
val get_opp_views: t -> Battleship.board list


(**[get_opp_pending_special] gets the pending special spaces for the opposing 
   player in state [st]*)
val get_opp_pending_special: t -> Battleship.special list 


(** The type representing the result of a movement. *)
type result = Legal of t | Illegal of string


(**[place st c n b] updates the state [st] after a ship [n] has been 
   placed on the board [b] given the coordinates [c]. It's [Illegal] if it 
   raises any of the following:[Invalid s], [Unknown Coordinate c] if the 
   coordinates are incorrect, or [UnknownShip sh] if the name has already been 
   provided or if the ship has already been placed. Otherwise, it's [Legal].*)
val place: t -> Battleship.coordinate list -> Battleship.ship_name -> 
  Battleship.board -> result


(**[move st c n b] updates the state [st] after a ship [n] has been moved on the
   board [b] given the coordinates [c]. It's [Illegal] if it raises any of the 
   following:[Invalid s], [Unknown Coordinate c] if the coordinates are 
   incorrect, or [UnknownShip sh] if the name has already been provided or if 
   the ship has already been placed. Otherwise, it's [Legal].*)
val move: t -> Battleship.coordinate list -> Battleship.ship_name -> 
  Battleship.board -> result


(**[shoot st c b] updates the state [st] after the board [b] has been shot at 
   coordinate [c]. It's [Illegal] if it raises either of the following: 
   [Invalid s] or [Unknown Coordinate c] if the coordinate is incorrect; 
   otherwise, it's [Legal].*)
val shoot: t -> Battleship.coordinate -> Battleship.board -> result


val taunt: t -> string -> result


(**[end_turn st] updates the state [st] after the current player ends their 
   turn. It switches opp_sunk/ships_sunk, must_place/opp_place, and 
   my_views/opp_views to update the information regarding the next player. 
   The result is [Illegal] if all the player's ships haven't been placed yet. 
   Otherwise, it's [Legal]*)
val end_turn: t -> result
