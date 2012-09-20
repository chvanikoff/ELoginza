# ELoginza

This is a simple module to handle with Loginza service.

Currently it can:
* check validation token
* retrieve (nested) fields of user's account

Dummy example of using the module:

    handle_post_request() ->
        case eloginza:check_token(get_value_from_post("token")) of
            {ok, Data} ->
                authorize_user(Data);
            {error, Error} ->
                show_error(Error)
        end.

    authorize_user(Data) ->
        Username = eloginza:get_field(nickname, Data),
        Full_name = eloginza:get_field({name, full_name}, Data),
        Mobile_phone = eloginza:get_field({phone, mobile}, Data),
        complete_auth(Username, Full_name, Mobile_phone).

Feel free to contact me with any questions/suggestions.