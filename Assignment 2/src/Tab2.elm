module Tab2 exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Html, a, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


display : List Int -> Int -> Int -> Int -> List (Html div)
display model size color cur =
    case model of
        [] ->
            []

        x :: xs ->
            div
                [ style "display" "inline-flex"
                , style "padding" "10px"
                , style "border" "1px solid black"
                , style "background-color"
                    (if cur == 1 && color == 1 then
                        "#47a8bd"

                     else
                        "white"
                    )
                ]
                [ text (String.fromInt x) ]
                :: display xs size color (cur + 1)


type alias Model =
    { larray : List Int
    , linput : String
    , rarray : List Int
    , rinput : String
    , array : List Int
    , sortedarray : List Int
    , lsize : Int
    , rsize : Int
    , size : Int
    , er : String
    }


init : Model
init =
    { larray = [ 4, 20, 30, 50, 60 ]
    , linput = ""
    , rarray = [ 5, 6, 7, 25, 32, 34, 70, 80 ]
    , rinput = ""
    , array = []
    , sortedarray = [ 4, 5, 6, 7, 20, 25, 30, 32, 34, 50, 60, 70, 80 ]
    , lsize = 5
    , rsize = 8
    , size = 0
    , er = ""
    }



-- UPDATE
-- Function to get sublists from the array


getSubList f l arr =
    case arr of
        [] ->
            []

        x :: xs ->
            if f == 1 then
                if l == 1 then
                    []

                else
                    x :: getSubList f (l - 1) xs

            else
                getSubList (f - 1) (l - 1) xs



--List as string


listToString arr =
    case arr of
        [] ->
            ""

        x :: xs ->
            if xs == [] then
                String.fromInt x

            else
                String.fromInt x ++ ", " ++ listToString xs



-- List to int


listStrToListInt arr =
    case arr of
        [] ->
            []

        x :: xs ->
            String.toInt x :: listStrToListInt xs


type Msg
    = Next
    | LChange String
    | RChange String
    | LSubmit
    | RSubmit


update : Msg -> Model -> Model
update msg model =
    case msg of
        LChange newInput ->
            { model | linput = newInput }

        RChange newInput ->
            { model | rinput = newInput }

        LSubmit ->
            { model | linput = model.linput, larray = List.sort (List.map (\n -> Maybe.withDefault 0 (String.toInt (String.trim n))) (String.split "," model.linput)), lsize = List.length (String.split "," model.linput), sortedarray = List.sort (List.map (\n -> Maybe.withDefault 0 (String.toInt (String.trim n))) (String.split "," model.linput) ++ model.rarray), array = [], size = 0 }

        RSubmit ->
            { model | rinput = model.rinput, rarray = List.sort (List.map (\n -> Maybe.withDefault 0 (String.toInt (String.trim n))) (String.split "," model.rinput)), rsize = List.length (String.split "," model.rinput), sortedarray = List.sort (List.map (\n -> Maybe.withDefault 0 (String.toInt (String.trim n))) (String.split "," model.rinput) ++ model.larray), array = [], size = 0 }

        Next ->
            if model.rsize > 0 && model.lsize > 0 then
                if Maybe.withDefault 0 (List.head model.rarray) < Maybe.withDefault 0 (List.head model.larray) then
                    { model | array = model.array ++ [ Maybe.withDefault 0 (List.head model.rarray) ], rarray = Maybe.withDefault [] (List.tail model.rarray), size = model.size + 1, rsize = model.rsize - 1, er = String.fromInt (Maybe.withDefault 0 (List.head model.rarray)) ++ " is smaller than " ++ String.fromInt (Maybe.withDefault 0 (List.head model.larray)) ++ " and is inserted at the end of the array" }

                else
                    { model | array = model.array ++ [ Maybe.withDefault 0 (List.head model.larray) ], larray = Maybe.withDefault [] (List.tail model.larray), size = model.size + 1, lsize = model.lsize - 1, er = String.fromInt (Maybe.withDefault 0 (List.head model.larray)) ++ " is smaller than " ++ String.fromInt (Maybe.withDefault 0 (List.head model.rarray)) ++ " and is inserted at the end of the array" }

            else if model.rsize > 0 then
                { model | array = model.array ++ [ Maybe.withDefault 0 (List.head model.rarray) ], rarray = Maybe.withDefault [] (List.tail model.rarray), size = model.size + 1, rsize = model.rsize - 1, er = String.fromInt (Maybe.withDefault 0 (List.head model.rarray)) ++ " is smaller than " ++ String.fromInt (Maybe.withDefault 0 (List.head model.larray)) ++ " and is inserted at the end of the array" }

            else if model.lsize > 0 then
                { model | array = model.array ++ [ Maybe.withDefault 0 (List.head model.larray) ], larray = Maybe.withDefault [] (List.tail model.larray), size = model.size + 1, lsize = model.lsize - 1, er = String.fromInt (Maybe.withDefault 0 (List.head model.larray)) ++ " is smaller than " ++ String.fromInt (Maybe.withDefault 0 (List.head model.rarray)) ++ " and is inserted at the end of the array" }

            else
                { model | er = "Both Lists are empty" }



-- VIEW


view : Model -> Html Msg
view model =
    let
        larray =
            model.larray

        rarray =
            model.rarray

        lsize =
            model.lsize

        rsize =
            model.rsize

        size =
            model.size

        array =
            model.array

        msg1 =
            if lsize == 0 && rsize == 0 then
                "Left and right have been merged while being sorted"

            else
                "Merge by clicking both lists"

        msg2 =
            "Left and right are two sorted arrays, and we aim at showing how they can be merged"

        msg3 =
            if rsize == 0 then
                "Right array is empty"

            else
                "Click right if right highlighted is smaller than left highlighted."

        er =
            model.er
    in
    -- Center the div
    -- Center horizontally
    div []
        [ Html.h1 [ style "text-align" "center", style "justify-content" "center" ] [ text "Merge Sort" ]

        -- Three centered divs beside each other
        , div [ style "display" "flex", style "text-align" "center", style "justify-content" "center" ]
            [ a [ href "/tab1.html" ] [ button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Manual Merge" ] ]
            , button [ style "flex" "1", style "background-color" "#4CADE0", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Automatic Merge Manual Iteration" ]
            , a [ href "/tab3.html" ] [ button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Manual Iterative Merge Sort" ] ]
            , a [ href "/tab4.html" ] [ button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Iterative Merge Sort" ] ]
            ]
        , div [ style "margin" "15vh" ]
            [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ input [ style "height" "20px", style "width" "250px", placeholder "Enter numbers separated with comma", value model.linput, onInput LChange ] [] ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ input [ style "height" "20px", style "width" "250px", placeholder "Enter numbers separated with comma", value model.rinput, onInput RChange ] [] ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick LSubmit ] [ text "Submit" ] ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick RSubmit ] [ text "Submit" ] ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-right" "5px" ] [ text "Left Array: " ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-right" "10px" ] (display larray lsize 1 1)
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-right" "5px" ] [ text "Right Array: " ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] (display rarray rsize 1 1)
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-right" "10px" ] (display array size 0 1)
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Next ] [ text "Next" ] ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Size: " ++ String.fromInt size) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Lsize: " ++ String.fromInt lsize ++ " | Rsize: " ++ String.fromInt rsize) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text msg1 ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text msg2 ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text msg3 ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Message: " ++ er) ]
            ]
        ]
