module Main exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL
display : List Int ->  List (Html div)
display model = case model of
     [] -> []
     (x::xs) -> div [style "display" "inline-flex", style "padding" "10px", style "border" "1px solid black"][ text (String.fromInt x)] :: display xs

type alias Model = {
    array: List Int,
    i: Int,
    size: Int,
    change: Bool
    }


init : Model
init = {
    array = [20, 15, 7, 3, 2, 1, 50, 25, 2],
    i = 1,
    size = 1,
    change = False
    }

-- UPDATE
getElement : Int -> List a -> Maybe a
getElement n arr =
  case arr of
    [] -> Nothing
    (x::xs) ->
      if n == 0 then Just x
      else getElement (n - 1) xs

-- Function to get sublist
getSubList f l arr = 
    case arr of
        [] -> []
        (x::xs) -> 
            if f == 1 then 
                if l == 1 then [] 
                else x :: getSubList f (l - 1) xs
            else getSubList (f - 1) (l-1) xs

-- Function to merge two sublists
mergeSubList arr1 arr2 = 
    case arr1 of
        [] -> arr2
        (x::xs) -> 
            case arr2 of
                [] -> arr1
                (y::ys) -> 
                    if x <= y then x :: mergeSubList xs arr2
                    else y :: mergeSubList arr1 ys

-- Function to merge
mergeSort arr i size =
    case arr of
        [] -> []
        [x] -> [x]
        (x::xs) -> 
            if i > List.length arr then arr
            else 
                (getSubList 1 i arr) ++ mergeSubList (getSubList i (i+size) arr) (getSubList (i+size) (i + size*2) arr) ++ getSubList (i+size*2) ((List.length arr) + 1) arr

--List as string
listToString arr =
    case arr of
        [] -> ""
        (x::xs) -> 
            if xs == [] then String.fromInt x
            else String.fromInt x ++ ", " ++ listToString xs
type Msg
  = Next

update : Msg -> Model -> Model
update msg model =
    case msg of
    Next ->
        if model.size > List.length model.array then
        model 
        else
            if model.i > List.length model.array then
                {model | array = model.array, i = 1, size = model.size * 2, change=True}
            else
                {model | array = mergeSort model.array model.i model.size, i = model.i + (model.size * 2), size = model.size, change=False}

-- VIEW

view : Model -> Html Msg
view model =
    let
        array = model.array
        i = model.i
        size = model.size
        change = 
            if model.change then 
                "Incremented size" 
            else 
                "Merging array " ++ String.fromInt i ++ ", " ++ String.fromInt (i + size - 1) ++ " and " ++ String.fromInt (i + size) ++ ", " ++ String.fromInt (i + size * 2 - 1) 
        arr1 = getSubList i (i+size) model.array 
        arr2 = getSubList (i+size) (i + size*2) model.array
        mergeContent = "arr1: " ++ listToString arr1 ++ ", arr2: " ++ listToString arr2
    in
        -- Center the div
        -- Center horizontally
        div []
            [ div [style "display" "flex", style "justify-content" "center", style "align-items" "center"] (display array)
            , div [style "display" "flex", style "justify-content" "center", style "align-items" "center"] [button [onClick Next] [text "Next"]]
            , div [style "display" "flex", style "justify-content" "center", style "align-items" "center"] [text ("Size: " ++ (String.fromInt size))]
            , div [style "display" "flex", style "justify-content" "center", style "align-items" "center"] [text ("index: " ++ (String.fromInt i))]
            , div [style "display" "flex", style "justify-content" "center", style "align-items" "center"] [text change]
            , div [style "display" "flex", style "justify-content" "center", style "align-items" "center"] [text mergeContent]
            ]
            