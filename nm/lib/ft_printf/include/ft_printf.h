/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/07 08:20:55 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 17:29:26 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FT_PRINTF_H
# define FT_PRINTF_H
# include <unistd.h>
# include <stdlib.h>
# include <stdarg.h>
# include <stdio.h>
# include "libft.h"
# define SPECIFIER "cspdiuxX%"
# define STR_NULL "(null)"
# define FLAG_PR 1
# define FLAG_Z 2
# define FLAG_M 4
# define FLAG_S 8
# define FLAG_D 16
# define FLAG_P 32
# define FLAG_C 64
# define FLAG_X 128

int		ft_format(t_list *alst);
int		ft_error(char **a);
int		ft_errorclean(t_list **alst, va_list lst_arg);
int		ft_margin(va_list lst_arg, t_list *alst, int i);
int		ft_precision(va_list lst_arg, t_list *alst, int i);
int		ft_printf(const char *format, ...);
int		ft_is_flag(char *format);
int		ft_add_lst(va_list lst_arg, char **format, t_list **alst, int i);
int		ft_split_args(va_list lst_arg, const char *format, t_list **alst);
int		ft_determine_specifier(va_list lst_arg, char spe, t_list *alst);
int		ft_determine_specifier_(va_list lst_arg, char spe, t_list *alst);
int		ft_addstr(t_list *alst, int start, char *add);
int		ft_insertstr(t_list *alst, int start, char *add);
int		ft_flag(va_list lst_arg, t_list *alst);
int		ft_if_precision(t_list *alst, int i);
int		ft_is_number(va_list lst_arg, t_list *alst, int i);
int		ft_add_int(va_list lst_arg, t_list *alst);
int		ft_add_u_int(va_list lst_arg, t_list *alst);
int		ft_add_str(va_list lst_arg, t_list *alst);
int		ft_add_char(va_list lst_arg, t_list *alst);
int		ft_add_hexa(va_list lst_arg, t_list *alst, int upper);
int		ft_add_per(t_list *alst);
int		ft_add_pointer(va_list lst_arg, t_list *alst);
int		ft_addback(t_list *alst, int margin, int l, char c);
int		ft_addfront(t_list *alst, int n, int l, char c);
int		ft_zero_space(t_list *alst);
int		ft_pr_zero(t_list *alst);
int		ft_pr_num(t_list *alst, int pr, int l);
int		ft_pr_string(t_list *alst, int pr);
int		ft_pr_pointer(t_list *alst, int pr);
int		ft_format_precision(t_list *alst);
int		ft_display(t_list *alst, int fd);
int		ft_null(t_list *alst);
int		ft_format_margin(t_list *alst);
int		ft_creat_lst(const char *format, va_list lst_arg, t_list **alst);
char	ft_is_specifier(char c);
void	ft_del(void *content);
#endif
