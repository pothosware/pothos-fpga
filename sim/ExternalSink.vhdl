------------------------------------------------------------------------
-- External input implementation
-- Read stream data from an input bus.
--
-- Copyright (c) 2014-2015 Josh Blum
-- SPDX-License-Identifier: BSL-1.0
------------------------------------------------------------------------

library PothosSimulation;
use PothosSimulation.ExternalFunctionsPkg.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ExternalSink is
    generic(
        -- the external interface port identification number
        PORT_NUMBER : natural
    );
    port(
        clk : in std_logic;
        rst : in std_logic;

        -- input bus
        in_data : in std_logic_vector;
        in_meta : in std_logic := '0';
        in_last : in std_logic := '1';
        in_valid : in std_logic;
        in_ready : out std_logic
    );
end entity ExternalSink;

architecture sim of ExternalSink is begin

    process (clk)
        variable handle : integer := setupSink(PORT_NUMBER);
        variable thisReady : boolean := false;
    begin

        if (falling_edge(clk)) then
            thisReady := sinkHasSpace(handle);
            if (thisReady) then
                in_ready <= '1';
            else
                in_ready <= '0';
            end if;
        end if;

        if (rising_edge(clk)) then
            if (rst = '1') then
                in_ready <= '0';
            elsif (in_valid = '1' and thisReady) then
                sinkPushData(handle, to_integer(signed(in_data)), in_meta = '1', in_last = '1');
            end if;
        end if;

    end process;

end architecture sim;
