type loc = { x: int; y: int}
type id = int
type param = string

class virtual node id loc =
  object (self)
    val id : id = id
    val mutable loc : loc = loc
    method virtual name : string
    method virtual tipe : string
    method id = id
    method is_page = false
    method is_datasink = false
    method is_datasource = false
    method update_loc _loc =
      loc <- _loc
    method to_frontend : Yojson.Basic.json =
      `Assoc (List.append
                [ ("name", `String self#name)
                ; ("id", `Int id)
                ; ("type", `String self#tipe)
                ; ("x", `Int loc.x)
                ; ("y", `Int loc.y)
                ]
                self#extra_fields)
    method extra_fields = []
  end;;

class value expr id loc =
  object (self)
    inherit node id loc
    val expr : string = expr
    method name : string = expr
    method tipe = "value"
    method extra_fields = [("value", `String expr)]
  end;;

class func name id loc =
  object (self)
    inherit node id loc
    val name : string = name
    method name = name
    method is_page = name == "Page_page"
    method tipe = if (Core.String.is_substring "page" name)
      then name
      else "function"
    method extra_fields =
      [("parameters",
        `List (List.map
                 (fun s -> `String s)
                 (Lib.get_fn name).parameters))]
  end;;

class datastore table id loc =
  object (self)
    inherit node id loc
    val table : string = table
    method name = "DS-" ^ table
    method tipe = "datastore"
  end;;
