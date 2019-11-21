-module(sctp_clt).
-export([start/1]).

start(IP) ->
  {ok, Socket} = gen_sctp:open(),
  {ok, Assoc} =
  gen_sctp:connect(
    Socket,
    IP,
    8080,
    [{active, false}, {mode, binary}]
  ),
  loop(Assoc, Socket, 1000).

loop(Assoc, Socket, N) when N > 0 ->
  Data = list_to_binary(lists:append(lists:flatten(io_lib:format("~p", [N])), " Hello server. Dont reply this")),
  io:fwrite("~w~n", [Data]),
  gen_sctp:send(Socket, Assoc, 0, Data),
  loop(Assoc, Socket, N - 1);
loop(_, Socket, 0) ->
  ok = gen_sctp:close(Socket).
