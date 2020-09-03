
(**The comments/code are inspired by Assignment 2/3.*)
open Battleship
open State
open Command


(**[views_print b] prints each board in [b] *)
let rec views_print blist :unit = match blist with
  |[] -> ()
  |hd::tl -> print hd; views_print tl 


(**[state_check st c b] ensures that the shooting at coordinate [c] on [b] given 
   the state [st] was a [Legal] shot; otherwise, it's [Illegal]*)
let rec shoot_check st coordinate' board' = 
  match shoot st coordinate' board' with
  | Legal new_state -> new_state
  | Illegal s -> ANSITerminal.(print_string [red] ("\n\n"^s ^ "\n\n")); st


(**[place_check st c n b] ensures that the placement of ship [n] onto 
   coordinates [c] on [b] given the state [st] resulted in a [Legal] placement, 
   otherwise it's [Illegal].  *)
let rec place_check  st coordinates' name' board' = 
  match place st  coordinates' (String.lowercase_ascii name') board' with
  |Legal new_state -> new_state
  |Illegal s -> ANSITerminal.(print_string [red] ("\n\n"^s ^ "\n\n")); st


(**[move_check st c n b] ensures that the move of ship [n] onto coordinates [c] 
   on [b] given the state [st] resulted in a [Legal] move, otherwise it's 
   [Illegal]. *)
let rec move_check  st coordinates' name' board' = 
  match move st coordinates' (String.lowercase_ascii name') board' with
  |Legal new_state -> new_state
  |Illegal s -> ANSITerminal.(print_string [red] ("\n\n"^s ^ "\n\n")); st


(**[int_to_unit n] convertes the int [n] into a unit *)
let int_to_unit num = match num with 
  |_ -> ()


(**[end_check st] checks if the End command has been used within the current 
   state [st] and adds new lines after this command so that the next player 
   doesn't see his/her boards.*)
let rec end_check st = match end_turn st with
  |Legal new_state -> 
    print_string ("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" ^
                  "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"); new_state
  |Illegal s -> ANSITerminal.(print_string [red] ("\n\n" ^s ^ "\n\n"));st


(**[same_board b] finds the board in [b] that is the current player's 
   own board.*)
let rec same_board blist = 
  match blist with
  |[] -> failwith "Troll"
  |hd::tl -> if fst (get_owner hd) = snd (get_owner hd) then hd 
    else same_board tl


(**[diff_board b] finds the board in [b] that is the board of the current 
   player's opponent.*)
let rec diff_board blist = 
  match blist with
  |[] -> failwith "Troll"
  |hd::tl -> if fst (get_owner hd) <> snd (get_owner hd) then hd 
    else diff_board tl


(**[alpha_check c] converts each coordinate in [c] into an uppercase letter/number
   combination *)
let rec alpha_check (coordinates': coordinate list) = match coordinates' with 
  |[] -> []
  |hd::tl -> (String.uppercase_ascii hd) :: alpha_check tl


(** [taunt_check st str] checks if taunt command has been used within the current
    state [st] and updates the new state with the message [str]. *)
let taunt_check st str = match taunt st str with
  |Legal new_state -> new_state
  |Illegal _ -> failwith "Failure!"


(* [parsing st str]  performs parse function, determines what the output is
   given the state [st] and the command [str]*)
let rec parsing st str = try (match parse(str) with
    |Surrender -> 
      ANSITerminal.(print_string [red]
                      ("\n\nLoser Loser Loser...LO0O0O0O000OOO0O0O0O0SEERRRRR!"^
                       "\n\n")); 
      Stdlib.exit 0
    |Sunk -> print_string ("\n\nShips sunk: " ^ 
                           String.concat " " (get_ships_sunk st) ^"\n\n");st
    |Taunt t -> taunt_check st (String.concat " " t)
    |Place p -> 
      place_check st (alpha_check (List.tl (p))) (List.hd (p)) 
        (same_board(get_my_views st))
    |Shoot sh -> 
      shoot_check st (String.uppercase_ascii (String.concat " " sh)) 
        (diff_board(get_my_views st))
    |End -> end_check st
    |Shots -> print_string ("\n\nShots left in this turn: "^ 
                            string_of_int (get_shots_left st) ^ "\n\n");st
    | Move m -> 
      move_check st (alpha_check (List.tl (m))) (List.hd (m)) 
        (same_board(get_my_views st)))
  with 
  |  Malformed ->  st
  |  Empty -> st


(** [vic_check st] checks to see if all the ships have been sunk of the other 
    player in state [st]. If they have, then the game is over and a victory 
    message is printed.*)
let vic_check state = 
  if List.length (get_ships_sunk state) < 5 then () 
  else ANSITerminal.(
      print_string [yellow]("\n\nCongratulations!!! Ye' arghhhh the scurviest" ^
                            " of them all!\n\n"); Stdlib.exit 0)


(**[game_loop st str] ensures that the game continues to run after each command 
   [str]. It updates [st] as well. *)
let rec game_loop state str : unit = 
  vic_check state;
  let s = parsing state str in
  try (
    match (parse str) with
    |End -> int_to_unit (Sys.command "clear"); game_loop s (read_line ())
    |a -> views_print (get_my_views s);game_loop s (read_line ()))
  with
  |  Malformed ->
    ANSITerminal.(print_string [red] ("\n\nYou have entered an invalid command"^
                                      " please try again.\n\n"));  
    game_loop state (read_line ())
  |  Empty -> 
    ANSITerminal.(print_string [red] 
                    "\n\nString is empty or only contains spaces.\n\n");  
    game_loop state (read_line ())


(** [play_game f] starts the game with the first command [f]. *)
let play_game f :unit = 
  let p1_state = og_state in game_loop p1_state (f)


let ship_instr = 
  ANSITerminal.(print_string [magenta] 
                  ("\n\nWelcome to the 3110 Battleship Game. Place ye' ships!" ^
                   "\n\nThese are the commands and format you are able to use:"^
                   "\n\nplace <ship name> <coordinates> : use this to place"^
                   " your ships at the beginning of the game.\n"
                   ^ "An 'A' represents the ships that you have placed.\n" ^
                   "    Ex. place martha A.1 A.2\n\n" ^
                   "shoot <coordinate> : use this to shoot at the"^
                   " other player's board.\n" ^ 
                   "An 'X' represents a miss while an 'O' represents a hit.\n" ^
                   "    Ex. shoot A.1\n\n" ^ "move " ^
                   "<ship name> <coordinates> : use this to move your ships.\n" 
                   ^ "You can move each ship once during the entire game.\n" ^
                   "    Ex. move martha B.1 B.2\n\n" ^
                   "end : use this when you are done with your turn - be " ^
                   "careful, you may end it even if you have shots left!"^ 
                   "\n\nsunk : use this to find out how many of your"^ 
                   " opponent's ships you have sunken.\n\n"
                   ^ "shots : use this to determine how many shots you "^ 
                   "currently have left. \n\n"
                   ^ "taunt : use this when you want to taunt the other player " 
                   ^ "- you can type any message that you want!\n\n"
                   ^ "surrender : use this if ye' be a landlubber!"^
                   "\n\n\nEach board has special tiles that, if shot on, can " ^ 
                   "grant a random player an extra shot, or even an extra"
                   ^ " turn!\n" 
                   ^"These are the ship names and their respective lengths:" ^
                   "\n\n" ^
                   "         Ship Names: Martha, Caravel, Leviathan, Amberjack," 
                   ^ " Junk       \n\n" ^
                   "         Ship Lengths: 2, 3, 3, 4, 5\n\n" ^      
                   "Valid coordinates are written in the "^
                   "following form: < Letter: A-J or a-j><.><Number:1-10>.\n\n")
               )


(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  ship_instr;
  play_game (read_line())


(* Execute the game engine. *)
let () = main ()
