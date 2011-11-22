-module(bbp).
-export([last/1]).
-export([penultimate/1]).
-export([len/1]).
-export([reverse/1]).
-export([is_palindrome/1]).
-export([flatten/1]).
-export([distinct/1]).
% -export([pack/1]).
-export([encode/1]).

last(List) -> case List of
    [] -> [];
    [_,S|T] -> last([S|T]);
    [Last|[]] -> Last
end.

%% 1.02 Find the second to last element of a list
penultimate([H|[]]) -> H;
penultimate([_,H|[]]) -> H;
penultimate(List) -> case List of
  [P,_|[]] -> P;
  [_,S|T] -> penultimate([S|T])
end.


%% 1.04 Find the length of a list
len([]) -> 0;
len([_|Tail]) -> 1 + len(Tail).

%% 1.05 Reverse a list
reverse(List) -> case List of
  [] -> [];
  [Head|[]] -> [Head];
  [Head|Tail] -> reverse(Tail) ++ [Head]
end.

%% 1.06 Determine if a list is a palindrome
is_palindrome([]) -> true;
is_palindrome([_|[]]) -> true;
is_palindrome([Head|Tail]) -> case reverse(Tail) of
  [Last|Rest] when Head == Last -> is_palindrome(Rest);
  _ -> false
end.

%% 1.07 Flatten a list of lists
flatten(List) -> case List of
  [] -> [];
  [Head|Tail] -> if
    is_list(Head) -> flatten(Head) ++ flatten(Tail);
    not is_list(Head) -> [Head|flatten(Tail)]
  end
end.

%% 1.08 Distinct elements of a list
distinct(List) -> case List of
  [] -> [];
  [Head|[]] -> [Head];
  [Head,Second|[]] ->
    if
      Head == Second -> [Head];
      Head /= Second -> [Head, Second]
    end;
  [Head,Second|Tail] ->
    if
      Head == Second -> distinct([Second|Tail]);
      Head /= Second -> [Head|distinct([Second|Tail])]
    end
end.

%% 1.09 Pack consecutive elements into a list of lists
% pack(List) -> case aux_pack(List, []) of
%     {[],
%
% aux_pack([], _) -> [];
% aux_pack([H|[]], _) -> [H];
% aux_pack([H|[Last|[]]], _) when H /= Last -> [[H, Last]];
% aux_pack([H|[Last|[]]], _) when H == Last -> [[H], [Last]];
% aux_pack([Head,Second|Tail], Packed) when Head == Second ->
%   aux_pack(Tail, [Head, Second] ++ Packed);
% aux_pack([Head,Second|Tail], Packed) when Head /= Second ->
%   {[Second] ++ Tail, [Head] ++ Packed}.


% pack([]) -> [];
% pack([H|[]) -> [[H]];
% pack([H,S|[]]) when H /= S -> [[H], [S]];
% pack([H,S|[]]) when H == S -> [[H, S]];
% pack([H,S|Tail]) when H /= S -> case aux_pack([S] ++ Tail)

%% 1.10 'Run-length encoding' of a list
encode(List) -> case List of
  [] -> [];
  [Head|[]] -> [[1, Head]];
  [Head, Second|[]] -> if
    Head == Second -> [[2, Head]];
    Head /= Second -> [[1, Head], [1, Second]]
  end;

  [Head,_|_] ->
    Counter = fun (Fn, C, List) -> 
      case List of
        [Head] -> {C+1, []};
        [Head,Second|Tail] -> if
          Head == Second -> Fn(Fn, C+1, [Second|Tail]);
          Head /= Second -> {C+1, [Second|Tail]}
        end
      end 
    end,

    {Count, Tail} = Counter(Counter, 0, List),
    [[Count, Head]|encode(Tail)]
end.
