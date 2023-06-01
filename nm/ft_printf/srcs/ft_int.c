/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_int.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/07 08:20:51 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/08 15:48:30 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_add_int(va_list lst_arg, t_list *alst)
{
	int	i;

	i = va_arg(lst_arg, int);
	alst->flag += FLAG_D;
	alst->content = ft_free(alst->content);
	if (i == 0 && alst->flag & FLAG_PR && alst->precision == 0)
	{
		if (!(alst->content = ft_strdup("")))
			return (0);
		return (1);
	}
	if (!(alst->content = ft_itoa(i)))
		return (0);
	return (1);
}

int	ft_add_u_int(va_list lst_arg, t_list *alst)
{
	unsigned int	i;

	i = va_arg(lst_arg, unsigned int);
	alst->flag += FLAG_D;
	alst->content = ft_free(alst->content);
	if (i == 0 && alst->flag & FLAG_PR && alst->precision == 0)
	{
		if (!(alst->content = ft_strdup("")))
			return (0);
		return (1);
	}
	if (!(alst->content = ft_u_itoa(i)))
		return (0);
	return (1);
}
