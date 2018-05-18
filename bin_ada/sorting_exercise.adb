with ada.text_io,ada.integer_text_io,ada.numerics.discrete_random ;
use ada.text_io ;

procedure sorting_exercise is


        type t_tableau is array(integer range <>) of integer ;
        t : t_tableau(1..50) ;


        function init_tab return t_tableau is
                subtype intervall is integer range 1..100 ;
                package aleatoire is new ada.numerics.discrete_random(intervall) ;
                hasard : aleatoire.generator ;
                tab : t_tableau(1..50) ;
        begin
                aleatoire.reset(hasard) ;
                for i in tab'range loop 
                        tab(i) := aleatoire.random(hasard) ;
                end loop ;
                return tab ;
        end init_tab;



        procedure render_tab(t : t_tableau) is
        begin
                for i in t'range loop 
                        ada.integer_text_io.put(t(i)) ;
                        new_line ;
                end loop ;
        end render_tab ;


        procedure exchange(a : in out integer ; b : in out integer) is
                temp : integer ;
        begin
                temp := b ;
                b := a ;
                a := temp ;
        end exchange ;

        function rang_min(t : t_tableau ; first : integer ; last : integer) return integer is
                min : integer := t(first) ;
                rank : integer ;
        begin
                for i in first..last loop
                        if min > t(i) then
                                rank := i ;
                                min := t(i) ;
                        end if ;
                end loop ;
                return rank ;
        end rang_min ;


        function sort(t : t_tableau) return t_tableau is
                tab : t_tableau := t ;
        begin
                for i in tab'range loop
                        exchange(tab(i),tab(rang_min(tab,i,tab'last))) ;
                end loop ;
                return tab ;
        end sort ;

        function insert_sort(t : t_tableau) return t_tableau is
                tab : t_tableau := t ;
        begin
                for i in tab'first+1..tab'last loop
                        for j in reverse tab'first+1..i loop
                                exit when tab(j-1) <= tab(j) ;
                                exchange(tab(j-1),tab(j)) ;
                        end loop ;
                end loop ;
                return tab ;
        end insert_sort ;

        function bubble_sort(t : t_tableau) return t_tableau is
                tab : t_tableau := t ;
                permut : boolean := true ;
        begin
                while permut loop
                        permut := false ;
                        for i in tab'first..tab'last-1 loop
                                if tab(i) > tab(i+1) then
                                       exchange(tab(i),tab(i+1)) ;
                                       permut := true ;
                                end if ;
                        end loop ;
                end loop ;
               return tab ;
        end bubble_sort ;


        

        function quik_sort(t : t_tableau) return t_tableau is

                procedure sort(t : in out t_tableau ; first,last : integer) is
                        pivot : integer := (first + last) / 2 ;
                        j : integer := first + 1 ;
                begin
                        if first < last then
                                exchange(t(first),t(pivot)) ;
                                pivot := first ;
                                for i in first + 1..last loop
                                        if t(i) < t(pivot) then
                                                exchange(t(i),t(j)) ;
                                                j := j + 1 ;
                                        end if ;
                                end loop ;
                                exchange(t(pivot),t(j - 1)) ;
                                pivot := j - 1 ;

                                sort(t,pivot+1,last) ;
                                sort(t,first,pivot-1) ;
                        end if ;

                                
                end sort ;

                tab : t_tableau := t ;



        begin

                sort(tab,tab'first,tab'last) ;

                return tab ;



        end quik_sort ;




               




        function fusion(t1,t2 : t_tableau) return t_tableau is
                t : t_tableau(1..t1'length+t2'length) ;
                i : integer := t1'first ;
                j : integer := t2'first ;
        begin

                if t1'length = 0 then
                        return t2 ;
                elsif t2'length = 0 then
                        return t1 ;
                end if ;



                for k in t'range loop
                        if i > t1'last and j > t2'last then
                                exit ;
                        elsif i > t1'last then
                                t(k..t'last) := t2(j..t2'last) ;
                                exit ;
                        elsif j > t2'last then
                                t(k..t'last) := t1(i..t1'last) ;
                                exit ;
                        end if ;

                        if t1(i) <= t2(j) then
                                t(k) := t1(i) ;
                                i := i + 1 ;
                        else
                                t(k) := t2(j) ;
                                j := j + 1 ;
                        end if ;
                end loop ;
                return t ;
        end fusion ;


        function tri_fusion(t : t_tableau) return t_tableau is
                lg : constant integer := t'length ;
        begin
                if lg <= 1 then
                        return t ;
                else
                        declare
                                t1 : t_tableau(t'first..t'first-1+lg/2) ;
                                t2 : t_tableau(t'first+lg/2..t'last) ;

                        begin
                                t1 := tri_fusion(t(t'first..t'first-1+lg/2)) ;
                                t2 := tri_fusion(t(t'first+ lg/2..t'last)) ;

                                return fusion(t1,t2) ;

                        end ;

                end if ;

        end tri_fusion ;


        procedure tamiser(t : in out t_tableau ; noeud : integer ; max : integer) is
                racine : integer := noeud ;
                feuille : integer := noeud * 2 ;
        begin
                while feuille <= max loop
                        if feuille+1 < max and then t(feuille) < t(feuille+1) then
                                feuille := feuille + 1 ;
                        end if ;
                        if t(racine) < t(feuille) then
                                exchange(t(racine),t(feuille)) ;
                        end if ;
                        racine := feuille ;
                        feuille:= 2 * racine ;
                end loop ;
        end tamiser ;

        function tri_arbre(t : t_tableau) return t_tableau is
                arbre : t_tableau(1..t'length) := t ;
        begin
                for i in reverse arbre'first..arbre'last/2 loop
                        tamiser(arbre,i,arbre'last) ;
                end loop ;
                for i in reverse arbre'first+1..arbre'last loop
                        exchange(arbre(arbre'first),arbre(i)) ;
                        tamiser(arbre,arbre'first,i-1) ;
                end loop ;

                return arbre ;

        end tri_arbre ;

        
                




begin

        t := init_tab ;
        render_tab(t) ;
        t := tri_arbre(t) ;
        put_line("tableau ranger") ;
        render_tab(t) ;

end sorting_exercise ;

