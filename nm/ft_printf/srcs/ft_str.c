/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_str.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/07 09:03:57 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 16:04:39 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_add_str(va_list lst_arg, t_list *alst)
{
	char	*str;

	str = va_arg(lst_arg, char *);
	alst->flag += 8;
	if (!str)
	{
		if (!(ft_null(alst)))
			return (0);
		return (1);
	}
	alst->content = ft_free(alst->content);
	if (!(alst->content = ft_strdup(str)))
		return (0);
	return (1);
}

int	ft_add_char(va_list lst_arg, t_list *alst)
{
	char *str;

	alst->flag += 64;
	if (!(str = (char *)malloc(sizeof(char) * 2)))
		return (0);
	*str = va_arg(lst_arg, int);
	if (*str == 0)
		alst->precision = -1;
	str[1] = 0;
	alst->content = ft_free(alst->content);
	alst->content = str;
	return (1);
}

int	ft_null(t_list *alst)
{
	char	*str;

	if (!(str = ft_strdup(STR_NULL)))
		return (0);
	free(alst->content);
	alst->content = str;
	return (1);
}
