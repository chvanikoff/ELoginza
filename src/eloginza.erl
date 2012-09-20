-module(eloginza).
-author('Roman Chvanikov <chvanikoff@gmail.com>').
-version(1.0).

-include("eloginza.hrl").

-export([check_token/1, get/2]).

check_token(Token) ->
    ok = start_inets(),
    {ok, {{_HttpVersion, 200, "OK"}, _Headers, JSON}} = httpc:request(get, {
        "http://loginza.ru/api/authinfo?token=" ++ Token ++ "&id=" ++ ?ELOGINZA_WIDGET_ID ++ "&sig=" ++ ?ELOGINZA_API_SIGNATURE,
        []}, [], []),
    Response = mochijson2:decode(JSON),
    case get_value(error_type, Response) of
        undefined -> {ok, Response};
        _ -> {error, Response}
    end.

get(Path, Struct) when is_tuple(Path) ->
    get_val(tuple_to_list(Path), Struct);
get(Key, {struct, List}) ->
    proplists:get_value(Key, List).

get_val(_, undefined) ->
    undefined;
get_val([Key], Struct) ->
    get_value(Key, Struct);
get_val([Key | T], Struct) ->
    get_val(T, get_value(Key, Struct)).

start_inets() ->
    case inets:start() of
        ok ->
            ok;
        {error, {already_started, inets}} ->
            ok;
        Error ->
            {error, Error}
    end.