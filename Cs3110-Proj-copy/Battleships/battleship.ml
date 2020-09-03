(**The code within Battleship was inspired by Assignment 2 and Assigment 3*)

type ship_name = string
type coordinate = string
exception UnknownShip of ship_name
exception UnknownCoordinate of coordinate
exception Invalid of string


(* Represents the part of each ship *)
type part = {
  coordinate_part: coordinate;
  hit_status: bool;
  been_moved: bool
}


(* Represents each ship*)
type ship = {
  name: ship_name;
  hp: int;
  parts: part list;
  sunk_status: bool;
}


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


(*Represents each tile on the board  *)
type tile = {
  coordinate: coordinate;
  hit_status: status;
  belongs_to: ship_name;
  special_space: special;
}


type board = {
  tiles: tile list;
  ships: ship list;
  owner: string*string
}


let get_owner board' = board'.owner


(** [get_tile b c] gets the tile from [b] that [c] is in.
    Raises [UnknownCoordinate c] if [c] is not a coordinate in [b]. *)
let rec get_tile board' coordinate' = match board'.tiles with
  |[] -> raise(UnknownCoordinate coordinate')
  |hd::tl -> if hd.coordinate = coordinate' then hd
    else get_tile {board' with tiles = tl} coordinate'


let get_hit_status board' coordinate' = 
  (get_tile board' coordinate').hit_status


let get_belongs_to board' coordinate' = 
  (get_tile board' coordinate').belongs_to


let get_special_space board' coordinate' = 
  (get_tile board' coordinate').special_space


(** [get_ship b s] gets the information of the ship [s] in [b].
    Raises [UnknownShip s] if [s] is not a ship in [b].*)
let rec get_ship board' name' = match board'.ships with
  |[] -> raise(UnknownShip name')
  |hd::tl -> if hd.name = name' then hd 
    else get_ship {board' with ships = tl} name'


let get_hp board' name' = 
  (get_ship board' name').hp


(** [get_parts b n] gets the parts of the ship [n] in [b].
    Raises [UnknownShip n] if [n] is not a ship in [b].*)
let get_parts board' name' = 
  (get_ship board' name').parts


let get_sunk_status board' name' =
  (get_ship board' name').sunk_status


(** [to_list_coordinate p] gets the coordinate from each part [p] and
    returns a list of theses coordinates   *)
let rec to_list_coordinates parts' = match parts' with
  |[] -> []
  |hd::tl -> hd.coordinate_part :: to_list_coordinates tl


let get_coordinates_part board' name' = 
  to_list_coordinates (get_parts board' name')



(** [get_part_hit_helper p] returns a list of the hit status' of each part in 
    [p].*)
let rec get_part_hit_helper (parts':part list) = match parts' with 
  |[] -> []
  |hd::tl -> hd.hit_status :: (get_part_hit_helper tl)


let get_part_hit board' name' = 
  get_part_hit_helper  (get_parts board' name')


(**[get_been_moved_helper p] checks to see if each part in [p] has been moved
   and returns the resulting booleans in a list.*)
let rec get_been_moved_helper parts' = match parts' with
  |[] ->[]
  |hd::tl -> hd.been_moved :: get_been_moved_helper tl


let get_been_moved board' name' = 
  get_been_moved_helper (get_parts board' name')


(* [owner_check b] determines if the board [b] belongs to the current player. *)
let owner_check board' =
  if fst board'.owner = snd board'.owner then Yours else None


(** [tiles_update c t n b] updates the tile within [t] with the coordinate [c] 
    after ship [n] has been placed on [b] *)
let rec tiles_update coordinate' tiles' name' board' = match tiles' with 
  |[] -> []
  |hd::t -> if hd.coordinate = coordinate' 
    then {hd  with  belongs_to = name'; hit_status = owner_check board'}::t 
    else hd :: tiles_update coordinate' t name' board'



(**[parts_update p c] updates the coordinate part within [p] to coordinate [c]
   after a ship has been placed.
   Raises [Invalid s] if the ship has already been placed.*)
let rec parts_update parts' coordinate' = match parts' with 
  |[] -> raise (Invalid "This ship has already been placed.")
  |hd::tl -> if hd.coordinate_part = "Nowhere0" 
    then {hd with coordinate_part = coordinate'} :: tl
    else hd :: parts_update tl coordinate' 


(**[ships_update n s c] updates the ship within [s] with name [n]. It updates 
   the coordinate part of the ship to have coordinate [c]. *)
let rec ships_update name' ships' coordinate' = match ships' with
  |[] -> []
  |hd::t-> if hd.name = name' 
    then {hd with parts = parts_update hd.parts coordinate'}::t 
    else hd:: ships_update name' t coordinate'


(**[place_helper b p c n] pdates the board [b] after the ship [n] has been 
   placed on the coordinates [c]. Updates each part within [p] of the ship.
   Raises [Invalid s] if there is not enough to coordinates to place the ship.*)
let rec place_helper board' (parts':part list) coordinates' name' = 
  if List.length parts' <>  List.length coordinates' 
  then raise(Invalid "Insufficient amount of coordinates to place this ship.")
  else match parts' with 
    |[] -> board'
    |hd::tl -> place_update board' tl coordinates' name'


(**[place_update b p c n] updates the board [b] after the ship [n] has been 
   placed on the coordinates [c]. Updates each part within [p] of the ship.
   Raises [Invalid s] if the tile already has a ship on it. *)
and place_update board' parts' coordinates' name' = match coordinates' with
  |[] -> board'
  |h::t -> if (get_tile board' h).belongs_to <> "" 
    then raise (Invalid "Le tile already has a ship on it!") 
    else 
      place_helper {board' with 
                    tiles =tiles_update h board'.tiles name' board';
                    ships = ships_update name' board'.ships h} parts' t name'


(**[alpha s] gets the letter portion of the coordinate [s]. 
   Raises [Invalid s] if they aren't valid coordinates.*)
let alpha str = if String.contains str '.' 
  then List.hd (String.split_on_char '.' str) 
  else raise
      (Invalid "You aren't even trying to type actual coordinates, are you?")


(**[num s] gets the number portion of the coordinate [s]*)
let num str = 
  let value = List.hd (List.tl (String.split_on_char '.' str)) in 
  match value with 
  |"1" |"2" |"3" |"4" |"5" |"6" |"7" |"8" |"9" |"10" -> value
  |_ -> raise (Invalid ("You aren't even trying to type actual coordinates, "
                        ^"are you?"))


(**[coord_checker c] checks that the coordinates [c] are valid. 
   This means that the letter and number must be within one space of each other.
   Ex. Given the coordinate C.2, then C.1, C.3, B.1, B.2, B.3, D.1, D.2, and D.3 
   are all valid coordinates.
   Raises [Invalid s] if the placement is not valid. *)
let rec coord_checker coordinates' = match coordinates' with
  |[] -> ()
  |hd::[] -> coord_checker []
  |hd::tl -> 
    let alpha_dist =  
      Int.abs(int_of_char(String.get (alpha hd) 0) - 
              int_of_char(String.get (alpha (List.hd tl)) 0)) in 
    let num_dist = Int.abs (int_of_string  (num hd) - 
                            int_of_string (num (List.hd tl))) in
    if num_dist > 1 || alpha_dist >1 
    then raise(Invalid "This placement is not valid!") 
    else coord_checker tl


let place_ship board' name' coordinates' = 
  coord_checker coordinates';
  place_helper board' (get_parts board' name') coordinates' name'


(**[coord_match p t] returns true if the coordinate part in [p] and the 
   coordinate in tile [t] matches and hasn't been moved, false otherwise.*)
let rec coord_match pts tl = match pts with 
  |[] -> false
  |hd::t -> if hd.coordinate_part = tl.coordinate && hd.been_moved = false  
    then true else coord_match t tl 


(**[move_tiles_update c t p n b] updates the tile within [t] with coordinate [c] 
   after the ship [n] has been moved to that coordinate on the board [b]. It 
   also updates the part with the coordinate [c] in [p]. It resets the old tile 
   so that it doesn't have the ship [n] anymore.*)
let rec move_tiles_update coordinate' tiles' parts' name' board' = 
  match tiles' with 
  |[] -> []
  |hd::t -> if coord_match parts' hd = true 
    then  {hd  with  belongs_to = ""; hit_status = None} :: 
          move_tiles_update coordinate' t parts' name' board'
    else if hd.coordinate = coordinate'  
    then {hd  with  belongs_to = name'; hit_status = owner_check board'} :: 
         move_tiles_update coordinate' t parts' name' board'
    else hd :: move_tiles_update coordinate' t parts' name' board'


(**[moving_parts p c] updates each part in [p] after that ship has been moved to 
   coordinate [c]. Raises [Invalid s] if the ship has already been moved. *)
let rec moving_parts parts' coordinate'  = match parts' with 
  |[] -> raise(Invalid "The ship has already been moved!")
  |hd::tl -> 
    if hd.been_moved = true 
    then hd :: moving_parts tl coordinate' 
    else {hd with coordinate_part = coordinate'; been_moved = true} :: tl


(** [move_ships_update n s c] finds the ship in [s] with the name [n] and 
    updates that part with coordinate [c] *)
let rec move_ships_update name' ships' coordinate' = 
  match ships' with
  |[] -> []
  |hd::t-> if hd.name = name' 
    then {hd with parts = moving_parts hd.parts coordinate'}::t 
    else hd:: move_ships_update name' t coordinate'


(** [move_helper b c n] updates the tiles and ship information for the ship with 
    name [n] on the board [b] after that ship has been moved to the coordinates 
    in [c] Raises [Invalid s] if the player tries to move the ship to a tile 
    that has already been hit*)
let rec move_helper board' coordinates' name' = 
  match coordinates' with
  |[] -> board'
  |h::t -> if (get_tile board' h).hit_status <> None 
    then raise (Invalid "Ye' may not move there! Try elsewhere.") 
    else move_helper {board' with tiles = move_tiles_update h board'.tiles 
                                      (get_parts board' name') name' board';
                                  ships =move_ships_update name' board'.ships h} 
        t name'


let move_ship board' name' coordinates' = 
  coord_checker coordinates';
  if (get_ship board' name').sunk_status = true 
  then raise (Invalid "That ship has already been sunken down!")
  else if List.length (get_parts board' name') <>  List.length coordinates' 
  then raise(Invalid "Insufficient amount of coordinates to move this ship.")
  else move_helper board' coordinates' name'


(**[shoot_tiles_update c t] updates the tile within [t] with coordinate [c] 
   after that tile has been shot at.*)
let rec shoot_tiles_update coordinate' tiles' = match tiles' with 
  |[] -> []
  |hd::tl -> if hd.coordinate = coordinate' then 
      (if hd.belongs_to = "" then {hd with hit_status = Miss} :: tl 
       else {hd with hit_status = Hit} :: tl) 
    else hd :: shoot_tiles_update coordinate' tl


(**[shoot_parts_update c p] updates the hit status of a coordinate part in [p] 
   at coordinate [c] after it has been shot*)
let rec shoot_parts_update coordinate' parts' = match parts' with
  |[] -> []
  |hd::tl -> if hd.coordinate_part = coordinate' 
    then {hd with hit_status = true} :: tl
    else hd :: shoot_parts_update coordinate' tl


(**[status_update s b] updates the hp and the sunk status of the ship [s] in 
   [b]*)
let status_update ship' board' = 
  if ship'.hp > 1 then {ship' with hp = ship'.hp - 1; sunk_status = false}  
  else (print_string("\n\n "^ ship'.name ^ " has been sunk!\n\n"); 
        {ship' with hp = 0; sunk_status = true})


(**[shoot_ships_update c s b] checks if there is a ship within [s] on the tile 
   at coordinate [c] after that tile has been shot on [b]. It updates the ship 
   at that tile.*)
let rec shoot_ships_update coordinate' ships' board' = match ships' with
  |[] ->[]
  |hd::tl -> if (get_tile board' coordinate').belongs_to = hd.name 
    then (status_update ({hd with parts = (shoot_parts_update coordinate' 
                                             (get_parts board' hd.name))})board'
          :: tl )
    else hd :: shoot_ships_update coordinate' tl board'


let shoot_ship coordinate' board' = 
  if (get_tile board' coordinate').hit_status <> None &&
     (get_tile board' coordinate').hit_status <> Yours
  then raise (Invalid "Ye' 'ave already shot there!") 
  else  {board' with tiles = shoot_tiles_update coordinate' board'.tiles ; 
                     ships = shoot_ships_update coordinate' board'.ships board'}


(*____________________________________________________________________________*)

(**All of the code below this line creates the board and ships. It assigns the 
   letter and number to each square within the matrix board. *)


(** [to_list i a] creates a  list of tiles by concatenating [s] and [a]
    to represent the board *)
let rec to_list int alpha = match int with 
  | 11 -> []
  |_-> 
    {coordinate = alpha ^ "." ^ string_of_int int; hit_status = None;
     belongs_to = ""; special_space = Nothing; }::(to_list (int + 1) alpha)


let a = to_list 1 "A" 
let b = to_list 1 "B"
let c = to_list 1 "C"
let d = to_list 1 "D"
let e = to_list 1 "E"
let f = to_list 1 "F"
let g = to_list 1 "G"
let h = to_list 1 "H"
let i = to_list 1 "I"
let j = to_list 1 "J"


let t_list = a @ b @ c @ d @ e @ f @ g @ h @ i @ j


let rec to_parts_list int name' = match int with
  | 0 -> []
  |_ -> {
      coordinate_part = "Nowhere0";hit_status = false; been_moved = false} :: 
      to_parts_list (int - 1) name'


let martha = {
  name = "martha";
  hp = 2;
  parts = to_parts_list 2 "martha";
  sunk_status = false
}


let junk = {
  name = "junk";
  hp = 5;
  parts = to_parts_list 5 "junk";
  sunk_status = false
}


let amberjack = {
  name = "amberjack";
  hp = 4;
  parts = to_parts_list 4 "amberjack";
  sunk_status = false
}


let leviathan = {
  name = "leviathan";
  hp = 3;
  parts = to_parts_list 3 "leviathan";
  sunk_status = false
}


let caravel = {
  name = "caravel";
  hp = 3;
  parts =  to_parts_list 3 "caravel";
  sunk_status = false
}


let player_1_own_board  = {
  tiles = t_list;
  ships = [martha;leviathan;caravel;amberjack;junk];
  owner = ("Player 1","Player 1")
}


let player_1_opp_board  = {
  tiles = t_list;
  ships = [martha;leviathan;caravel;amberjack;junk];
  owner = ("Player 1","Player 2")
}


let player_2_own_board  = {
  tiles = t_list;
  ships = [martha;leviathan;caravel;amberjack;junk];
  owner = ("Player 2","Player 2")
}


let player_2_opp_board  = {
  tiles = t_list;
  ships = [martha;leviathan;caravel;amberjack;junk];
  owner = ("Player 2","Player 1")
}


(**[tile_changes n c t] assigns a special space to the tile in [t] with
   coordinate [c]. The type of special space is determined by the random number 
   [n].  *)
let rec tile_changes num' coordinate' tiles' = 
  Random.self_init ();
  match tiles' with
  |[] -> failwith "Should not end up reaching here"
  | hd::tl -> if hd.coordinate = coordinate' && hd.special_space <>  Nothing
    then hd::tl 
    else if hd.coordinate = coordinate' && num' = 1 
    then {hd with special_space = Eturn }::tl
    else if hd.coordinate = coordinate' && num' = 2 
    then {hd with special_space = Eshot}::tl
    else if hd.coordinate = coordinate' && num' = 3 
    then {hd with special_space = Oshot}::tl
    else if hd.coordinate = coordinate' && num' = 4
    then {hd with special_space = Oturn}::tl
    else hd:: tile_changes num' coordinate' tl


let rec special_insert boarda boardb dec = 
  Random.self_init ();
  let randomnum = (Random.int 10) + 1 in
  let spec_num = (Random.int 4) + 1 in
  let num_to_alpha = match (Random.int 10) + 1 with
    |1 -> "A"|2 -> "B"|3 -> "C"|4 -> "D"|5 -> "E"|6 -> "F"|7 -> "G"|8-> "H"
    |9 -> "I"|10 -> "J"|_ -> failwith "This will never reach here." in
  match dec with
  | 0 -> (boarda,boardb)
  |_ -> 
    special_insert 
      {boarda with tiles = tile_changes spec_num
                       (num_to_alpha ^ "." ^ (string_of_int randomnum)) 
                       boarda.tiles }
      {boardb with tiles = tile_changes spec_num 
                       (num_to_alpha ^ "." ^ (string_of_int randomnum)) 
                       boardb.tiles } (dec - 1)


(**[split s] splits the coordinate [s]*)
let split str = List.hd (String.split_on_char '.' str)


(**[comparison s1 s2] checks to see if the two strings [s1] and [s2] are equal*)
let comparison str1 str2 = if str1 <> str2 then print_string("|\n") else ()


(**[alpha_compare t1 t2] compares [t1] and [t2]. *)
let alpha_compare t1 t2 = comparison (split t1) (split t2)


let rec print board' = match board'.tiles with
  |[] -> print_string("\n");()
  |hd::tl -> print_string("|"); match hd.hit_status with 
    |None -> print_string(" "); tl_checker hd tl board'
    |Hit -> print_string("O") ;tl_checker hd tl board'
    |Miss -> print_string("X"); tl_checker hd tl board'
    |Yours -> print_string("A"); tl_checker hd tl board'


(**[tl_checker h t b] prints the end of the row of the board [b] by checking if 
   [tl] is empty, otherwise compares the coordinates of [hd]*)
and tl_checker hd tl board' = if tl  = [] 
  then (print_string("|"); print {board' with tiles = tl}) 
  else alpha_compare hd.coordinate (List.hd tl).coordinate; 
  print {board' with tiles = tl}
