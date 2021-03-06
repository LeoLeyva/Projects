(**These comments are directly from Assignment 2/3, with some slight 
   modifications to fit this project.*)

(** The type [object_phrase] represents the object phrase that can be part of a 
    player command.  Each element of the list represents a word of the object 
    phrase, where a {i word} is defined as a consecutive sequence of non-space 
    characters.  Thus, no element of the list should contain any leading,
    internal, or trailing spaces.  The list is in the same order as the words 
    in the original player command. *)
type object_phrase = string list


(** The type [command] represents a player command that is decomposed
    into a verb and possibly an object phrase. *)
type command = 
  |Shoot of object_phrase
  |Sunk
  |Surrender
  |Taunt of object_phrase
  |Place of object_phrase
  |End
  |Shots
  |Move of object_phrase


(** Raised when an empty command is parsed. *)
exception Empty

(** Raised when a malformed command is encountered. *)
exception Malformed


(** [parse str] parses a player's input into a [command], as follows. The first
    word (i.e., consecutive sequence of non-space characters) of [str] becomes 
    the command (what the player wants to do). The rest of the words, if any, 
    become the object phrase.
    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space 
    characters (only ASCII character code 32; not tabs or newlines, etc.).
    Raises: [Empty] if [str] is the empty string or contains only spaces. 
    Raises: [Malformed] if the command is malformed. A command
    is malformed if the verb isn't any of the following: "shoot", "sunk",
    "surrender", "taunt", "place", "end", "shots", or "move."
*)
val parse : string -> command
