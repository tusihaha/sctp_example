-module(sctp_clt).
-export([start/0]).

start() ->
  {ok, Socket} = gen_sctp:open(),
  {ok, Assoc} =
  gen_sctp:connect(
    Socket,
    {127, 0, 0, 1},
    8080,
    [{active, false}, {mode, binary}]
  ),
  loop(Assoc, Socket, 1000).

loop(Assoc, Socket, N) when N > 0 ->
  Data = <<"Hello server. Dont reply this">>,
  gen_sctp:send(Socket, Assoc, 0, Data),
  loop(Assoc, Socket, N - 1);
loop(_, Socket, 0) ->
  ok = gen_sctp:close(Socket).
