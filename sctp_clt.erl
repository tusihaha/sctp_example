-module(sctp_clt).
-include_lib("kernel/include/inet_sctp.hrl").
-import_record_info([{inet_sctp, sctp_paddrparams}]).
-export([start/1]).

start([IP, N]) ->
  IPAddr = case is_tuple(IP) of
		true -> IP;
		false ->
			{ok, R} = inet:parse_address(IP),
			R
	   end,
  {ok, Socket} = gen_sctp:open(),
  {ok, Assoc} =
  gen_sctp:connect(
    Socket,
    IPAddr,
    8080,
    [
	{active, false}, {mode, binary}, {sctp_nodelay, true},
	{sctp_peer_addr_params, #sctp_paddrparams{
	hbinterval=20,
	flags=[hb_enable]
	}
	}
    ]
  ),
  Nc = case is_integer(N) of
	true -> N;
	false -> list_to_integer(N)
       end,
  loop(Assoc, Socket, 1, Nc).

loop(Assoc, Socket, I, N) when I =< N ->
  Data = list_to_binary(lists:append(lists:flatten(io_lib:format("~p", [I])), " Hello server. Dont reply this")),
  io:fwrite("~p~n", [Data]),
  gen_sctp:send(Socket, Assoc, 0, Data),
  loop(Assoc, Socket, I + 1, N);
loop(_, Socket, _, _) ->
  ok = gen_sctp:close(Socket).
