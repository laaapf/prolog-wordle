% Student exercise profile
:- set_prolog_flag(occurs_check, error).        % disallow cyclic terms
:- set_prolog_stack(global, limit(8 000 000)).  % limit term space (8Mb)
:- set_prolog_stack(local,  limit(2 000 000)).  % limit environment space

main :-
    print('Digite o tamanho da palavra que deseja jogar (4 a 7 letras): '),
    read(Number),
	(integer(Number),between(Number) -> game_setup(Number);
    print("Não é um número válido!"),
    nl,
    main()).

game_setup(Number) :-
  	get_random_word(Number,Lines, Random_word),
    write(Random_word),
    play_game(Number, 6, Random_word).


play_game(Number, Tries, Random_word) :-
  write('Digite a palavra que deseja adivinhar: '),
  read(Guess),
  atom_chars(Guess, Guess_char_list),
  Tries_left is Tries - 1,  
  (Tries_left is 0 -> end_game();
  nl, play_game(Number, Tries_left, Random_word)).

lenght_word_check(Number, Guess_char_list) :-
	write(" ").
	
get_random_word(Number, Lines, Random_word) :-
    get_all_words(Number,Lines,N),
    nth1(N, Lines, Random_word).

get_all_words(Number,Lines,N) :-
    (4 = Number -> open('4_letters.txt',read, Str),random(0, 972, N),write('1');
    5 = Number -> open('5_letters.txt',read, Str),random(0, 2193, N),write('2');
    6 = Number -> open('6_letters.txt',read, Str),random(0, 3042, N),write('3');
    7 = Number -> open('7_letters.txt',read, Str),random(0, 4101, N),write('4'))->
    read_file(Str,Lines),
    close(Str),
    nl.

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), % \+ not provable
    read(Stream,X),
    read_file(Stream,L).

end_game :-
    write("O jogo terminou! Deseja jogar novamente? (sim/nao) "),
   	read(Option),
    (Option = 'sim' ->  main();
    (Option = 'nao' -> write('Terminando o jogo!');
    write("Opção inválida!"),
    nl,
    end_game())).

between(Number) :-
	4 =< Number, 7 >= Number.
                  
    