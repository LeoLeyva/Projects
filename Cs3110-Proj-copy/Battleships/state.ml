(**The code within State was inspired by Assignment 2/3. *)

open Battleship


type t = {
  shots_left: int;
  ships_sunk: ship_name list;
  opp_sunk: ship_name list;
  must_place: ship_name list;
  opp_place:ship_name list;
  my_views: board list;
  opp_views: board list;
  opp_pending_special: special list;
  first_turn: bool;
  opp_first_turn: bool;
  my_taunt: string;
  opp_taunt: string
}


let og_state = 
  Random.self_init ();
  let randomnum1 = (Random.int 25) + 1  in
  let randomnum2 = (Random.int 25) + 1 in
  let insert_spaces = 
    special_insert player_1_own_board player_2_opp_board randomnum1 in 
  let insert_spaces2 =
    special_insert player_2_own_board player_1_opp_board randomnum2 in
  {
    shots_left = 5;
    ships_sunk = [];
    opp_sunk = [];
    must_place = ["martha";"leviathan";"caravel";"amberjack";"junk"];
    opp_place = ["martha";"leviathan";"caravel";"amberjack";"junk"];
    my_views = [fst insert_spaces;snd insert_spaces2];
    opp_views = [fst insert_spaces2;snd insert_spaces];
    opp_pending_special = [];
    first_turn = true;
    opp_first_turn = true;
    my_taunt = "";
    opp_taunt = "";
  } 


let get_shots_left (st:t) = st.shots_left


let get_ships_sunk (st:t) = st.ships_sunk


let get_opp_sunk (st:t) = st.opp_sunk


let get_must_place (st:t) = st.must_place


let get_opp_place (st:t) = st.opp_place


let get_my_views (st:t) = st.my_views


let get_opp_views (st:t) = st.opp_views


let get_opp_pending_special (st:t) = st.opp_pending_special


type result = Legal of t | Illegal of string


(**[board_place_update b1 b c n] updates the board [b1] within [b] after a ship 
   [n] has been placed at the coordinates [c] *)
let rec board_place_update board' boards' coordinates' name'= match boards' with 
  |[] ->[]
  |hd::tl  -> if snd (get_owner board') = snd (get_owner hd) 
    then (place_ship hd name' coordinates') :: 
         board_place_update board' tl coordinates' name' 
    else hd :: board_place_update board' tl coordinates' name' 


let place (st:t) coordinates' name' board' = 
  try Legal {
      shots_left = st.shots_left;
      ships_sunk = st.ships_sunk;
      opp_sunk = st.opp_sunk;
      must_place =  List.filter (fun x -> x <> name') st.must_place;
      opp_place = st.opp_place;
      my_views = board_place_update board' st.my_views coordinates' name';
      opp_views = board_place_update board' st.opp_views coordinates' name';
      opp_pending_special = st.opp_pending_special;
      first_turn = st.first_turn;
      opp_first_turn = st.opp_first_turn;
      my_taunt = st.my_taunt;
      opp_taunt = st.opp_taunt}
  with
  |Invalid s-> Illegal (s ^ ".") 
  |UnknownCoordinate c -> 
    Illegal "These coordinate entries are unknown. Please try again!"
  |UnknownShip sh -> 
    Illegal ("Either you have placed this ship, or the name ye' have provided " 
             ^ "is not valid.")


(**[board_move_update b1 b c n] updates the board [b1] within [b] after the ship 
   [n] has been moved to the coordinates [c]. *)
let rec board_move_update board' boards' coordinates' name'= match boards' with 
  |[] ->[]
  |hd::tl  -> if snd (get_owner board') = snd (get_owner hd) 
    then (move_ship hd name' coordinates') :: 
         board_move_update board' tl coordinates' name' 
    else hd :: board_move_update board' tl coordinates' name' 


let move (st:t) coordinates' name' board' = 
  if List.length st.must_place > 0 
  then Illegal "\n\nYou haven't placed all of your ships on the board yet!\n\n"
  else try
      Legal {
        shots_left = st.shots_left;
        ships_sunk = st.ships_sunk;
        opp_sunk = st.opp_sunk;
        must_place = st.must_place;
        opp_place = st.opp_place;
        my_views = board_move_update board' st.my_views coordinates' name';
        opp_views = board_move_update board' st.opp_views coordinates' name';
        opp_pending_special = st.opp_pending_special;
        first_turn = st.first_turn;
        opp_first_turn = st.opp_first_turn;
        my_taunt = st.my_taunt;
        opp_taunt = st.opp_taunt}
    with
    |Invalid s-> Illegal (s ^ ".") 
    |UnknownCoordinate c -> 
      Illegal "These coordinate entries are unknown. Please try again!"
    |UnknownShip sh -> 
      Illegal ("Either you have moved this ship, or the name ye' have provided "
               ^ "is not valid.")


(**[board_shoot_update b1 b c] updates the board [b1] within [b] after 
   coordinate [c] has been shot.*)
let rec board_shoot_update board' boards' coordinate' = match boards' with 
  |[] ->[]
  |hd::tl  -> if snd (get_owner board') = snd (get_owner hd) 
    then shoot_ship coordinate' hd :: board_shoot_update board' tl coordinate' 
    else hd :: board_shoot_update board' tl coordinate' 


(**[sunk_check b s] gets the sunk_status of each ship within [s] on the board 
   [b] and updates the list of ships that have been sunk.*)
let rec sunk_check board' ships' = match ships' with
  |[] -> []
  |hd::tl -> if get_sunk_status board' hd = true then hd :: sunk_check board' tl 
    else sunk_check board' tl


(**[board_match b1 b] gets the board in [b] that matches [b1]*)
let rec board_match board' boards' = 
  match boards' with 
  |[] -> failwith ("Impossible to fail; troll.")
  |hd::tl -> if snd (get_owner board') = snd (get_owner hd) then hd
    else board_match board' tl


(**[shots_update st sp] updates the number of shots of the current player after 
   landing on a special space [sp]. This updates the state [st]. *)
let shots_update (st:t) special_space' = 
  if special_space' = Eturn 
  then (print_string ("\n\nYe' have landed on a special space; " ^
                      "have an extra turn!\n\n");
        5 - List.length st.ships_sunk)
  else if special_space' = Eshot
  then (print_string ("\n\nYe' have landed on a special space; " ^
                      "have an extra shot!\n\n");
        st.shots_left) else st.shots_left - 1


(**[opp_pending_update st sp] updates the special spaces in state [st] if the 
   current player landed on a space [sp] that benefits the opposing player*)
let opp_pending_update (st:t) special_space' = 
  if special_space' = Oshot 
  then (print_string ("\n\nYe' have landed on a special space; " ^
                      "your opponent gets an extra shot!\n\n"); 
        Oshot :: st.opp_pending_special) 
  else if special_space' = Oturn 
  then (print_string ("\n\nYe' have landed on a special space; " ^ 
                      "your opponent gets an extra turn!\n\n");  
        Oturn :: st.opp_pending_special) 
  else st.opp_pending_special


let shoot (st:t) coordinate' board'  = 
  try let special_space = get_special_space board' coordinate' in 
    if st.shots_left <= 0 
    then Illegal "\n\nYe've ran out shots! End your turn, ya scallywag!\n\n"
    else if List.length st.must_place > 0 
    then Illegal "\n\nYou haven't placed all of your ships on the board yet!\n\n"
    else if st.first_turn == true 
    then Illegal "\n\nYe' can't shoot in your first turn!"
    else
      let updated_boards boards' = board_shoot_update board' boards' coordinate' 
      in Legal
        {shots_left = shots_update st special_space;
         ships_sunk =sunk_check(board_match board' (updated_boards st.my_views)) 
             ["martha";"leviathan";"caravel";"amberjack";"junk"];
         opp_sunk = st.opp_sunk;
         must_place = st.must_place;
         opp_place = st.opp_place;
         my_views = updated_boards st.my_views;
         opp_views = updated_boards st.opp_views;
         opp_pending_special = opp_pending_update st special_space;
         first_turn = st.first_turn;
         opp_first_turn = st.opp_first_turn;
         my_taunt = st.my_taunt;
         opp_taunt = st.opp_taunt } with
  |Invalid s -> Illegal (s ^ ".")
  |UnknownCoordinate c -> Illegal "This coordinate is unknown. Please try again!"


(**[shots_left_update s p] updates the number of shots the next player will 
   receive given the number of ships the other player has sunk [s] and if the 
   player has received any extra shots or turns from a special space [p].*)
let rec shots_left_update suint penlst = match penlst with
  |[] -> 5  - suint
  |hd::tl -> if hd = Oturn then 5 -  suint + shots_left_update suint tl 
    else 1 + shots_left_update suint tl

(** [taunt st str] updates the state [st] after the current player uses the 
    taunt command to send a message [st] to the other player. This is always [Legal] *)  
let taunt (st:t) (str: string) = 
  Legal {
    shots_left = st.shots_left;
    ships_sunk = st.ships_sunk;
    opp_sunk = st.opp_sunk;
    must_place = st.must_place;
    opp_place = st.opp_place;
    my_views = st.my_views;
    opp_views = st.opp_views;
    opp_pending_special = st.opp_pending_special;
    first_turn = st.first_turn;
    opp_first_turn = st.opp_first_turn;
    my_taunt = str;
    opp_taunt = st.opp_taunt
  }


let end_turn (st:t) = 
  if st.must_place <>  [] 
  then Illegal "Ye' havent placed all your ships, matey!"
  else
    Legal {
      shots_left = 
        shots_left_update (List.length st.opp_sunk) st.opp_pending_special;
      ships_sunk = st.opp_sunk;
      opp_sunk = st.ships_sunk;
      must_place = st.opp_place;
      opp_place = st.must_place;
      my_views = st.opp_views;
      opp_views = st.my_views;
      opp_pending_special = [];
      first_turn = st.opp_first_turn;
      opp_first_turn = false;
      my_taunt =  if st.my_taunt <> "" then 
          (print_string ("\n\nMessage from the enemy: " ^ st.my_taunt ^ "\n\n");
           st.opp_taunt) 
        else st.opp_taunt;
      opp_taunt = st.opp_taunt
    }
