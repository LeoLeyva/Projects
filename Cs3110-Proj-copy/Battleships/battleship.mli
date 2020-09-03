(**The code within Battleship was inspired by Assignment 2 and Assigment 3*)


(* The type that represents the battleship board *)
type board 


(*The type of ship names. *)
type ship_name = string


(** The type of coordinate. *)
type coordinate = string


(* Indicates the status of a ship.
   None: empty board
   Hit: hit a ship, indicated by 'O' on board
   Miss: did not hit a ship, indicated by 'X' on board
   Yours: indicates the location of the ships the current
   player has, indicated by 'A' on board *)
type status = 
  |None
  |Hit
  |Miss
  |Yours


(* Indicates whether a space is special.
   Nothing: non-special spot
   Eturn:  current player receives extra turn
   Eshot: current player receives extra shot
   Oturn: opposing player receives extra turn
   Oshot: opposing player receives extra shot*)
type special = 
  |Nothing
  |Eturn
  |Eshot
  |Oturn
  |Oshot

(** Raised when an unknown ship is encountered. *)
exception UnknownShip of ship_name


(** Raised when an unknown coordinate is encountered. *)
exception UnknownCoordinate of coordinate


(** Raised when invalid inputs are encountered. *)
exception Invalid of string


(** [get_owner b] is a pair of the players' names, depending on the 
    [b] that is being used. The first string in the pair represents whose 
    turn it is while the second string in the pair represents whose board is 
    being looked at.
    Ex. ("Player 1", "Player 2") means it is Player 1's turn, but they are
    looking at Player 2's board  *)
val get_owner: board -> string*string   


(** [get_hit_status b c] gets the hit status of [c] in [b].
    Raises [UnknownCoordinate c] if [c] is not a coordinate in [b]. *)
val get_hit_status: board -> coordinate -> status


(* [get_belongs_to b c] determines what ship the coordinate [c] on the board [b]
   belongs to.  *)
val get_belongs_to: board -> coordinate -> ship_name


(* [get_special_space b c] gets the type special space on board [b] at the
   coordinate [c]. *)
val get_special_space: board -> coordinate -> special


(** [get_hp b s] gets the hp, or number of tiles [s] occupies that haven't 
    been hit, of the ship [s] in [b].
    Raises [UnknownShip s] if [s] is not a ship in [b].*)
val get_hp: board -> ship_name -> int


(** [get_sunk_status b s] is the sunk status of the ship [s] in [b]. 
    The sunk status is true if each part of [s] has been hit.
    Raises [UnknownShip s] if [s] is not a ship in [b].*)
val get_sunk_status: board -> ship_name -> bool


(** [get_coordinate_parts b s] gets each coordinate from the ship [s] in [b].
    Raises [UnknownShip s] if [s] is not a ship in [b].*)
val get_coordinates_part: board -> ship_name -> coordinate list


(** [get_part_hit b s] checks each part of the ship [s] to see if it has been 
    hit. True means that that part has been hit. False otherwise. *)
val get_part_hit: board -> ship_name -> bool list


(* [get_been_moved b s]  determines if ship [s] has been moved on the board [b].
   True if the ship has been moved, false otherwise.*)
val get_been_moved: board -> ship_name -> bool list


(* [place_ship b n c]  places ship [n] onto the board [b] using the given 
   coordinates [c]*)
val place_ship: board -> ship_name -> coordinate list -> board


(* [move_ship b n c] moves the ship [n] on board [b] to the given coordinates 
   [c]. Raises [Invalid s] if the ship has been sunk or there is not enough 
   coordinates provided. *)
val move_ship: board -> ship_name -> coordinate list -> board


(* [shoot_ship c b] updates the board [b] given the coordinates [c] that the 
   user shot at. Raises [Invalid] if the tile with that coordinate has been shot 
   already. *)
val shoot_ship: coordinate -> board -> board


(* Creates player 1's own board *)
val player_1_own_board:board


(* Creates the oppponent's board for player 1*)
val player_1_opp_board:board


(* Creates player 2's own board *)
val player_2_own_board:board


(* Creates the opponent's board for player 2 *)
val player_2_opp_board:board


(* [special_insert b1 b2 i] places the random special spaces onto both
   player's boards [b1] and [b2]. Neither player can see these spaces. It places
   [i] special_spaces onto each board.*)
val special_insert: board -> board -> int -> board*board


(* [print b] prints the board [b] and updates it after each status command*)
val print: board -> unit
