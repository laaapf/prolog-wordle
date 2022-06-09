

%verifica se o numero digitado pelo usuario eh valido
main :-
    write("Digite o tamanho da palavra que deseja jogar de 4 a 7 letras (EXEMPLO: 4.): "),
    read(Number),
	(integer(Number),between(Number) -> game_setup(Number);
    print("Não eh um numero valido!"),
    nl,
    main()).

%setup para iniciar o jogo
game_setup(Number) :-
  	get_random_word(Number,Lines, Random_word_aux),
    downcase_atom(Random_word_aux,Random_word),
    atom_chars(Random_word, Random_word_char_list),
    nl,
    write(Random_word),
    nl,
    play_game(Number, 6, Random_word, Lines,Random_word_char_list).

%pega a entrada do usuario, verifica se a entrada eh valida, se for, continua o jogo, senao, uma palavra valida deve ser digitada novamente
play_game(Number, Tries, Random_word, Lines,Random_word_char_list) :-
  write("Faltam "),write(Tries),write(" chances!"),
  nl,
  get_guess(_Guess_aux,Guess,Guess_char_list),
  lenght_word(Guess_char_list,Lenght),
  check_if_guess_is_valid(Number,Lenght,Lines,Guess) -> 
  check_guess(Guess_char_list,Guess,Random_word,Random_word_char_list),Tries_left is Tries - 1,  (Tries_left is 0 -> end_game();nl, play_game(Number, Tries_left, Random_word, Lines,Random_word_char_list));
  write("A palavra que foi digitada eh invalida ou seu tamanho nao corresponde com o tamanho da palavra aleatoria que esta jogando!"),nl,play_game(Number,Tries,Random_word,Lines,Random_word_char_list).

check_guess(Guess_char_list,_Guess,Random_word,Random_word_char_list) :-
    Guess_char_list = Random_word_char_list -> write('Voce ganhou! A palavra eh "'),write(Random_word),write('"!'),end_game();
    check_correct_positions(Guess_char_list,Random_word_char_list,1).

check_correct_positions([],[],_Pos):-
    true.
check_correct_positions([HG|TG],[HR|TR],Pos) :-
    HG = HR -> (nl,write('A letra "'),write(HG),write('" esta correta na posicao '),write(Pos),add_number(Pos,P),check_correct_positions(TG,TR,P));
    add_number(Pos,P),check_correct_positions(TG,TR,P).

%lendo a entrada do usuario
get_guess(_Guess_aux,Guess,Guess_char_list) :-
  nl,
  write('Digite a palavra que deseja adivinhar entre aspas com um ponto no final(EXEMPLO: "teste".): '),
  read(Guess_aux),
  nl,
  downcase_atom(Guess_aux,Guess),
  atom_chars(Guess, Guess_char_list).

%somando 1 a um numero
add_number(N, Number) :-
    Number is N + 1.

%verifica o tamanho de uma palavra
lenght_word([],Lenght) :- Lenght is 0. 
lenght_word([_H|T], Lenght) :- lenght_word(T,L),Lenght is L+1.

%resgata uma palavra aleatoria de acordo com o arquivo correspondente
get_random_word(Number, Lines, Random_word) :-
    get_all_words(Number,Lines,N),
    nth1(N, Lines, Random_word).

%abertura e leitura do arquivo de palavras
get_all_words(Number,Lines,N) :-
    (4 = Number -> open('4_letters.txt',read, Str),random(0, 972, N);
    5 = Number -> open('5_letters.txt',read, Str),random(0, 2193, N);
    6 = Number -> open('6_letters.txt',read, Str),random(0, 3042, N);
    7 = Number -> open('7_letters.txt',read, Str),random(0, 4101, N))->
    read_file(Str,Lines),
    close(Str),
    nl.

%verificando se a palavra eh valida
check_if_guess_is_valid(Number,Lenght,Lines,Guess):-
    Number = Lenght,
    check_if_guess_exists(Lines,Guess).

%verifica se a palavra existe no arquivo de palavras
check_if_guess_exists([], _Guess) :-
    false.
check_if_guess_exists([Element_aux|Lines], Guess) :-
    downcase_atom(Element_aux,Element),
    Element \== Guess -> check_if_guess_exists(Lines,Guess);true.

%leitura do arquivo de palavras
read_file(Stream,[]) :-
    at_end_of_stream(Stream).
read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), % \+ not provable
    read(Stream,X),
    read_file(Stream,L).


%verificando se o usuario quer continuar o jogo ou finalizar o programa
end_game :-
    nl,
    write('O jogo terminou! Deseja jogar novamente? (Digite "sim". ou "nao".) '),
   	read(Option),
    (Option = "sim" ->  nl,main();
    (Option = "nao" -> write('Terminando o jogo!'),halt(0);
    write("Opcao invalida!"),
    nl,
    end_game())).

%checando se o tamanho da palavra eh valido
between(Number) :-
	4 =< Number, 7 >= Number.
                  
    

    