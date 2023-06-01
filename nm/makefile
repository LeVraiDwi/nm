SRCS = $(addprefix $(SRC_PATH)/,$(SRC_NAME))

UNAME_S = $(shell uname -s)

SRC_PATH = ./src

SRC_NAME =	ft_nm.c bit_read.c file.c\
			map_struct.c arg.c elf.c\
			elf_data_struct.c utils.c\
			sort_symbole.c check.c\

LIBFT = ./libft/libft.a

PRINTF = ./ft_printf/libftprintf.a

OBJS = $(SRCS:.c=.o)

NAME = nm

FLAGS = -Wall -Wextra -Werror

HEADER = -I "./include" -I "./libft" -I "./ft_printf"

CC = clang

RM = rm -f

CD = cd

.c.o:
		$(CC) ${FLAGS} ${HEADER} -c $< -o $@

${NAME}:	${OBJS}
			cd libft; $(MAKE);
			cd ft_printf; $(MAKE);
			${CC} -o ${NAME} ${OBJS} ${FLAGS} ${LIBFT} $(PRINTF)

all: ${NAME}

clean:
		cd libft; make clean;
		cd ft_printf; make clean;
		${RM} ${OBJS}

fclean:		clean
			cd libft; make fclean;
			cd ft_printf; make fclean;
			${RM} ${NAME}

re:	fclean all;

.PHONY =	all clean fclean re