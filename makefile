SRCS = $(addprefix $(SRC_PATH)/,$(SRC_NAME))

UNAME_S = $(shell uname -s)

SRC_PATH = ./src

SRC_NAME =	ft_nm.c bit_read.c file.c\
			map_struct.c arg.c\

LIBFT = ./libft/libft.a

OBJS = $(SRCS:.c=.o)

NAME = nm

FLAGS = -Wall -Wextra -Werror

HEADER = -I "./include" -I "./libft"

CC = gcc

RM = rm -f

CD = cd

.c.o:
		$(CC) ${FLAGS} ${HEADER} -c $< -o $@

${NAME}:	${OBJS}
			cd libft; make;
			${CC} -o ${NAME} ${OBJS} ${FLAGS} ${LIBFT}

all: ${NAME}

clean:
		${RM} ${OBJS}

fclean:		clean
			${RM} ${NAME}

re:	fclean all;

.PHONY =	all clean fclean re