module type BattleshipSig = sig
  type board 
  type ship_name = string
  type coordinate = string
  type status = 
    |None
    |Hit
    |Miss
    |Yours
  type special = 
    |Nothing
    |Eturn
    |Eshot
    |Oturn
    |Oshot
  exception UnknownShip of ship_name
  exception UnknownCoordinate of coordinate
  exception Invalid of string
  val get_owner: board -> string*string   
  val get_hit_status: board -> coordinate -> status
  val get_belongs_to: board -> coordinate -> ship_name
  val get_special_space: board -> coordinate -> special
  val get_hp: board -> ship_name -> int
  val get_sunk_status: board -> ship_name -> bool
  val get_coordinates_part: board -> ship_name -> coordinate list
  val get_part_hit: board -> ship_name -> bool list
  val get_been_moved: board -> ship_name -> bool list
  val place_ship: board -> ship_name -> coordinate list -> board
  val move_ship: board -> ship_name -> coordinate list -> board
  val shoot_ship: coordinate -> board -> board
  val player_1_own_board:board
  val player_1_opp_board:board
  val player_2_own_board:board
  val player_2_opp_board:board
  val special_insert: board -> board -> int -> board*board
  val print: board -> unit
end






module BattleshiCheck : BattleshipSig = Battleship


module type CommandSig = sig

  type object_phrase = string list

  type command = 
    | Shoot of object_phrase
    | Sunk
    | Surrender
    | Taunt of object_phrase
    | Place of object_phrase
    |End
    |Shots
    |Move of object_phrase

  exception Empty

  exception Malformed

  val parse : string -> command
end

module CommandCheck : CommandSig = Command


module type StateSig = sig
  type t 
  val og_state:t
  val get_shots_left: t -> int
  val get_ships_sunk: t -> Battleship.ship_name list
  val get_opp_sunk: t ->  Battleship.ship_name list
  val get_must_place: t -> Battleship.ship_name list
  val get_opp_place: t -> Battleship.ship_name list
  val get_my_views: t -> Battleship.board list
  val get_opp_views: t -> Battleship.board list
  val get_opp_pending_special: t -> Battleship.special list 
  type result = Legal of t | Illegal of string
  val place: t -> Battleship.coordinate list -> Battleship.ship_name -> 
    Battleship.board -> result
  val move: t -> Battleship.coordinate list -> Battleship.ship_name -> 
    Battleship.board -> result
  val shoot: t -> Battleship.coordinate -> Battleship.board -> result
  val taunt: t -> string -> result
  val end_turn: t -> result
end

module StateCheck : StateSig = State

module type AuthorsSig = sig
  val hours_worked : int
end

module AuthorsCheck : AuthorsSig = Authors
