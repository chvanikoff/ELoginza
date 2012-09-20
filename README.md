# ELoginza

This is a simple module to handle with Loginza service.

Currently it can:
* check validation token
* retrieve (nested) fields of user's account

Dummy example of using the module:

    handle_post_request() ->
        case loginza:check_token(get_value_from_post("token")) of
            {ok, Data} ->
                authorize_user(Data);
            {error, Error} ->
                show_error(Error)
        end.

    authorize_user(Data) ->
        Username = loginza:get(nickname, Data),
        Full_name = loginza:get({name, full_name}, Data),
        Mobile_phone = loginza:get({phone, mobile}, Data),
        complete_auth(Username, Full_name, Mobile_phone).

Feel free to contact me with any questions/suggestions.