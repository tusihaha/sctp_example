-module(sctp_serv).
-export([start/1]).

start(IP) ->
  {ok, Socket} =
  gen_sctp:open(
    8080,
    [{ip, IP}, {active, false}, {mode, binary}, {reuseaddr, true}]
  ),
  ok = gen_sctp:listen(Socket, 5),
  io:fwrite("Listen on port 8080 <Ctrl-c> to close\n"),
  loop(Socket, 1).

loop(Socket, N) ->
  case gen_sctp:recv(Socket) of
    {ok, {_FromIP, _FromPort, _AcnData, Data}} when is_tuple(Data) ->
      io:fwrite("");
    {ok, {_FromIP, _FromPort, _AcnData, Data}} ->
      io:fwrite("Data ~p: ~p~n", [N, Data]);
    {error, Reason} ->
      io:fwrite("Error: ~w~n", [Reason])
  end,
  loop(Socket, N + 1).
