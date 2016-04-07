-module(dummy_handler).
-behavior(lasse_handler).

-dialyzer(no_behaviours).

-export([
         init/2,
         handle_info/2,
         handle_notify/2,
         handle_error/3,
         terminate/3
        ]).

init(_LastEventId, Req) ->
    {ok, Req, {}}.

handle_info(_, _) ->
    does_not_matter.

handle_notify(_, _) ->
    does_not_matter.

handle_error(_, _, _) ->
    doesnt_matter.

terminate(_, _, _) ->
    ok.
