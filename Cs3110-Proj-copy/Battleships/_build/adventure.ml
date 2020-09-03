open Yojson.Basic.Util

type room_id = string
type item_id = string
type exit_name = string
exception UnknownRoom of room_id
exception UnknownExit of exit_name
exception UnknownItem of item_id




type item = {
  item_name: item_id;
  current_room: room_id;
  points: int;
  treasure_room_points: int;
}


(**type [exit] represents the abstract type of values representing an exit 
   found linked to a room, or rooms, of a corresponding adventure. It  consists
   of the properties exit_name, which is the name of this exit, and exit_id,
   which consists of the identifier of the room it leads to.*)
type exit = {
  exit_name: exit_name ;
  exit_id: room_id ;
}

(** type [room] represents the abstract type of values representing a room 
    found in its corresponding adventure. It consists of the properties 
    current_id, which is the identifier of the room, description, which is 
    the description describing the room, and exits-- which contains the exits
    from the room.*)
type room = {
  current_id: room_id;
  description : string ;
  exits: exit list ;
  score_change: int;
}


(** type [t] is the abstract type of values representing adventures. It consists
    of the properties [rooms], which consists of all of the possible rooms 
    found in the adventure, and [start_room]-- which consists of the room_id of 
    the room in which one begins their "adventure in." *)
type t = {
  rooms: room list  ;
  start_room: string ;
  items: item list;
  treasure_room: room_id;
  win_message: string;
}


(** The following three helper functions are meant solely to parse 
    Adventure json files. These functions are essentially the same as the ones 
    from the json_tutorial file.
    Requires: [j] is a valid JSON adventure representation.  *)
let exit_of_json (j:Yojson.Basic.t) = {
  exit_name = j |> member "name" |> to_string;
  exit_id = j |> member "room id" |> to_string;
}


let items_of_json (j:Yojson.Basic.t) = {
  item_name  = j |> member "item name" |> to_string ;
  current_room  =  j |> member  "current room" |> to_string ;
  points = j |> member "item points" |> to_int;
  treasure_room_points = j |> member "treasure room points" |> to_int;
}


let room_of_json (j:Yojson.Basic.t) = {
  current_id = j |> member "id" |> to_string ;
  description = j |> member "description" |> to_string ;
  exits = j |> member "exits" |> to_list |> List.map exit_of_json ;
  score_change = j |> member  "points" |> to_int;
}


let parse (j:Yojson.Basic.t) = {
  rooms = j |> member "rooms" |> to_list |> List.map room_of_json;
  start_room = j |> member "start room" |> to_string;
  items = j |> member "quest items" |> to_list |> List.map items_of_json;
  treasure_room = j |> member "treasure room" |> to_string;
  win_message = j |> member "win message" |> to_string
}



let from_json (json:Yojson.Basic.t) : t = 
  parse json


let start_room (adv:t) : room_id =
  adv.start_room


let get_items (adv:t): item list = 
  adv.items

let get_treasure_rm (adv:t) : room_id = 
  adv.treasure_room

let get_win_msg (adv:t) : string  = 
  adv.win_message



let rec remove x y = 
  match x with
  |[] -> []
  |hd::tl -> if hd.item_name = y then tl else hd :: remove tl y






(** [empty room] returns an empty room, with no exits, a description of why 
    I created this room, and the current_id of empty room.*)
let made_up_room = 
  {
    current_id = "made up room";
    description = "It is a made up room that I created in order to vanquish 
    pattern matching.";
    exits = [];
    score_change = 0;
  }

(**[get_room room rooms] returns the actual room that matches the room_id of 
   [room] from the room list of [rooms]. If there is no such room, then a fabricated 
   Requires: 
   [room]: Follows the preconditions of room types that were specified in the 
   A2 handout. 
   [rooms]: Each room follows the preconditions of room types that were 
   specified in the A2 handout.  *)
let rec get_room (room:room_id) rooms : room =
  match rooms with 
    [] -> made_up_room
  |hd::tl -> if hd.current_id = room then hd else get_room room tl 


(**[get_exit exit exits] returns the room_id of the room that one ends up in 
   when exiting from the exit named [exit] found from the list of all possible 
   [exits]. 
   Requires: 
   [exit]: Follows the preconditions of exit types that were specified in the 
   A2 handout. 
   [exits]: Each room follows the preconditions of room types that were 
   specified in the A2 handout.  *)
let rec get_exit (exit:exit_name) (exits:exit list) : room_id  =
  match exits with 
    [] -> ""
  |hd::tl -> if hd.exit_name = exit then hd.exit_id else get_exit exit tl 


let room_ids (adv:t) :room_id list = 

  adv.rooms |> List.map (fun room: room_id -> room.current_id  ) |> 
  List.sort_uniq String.compare 


(**[room_check adv room] returns whether [room] is a valid room in adventure 
   file [adv].
   Requires:
   [room]: Follows the preconditions of room types that were specified in the 
   A2 handout.  *)
let room_check (adv:t) (room:room_id) : bool =
  room_ids adv|> List.mem room



let rec get_room_items (adv:t)(it_list:item list)(room:room_id): item_id list =
  if room_check adv room = false then raise (UnknownRoom room)
  else match it_list with 
    |[] -> []
    |hd::tl -> if room  = hd.current_room then (hd.item_name :: 
                                                get_room_items adv tl room )
      else get_room_items adv tl room 



let description (adv: t) (room: room_id) : string =
  if room_check adv room = false then raise (UnknownRoom room)
  else (get_room room adv.rooms).description


let exits (adv:t) (room:room_id): exit_name list =
  if room_check adv room = false then raise (UnknownRoom room)
  else
    (get_room room adv.rooms).exits |> 
    List.map (fun exit :exit_name -> exit.exit_name) |> List.sort_uniq 
      String.compare


let next_room (adv:t) (room:room_id) (ex:exit_name):room_id =
  if room_check adv room = false then raise (UnknownRoom room)
  else if room |> exits adv |> List.mem ex = false then raise (UnknownExit ex)
  else
    get_exit ex (get_room room adv.rooms).exits


let next_rooms (adv:t) (room:room_id):room_id list =
  if room_check adv room = false then raise (UnknownRoom room)
  else
    (get_room room adv.rooms).exits|> 
    List.map (fun exit : room_id -> exit.exit_id) |> List.sort_uniq 
      String.compare 


let room_score (adv:t)(room:room_id): int =
  if room_check adv room = false then raise (UnknownRoom room)
  else (get_room room adv.rooms).score_change
