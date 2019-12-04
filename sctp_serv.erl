-module(sctp_serv).
-include_lib("kernel/include/inet_sctp.hrl").
-import_record_info([{inet_sctp, sctp_paddrparams}]).
-export([start/0]).
%-record(sctp_paddrparams, {assoc_id, address, hbinterval, pathmaxrxt, pathmtu, sackdelay, flags}).

start() ->
  {ok, Socket} =
  gen_sctp:open(
    8080,
    [{ip, {0,0,0,0}}, {active, false}, {mode, binary}, {reuseaddr, true},
     {recbuf, 100000},
    ]
  ),
  ok = gen_sctp:listen(Socket, 5),
  io:fwrite("Listen on port 8080 <Ctrl-c> to close\n"),
  loop(Socket, 1).

loop(Socket, N) ->
  case gen_sctp:recv(Socket) of
    {ok, {_FromIP, _FromPort, _AcnData, Data}} when is_tuple(Data) ->
      io:fwrite(""),
      loop(Socket, N);
    {ok, {_FromIP, _FromPort, _AcnData, Data}} ->
      io:fwrite("Data ~p: ~p~n", [N, Data]),
      loop(Socket, N + 1);
    {error, Reason} ->
      io:fwrite("Error: ~w~n", [Reason]),
      loop(Socket, N)
  end.
