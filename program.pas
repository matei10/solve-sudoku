program sudoku;
uses SysUtils;
const n_mat = 9;
      version = '1.4.0'; 
      autor = 'Micu Matei-Marius';
      git_repo = 'https://github.com/matei10/solve-sudoku';
      gmail = 'micumatei@gmail.com';
      licenta = 'The MIT License (MIT)';

type point = record
        x, y :byte;
        end;

     vector = array[1..81] of point;

     nod = record
        liber :boolean; { daca locul e liber, adica la citirea matrici nu se aflau valori in nod  }         
        valoare :byte; { ce valoare are  }
        end;

    matrice_adj = array[1..81, 1..81] of boolean;

    matrice_nod = array[1..9, 1..9] of nod;

var mat_a :matrice_adj;
    mat_n :matrice_nod;
    vec_goale :vector;
    n, i :byte;

{ POINT functions / procedures }
function new_point(i, j :byte):point;
begin
with new_point do
    begin
    x := i;
    y := j;
    end;
end;

{ NOD functions / procedures  }

procedure init_nod(var n :nod);
{ initializam un nod }
begin
with n do
    begin
    liber := false;
    valoare := 0;
    end;
end;


function new_nod(x :byte):nod;
{ cream un nod cu valoarea <x> }
begin
init_nod(new_nod); { initializam nodul }
with new_nod do
    begin
    valoare := x;
    liber := (x = 0);
    end;
end;


{ AJUTATOAREA functions / procedures}

procedure afis_mat_n(var m_n :matrice_nod);
var i, j :byte;
begin
for i := 1 to n_mat do
    begin
    for j := 1 to n_mat do
        write(m_n[i, j].valoare:4, ' ');
    writeln;
    end;
end;


procedure init_mat_a(var m_a:matrice_adj);
{ initializam matricea de adiacenta }
var i, j:byte;
begin
for i := 1 to n_mat * n_mat do
    for j := 1 to n_mat * n_mat do
        m_a[i, j] := false;
end;

procedure afis_mat_a(var m_a:matrice_adj);
{ afisam matricea de adiacenta }
var i, j :integer;
begin
write(' ');
for i := 1 to n_mat * n_mat do
    write('|',i);
writeln('|');

for i := 1 to n_mat * n_mat do
    begin
    write(i);
    for j := 1 to n_mat * n_mat do
        if m_a[i, j] then
            write('x|')
        else
            write('0|');
    writeln('|');
    end;
end;

function generate_vec_poz(i, j:byte):byte;
{ returnam pozitia in vector a elementului din matrice de pe pozitia <i>, <j> }
begin
generate_vec_poz := (i-1)*n_mat + j;
end;

function generate_poz_p(a :byte):point;
var i, j :integer;
begin
with generate_poz_p do
    begin
    j := a mod n_mat;
    if j = 0 then
        j := 9;

    i := ((a - j) div n_mat) + 1;

    x := i;
    y := j;
    end;
end;


{ MAIN functions / procedures }

procedure init_program;
begin
n := 0; { numarul de elemente goale }
end;

procedure gen_mat_adj(var m_a:matrice_adj);
{ generam matricea de adiacenta }
var i, j, aux, i2, j2 :byte;

    function get_corner(x :byte):byte;
    { cautam coltul patratului mic care compune matricea  }
    begin
    get_corner := (((x-1) div 3)*3) + 1;
    end;

begin
init_mat_a(m_a); { initializam matricea cu false }

for i := 1 to n_mat do
    for j := 1 to n_mat do
        begin
        aux := generate_vec_poz(i, j); { locul elementului [i, j] in vectorul de elemente }

        { mergem pe coloane }
        for j2 :=  1 to n_mat do
            if j2 <> j then
                m_a[aux, generate_vec_poz(i, j2)] := true;

        { mergem pe linii }
        for i2 := 1 to n_mat do
            if i2 <> i then 
                m_a[generate_vec_poz(i2, j), j] := true;

        { circulam elementele din patratul mic }
        for i2 := get_corner(i)  to get_corner(i) + 2 do
            for j2 := get_corner(j) to get_corner(j) + 2 do
                if (i2 <>i) AND (j2 <> j) then 
                    begin
                    m_a[aux, generate_vec_poz(i2, j2)] := true;
                    end;
        end;
end;


procedure citire(var m_n :matrice_nod; s :string);
{ citim matricea cu elemente }
var i, j, aux :byte;
    f :text;
begin
assign(f, s);
reset(f);

i := 0;
while not eof(f) do
    begin
    i := i + 1;
    j := 0;

    while not eoln(f) do
        begin
        j := j + 1;
        read(f, aux);
        m_n[i, j] := new_nod(aux);

        if m_n[i, j].liber then { retinem punctul acesta ca element liber }
            begin
            n := n + 1;
            vec_goale[n] := new_point(i, j); { retinem faptul ca acest element e gol si il putem modifica }
            end;
        end;
    readln(f);
    end;
close(f);

gen_mat_adj(mat_a); { generam matricea de adiacenta}
end;

procedure start_solve;
{ rezolvam matricea  }
var rezolvat :boolean;

    function get_nr_var(e :byte):byte;
    { returnam numarul de variabile pe care le poate lua elementul vec_goale[e] }
    var v :array[1..n_mat] of boolean;
        aux_p, aux_p2 :point;
        i, aux :byte;
    begin
    { initializam v cu false }
    for i := 1 to n_mat do 
        v[i] := false;

    aux_p := vec_goale[e]; 

    get_nr_var := 0;

    if mat_n[aux_p.x, aux_p.y].valoare = 0 then { cat timp nu am incercat deja o valoare aici}
        begin
        for  i := 1 to n_mat * n_mat do
            if mat_a[generate_vec_poz(aux_p.x, aux_p.y), i] then { exista legatura intre aux_p si i }
                begin
                aux_p2 := generate_poz_p(i);
                aux := mat_n[aux_p2.x, aux_p2.y].valoare;

                if aux <> 0 then
                    v[aux] := true;
                end;

        for i := 1 to n_mat do
            if not v[i] then
                inc(get_nr_var);
        end
    else
        get_nr_var := 10;

    end;


    function get_min_var:byte;
    var i, min, aux :byte;
    { returnam elementul liber care are minimul de variante posibile }
    begin
    min := 10;
    for i := 1 to n do { circulam prin toate elementele libere }
        begin
        aux := get_nr_var(i);
        if aux < min then 
            begin
            min := aux;
            get_min_var := i;
            end;
        end;
    end;

    function get_valid_var(e :byte):byte;
    { returnam urmatoarea varianta posibila }
    var i, aux :byte;
        v :array[1..n_mat] of boolean;
        aux_p, aux_p2 :point;
    begin
    { initializam v cu false }
    for i := 1 to n_mat do 
        v[i] := false;

    aux_p := vec_goale[e]; 

    for  i := 1 to n_mat * n_mat do
        if mat_a[generate_vec_poz(aux_p.x, aux_p.y), i] then { exista legatura intre aux_p si i }
            begin
            aux_p2 := generate_poz_p(i);
            aux := mat_n[aux_p2.x, aux_p2.y].valoare;

            if aux <> 0 then
                v[aux] := true;
            end;

    get_valid_var := 0;
    for i := mat_n[aux_p.x, aux_p.y].valoare + 1 to n_mat do
        if not v[i] then
            begin
            get_valid_var := i;
            break;
            end;
    end;

    procedure re_init(e :byte);
    var aux_p :point;
    begin
    aux_p := vec_goale[e]; 

    mat_n[aux_p.x, aux_p.y].valoare := 0;
    end;

    function solutie(e :byte):boolean;
    begin
    solutie := (e = n);
    end;

    procedure back(e :byte);
    var aux_p :point;
    { procedura recursiva  }
    begin
    aux_p := vec_goale[e];
    if not rezolvat then
        begin
        re_init(e);

        while ((get_valid_var(e) <> 0) AND (not rezolvat) ) do
            begin
            mat_n[aux_p.x, aux_p.y].valoare := get_valid_var(e);
            if solutie(e) then 
                rezolvat := true
            else
                back(get_min_var);
            end;
        end;
    end;

begin
if n > 0 then
    begin
    rezolvat := false;
    back(get_min_var);
    end
else
    rezolvat := true;

if rezolvat then 
    afis_mat_n(mat_n)
else
    writeln('Nu are solutie');
end;

procedure test;
{ teste  }
begin
writeln('Am rulat !');
citire(mat_n, 'input.txt');
writeln('Am citit (2) :');
afis_mat_n(mat_n);
writeln('INitializam mat_adj');
writeln('Rezolvam:');
start_solve;
end;

begin
init_program;

if ParamCount > 0 then { s-a transmis un parametru }
    begin
    if (lowercase(ParamStr(1)) = '-h') OR (lowercase(ParamStr(1)) = '--help') OR (lowercase(ParamStr(1)) = '-?') then
        begin
        writeln;
        writeln(' Acest program rezolva o matrice sudoku 9x9');
        writeln(' Programul primeste ca parametri calea relativa catre fisierele care contin matricea .');
        writeln(' Puteti afisa acest help message folosit comanda -h, --help sau -? .');
        writeln(' Autor :', autor);
        writeln(' GitHug :', git_repo);
        writeln(' Gmail ', gmail);
        writeln(' Licenta :', licenta);
        writeln;
        end
    else
        for i := 1 to ParamCount do
            begin
            writeln(' Citim fisierul :', ParamStr(i));
            if FileExists(ParamStr(i)) then
                begin
                citire(mat_n, ParamStr(i));
                start_solve;
                writeln;
                end
            else
                begin
                writeln(' Nu am gasit fisierul :', ParamStr(i) ,' ,va rugam verificati : ', git_repo);
                writeln(' pentru mai multe informatii sau <-h> !');
                end;
            end;
    end
else { nu s-a transmis nici un paramteru }
    begin
    writeln(' Nu s-a transmis un fisier, va rugam verificati : ', git_repo);
    writeln(' pentru mai multe informatii sau <-h> !');
    end;
end.
