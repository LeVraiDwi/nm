SRCS = $(addprefix $(SRC_PATH)/,$(SRC_NAME))

UNAME_S = $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	CFLAGS := -Wall -Wextra -Werror -fPIE
else
	CFLAGS := -Wall -Wextra -Werror
endif

SRC_PATH = ./srcs

LIBFT_PATH = ./libft

SRC_NAME =	ft_display.c ft_is_specifier.c ft_lst.c \
			ft_flag.c ft_lst.c ft_del.c \
			ft_utils.c ft_new.c ft_int.c \
			ft_str.c ft_hexa.c ft_int.c \
			ft_per.c ft_printf.c ft_precision.c \
			ft_margin.c\

OBJS = ${SRCS:.c=.o}

OBJS_LIBFT =	ft_memset.o ft_bzero.o ft_memcpy.o \
			ft_memccpy.o ft_memmove.o ft_memchr.o \
			ft_memcmp.o ft_strlen.o ft_isalpha.o \
			ft_isdigit.o ft_isalnum.o ft_isascii.o \
			ft_isprint.o ft_toupper.o ft_tolower.o \
			ft_strchr.o ft_strrchr.o ft_strncmp.o \
			ft_strlcpy.o ft_strlcat.o ft_strnstr.o \
			ft_atoi.o ft_calloc.o ft_strdup.o \
			ft_substr.o ft_strjoin.o ft_strtrim.o \
			ft_split.o ft_itoa.o ft_strmapi.o\
			ft_putchar_fd.o ft_putstr_fd.o ft_putendl_fd.o \
			ft_putnbr_fd.o ft_u_itoa.o ft_lstmap.o \
			ft_lstnew.o ft_lstadd_front.o ft_lstsize.o \
			ft_lstlast.o ft_lstadd_back.o ft_lstdelone.o \
			ft_lstclear.o ft_lstiter.o ft_int_hexa.o \
			ft_pointer_hexa.o ft_free.o \

LIBFT = $(addprefix $(LIBFT_PATH)/,$(OBJS_LIBFT))

NAME = libftprintf.a

HEADER = -I "./include"

CC = clang

RM = rm -f

.c.o: 
			${CC} ${CFLAGS} ${HEADER} -c $< -o $@

${NAME}:	${OBJS}
			cd ./libft && $(MAKE)
			ar rc ${NAME} ${OBJS} ${LIBFT}

all:		${NAME}

clean:
			${RM} ${OBJS} ${LIBFT}

fclean:		clean
			${RM} ${NAME}

re:			fclean all

.PHONY =	all clean fclean re
