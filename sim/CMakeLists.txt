########################################################################
## Create VHDL interface with simulation server interface
########################################################################
include_directories(${Pothos_INCLUDE_DIRS})

add_library(PothosFPGAHarness SHARED
    SimulationHarness.cpp
    SimulationServer.cpp
)
target_link_libraries(PothosFPGAHarness ${Pothos_LIBRARIES})

install(TARGETS PothosFPGAHarness
    LIBRARY DESTINATION lib${LIB_SUFFIX} # .so file
    ARCHIVE DESTINATION lib${LIB_SUFFIX} # .lib file
    RUNTIME DESTINATION bin              # .dll file
)

########################################################################
## Create VHDL library for external simulation interface
########################################################################
GHDL_ELABORATE(
    TARGET PothosSimulation
    LIBRARY PothosSimulation
    SOURCES
        ExternalFunctionsPkg.vhdl
        ExternalSource.vhdl
        ExternalSink.vhdl
        ExternalControl.vhdl
    ANALYZE_ONLY
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
)

########################################################################
## loopback testbench
########################################################################
GHDL_ELABORATE(
    TARGET LoopbackTb
    LIBRARY LoopbackTb
    SOURCES LoopbackTb.vhdl
    DEPENDS PothosSimulation
    LIBRARIES PothosFPGAHarness
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    IEEE synopsys
)

GHDL_INSTALL(
    TARGET LoopbackTb
    DESTINATION lib${LIB_SUFFIX}/Pothos/fpga/test
)

########################################################################
## fifo testbench
########################################################################
GHDL_ELABORATE(
    TARGET FifoTb
    LIBRARY FifoTb
    SOURCES FifoTb.vhdl
    DEPENDS
        PothosInterconnect
        PothosSimulation
    LIBRARIES PothosFPGAHarness
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    IEEE synopsys
)

GHDL_INSTALL(
    TARGET FifoTb
    DESTINATION lib${LIB_SUFFIX}/Pothos/fpga/test
)

########################################################################
## combiner testbench
########################################################################
GHDL_ELABORATE(
    TARGET CombinerTb
    LIBRARY CombinerTb
    SOURCES CombinerTb.vhdl
    DEPENDS
        PothosInterconnect
        PothosSimulation
    LIBRARIES PothosFPGAHarness
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    IEEE synopsys
)

GHDL_INSTALL(
    TARGET CombinerTb
    DESTINATION lib${LIB_SUFFIX}/Pothos/fpga/test
)

########################################################################
## splitter testbench
########################################################################
GHDL_ELABORATE(
    TARGET SplitterTb
    LIBRARY SplitterTb
    SOURCES SplitterTb.vhdl
    DEPENDS
        PothosInterconnect
        PothosSimulation
    LIBRARIES PothosFPGAHarness
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    IEEE synopsys
)

GHDL_INSTALL(
    TARGET SplitterTb
    DESTINATION lib${LIB_SUFFIX}/Pothos/fpga/test
)

########################################################################
## interconnect testbench
########################################################################
GHDL_ELABORATE(
    TARGET InterconnectTb
    LIBRARY InterconnectTb
    SOURCES InterconnectTb.vhdl
    DEPENDS
        PothosInterconnect
        PothosSimulation
    LIBRARIES PothosFPGAHarness
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    IEEE synopsys
)

GHDL_INSTALL(
    TARGET InterconnectTb
    DESTINATION lib${LIB_SUFFIX}/Pothos/fpga/test
)

########################################################################
## build and install unit tests
########################################################################
POTHOS_MODULE_UTIL(
    TARGET SimulationUnitTests
    SOURCES
        SimulationClient.cpp
        LoopbackTests.cpp
        FifoTests.cpp
        CombinerTests.cpp
        SplitterTests.cpp
        InterconnectTests.cpp
    DESTINATION fpga
)
