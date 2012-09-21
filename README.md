# ELoginza

This is a simple module to handle with Loginza service.

Currently it can:
* check validation token
* retrieve (nested) fields of user's account

Just follow these two steps to start using ELoginza:
1. include the lib into your project
2. (optional) update eloginza.hrl with your actual loginza widget ID and API signature.
Second step is unnecessary since you can pass both keys straight to check_token/2 function as a proplist (look at example)

Dummy example of using the module:

    handle_post_request() ->
        case eloginza:check_token(
            get_value_from_post("token"),
            [{widget_id, "12345"}, {api_signature, "asdasdasd"}]) of
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