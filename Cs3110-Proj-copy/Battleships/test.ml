(**Test Plan:

   Tested via. OUnit:
   - All of the functions in the Battleship.mli except for 
     get_special_space, special_insert, and print.
   - Parse from Command.mli.


   Tested via. the terminal and running the game:
   - The functions stated in state.mli.
   - The functions stated in main.ml.
   - special_space, special_insert, and print from Battleship.mli.


   We used glass-box testing for most-to-all of the testing regarding this 
   project. We would implement our code, and then develop test cases in order 
   to test our logic as well as our code.


   We believe that our testing approach was suitable for the system that we
   created due to the fact that most of the functions in Battleship.mli and 
   command.mli could not really be directly tested by running the game-- mostly
   because the option to run isn't even available until main is finally created.
   Moreover, it was crucial that the aforementioned modules were tested via. 
   OUnit because of the fact that, in order to ensure that the functions in 
   State.mli and Main.ml were working correctly, correct implementation of the 
   revious module was essential. In terms of testing via. running the game, 
   it was the easiest way to test that state.mli and main.mli were working 
   correctly-- as creating abitrary states and testing them via. OUnit is 
   somewhat annoying and a bit tedious. Finally, get_special_insert and 
   get_special_space were tested via. running the game due to the use of the 
   Random module; thus, one could never be certain as to where special spaces 
   would be created/located unless a player encountered one during the gameplay.
   We believe that it is self-explanatory as to why we tested print via. 
   running the game.
*)
open OUnit2
open Battleship
open Command
open State




(*
  type board 

  val get_special_space: board -> coordinate -> special
  val place_ship: board -> ship_name -> coordinate list -> board
  val move_ship: board -> ship_name -> coordinate list -> board
  val shoot_ship: coordinate -> board -> board
  val special_insert: board -> board -> int -> board*board
  val print: board -> unit*)



(*val parse : string -> command *)



(*   type t 
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
     val end_turn: t -> result
*)





(** [get_owner_test board_owner_getter board expected_output] constructs an 
    OUnit test named [board_owner_getter] that asserts the quality of 
    [expected_output] with [get_owner board]. *)
let get_owner_test 
    (board_owner_getter : string) 
    (board: Battleship.board) 
    (expected_output: string*string ) : test =  
  board_owner_getter >:: (fun _ -> 
      assert_equal expected_output (get_owner board ) )


(** [get_hit_status_test tile_hit_status_getter board coordinate 
    expected_output] constructs an OUnit test named [tile_hit_status_getter] 
    that asserts the quality of [expected_output] with 
    [get_hit_status board coordinate]. *)
let get_hit_status_test
    (tile_hit_status_getter : string) 
    (board: Battleship.board) 
    (coordinate: string)
    (expected_output: status ) : test =  
  tile_hit_status_getter >:: (fun _ -> 
      assert_equal expected_output (get_hit_status board coordinate ) )


(** [get_belongs_to_test belongs_to_getter board coordinate expected_output] 
    constructs an OUnit test named [belongs_to_getter] that asserts the quality 
    of [expected_output] with [get_belongs_to board coordinate]. *)
let get_belongs_to_test
    (belongs_to_getter : string) 
    (board: Battleship.board) 
    (coordinate: string)
    (expected_output: ship_name ) : test =  
  belongs_to_getter >:: (fun _ -> 
      assert_equal expected_output (get_belongs_to board coordinate ) )


(** [get_hp_test hp_getter board ship expected_output] constructs an 
    OUnit test named [hp_getter] that asserts the quality of 
    [expected_output] with [get_hp board ship]. *)
let get_hp_test
    (hp_getter : string) 
    (board: Battleship.board) 
    (ship: ship_name)
    (expected_output: int ) : test =  
  hp_getter >:: (fun _ -> 
      assert_equal expected_output (get_hp board ship ) )


(** [get_sunk_status_test sunk_status_getter board ship expected_output] 
    constructs an OUnit test named [sunk_status_getter] that asserts the 
    quality of [expected_output] with [get_sunk_status board ship]. *)
let get_sunk_status_test
    (sunk_status_getter : string) 
    (board: Battleship.board) 
    (ship: ship_name)
    (expected_output: bool ) : test =  
  sunk_status_getter >:: (fun _ -> 
      assert_equal expected_output (get_sunk_status board ship ) )


(** [get_coordinates_part_test coordinates_part_getter board ship 
    expected_output] constructs an OUnit test named [coordinates_part_getter] 
    that asserts the quality of [expected_output] with 
    [get_coordinates_part board ship]. *)
let get_coordinates_part_test
    (coordinates_part_getter : string) 
    (board: Battleship.board) 
    (ship: ship_name)
    (expected_output: coordinate list ) : test =  
  coordinates_part_getter >:: (fun _ -> 
      assert_equal expected_output (get_coordinates_part board ship ) )


(** [get_part_hit_test part_hit_getter board ship expected_output] constructs an 
    OUnit test named [part_hit_getter] that asserts the quality of 
    [expected_output] with [get_part_hit board ship]. *)
let get_part_hit_test
    (part_hit_getter : string) 
    (board: Battleship.board) 
    (ship: ship_name)
    (expected_output: bool list ) : test =  
  part_hit_getter >:: (fun _ -> 
      assert_equal expected_output (get_part_hit board ship ) )


(** [get_been_moved_test been_moved_getter board ship expected_output] 
    constructs an OUnit test named [been_moved_getter] that asserts the quality 
    of [expected_output] with [get_been_moved board ship]. *)
let get_been_moved_test
    (been_moved_getter : string) 
    (board: Battleship.board) 
    (ship: ship_name)
    (expected_output: bool list ) : test =  
  been_moved_getter >:: (fun _ -> 
      assert_equal expected_output (get_been_moved board ship ) )


let  x1 = place_ship  player_1_own_board  "martha" ["A.1";"B.1"]
let x2 = place_ship player_2_opp_board "martha" ["A.1";"B.1"]


let x3 = shoot_ship "A.1" x1 
let x4 = shoot_ship "A.1" x2
let x9 = shoot_ship "J.10" x1


let x5 = shoot_ship "B.1" x3
let x6 = shoot_ship "B.1" x4


let x7 = move_ship x1 "martha" ["H.1";"I.1"]
let x8 = move_ship x2 "martha" ["H.1";"I.1"]


(*manually tested anything relatng to special spaces, including special insert 
  because of the randomization aspect of it.*)

(*Manually tested print by simply just applying it in main. *)



let battleship_tests =
  [
    get_owner_test "Four" player_1_opp_board ("Player 1","Player 2");
    get_owner_test "Four" player_1_own_board ("Player 1","Player 1");
    get_owner_test "Four" player_2_opp_board ("Player 2","Player 1");
    get_owner_test "Four" player_2_own_board ("Player 2","Player 2");


    get_hit_status_test "" player_1_own_board "A.1" None;
    get_hit_status_test ""  x1 "A.1" Yours;
    get_hit_status_test "" x2 "A.1" None;
    get_hit_status_test "" x3 "A.1" Hit;
    get_hit_status_test "" x4 "A.1" Hit;
    get_hit_status_test "" x9 "J.10" Miss;


    get_belongs_to_test "" player_1_own_board "A.1" "";
    get_belongs_to_test "" x1 "A.1" "martha";
    get_belongs_to_test "" x2 "A.1" "martha";
    get_belongs_to_test "" x7 "H.1" "martha";
    get_belongs_to_test "" x7 "I.1" "martha";
    get_belongs_to_test "" x8 "H.1" "martha";
    get_belongs_to_test "" x8 "I.1" "martha";


    get_hp_test "" player_1_own_board "martha" 2;
    get_hp_test "" x3 "martha" 1;
    get_hp_test "" x4 "martha" 1;


    get_sunk_status_test "" player_1_own_board "martha" false;
    get_sunk_status_test "" x5 "martha" true;
    get_sunk_status_test "" x6 "martha" true;


    get_coordinates_part_test "" player_1_own_board 
      "martha" ["Nowhere0";"Nowhere0"];
    get_coordinates_part_test "" x1
      "martha" ["A.1";"B.1"];
    get_coordinates_part_test "" x2
      "martha" ["A.1";"B.1"];


    get_part_hit_test "" player_1_own_board "martha" [false;false];
    get_part_hit_test "" player_1_opp_board "martha" [false;false];
    get_part_hit_test "" x3 "martha" [true;false];
    get_part_hit_test "" x5 "martha" [true;true];


    get_been_moved_test "" x1 "martha" [false;false];
    get_been_moved_test "" x7 "martha" [true;true];
    get_been_moved_test "" x8 "martha" [true;true];
  ]


(** [parser_test command_getter input expected_output] constructs an OUnit
    test named [command_getter] that asserts the quality of [expected_output]
    with [parse input]. *)
let parser_test 
    (command_getter : string)
    (input: string) 
    (expected_output: command) : test =  
  command_getter >:: (fun _ -> 
      assert_equal expected_output (parse input))


let command_tests =
  [
    "Empty string."    >:: (fun _ -> assert_raises (Empty) 
                               (fun () -> parse ""));


    "Malformed command."    >:: (fun _ -> assert_raises (Malformed) 
                                    (fun () -> parse "awoirfnn"));


    parser_test "This results in the following command:" "surrender" 
      Surrender;
    "Malformed surrender command."    >:: (fun _ -> assert_raises (Malformed) 
                                              (fun () -> parse "surrender a"));


    parser_test "This results in the following command:" "sunk" 
      Sunk;
    "Malformed sunk command."    >:: (fun _ -> assert_raises (Malformed) 
                                         (fun () -> parse "sunk aeidofk"));


    parser_test "This results in the following command:" "end" 
      End;
    "Malformed end command."    >:: (fun _ -> assert_raises (Malformed) 
                                        (fun () -> parse "end idfiif"));


    parser_test "This results in the following command:" "shots" 
      Shots;
    "Malformed shots command."    >:: (fun _ -> assert_raises (Malformed) 
                                          (fun () -> parse "shots awoirfnn"));


    parser_test "This results in the following command:" "shoot A.1" 
      (Shoot ["A.1"]);
    parser_test "This results in the following command:" "shoot shoot A.1" 
      (Shoot ["shoot";"A.1"]);
    "Malformed shoot command."    >:: (fun _ -> assert_raises (Malformed) 
                                          (fun () -> parse "shoot     "));


    parser_test "This results in the following command:" "place martha A.1 B.1" 
      (Place ["martha";"A.1";"B.1"]);
    "Malformed place command."    >:: (fun _ -> assert_raises (Malformed) 
                                          (fun () -> parse "place    "));


    parser_test "This results in the following command:" "move martha D.1 D.2" 
      (Move ["martha";"D.1";"D.2"]);
    "Malformed move command."    >:: (fun _ -> assert_raises (Malformed) 
                                         (fun () -> parse "move     "));
  ]


let suite =
  "test suite for A2"  >::: List.flatten [
    battleship_tests;
    command_tests;
  ]

let _ = run_test_tt_main suite
