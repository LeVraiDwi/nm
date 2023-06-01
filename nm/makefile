SRCS = $(addprefix $(SRC_PATH)/,$(SRC_NAME))

UNAME_S = $(shell uname -s)

SRC_PATH = ./src

SRC_NAME =	ft_nm.c bit_read.c file.c\
			map_struct.c arg.c elf.c\
			elf_data_struct.c utils.c\
			sort_symbole.c check.c\

LIBFT = ./lib/libft/libft.a

PRINTF = ./lib/ft_printf/libftprintf.a

OBJS = $(SRCS:.c=.o)

NAME = nm

FLAGS = -Wall -Wextra -Werror

HEADER = -I "./include" -I "./lib/libft" -I "./lib/ft_printf"

CC = clang

RM = rm -f

CD = cd

.c.o:
		$(CC) ${FLAGS} ${HEADER} -c $< -o $@

${NAME}:	${OBJS}
			cd lib/libft; $(MAKE);
			cd lib/ft_printf; $(MAKE);
			${CC} -o ${NAME} ${OBJS} ${FLAGS} ${LIBFT} $(PRINTF)

all: ${NAME}

clean:
		cd lib/libft; make clean;
		cd lib/ft_printf; make clean;
		${RM} ${OBJS}

fclean:		clean
			cd lib/libft; make fclean;
			cd lib/ft_printf; make fclean;
			${RM} ${NAME}

re:	fclean all;

.PHONY =	all clean fclean re