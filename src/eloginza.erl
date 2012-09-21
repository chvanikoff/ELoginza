-module(eloginza).
-author('Roman Chvanikov <chvanikoff@gmail.com>').
-version(1.0).

-include("eloginza.hrl").

-export([check_token/1, check_token/2, get_field/2 ]).

check_token(Token) ->
    check_token(Token, [{widget_id, ?ELOGINZA_WIDGET_ID}, {api_signature, ?ELOGINZA_API_SIGNATURE}]).

check_token(Token, Params) ->
    ok = start_inets(),
    Widget_ID = proplists:get_value(widget_id, Params),
    API_signature = proplists:get_value(api_signature, Params),
    io:format("ID: ~p~n", [Widget_ID]),
    io:format("SIG: ~p~n", [API_signature]),
    {ok, {{_HttpVersion, 200, "OK"}, _Headers, JSON}} = httpc:request(get, {
        lists:concat(["http://loginza.ru/api/authinfo?token=", Token, "&id=", Widget_ID, "&sig=", API_signature]),
        []}, [], []),
    Response = mochijson2:decode(JSON),
    case get_field(error_type, Response) of
        undefined -> {ok, Response};
        _ -> {error, Response}
    end.

get_field(Path, Struct) when is_tuple(Path) ->
    get_val(tuple_to_list(Path), Struct);
get_field(Key, {struct, List}) ->
    proplists:get_value(Key, List).

get_val(_, undefined) ->
    undefined;
get_val([Key], Struct) ->
    get_field(Key, Struct);
get_val([Key | T], Struct) ->
    get_val(T, get_field(Key, Struct)).

start_inets() ->
    case inets:start() of
        ok ->
            ok;
        {error, {already_started, inets}} ->
            ok;
        Error ->
            {error, Error}
    end.