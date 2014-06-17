# lasse
## SSE handler for Cowboy

### References
* [Cowboy](/extend/cowboy)
* [SSE](http://dev.w3.org/html5/eventsource/)
* [canillita's handler](/canillita/blob/master/src/canillita_news_handler.erl) (as a reference)

### How to use it
``lasse`` provides a [cowboy loop handler](http://ninenines.eu/docs/en/cowboy/HEAD/guide/loop_handlers/)
called ``lasse_handler`` that describes a behaviour. To include it in your server routes, just add
the following tuple to your [dispatch routes](http://ninenines.eu/docs/en/cowboy/HEAD/guide/routing/):

```erlang
{<<"/your/[:route]">>, lasse_handler, [your_module]}
% or
{<<"/your/[:route]">>, lasse_handler, [{module, your_module}, {init_args, Args}]}
```

Specifying the ``module`` (e.g ``your_module``) is mandatory while providing a value for ``init_args``
is optional.

Additionally, in your module, you have to implement the ``lasse_handler`` behaviour and its
[callbacks](#callbacks):

```erlang
-behaviour(lasse_handler).
```

#### Examples

You can find some example applications that implement the ``lasse_handler`` in the ``examples`` folder.

Running the examples is as simple as executing ``make run``, given you have the ``make`` tool
and ``erlang`` installed in your environment.

<a name="callbacks"></a>
#### Callbacks

##### init(InitArgs, Req) -> {ok, NewReq, State} | {shutdown, StatusCode, Headers, Body, NewReq}

Will be called upon initialization of the handler, if everything goes well it should return
``{ok, NewReq, State}``, otherwise ``{shutdown, StatusCode, Headers, Body, NewReq}`` which will
cause the handler to reply to the client with the information supplied and then terminate.

Types:
- InitiArgs = any()
- Req = cowboy_req:req()
- NewReq = cowboy_req:req()
- State = any()
- StatusCode = cowboy:http_status()
- Headers = cowboy:http_headers()
- Body = iodata()

##### handle_notify(Msg, State) -> Result

Receives and processes in-band messages sent through the ``lasse_handler:notify/2`` function.

Types:
- Msg = any()
- State = any()
- Result = [result()](#result_type)

##### handle_info(Msg, State) -> Result

Receives and processes out-of-band messages sent directly to the handler's process.

Types:
- Msg = any()
- State = any()
- Result = [result()](#result_type)

##### handle_error(Msg, Reason, State) -> NewState

If there's a problem while sending a chunk to the client, this function will be called after which the handler will terminate.

Types:
- Msg = any()
- Reason = atom()
- State = any()
- NewState = any()

##### terminate(Reason, Req, State) -> ok

This function will be called before terminating the handler, its return value is ignored.

Types:
- Reason = atom()
- Req = cowboy:http_headers()
- State = any()

#### Types

<a name="result_type"></a>
##### result() = {'send', Event :: event(), NewState :: any()}
    | {'nosend', NewState :: any()}
    | {'stop', NewState :: any()}
