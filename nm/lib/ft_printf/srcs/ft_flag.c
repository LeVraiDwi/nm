/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_flag.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/09/14 15:59:40 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 16:30:34 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_determine_specifier(va_list lst_arg, char spe, t_list *alst)
{
	if (spe == 'd' || spe == 'i')
	{
		if (!(ft_add_int(lst_arg, alst)))
			return (0);
	}
	else if (spe == 'c')
	{
		if (!(ft_add_char(lst_arg, alst)))
			return (0);
	}
	else if (spe == 'x')
	{
		if (!(ft_add_hexa(lst_arg, alst, 0)))
			return (0);
	}
	else if (spe == 'p')
	{
		if (!(ft_add_pointer(lst_arg, alst)))
			return (0);
	}
	else
	{
		return (ft_determine_specifier_(lst_arg, spe, alst));
	}
	return (1);
}

int	ft_determine_specifier_(va_list lst_arg, char spe, t_list *alst)
{
	if (spe == 's')
	{
		if (!(ft_add_str(lst_arg, alst)))
			return (0);
	}
	else if (spe == 'X')
	{
		if (!(ft_add_hexa(lst_arg, alst, 1)))
			return (0);
	}
	else if (spe == 'u')
	{
		if (!(ft_add_u_int(lst_arg, alst)))
			return (0);
	}
	else if (spe == '%')
	{
		if (!(ft_add_per(alst)))
			return (0);
	}
	else
		alst->flag = 0;
	return (1);
}

int	ft_endofflag(va_list lst_arg, t_list *alst, char c)
{
	if (ft_is_specifier(c))
		return (ft_determine_specifier(lst_arg, c, alst));
	else
	{
		alst->content = ft_free(alst->content);
		if (!(alst->content = ft_strdup("")))
			return (0);
		return (1);
	}
}

int	ft_flag(va_list lst_arg, t_list *alst)
{
	int		i;
	char	*str;

	i = 1;
	str = alst->content;
	while (str[i])
	{
		if (ft_isalpha(str[i]) || str[i] == '%')
			return (ft_endofflag(lst_arg, alst, str[i]));
		if (str[i] == '0')
		{
			if (!(alst->flag & FLAG_Z))
				alst->flag += FLAG_Z;
			i++;
		}
		else if (ft_isdigit(str[i]) || str[i] == '*')
			i = ft_margin(lst_arg, alst, i);
		else if (str[i] == '-' && !(alst->flag & FLAG_M))
			alst->flag += FLAG_M;
		else if (str[i] == '.')
			i = ft_precision(lst_arg, alst, i);
		else
			i++;
	}
	return (1);
}
