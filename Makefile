#LHAPDF
LHAPDFINCS = -I$(shell lhapdf-config --prefix)/include
LHAPDFDIR  = $(shell lhapdf-config --prefix)/lib
LHAPDFLIBS = -L$(LHAPDFDIR) -lLHAPDF

# additional libraries to be included
LDFLAGS = $(LHAPDFLIBS) -lceres -lglog -lyaml-cpp
INCLUDES += -I/Cellar/yaml-cpp/0.6.2/include/  -I$(PWD)/inc -I/usr/local/include/eigen3

CXX = clang++ 

TARGET ?= main
SRC_DIRS ?= ./src

SRCS := $(shell find $(SRC_DIRS) -name '*.cc') $(TARGET).cc
OBJS := $(addsuffix .o,$(basename $(SRCS)))
DEPS := $(OBJS:.o=.d)

INC_FLAGS := $(INCLUDES)

CXXFLAGS ?= $(LHAPDFINCS) -Wall -O3 -std=c++11 $(INC_FLAGS) -MMD -MP

$(TARGET): $(OBJS)
	$(CXX) $(LDFLAGS) $(OBJS) -o $@ $(LOADLIBES) $(LDLIBS)

.PHONY: clean
clean:
	$(RM) $(TARGET) $(OBJS) $(DEPS)

-include $(DEPS)