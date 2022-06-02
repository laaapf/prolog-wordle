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
  	get_random_word(Number,Random_word),
    play_game(Number,6, Random_word).


play_game(Number, Tries, Random_word) :-
  Tries_left is Tries - 1,
  write('Digite a palavra que deseja adivinhar: '),
  read(Guess),
  atom_chars(Guess,Guess_char_list),
  (Tries_left is 0 -> end_game();
  nl, play_game(Number,Tries_left,Random_word)).

end_game :-
    write("O jogo terminou! Deseja jogar novamente? (sim/nao) "),
   	read(Option),
    (Option = 'sim' ->  main();
    (Option = 'nao' -> write('Terminando o jogo!');
    write("Opção inválida!"),
    nl,
    end_game())).

get_random_word(Number, Random_word) :-
	open('words.txt', read, Str),
    read_file(Str,Words),
    close(Str),
    write(Lines),nl,
    Random_word = 'cacilda'.

                                                                           
between(Number) :-
	4 =< Number, 7 >= Number.
                  
    