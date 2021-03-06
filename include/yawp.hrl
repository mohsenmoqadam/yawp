%% -*- mode:erlang -*-
-author('MohsenMoqadam@yahoo.com').

-ifndef(HEADER_YAWP).
-define(HEADER_YAWP, true).

-record(yawp_pool, {name   :: atom(), %% Pool name
                    worker :: mfa(),  %% Worker {module(), fun(), arity()}
                    max_size = 32  :: non_neg_integer(), %% Maximum pool size
                    min_size = 16  :: non_neg_integer(), %% Minimum pool size
                    sui      = 200 :: non_neg_integer(), %% Shaper Update Interval
                    bi       = 200 :: non_neg_integer(), %% Beacon Interval
                    decrement_timeout = 60000 :: non_neg_integer()
                   }).

-record(yawp_signal, {name      :: beacon_service_feedback |
                                   worker_service_feedback |
                                   worker_service_stats    |
                                   worker_join_pool        |
                                   worker_leave_pool       |
                                   shaper_service_stats,
                      meta      :: term(),
                      sender    :: pid(),
                      receivers :: list(pid())}).

-record(yawp_shaper_info, {cpd       :: term(), %% CPD: Cumulative Probability Distribution
                           mntr_name :: atom()  %% The name of the actor which calculate workers stats.
                          }).


-record(yawp_worker_feedback, {worker_ql :: non_neg_integer(), %% QL: Queue Lenght
                               worker_ct :: non_neg_integer()  %% CT: Commited Tasks.
                              }).

-record(yawp_worker_stats, {calls = 0    :: non_neg_integer(),
                            casts = 0    :: non_neg_integer(),
                            infos = 0    :: non_neg_integer(),
                            ol_calls = 0 :: non_neg_integer(),
                            ol_casts = 0 :: non_neg_integer(),
                            ol_infos = 0 :: non_neg_integer()}).

-record(yawp_shaper_stats, {search_time = 0 :: non_neg_integer()}).

-type yawp_poo()          :: #yawp_pool{}.
-type yawp_pool_sup()     :: pid().
-type yawp_pool_name()    :: atom().
-type yawp_pool_size()    :: non_neg_integer().
-type yawp_pool_available_size() :: integer().
-type yawp_pool_current_size()   :: integer().

-type yawp_pool_worker_pids()  :: list(pid()).
-type yawp_pool_worker_pid()   :: pid().

-type yawp_pool_shaper_cpd()   :: term().
-type yawp_pool_shaper_cpd_prob() :: float().
-type yawp_pool_shaper_cpd_boundary() :: integer().

-type yawp_pool_mntr_name() :: atom().

-type yawp_pool_beacon_name() :: atom().

-type yawp_worker_stats() :: #yawp_worker_stats{}.

-type yawp_signal() :: #yawp_signal{}.

-define(YAWP_NOW_NANO(),  erlang:system_time(nanosecond)).
-define(YAWP_NOW_MICRO(), erlang:system_time(microsecond)).
-define(YAWP_NOW_SEC(),   erlang:system_time(second)).

-ifdef(TEST).
-define(YAWP_LOG_ERROR(Format, Args), ct:print(default, 50, Format, Args)).
-define(YAWP_LOG_INFO(Format,  Args), ?YAWP_LOG_ERROR(Format, Args)).
-define(YAWP_LOG_DEBUG(Format, Args), ?YAWP_LOG_ERROR(Format, Args)).
-else.
-define(YAWP_LOG_ERROR(Format, Args), lager:error(Format, Args)).
-define(YAWP_LOG_INFO(Format,  Args), lager:info(Format, Args)).
-define(YAWP_LOG_DEBUG(Format, Args), lager:debug(Format, Args)).
-endif.

-endif.
