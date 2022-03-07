module Tab2 exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Attribute, Html, a, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



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



-- Display function but without color


display_nocolor : List Int -> List (Html div)
display_nocolor model =
    case model of
        [] ->
            []

        x :: xs ->
            div
                [ style "display" "inline-flex"
                , style "padding" "10px"
                , style "border" "1px solid black"
                ]
                [ text (String.fromInt x) ]
                :: display_nocolor xs



-- Display for List of strings


display_nocolor_string : List String -> List (Html div)
display_nocolor_string model =
    case model of
        [] ->
            []

        x :: xs ->
            div
                [ style "padding" "10px"
                , style "border" "1px solid black"
                , style "display" "flex"
                , style "justify-content" "center"
                , style "align-items" "center"
                ]
                [ text x ]
                :: display_nocolor_string xs


type alias Model =
    { input : String
    , array : List Int
    , mergeUnit1 : List Int
    , mu1_sort : Bool
    , mu1_merge : Bool
    , mergeUnit2 : List Int
    , mu2_sort : Bool
    , mu2_merge : Bool
    , i : Int
    , j : Int
    , size : Int
    , change : Bool
    , trajectory : List String
    }


init : Model
init =
    { input = ""
    , array = [ 20, 15, 7, 3, 2, 1, 50, 25, 2 ]
    , mergeUnit1 = []
    , mu1_sort = True
    , mu1_merge = True
    , mergeUnit2 = []
    , mu2_merge = True
    , mu2_sort = True
    , i = 1
    , j = 1
    , size = 1
    , change = False
    , trajectory = [ "Start Array: 20, 15, 7, 3, 2, 1, 50, 25, 2" ]
    }



-- UPDATE
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



-- Update array values in arr1 from arr2
-- Updat values from f - l in arr1 from 0 - l in arr2


updateArray : List Int -> List Int -> number -> number -> List Int
updateArray arr1 arr2 f l =
    case arr1 of
        [] ->
            []

        x :: xs ->
            if f > 1 then
                x :: updateArray xs arr2 (f - 1) (l - 1)

            else if l > 0 then
                case arr2 of
                    [] ->
                        []

                    y :: ys ->
                        if l == 0 then
                            []

                        else
                            y :: updateArray xs ys (f - 1) (l - 1)

            else
                x :: updateArray xs arr2 1 0



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
    | Submit
    | Merge1
    | Sort1
    | Merge2
    | Sort2


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newInput ->
            { model | input = newInput }

        Submit ->
            { model
                | input = model.input
                , array = List.map (\n -> Maybe.withDefault 0 (String.toInt (String.trim n))) (String.split "," model.input)
                , i = 1
                , size = 1
                , change = False
                , trajectory = List.append model.trajectory [ "Initial array is " ++ listToString model.array ]
            }

        Next ->
            if model.size > List.length model.array || model.mu1_merge == False || model.mu2_merge == False then
                { model | trajectory = List.append model.trajectory [ "Next: clicked but Merge unit 1 or 2 is not merged" ] }

            else if model.i > List.length model.array then
                { model | array = model.array, i = 1, size = model.size * 2, change = True, trajectory = List.append model.trajectory [ "Next: clicked index is reset to 1 and size is now " ++ String.fromInt (model.size * 2) ] }

            else
                { model
                    | mergeUnit1 = getSubList model.i ((model.size * 2) + model.i) model.array
                    , mergeUnit2 = getSubList (model.i + (model.size * 2)) ((model.size * 2) + (model.i + (model.size * 2))) model.array
                    , i = model.i
                    , j = model.i + (model.size * 2)
                    , size = model.size
                    , change = False
                    , mu1_merge =
                        if List.length (getSubList model.i ((model.size * 2) + model.i) model.array) == 0 then
                            True

                        else
                            False
                    , mu1_sort =
                        if List.length (getSubList model.i ((model.size * 2) + model.i) model.array) == 0 then
                            True

                        else
                            False
                    , mu2_merge =
                        if List.length (getSubList (model.i + (model.size * 2)) ((model.size * 2) + (model.i + (model.size * 2))) model.array) == 0 then
                            True

                        else
                            False
                    , mu2_sort =
                        if List.length (getSubList (model.i + (model.size * 2)) ((model.size * 2) + (model.i + (model.size * 2))) model.array) == 0 then
                            True

                        else
                            False
                    , trajectory = List.append model.trajectory [ "Next: Merge unit 1 is " ++ listToString (getSubList model.i ((model.size * 2) + model.i) model.array) ++ ", Merge unit 2 is " ++ listToString (getSubList (model.i + (model.size * 2)) ((model.size * 2) + (model.i + (model.size * 2))) model.array) ]
                }

        Sort1 ->
            if model.mu1_sort then
                { model | trajectory = List.append model.trajectory [ "Sort: clicked but Merge unit 1 is already sorted" ] }

            else
                { model
                    | mergeUnit1 = mergeSubList (getSubList 1 (model.size + 1) model.mergeUnit1) (getSubList (model.size + 1) ((model.size * 2) + 1) model.mergeUnit1)
                    , mu1_sort = True
                    , mu1_merge = False
                    , trajectory = List.append model.trajectory [ "Sort: Merge unit 1 is sorted:" ++ listToString (mergeSubList (getSubList 1 (model.size + 1) model.mergeUnit1) (getSubList (model.size + 1) ((model.size * 2) + 1) model.mergeUnit1)) ]
                }

        Merge1 ->
            if model.mu1_merge then
                { model | trajectory = List.append model.trajectory [ "Merge: clicked but Merge unit 1 is already merged" ] }

            else
                { model
                    | array = updateArray model.array model.mergeUnit1 model.i (List.length model.mergeUnit1 + (model.i - 1))
                    , i = model.i + (model.size * 2)
                    , mergeUnit1 = []
                    , mu1_merge = True
                    , mu1_sort = True
                    , trajectory = List.append model.trajectory [ "Merge: Merge unit 1 is merged, array is: " ++ listToString (updateArray model.array model.mergeUnit1 model.i (List.length model.mergeUnit1 + (model.i - 1))) ]
                }

        -- Update this
        Sort2 ->
            if model.mu2_sort then
                { model | trajectory = List.append model.trajectory [ "Sort: clicked but Merge unit 2 is already sorted" ] }

            else
                { model
                    | mergeUnit2 = mergeSubList (getSubList 1 (model.size + 1) model.mergeUnit2) (getSubList (model.size + 1) ((model.size * 2) + 1) model.mergeUnit2)
                    , mu2_sort = True
                    , mu2_merge = False
                    , trajectory = List.append model.trajectory [ "Sort: Merge unit 2 is sorted:" ++ listToString (mergeSubList (getSubList 1 (model.size + 1) model.mergeUnit2) (getSubList (model.size + 1) ((model.size * 2) + 1) model.mergeUnit2)) ]
                }

        Merge2 ->
            if model.mu2_merge then
                { model | trajectory = List.append model.trajectory [ "Merge: clicked but Merge unit 2 is already merged" ] }

            else
                { model
                    | array = updateArray model.array model.mergeUnit2 model.j (List.length model.mergeUnit2 + (model.j - 1))
                    , i = model.i + (model.size * 2)
                    , mergeUnit2 = []
                    , mu2_merge = True
                    , mu2_sort = True
                    , trajectory = List.append model.trajectory [ "Merge: Merge unit 2 is merged, array is: " ++ listToString (updateArray model.array model.mergeUnit2 model.j (List.length model.mergeUnit2 + (model.j - 1))) ]
                }



-- VIEW


view : Model -> Html Msg
view model =
    let
        array =
            model.array

        mergeUnit1 =
            model.mergeUnit1

        mergeUnit2 =
            model.mergeUnit2

        i =
            model.i

        j =
            model.j

        size =
            model.size

        change =
            if size > List.length array then
                "Sorted"

            else if model.change then
                "Incremented size"

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
            [ a [ href "/tab1.html" ] [ button [ style "flex" "1", style "background-color" "#4CAF50", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Merge Sort" ] ]
            , button [ style "flex" "1", style "background-color" "#4CADE0", style "color" "white", style "padding" "14px 20px", style "margin" "8px 1px", style "border" "none", style "cursor" "pointer" ] [ text "Parallel Merge Sort" ]
            ]
        , div [ style "margin" "15vh" ]
            [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ input [ style "height" "20px", style "width" "250px", placeholder "Enter numbers separated with comma", value model.input, onInput Change ] [] ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Submit ] [ text "Submit" ] ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] (display array i size 1)
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Next ] [ text "Next" ] ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Size: " ++ String.fromInt size) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("Index: " ++ String.fromInt i) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text ("J: " ++ String.fromInt j) ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "color" "green" ] [ text mergeContent1 ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text mergeContent2 ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "color" "red" ] [ text mergeContent3 ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text "Merge Unit 1: " ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] (display_nocolor mergeUnit1)
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Sort1 ] [ text "Sort MergeUnit 1" ] ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Merge1 ] [ text "Merge MergeUnit 1" ] ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text "Merge Unit 2: " ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] (display_nocolor mergeUnit2)
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ]
                [ div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Sort2 ] [ text "Sort MergeUnit 2" ] ]
                , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center", style "margin-bottom" "20px" ] [ button [ onClick Merge2 ] [ text "Merge MergeUnit 2" ] ]
                ]
            , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text change ]
            ]
        , div [ style "display" "flex", style "justify-content" "center", style "align-items" "center" ] [ text "Trajectory: " ]
        , div [ style "justify-content" "center", style "align-items" "center" ] (display_nocolor_string model.trajectory)
        ]
