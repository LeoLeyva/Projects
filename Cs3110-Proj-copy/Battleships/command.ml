(**This code is directly from Assignment 2/3, with some slight modifications
   to fit this project.*)


type object_phrase = string list


type command = 
  |Shoot of object_phrase
  |Sunk
  |Surrender
  |Taunt of object_phrase
  |Place of object_phrase
  |End
  |Shots
  |Move of object_phrase


exception Empty
exception Malformed


(* [no_spaces str list new_list] checks if the [str] is empty. It then gets
   rid of any spaces included in [list] and adds it to [new_list]  *)
let rec no_spaces str list new_list = 
  if str = "" then raise Empty 
  else match list with
    | [] -> new_list
    | h::t -> if h = "" then no_spaces str t new_list 
      else no_spaces str t (h::new_list) 


(* [remove list] removes the string form of the command from the string list and 
   returns the type command corresponding to the string.*)
let rec remove (list:object_phrase) = 
  match list with
  |[] -> raise (Malformed)
  |h::t -> let len = List.length t in 
    let hd = String.lowercase_ascii h in
    if hd = "shoot" && len <> 0 then Shoot t 
    else if hd = "taunt" && len <> 0 then Taunt t 
    else if hd = "surrender" && len = 0 then Surrender 
    else if hd ="place" && len <> 0 then Place t 
    else if hd = "sunk" && len = 0 then Sunk 
    else if hd = "end" && len = 0 then End 
    else if hd = "shots" && len = 0 then Shots 
    else if hd = "move" && len <> 0 then Move t
    else remove t


let parse str =
  let split = String.split_on_char ' ' str in
  let no_space_norev = no_spaces str split [] in
  let no_space = List.rev no_space_norev in
  if no_space = [] then raise Empty 
  else remove no_space
