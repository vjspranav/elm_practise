module Tab3 exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Attribute, Html, button, div, input, text, a, select, option)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Char exposing (toLower)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


display : List Int -> Int -> Int -> Int -> List (Html div)
display model i size cur =
    case model of
        [] ->
            []

        x :: xs ->
            div
                [ style "display" "inline-flex"
                , style "padding" "10px"
                , style "border" "1px solid black"
                , style "background"
                    (if cur >= i && cur < (i + size) then
                        "green"

                     else if cur >= (i + size) && cur < (i + (size * 2)) then
                        "red"

                     else if cur < i then
                        "yellow"

                     else
                        "white"
                    )
                ]
                [ text (String.fromInt x) ]
                :: display xs i size (cur + 1)


type alias Model =
    { input : String
    , select_input : String
    , array : List Int
    , i : Int
    , size : Int
    , change : Bool
    }


init : Model
init =
    { input = ""
    , select_input = "1"
    , array = [ 20, 15, 7, 3, 2, 1, 50, 25, 2 ]
    , i = 1
    , size = 1
    , change = False
    }



-- UPDATE

-- Function to give power of 2 lower than n
getPowerTwo_N : Int -> Int -> Int
getPowerTwo_N n two = 
    if ((two * 2) >= n)
    then
        two 
    else 
        getPowerTwo_N n (two * 2)        

-- Function that creates options for select
getOptions : Int -> Int -> List (Html select)
getOptions m n = 
    if m >= n
    then
        []
    else
        [ option [ value (String.fromInt m) ] [ text (String.fromInt m) ] ] ++ getOptions (m * 2) n
-- Function to get sublist


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



-- Function to merge two sublists


mergeSubList arr1 arr2 =
    case arr1 of
        [] ->
            arr2

        x :: xs ->
            case arr2 of
                [] ->
                    arr1

                y :: ys ->
                    if x <= y then
                        x :: mergeSubList xs arr2

                    else
                        y :: mergeSubList arr1 ys



-- Function to merge


mergeSort arr i size =
    case arr of
        [] ->
            []

        [ x ] ->
            [ x ]

        x :: xs ->
            if i > List.length arr then
                arr

            else
                getSubList 1 i arr ++ mergeSubList (getSubList i (i + size) arr) (getSubList (i + size) (i + size * 2) arr) ++ getSubList (i + size * 2) (List.length arr + 1) arr



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
    | Change String
    | Select String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newInput ->
            { model | input = newInput }

        Select newSelectInput ->
            { model | select_input = newSelectInput, size = Maybe.withDefault 0 (String.toInt newSelectInput), i = 1, change = False}
            
        Submit ->
            { model | input = model.input, array = List.map (\n -> Maybe.withDefault 0 (String.toInt (String.trim n))) (String.split "," model.input), i = 1, size = 1, change = False }

        Next ->
            if model.size > List.length model.array then
                model

            else if model.i > List.length model.array then
                { model | array = model.array, size = model.size, change = True }

            else
                { model | array = mergeSort model.array model.i model.size, i = model.i + (model.size * 2), size = model.size, change = False }



-- VIEW


view : Model -> Html Msg
view model =
    let
        array =
            model.array

        i =
            model.i

        size =
            model.size

        change =
            if model.change then
                if size * 2 >= List.length array then
                    if (array == List.sort array) then
                        "Sorted" 
                    else
                        "Not sorted, Please try again" 
                else
                    "All in this size done, Please increase split size"
            else
                "Merging array " ++ String.fromInt i ++ ", " ++ String.fromInt (i + size - 1) ++ " and " ++ String.fromInt (i + size) ++ ", " ++ String.fromInt (i + size * 2 - 1)

        arr1 =
            getSubList i (i + size) model.array

        arr2 =
            getSubList (i + size) (i + size * 2) model.array

        mergeContent1 =
            "arr1: " ++ listToString arr1

        mergeContent2 =
            "--,--"

        mergeContent3 =
            " arr2: " ++ listToString arr2
    in
    -- Center the div
    -- Center horizontally
    div []
        [ Html.h1 [ style "text-align" "center", style "justify-content" "center" ] [ text "Merge Sort" ]

        -- Three centered divs beside each other
        , div [ style "display" "flex", style "text-align" "center", style "justify-content" "center" ]
            [ a [href "/tab1.html"] [button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Manual Merge" ]]
            , a [href "/tab2.html"] [button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Automatic Merge Manual Iteration" ]]
            , button [ style "flex" "1", style "background-color" "#4CADE0", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Manual Iterative Merge Sort" ]
            , a [href "/tab4.html"] [button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Iterative Merge Sort" ]]
            ]
        , div [ style "margin" "15vh" ]
            [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ input [ style "height" "20px", style "width" "250px", placeholder "Enter numbers separated with comma", value model.input, onInput Change ] [] ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Submit ] [ text "Submit" ] ]
            , div [ style "display" "flex", style "text-align" "center", style "justify-content" "center" ]
                [ div [ style "padding" "14px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Split Size ->" ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ select [value model.select_input, onInput Select] (getOptions 1 (List.length array)) ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] (display array i size 1)
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Next ] [ text "Next" ] ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text "In this system we will get a chance to select a size and do merges of that size, Please select a size from drop down and keep clicking next." ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Size: " ++ String.fromInt size) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Index: " ++ String.fromInt i) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "color" "green" ] [ text mergeContent1 ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text mergeContent2 ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "color" "red" ] [ text mergeContent3 ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text change ]
            ]
        ]
