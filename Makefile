#*******************************  VARIABLES  **********************************#

NAME			=	libasm.a
TEST_NAME		=	tests_bin

# --------------- FILES --------------- #

LIST_ASM_SRC		=	\
						ft_read.s				\
						ft_strlen.s     \
						ft_strcmp.s     \
						ft_strcpy.s     \
						ft_strdup.s     \
						ft_write.s      \

LIST_TEST_SRC		=	\
						ft_read.c				\
						main.c					\
						ft_strlen.c     \
						ft_strcmp.c     \
						ft_strcpy.c     \
						ft_strdup.c     \
						ft_write.c      \

# ------------ DIRECTORIES ------------ #

DIR_BUILD		=	.build/
DIR_SRC 		=	src/
DIR_INCLUDE		=	inc/
DIR_TEST		=	test/
DIR_LIB			=	lib/
DIR_UTEST		=	$(DIR_LIB)utest/

# ------------- SHORTCUTS ------------- #

OBJ				=	$(patsubst %.s, $(DIR_BUILD)%.o, $(SRC))
DEP				=	$(patsubst %.s, $(DIR_BUILD)%.d, $(SRC))
SRC				=	$(addprefix $(DIR_SRC), $(LIST_ASM_SRC))
TEST_SRC		=	$(addprefix $(DIR_TEST), $(LIST_TEST_SRC))
TEST_DEP		=	$(patsubst %.c, $(DIR_BUILD)%.d, $(TEST_SRC))
TEST_OBJ		=	$(patsubst %.c, $(DIR_BUILD)%.o, $(TEST_SRC))
UTEST_INCLUDE	=	$(DIR_UTEST)

# ------------ TOOLS / EXTRAS ------------
CC              ?= cc

# ---- Bear / compile_commands.json ----
BEAR            ?= bear
CDB_OUT         ?= compile_commands.json


# ------------ COMPILATION ------------ #

AS				=	nasm
ASFLAGS			=	-f elf64 -I $(DIR_SRC)

CFLAGS			=	-Wall -Wextra -Werror

DEP_FLAGS		=	-MMD -MP

ARFLAGS			=	rcs

# -------------  COMMANDS ------------- #

RM				=	rm -rf
MKDIR			=	mkdir -p

#***********************************  RULES  **********************************#


.PHONY: all
all:			$(NAME)

.PHONY: tests
tests: $(TEST_NAME)
				valgrind ./$(TEST_NAME)

$(TEST_NAME):	$(TEST_OBJ) $(NAME)
				$(CC) $(CFLAGS) $(TEST_OBJ) -L. -l:$(NAME) -o $(TEST_NAME)

# ---------- VARIABLES RULES ---------- #

$(NAME):		$(OBJ)
				$(AR) $(ARFLAGS) $(NAME) $(OBJ)

# ---------- COMPILED RULES ----------- #

-include $(DEP)
$(DIR_BUILD)%.o: %.s
				mkdir -p $(shell dirname $@)
				$(AS) $(ASFLAGS) -MD $(@:.o=.d) $< -o $@

-include $(TEST_DEP)
$(DIR_BUILD)%.o: %.c
				mkdir -p $(shell dirname $@)
				$(CC) $(CFLAGS) $(DEP_FLAGS) -c $< -o $@ -I $(DIR_INCLUDE) -I $(UTEST_INCLUDE)

.PHONY: clean
clean:
				$(RM) $(DIR_BUILD)

.PHONY: fclean
fclean: clean
				$(RM) $(NAME)
				$(RM) $(TEST_NAME)

.PHONY: re
re:				fclean
				$(MAKE) all

.PHONY: check-format
check-format:
				clang-format -style=file $(TEST_SRC) -n --Werror

.PHONY: format
format:
				clang-format -style=file $(TEST_SRC) -i

.PHONY: compdb 
compdb: clean
	@# Ensure Bear is installed 
	@if ! command -v bear &> /dev/null; then \
		echo "Bear is not installed. Please install it to generate compile_commands.json"; \
		exit 1; \
	fi 
	@$(RM) $(CDB_OUT)
	@echo "Generating $(CDB_OUT) using Bear.."
	@$(BEAR") --output $(CDB_OUT) -- $(MAKE) $(TEST_NAME) ||  \
	 ($(BEAR) --output $(CDB_OUT)  $(MAKE) $(TEST_NAME))
	@echo "Done -> $(CDB_OUT)"

.PHONY: compdb-quick
# Quicker (doesn't clean first). Forces rebuild with -B so Bear sees compiles.
compdb-quick:
	@if ! command -v $(BEAR) >/dev/null 2>&1; then \
		echo "Error: '$(BEAR)' not found. Install: https://github.com/rizsotto/Bear"; \
		exit 1; \
	fi
	@$(RM) $(CDB_OUT)
	@echo "Generating $(CDB_OUT) with Bear (quick)..."
	@($(BEAR) --output $(CDB_OUT) -- $(MAKE) -B $(TEST_NAME)) || \
	 ($(BEAR) --output $(CDB_OUT)  $(MAKE) -B $(TEST_NAME))
	@echo "Done -> $(CDB_OUT)"

.PHONY: cdb-clean
# Remove compile_commands.json only
cdb-clean:
	$(RM) $(CDB_OUT)
