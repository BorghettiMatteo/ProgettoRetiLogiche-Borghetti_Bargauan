library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--draft che sembra funzionare

entity project_reti_logiche is port (
    i_clk : in std_logic; 
    i_rst : in std_logic;
    i_start : in std_logic;
    i_data : in std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    o_en : out std_logic;
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0)
);

end project_reti_logiche; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity address_adder is port(
        i_clk : in std_logic;
        compute_read_address : in std_logic;
        compute_write_address : in std_logic;
        read_address_out : out std_logic_vector(15 downto 0);
        write_address_out : out std_logic_vector(15 downto 0);
        reset_address_to_known_value : in std_logic;
        full_address: in std_logic;
        reset_full_address: in std_logic;
        half_address: in std_logic;
        reset_half_address : in std_logic

        );
end address_adder;

        architecture Behavioral of address_adder is
        signal read_address_reg : std_logic_vector(15 downto 0) := "0000000000000001";
        signal write_address_reg : std_logic_vector(15 downto 0) := "0000000000000001";
        signal read_address_reg_next : std_logic_vector(15 downto 0) := "0000000000000000";
        signal write_address_reg_next : std_logic_vector(15 downto 0) := "0000000000000000";

        signal temp_read : std_logic_vector(15 downto 0) := "0000000000000000";
        signal temp_write : std_logic_vector(15 downto 0) := "0000000000000000";

        


    begin

        read_address_reg_next <= read_address_reg + "0000000000000001";

        write_address_reg_next  <= write_address_reg + "0000000000000001";

        process(compute_read_address,i_clk,reset_address_to_known_value)
        begin
            if(reset_address_to_known_value = '1') then
                read_address_out  <= "0000000000000000";
            end if; 
            if(compute_read_address = '1' and rising_edge(i_clk)) then
            read_address_out  <= temp_read;
            end if;

        end process;

       
        with reset_full_address select
            temp_read <= read_address_reg_next when  '1' , "0000000000000000" when  '0' , "XXXXXXXXXXXXXXXX" when others ;

        process(i_clk,full_address,reset_address_to_known_value)
        begin
        if(reset_address_to_known_value = '1') then 
            read_address_reg  <= "0000000000000001";
        end if;
        if(full_address = '1' and rising_edge(i_clk)) then
            read_address_reg  <= temp_read;   
        end if;
        end process;
                
        --calcolo rilettura

        

        process(compute_write_address,i_clk,reset_address_to_known_value)
            begin
                if(reset_address_to_known_value = '1') then
                    write_address_out  <= "0000000000000001";
                end if; 
                if(compute_write_address = '1' and rising_edge(i_clk)) then
                write_address_out  <= temp_write;
                end if;
        end process;

        with reset_half_address select
            temp_write <= write_address_reg_next when  '1' , "0000000000000000" when  '0' , "XXXXXXXXXXXXXXXX" when others ;

        process(i_clk,half_address,reset_address_to_known_value)
            begin
                if(reset_address_to_known_value = '1') then 
                    write_address_reg  <= "0000000000000001";
                end if;
                if(half_address = '1' and rising_edge(i_clk)) then
                    write_address_reg  <= temp_write;   
                end if;
        end process;


    end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

architecture Behavioral of project_reti_logiche is
    component datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector (7 downto 0);
        i_start : in std_logic;
        summ_dimention_load : in std_logic;
        temporary_sum_load : in std_logic;
        decrement_mux_selector: in std_logic;
        dec_load : in std_logic;
        stop_max_min : out std_logic;
        machine_counter : in std_logic_vector(1 downto 0);
        
        reg_max_load : in std_logic;
        reg_min_load : in std_logic;
        redo_dec_max_min : in std_logic;
        new_max : out std_logic;
        new_min : out std_logic;
        stop_dim_calc : out std_logic;
        dimension_calc_for_max_min : in std_logic;
        delta_value_load : in std_logic;
        log_calc_load : in std_logic;
        do_dec_on_eq_img : in std_logic;
        equalization_dim_dec : out std_logic;
        dec_shift : out std_logic;
        ready_shift : in std_logic;
        check_255_bound : in std_logic;
        start_dec_for_shift : in std_logic;
        load_shift_value : in std_logic;
        evlauete_equalized_pixel : in std_logic;
        end_equalization : in std_logic;
        end_calc : out std_logic;
        end_calc_2 : out std_logic;
        write_to_memory_pixel  : in std_logic

        );
    end component;

    component address_adder is port(
        i_clk : in std_logic;
        compute_read_address : in std_logic;
        compute_write_address : in std_logic;
        read_address_out : out std_logic_vector(15 downto 0);
        write_address_out : out std_logic_vector(15 downto 0);
        reset_address_to_known_value : in std_logic;
        full_address: in std_logic;
        reset_full_address: in std_logic;
        half_address : in std_logic;
        reset_half_address : in std_logic
        );
    end component;

    signal compute_read_address : std_logic;
    signal compute_write_address :std_logic;
    signal read_address_out : std_logic_vector(15 downto 0);
    signal write_address_out : std_logic_vector(15 downto 0);
    signal reset_address_to_known_value : std_logic;    
    signal summ_dimention_load : std_logic;
    signal temporary_sum_load : std_logic;
    signal dec_load : std_logic;
    signal stop_max_min :std_logic;
    signal decrement_mux_selector : std_logic;
    signal machine_counter : std_logic_vector(1 downto 0) := "00";

    signal reg_max_load :  std_logic;
    signal reg_min_load :  std_logic;
    signal redo_dec_max_min :  std_logic;
    signal new_max :  std_logic;
    signal new_min :  std_logic;
    signal stop_dim_calc : std_logic;
    signal dimension_calc_for_max_min : std_logic;
    signal delta_value_load : std_logic;
    signal log_calc_load : std_logic;
    signal equalization_dim_dec : std_logic;
    signal do_dec_on_eq_img : std_logic;
    signal dec_shift : std_logic;
    signal ready_shift : std_logic;
    signal check_255_bound : std_logic;
    signal start_dec_for_shift : std_logic;
    signal load_shift_value : std_logic;
    signal evlauete_equalized_pixel : std_logic;
    signal end_equalization : std_logic;
    signal end_calc : std_logic;
    signal end_calc_2 : std_logic;
    signal reset_full_address: std_logic;
    signal full_address: std_logic;
    signal half_address : std_logic;
    signal reset_half_address : std_logic;
    signal write_to_memory_pixel : std_logic;

    -- gestione segnali
    type S is(
        S_INIT_MACHINE,
        LOAD_ADDRESSES,
        LOAD_FIRST_DIMENSION,
        LOAD_SECOND_DIMENSION,
        CALC_IMAGE_DIMENSION,
        LOAD_UNEQUALIZED_PIXEL_FOR_MAX_MIN,
        CHECK_NEW_MAX_MIN,
        REGISTER_NEW_MAX_MIN,
        S_CALC_ADDRESS,
        S_INIT_SUM,
        CALC_DELTA_VALUE,
        CALC_LOG_VALUE,
        S_CALC_EQUALIZATION_ADDRESS,
        S_GET_PIXEL,
        S_INIT_SHIFT,
        S_WAIT_SHIFT,
        S_CHECK_255,
        S_WRITE_EQUALIZED_PIXEL,
        HALT,
        S_CURRETPX_MIN,
        S_DEC_IMG_DIMESION,
        S_CONTROL_MAX_MIN
        );

    signal curr_state, next_state: S;

    
begin
    DATAPATH0: datapath port map(
        i_clk  => i_clk,
        i_rst => i_rst,
        i_data => i_data,
        o_data => o_data,
        i_start => i_start,
        summ_dimention_load => summ_dimention_load,
        temporary_sum_load => temporary_sum_load,
        decrement_mux_selector => decrement_mux_selector,
        dec_load =>dec_load ,
        stop_max_min => stop_max_min,
        machine_counter  => machine_counter,
        reg_max_load => reg_max_load, 
        reg_min_load => reg_min_load,
        redo_dec_max_min => redo_dec_max_min,
        new_max => new_max,
        new_min => new_min,
        stop_dim_calc => stop_dim_calc,
        dimension_calc_for_max_min => dimension_calc_for_max_min,
        delta_value_load => delta_value_load,
        log_calc_load => log_calc_load,
        equalization_dim_dec => equalization_dim_dec,
        do_dec_on_eq_img => do_dec_on_eq_img,
        dec_shift => dec_shift,
        ready_shift => ready_shift,
        check_255_bound => check_255_bound,
        start_dec_for_shift => start_dec_for_shift,
        load_shift_value => load_shift_value,
        evlauete_equalized_pixel => evlauete_equalized_pixel,
        end_equalization => end_equalization,
        end_calc => end_calc,
        end_calc_2 => end_calc_2,
        write_to_memory_pixel  => write_to_memory_pixel
        );


    ADDRESS_ADDER_0: address_adder port map(
        i_clk  =>  i_clk,
        compute_read_address  =>  compute_read_address,
        compute_write_address  =>  compute_write_address,
        read_address_out  =>  read_address_out,
        write_address_out  =>  write_address_out,
        reset_address_to_known_value  =>  reset_address_to_known_value,
        reset_full_address=> reset_full_address,
        full_address => full_address,
        half_address  => half_address,
        reset_half_address  => reset_half_address
        );

    process(i_clk,i_rst)
    begin
        if(i_rst = '1') then
            curr_state <= S_INIT_MACHINE;
        elsif rising_edge(i_clk) then
            curr_state <= next_state;
        end if;
    end process;



    process(curr_state,next_state,stop_max_min,new_min,new_max,stop_dim_calc,i_rst,equalization_dim_dec,dec_shift,i_start,end_calc,end_calc_2) -- i segnali che cambiano datapath -> esterno che pilotano la FSM devono essere messi in questa sensitivity list !!!!!!!!
    begin
        next_state <= curr_state;
        case curr_state is
            when S_INIT_MACHINE =>
                if(i_start = '1') then
                    next_state <= LOAD_ADDRESSES;
                else next_state <= S_INIT_MACHINE;
            end if;
            when LOAD_ADDRESSES => 
                next_state <= LOAD_FIRST_DIMENSION;
            when LOAD_FIRST_DIMENSION => 
               
                    next_state <= LOAD_SECOND_DIMENSION;
            when LOAD_SECOND_DIMENSION =>
                if(end_calc = '1') then
                    next_state <= HALT;
                else
                    next_state <= S_INIT_SUM;
                end if;
            when S_INIT_SUM =>
                    if(end_calc_2 = '1') then
                   
                    next_state <= HALT;
                else
                next_state <= CALC_IMAGE_DIMENSION;
                end if;
            when CALC_IMAGE_DIMENSION => 
                if(stop_dim_calc = '0') then
                    next_state <= CALC_IMAGE_DIMENSION;
                else
                    next_state <= S_DEC_IMG_DIMESION;
                end if;

            when S_DEC_IMG_DIMESION  => 
                next_state   <= S_CONTROL_MAX_MIN;
            
            when S_CONTROL_MAX_MIN   => 
                next_state  <= S_CALC_ADDRESS;

            when S_CALC_ADDRESS =>
                next_state  <= LOAD_UNEQUALIZED_PIXEL_FOR_MAX_MIN;

            when LOAD_UNEQUALIZED_PIXEL_FOR_MAX_MIN  =>
                next_state <= CHECK_NEW_MAX_MIN;
            when CHECK_NEW_MAX_MIN =>
                if(stop_max_min = '1') then 
                    next_state  <= CALC_DELTA_VALUE;
                else
                    if(new_max = '1' or new_min = '1') then 
                        next_state <= REGISTER_NEW_MAX_MIN; -- aspetto per far si che new max siam correttamente salvato nei registri 
                    else
                        next_state <= S_DEC_IMG_DIMESION; -- leggo un nuovo valore su cui far ela comp
                    end if;
                end if;

            when REGISTER_NEW_MAX_MIN =>
                next_state  <= S_DEC_IMG_DIMESION;

            when CALC_DELTA_VALUE =>
                next_state <= CALC_LOG_VALUE;
            when CALC_LOG_VALUE =>
                next_state <= S_CALC_EQUALIZATION_ADDRESS;


            when S_CALC_EQUALIZATION_ADDRESS =>
                next_state <= S_GET_PIXEL;
            when S_GET_PIXEL => 
                next_state <= S_INIT_SHIFT;
            when S_CURRETPX_MIN =>
                next_state <= S_WAIT_SHIFT;
            when S_INIT_SHIFT =>
                next_state <= S_CURRETPX_MIN;
            when S_WAIT_SHIFT =>
                if(dec_shift = '1') then
                    next_state <= S_CHECK_255;
                else
                    next_state <= S_WAIT_SHIFT;
                end if;

            when S_CHECK_255 =>
                next_state <= S_WRITE_EQUALIZED_PIXEL;
                

            when S_WRITE_EQUALIZED_PIXEL =>
                if(equalization_dim_dec ='1') then
                    next_state <= HALT;
                else
                    next_state <= S_CALC_EQUALIZATION_ADDRESS;
                end if;
            when HALT  =>
                next_state <= S_INIT_MACHINE;
            when others =>
                null;

        end case;   
    end process;

    process(curr_state,read_address_out,write_address_out)
    begin
       compute_read_address  <= '0';
       reset_address_to_known_value <= '0';
       compute_write_address <= '0';
       o_address <= "0000000000000000";
       o_en  <= '0';
       o_we  <= '0';
       --
       decrement_mux_selector  <= '0';
       temporary_sum_load  <= '0';
       dec_load  <=  '0';
       reg_min_load  <=  '0';
       redo_dec_max_min  <= '0';
       dimension_calc_for_max_min  <= '0';
       reg_min_load  <= '0';
       reg_max_load  <= '0';
       delta_value_load  <= '0';
       log_calc_load  <= '0';
       do_dec_on_eq_img  <= '0';
       ready_shift  <= '0';
       check_255_bound  <= '0';
       start_dec_for_shift  <= '0';
       load_shift_value  <= '0';
       evlauete_equalized_pixel  <= '0';
       end_equalization  <= '0';
       summ_dimention_load  <= '0';
       machine_counter <= "00";
       
        o_done <= '0';
        reset_full_address <= '1';
        full_address <= '0';
        reset_half_address  <= '1';
        half_address  <= '0';
        write_to_memory_pixel  <= '0';

        case curr_state is
            when S_INIT_MACHINE =>
                machine_counter <= "00";

                summ_dimention_load <= '0';
                temporary_sum_load <= '0';
                decrement_mux_selector <= '0';
            
                dec_load <= '0';
                end_equalization <= '0';
                reset_address_to_known_value  <= '1';
                o_done <= '0';
                reset_full_address <= '0';
                reset_half_address  <= '0';
                o_en <= '1';

            when LOAD_ADDRESSES =>
                machine_counter <= "00";
                reset_address_to_known_value  <= '0';
                summ_dimention_load <= '0';
                temporary_sum_load <= '0';
                decrement_mux_selector <= '0';
                dec_load <= '0';
                o_en <= '1'; -- prepara lettura memoria
                o_address <= "0000000000000000"; -- primo byte di memoria  
                machine_counter <= "00";
                end_equalization <= '0';
            
            when LOAD_FIRST_DIMENSION =>
                machine_counter <= "00";
                o_address <= "0000000000000001"; -- primo byte di memoria  
                o_en <= '1';
                summ_dimention_load <= '1'; --iniz caricamento nel primo reg
                temporary_sum_load <= '0';
                dec_load <= '0';
            
                
            when S_INIT_SUM =>
                machine_counter <= "00";
                temporary_sum_load <= '1';

            when LOAD_SECOND_DIMENSION =>
                machine_counter <= "00";
                summ_dimention_load <= '0';
                temporary_sum_load <= '0';
                dec_load <= '1';
                decrement_mux_selector <= '0'; -- scrivo su memoria
                o_en <= '0';
                
            when CALC_IMAGE_DIMENSION =>
                machine_counter <= "00";
                summ_dimention_load <= '0';
                decrement_mux_selector<= '1';
                dec_load <= '1';
                o_en <= '0';
                temporary_sum_load <= '1';

            when S_DEC_IMG_DIMESION  => 
                redo_dec_max_min <= '1'; -- fa un colpo di decrementazione
                dimension_calc_for_max_min <= '1';
                machine_counter  <= "01";
                
            when S_CONTROL_MAX_MIN  => 
                machine_counter  <= "01";

            when S_CALC_ADDRESS =>
                compute_read_address  <= '1';
                machine_counter <= "01";
                reg_min_load <= '0';
                reg_max_load <= '0';
                dimension_calc_for_max_min <= '0';
                reset_full_address <= '1';
                full_address <= '0';

            when LOAD_UNEQUALIZED_PIXEL_FOR_MAX_MIN => 
                compute_read_address  <= '0';
                machine_counter <= "01"; -- fase calcolo massimo e minimo e anche la sottrazione
                o_en <= '1';
                o_address <= read_address_out;
                reg_max_load <= '0';
                reg_min_load <= '0';
                full_address <= '1';
                reset_full_address <= '1';

            when CHECK_NEW_MAX_MIN =>
                machine_counter <= "01";
                dimension_calc_for_max_min <= '0';
                reg_min_load <= '1';
                reg_max_load <= '1';
                o_en <= '0';
            when REGISTER_NEW_MAX_MIN =>
                machine_counter <= "01"; 
                compute_read_address  <= '0';
                reg_min_load <= '1';
                reg_max_load <= '1';
                o_en <= '0';

            when CALC_DELTA_VALUE =>
                machine_counter <= "10";
                delta_value_load <= '1';
                log_calc_load <= '0';
                
            when CALC_LOG_VALUE =>
                machine_counter <= "10";    
                delta_value_load <= '0';
                log_calc_load <= '1';

            when S_CALC_EQUALIZATION_ADDRESS =>
                machine_counter <= "11";
                o_en <= '0';
                o_we <= '0';
                compute_read_address <= '1';
                compute_write_address  <= '1';
                half_address  <= '0';
                full_address  <= '0';
                check_255_bound <= '0';
                do_dec_on_eq_img <= '0';
                load_shift_value  <= '0';
                ready_shift <= '0';
                
            when S_GET_PIXEL =>
                machine_counter <= "11";
                compute_write_address  <= '0'; 
                compute_read_address <= '0';
                o_en <= '1';
                o_address <= write_address_out;
                do_dec_on_eq_img <= '0';
                load_shift_value  <= '0';
                ready_shift <= '0';
                half_address  <= '1';
                full_address  <= '1';
                
            when S_CURRETPX_MIN =>
                machine_counter <= "11";
                evlauete_equalized_pixel <= '1';

            when S_INIT_SHIFT =>
                machine_counter <= "11";
                load_shift_value <= '1';
                o_en <= '0';
                
            when S_WAIT_SHIFT =>
                machine_counter <= "11";
                evlauete_equalized_pixel <= '0';
                ready_shift <= '1';
                load_shift_value <= '0';
                o_en <= '0';
                start_dec_for_shift <= '1';
            
            when S_CHECK_255 =>
                machine_counter <= "11";
                ready_shift <= '0';
                load_shift_value <= '0';
                start_dec_for_shift <= '0';
                check_255_bound <= '1';
                do_dec_on_eq_img <= '1';
                
            when S_WRITE_EQUALIZED_PIXEL =>
                write_to_memory_pixel  <= '1';
                machine_counter <= "11";
                o_en <= '1';
                o_we <= '1';
                o_address <= read_address_out;
                do_dec_on_eq_img <= '0';
                check_255_bound <= '1';
                
            when HALT  =>
                machine_counter <= "11";
                end_equalization <= '1';
                o_done <= '1';
             
            when others =>
                null;

        end case;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    port(
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_data : out std_logic_vector (7 downto 0);
        i_start : in std_logic;
        summ_dimention_load : in std_logic;
        temporary_sum_load : in std_logic;
        decrement_mux_selector: in std_logic;
        dec_load : in std_logic;
        stop_max_min : out std_logic;
        stop_dim_calc : out std_logic;
        machine_counter : in std_logic_vector(1 downto 0);
        
        reg_max_load : in std_logic;
        reg_min_load : in std_logic;
        redo_dec_max_min : in std_logic;
        new_max : out std_logic;
        new_min : out std_logic;
        dimension_calc_for_max_min : in std_logic;

        delta_value_load : in std_logic;
        log_calc_load : in std_logic;

        equalization_dim_dec : out std_logic;
        do_dec_on_eq_img : in std_logic;

        dec_shift : out std_logic;
        ready_shift : in std_logic;
        check_255_bound : in std_logic;
        start_dec_for_shift : in std_logic;
        load_shift_value : in std_logic;
        evlauete_equalized_pixel : in  std_logic;
        end_equalization : in std_logic;
        end_calc : out std_logic ;
        end_calc_2 : out std_logic;
        write_to_memory_pixel : in std_logic

    );
end datapath;

-- fare ass di tipo vc <= vc + va solo se vc e va sono fuori dalla sensitivity list
    architecture Behavioral of datapath is 
    signal sdm_reg : std_logic_vector(7 downto 0) := "00000000"; -- registro che contiene il primo operando (byte ) letto dalla memoria (dim immagine)
    signal dec_reg :  std_logic_vector(7 downto 0) := "11111111"; -- registro che contiene il secondo operando (byte) letto dalla memorie (dim immagine)
    signal temp_sum : std_logic_vector(15 downto 0) := "0000000000000000"; -- registro temporaneo somma
    signal temporary_stop_dim_calc : std_logic := '0'; -- vale 1 quando ci si finisce di calcolare il prodotto delle dimensioni dell'immagine
    signal temp_max_reg : std_logic_vector(7 downto 0 ) := "00000000"; -- reg per il massimo
    signal temp_min_reg : std_logic_vector(7 downto 0 ) := "11111111"; --reg per il minimo
    signal delta_value: std_logic_vector(8 downto 0) := "000000000"; -- 9 bit per cosiderare 255+1; di deltavalue
    signal log : std_logic_vector(3 downto 0) := "0000"; -- 4 bit per poter gestire il caso di 8 - log(1), logaritmo
    signal eq_dim_immagine : std_logic_vector(15 downto 0) := "0000000000000000"; -- registro per il calcolo della dimensione quando scrivi i byte equalizzati
    signal eq_dim_stop : std_logic := '0'; -- segnle che si ferma la scrittura dei pixel equalizzati , quando eq_dim_immagine = 0
    signal shift : std_logic_vector(3 downto 0) := "0000"; -- shift
    signal shifted_pixel : std_logic_vector(14 downto 0) := "000000000000000"; -- valore temporaneo che viene shiftato
    signal temp_get_dim_dec_shift : std_logic  := '0'; -- loader per il registro di shift
    signal end_calc_temp : std_logic := '0'; -- se la prima dimensione è zero arresta la macchina
    signal end_calc_temp_2 : std_logic := '0'; -- se la seconda dimensione è zero, arresta la macchina
    signal o_data_temp : std_logic_vector(7 downto 0) := "00000000"; -- registro temporaneo per scrivere sulla memoria ram

begin
 --somma

    process(summ_dimention_load,temporary_sum_load,i_clk,i_data,i_rst,machine_counter,temporary_stop_dim_calc,eq_dim_stop,do_dec_on_eq_img)
    begin
        if(i_rst = '1') then 
            sdm_reg <= "00000000";   
            temp_sum <= "0000000000000000";
            sdm_reg <= "00000000";
            eq_dim_immagine <= "0000000000000000";
            end_calc_temp <= '0';

        elsif (rising_edge(i_clk)) then 
            case(machine_counter) is
                when "00" =>
                    if(temporary_stop_dim_calc = '0') then
                        if(summ_dimention_load = '1' and temporary_sum_load = '0') then
                            sdm_reg <= i_data;
                            if(i_data = "00000000") then
                                end_calc_temp <= '1'; --in macchina a stati aggiungere
                            end if;
                        elsif(temporary_sum_load = '1' and summ_dimention_load = '0') then
                            temp_sum <= temp_sum + sdm_reg;--sdm_reg; 
                            eq_dim_immagine <= eq_dim_immagine + sdm_reg;   
                        end if;
                    end if;
                when "01" =>
                        if (temp_sum > "0000000000000000" and dimension_calc_for_max_min = '1') then
                            temp_sum <= temp_sum - "0000000000000001";
                        end if;
                when "10" => 
                    null;
                when "11" => 
                        end_calc_temp <= '0';
                        if(eq_dim_stop = '0' and do_dec_on_eq_img = '1') then -- eq_dim_stop segnale che fa diminuire di 1 la dimensione della eq_dim-immagine pilotata dalla fsm
                            eq_dim_immagine <= eq_dim_immagine - "0000000000000001";
                        end if;
                when others => null;
                    
            end case;
        end if;
    end process;

    eq_dim_stop <= '1' when eq_dim_immagine =  "0000000000000000" else '0';
    equalization_dim_dec <= '1' when eq_dim_immagine = "0000000000000000" else '0';
    end_calc <= '1' when end_calc_temp = '1' else '0';

-- sottrazione

    process(decrement_mux_selector,i_clk,i_data,dec_load,temporary_stop_dim_calc,machine_counter,i_rst) 
    begin
        if(i_rst = '1') then
            dec_reg <= "11111111";
            end_calc_temp_2 <= '0';
        elsif (rising_edge(i_clk)) then
            case (machine_counter) is
                when "00" =>
                    if(temporary_stop_dim_calc = '0') then
                        if(decrement_mux_selector = '0' and dec_load = '1') then
                            if(i_data = "00000000") then
                                 end_calc_temp_2 <= '1';
                             end if;
                            dec_reg <= i_data;
                        end if;
                        if(decrement_mux_selector = '1' and dec_load = '1') then
                            dec_reg <= dec_reg - "00000001";
                        end if;
                    end if;
                when "11" =>
                    end_calc_temp_2 <= '0';
                when others =>
                    null;
            end case;
        end if;
        
    end process;
   
    
    temporary_stop_dim_calc <= '1' when dec_reg = "00000001" else '0'; -- segnale di gestione della macchian che può sia scrivere che leggere 
    stop_dim_calc <= '1' when dec_reg = "00000001" else '0'; 
    end_calc_2 <= '1' when end_calc_temp_2 = '1' else '0';
    

    --scrittura in memoria
    with write_to_memory_pixel select
        o_data  <=  o_data_temp when '1',
        "00000000" when '0',"XXXXXXXX" when others;

    process(i_rst,i_clk,reg_max_load,reg_min_load,machine_counter,temp_max_reg,i_data,temp_min_reg,ready_shift,check_255_bound,evlauete_equalized_pixel)
    begin
        if(i_rst = '1') then
            temp_max_reg <= "00000000";
            temp_min_reg <= "11111111";
            delta_value <= "000000000";
            shift <= "0000";
        end if;
            if(rising_edge(i_clk)) then
            case machine_counter is
            when "01" => 
                if(reg_min_load = '1' and reg_max_load = '1') then
                    if(temp_max_reg < i_data) then
                        temp_max_reg <= i_data;
                        new_max <= '1'; 
                    else
                        new_max <= '0';
                    end if;

                    if(temp_min_reg > i_data) then
                        temp_min_reg <= i_data;
                        new_min <= '1';
                    else
                        new_min <= '0';
                    end if;
                end if;
            when "10" => -- calcoliamo il log
                if(delta_value_load = '1') then
                    delta_value <= temp_max_reg - temp_min_reg + "000000001";
                end if;
                if(log_calc_load = '1') then
                    if(delta_value < "000000001") then log <= "0000"; 
                    elsif(delta_value < "000000010") then log <= "0000";
                    elsif(delta_value < "000000100") then log <= "0001";
                    elsif(delta_value < "000001000") then log <= "0010";
                    elsif(delta_value < "000010000") then log <= "0011";
                    elsif(delta_value < "000100000") then log <= "0100";
                    elsif(delta_value < "001000000") then log <= "0101";
                    elsif(delta_value < "010000000") then log <= "0110";
                    elsif(delta_value < "100000000") then log <= "0111";
                    else log <= "1000";
                    end if;
                end if;

            when "11" =>
                --
                if(temp_get_dim_dec_shift = '1') then
                    shift <= "1000"- log ; -- reimposta i registri
                end if;

                if (load_shift_value = '1') then -- allora facciamo lo shift di una volta sola
                    shifted_pixel <= "0000000" & i_data;
                elsif(load_shift_value = '0' and ready_shift = '1' and temp_get_dim_dec_shift = '0') then -- shiftiamo
                    shifted_pixel <= shifted_pixel(13 downto 0) & '0';
                end if;


                if(check_255_bound = '1') then -- se vale 0 il dato è disponibile per essere manipolati e letto
                    if(shifted_pixel >= "000000011111111") then
                        o_data_temp  <= "11111111";
                    else
                        o_data_temp  <= shifted_pixel(7 downto 0);  
                    end if;
                end if;   
                      
                if(start_dec_for_shift = '1' and shift > "0000") then
                    shift <= shift - "0001";   
                end if;
                if(evlauete_equalized_pixel = '1' and shifted_pixel > "000000000000000") then
                    shifted_pixel <= shifted_pixel - ("0000000" & temp_min_reg);
                end if;
            when others => null;
        end case;
          
        end if;
    end process;

    stop_max_min <= '1' when temp_sum = "000000000000000" else '0';
    dec_shift <= '1' when shift = "0000" else '0';
    temp_get_dim_dec_shift <= '1' when shift = "0000" else '0';

end Behavioral;