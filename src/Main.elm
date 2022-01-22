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
    iteration: Int,
    counter: Int,
    merge: Bool
    }


init : Model
init = {
    array = [20, 15, 3, 7, 2, 1, 50, 25, 2],
    iteration = 1,
    counter = 0,
    merge = False
    }

-- UPDATE

getElement n arr =
  if n == 1 then
    (Maybe.withDefault 0 (List.head arr))
  else 
    getElement (n-1) (Maybe.withDefault [] (List.tail arr))

type Msg
  = Next

update : Msg -> Model -> Model
update msg model =
    case msg of
    Next ->
        { model | array = model.array, counter = (getElement (model.iteration) model.array), iteration = model.iteration + 1, merge = model.merge}

-- VIEW

view : Model -> Html Msg
view model =
    let
        array = model.array
        counter = model.counter
    in
        -- Center the div
        -- Center horizontally
        div [style "display" "flex", style "justify-content" "center", style "align-items" "center"]
            [ div [] (display array)
            , button [onClick Next] [text "Next"]
            , div [] [text (String.fromInt counter)]
            ]
            