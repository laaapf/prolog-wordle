

%se o numero digitado pelo usuario eh valido, comeca o jogo
main :-
    read_number(Number) -> game_setup(Number);
    print("Nao eh um numero valido!"),nl,main().

%le o numero do usuario e realiza a verificacao
read_number(Number) :-
    write("Digite o tamanho da palavra que deseja jogar de 4 a 7 letras (EXEMPLO: 4.): "),
    read(Number),
	integer(Number),between(Number).

%setup para iniciar o jogo
game_setup(Number) :-
  	get_random_word(Number,Lines, Random_word_aux),
    downcase_atom(Random_word_aux,Random_word),
    atom_chars(Random_word, Random_word_char_list),nl,
    write(Random_word),nl,
    play_game(Number, 6, Random_word, Lines,Random_word_char_list).

%pega a entrada do usuario, verifica se a entrada eh valida, se for, continua o jogo, senao, uma palavra valida deve ser digitada novamente
play_game(Number, Tries, Random_word, Lines,Random_word_char_list) :-
  write("Falta(m) "),write(Tries),write(" chance(s)!"),nl,
  get_guess(_Guess_aux,Guess,Guess_char_list),
  lenght_word(Guess_char_list,Lenght),
  check_if_guess_is_valid(Number,Lenght,Lines,Guess) -> 
  check_char_guess_positions(Guess_char_list,Guess,Random_word,Random_word_char_list),Tries_left is Tries - 1,  (Tries_left is 0 -> end_game();nl, play_game(Number, Tries_left, Random_word, Lines,Random_word_char_list));
  write("A palavra que foi digitada eh invalida ou seu tamanho nao corresponde com o tamanho da palavra aleatoria que esta jogando!"),nl,play_game(Number,Tries,Random_word,Lines,Random_word_char_list).

%verificando se o usuario acertou a palavra, se nao acertou, fazemos a verificacao dos caracteres
check_char_guess_positions(Guess_char_list,_Guess,Random_word,Random_word_char_list) :-
    Guess_char_list = Random_word_char_list -> nl,ansi_format([bold,fg(green)],'Voce ganhou! A palavra eh "~w"!',[Random_word]),end_game();
    check_correct_positions(Guess_char_list,Random_word_char_list,1,Random_word_char_list,Chars_left),
    check_wrong_positions(Guess_char_list,Random_word_char_list,Random_word_char_list,1,Chars_left).

%verifica as letras que nao estao na palavra e as letras que estao fora de posicao
check_wrong_positions([],[],_Random_word_char_list,_Pos,_Chars_left):- !.
check_wrong_positions([HG|TG],[HR|TR],Random_word_char_list,Pos,Chars_left):-
    HG \== HR -> (member(HG,Chars_left) -> (remove_from_list(HG,Chars_left,Result), %percorremos a palavra aleatoria e o palpite do usuario ao mesmo tempo,
    %verificamos se o head de cada palavra eh diferente, se for, verificamos se a letra atual do palpite pertence a lista de letras da palavra aleatoria que faltam ser
    %verificadas, se fizer parte, subtraimos a primeira ocorrencia dessa letra na lista de caracteres que faltam ser verificados.
    %caso a letra nao faca parte dessa lista de caracteres, a letra nao faz parte da palavra
    nl,ansi_format([bold,fg(yellow)],'A letra "~w" na posicao ~w existe na palavra mas esta na posicao errada',[HG,Pos]),
    add_number(Pos,P),check_wrong_positions(TG,TR,Random_word_char_list,P,Result));
    nl,ansi_format([bold,fg(red)],'A letra "~w" na posicao ~w nao esta na palavra',[HG,Pos]),
    add_number(Pos,P),check_wrong_positions(TG,TR,Random_word_char_list,P,Chars_left));
    add_number(Pos,P),check_wrong_positions(TG,TR,Random_word_char_list,P,Chars_left).
                                                                     
%verificando as letras que estao na posicao correta
check_correct_positions([],[],_Pos,Aux_list,Chars_left):- append([],Aux_list,Chars_left).
check_correct_positions([HG|TG],[HR|TR],Pos,Aux_list,Chars_left) :-
    HG = HR -> (nl,ansi_format([bold,fg(green)],'A letra "~w" esta correta na posicao ~w',[HG,Pos]),
    remove_from_list(HG,Aux_list,Result),     %se a letra estiver na posicao correta, removemos a primeira ocorrencia da letra na lista auxiliar de palavras
    add_number(Pos,P),
    check_correct_positions(TG,TR,P,Result,Chars_left)); 
    add_number(Pos,P),check_correct_positions(TG,TR,P,Aux_list,Chars_left). %senao apenas continuamos


%lendo a entrada do usuario
get_guess(_Guess_aux,Guess,Guess_char_list) :-
  nl,
  write('Digite a palavra que deseja adivinhar entre aspas com um ponto no final(EXEMPLO: "teste".): '),
  read(Guess_aux),
  nl,
  downcase_atom(Guess_aux,Guess),   %colocando a entrada do usuario em lower case
  atom_chars(Guess, Guess_char_list).  %transformando a entrada do usuario em uma lista de caracteres

%remove a primeira ocorrencia de um elemento de uma lista
remove_from_list(_,[],[]).
remove_from_list(Element, [Element|T],T).
remove_from_list(Element, [H|T], [H|Result]) :- remove_from_list(Element,T,Result).

%somando 1 a um numero
add_number(N, Number) :-
    Number is N + 1.

%descobre o tamanho de uma palavra
lenght_word([],Lenght) :- Lenght is 0. 
lenght_word([_H|T], Lenght) :- lenght_word(T,L),Lenght is L+1.

%resgata uma palavra aleatoria de acordo com o arquivo correspondente
get_random_word(Number, Lines, Random_word) :-
    get_all_words(Number,Lines,N),
    nth1(N, Lines, Random_word).

%abertura e leitura do arquivo de palavras, resgatando todas as palavras do arquivo
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
    Number = Lenght,   %verificando se o tamanho da palavra corresponde ao tamanho que esta sendo jogado
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

%checando se o numero informado para jogar eh valido
between(Number) :-
	4 =< Number, 7 >= Number.

    
                  
    
                  