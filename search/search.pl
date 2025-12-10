
search(Actions) :-
    initial(StartRoom),
    % Initial state: StartRoom with keys found in that room
    get_keys(StartRoom, [], InitialKeys),
    % BFS Queue: List of [CurrentRoom, CurrentKeys, PathSoFar]
    % Visited: List of visited(Room, Keys) to prevent cycles
    bfs([[StartRoom, InitialKeys, []]], [visited(StartRoom, InitialKeys)], Actions).

% Base Case: Reached the treasure
bfs([[Room, _Keys, Path] | _], _, Actions) :-
    treasure(Room),
    reverse(Path, Actions).

% Recursive Step: Expand the queue
bfs([[Room, Keys, Path] | RestQueue], Visited, Actions) :-
    findall(
        [NextRoom, NextKeys, [move(Room, NextRoom) | Path]],
        (
            % 1. Check valid move (door or unlocked door)
            can_move(Room, NextRoom, Keys),
            % 2. Update keys (collect new keys from NextRoom)
            get_keys(NextRoom, Keys, NextKeys),
            % 3. Check if this state (Room + Keys) has been visited
            \+ member(visited(NextRoom, NextKeys), Visited)
        ),
        NewStates
    ),
    extract_visited(NewStates, NewVisited),
    append(Visited, NewVisited, UpdatedVisited),
    append(RestQueue, NewStates, NewQueue),
    bfs(NewQueue, UpdatedVisited, Actions).

% Determines if we can move between two rooms
can_move(A, B, _) :- door(A, B).
can_move(A, B, _) :- door(B, A).
can_move(A, B, Keys) :- locked_door(A, B, Color), member(Color, Keys).
can_move(A, B, Keys) :- locked_door(B, A, Color), member(Color, Keys).

% Collects keys in the current room and updates the key list
get_keys(Room, CurrentKeys, SortedKeys) :-
    findall(K, key(Room, K), RoomKeys),
    append(CurrentKeys, RoomKeys, AllKeys),
    sort(AllKeys, SortedKeys). % Sort ensures set equality for visited check

extract_visited([], []).
extract_visited([[R, K, _] | T], [visited(R, K) | VT]) :-
    extract_visited(T, VT).

    