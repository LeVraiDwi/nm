/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_hexa.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/31 17:03:24 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/08 12:33:45 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_add_hexa(va_list lst_arg, t_list *alst, int upper)
{
	unsigned int	i;

	i = va_arg(lst_arg, unsigned int);
	alst->flag += FLAG_D;
	alst->flag += FLAG_X;
	alst->content = ft_free(alst->content);
	if (i == 0 && alst->flag & FLAG_PR && alst->precision == 0)
	{
		if (!(alst->content = ft_strdup("")))
			return (0);
		return (1);
	}
	if (!(alst->content = ft_int_hexa(i, upper)))
		return (0);
	return (1);
}

int	ft_add_pointer(va_list lst_arg, t_list *alst)
{
	void *p;

	p = va_arg(lst_arg, void *);
	alst->flag += FLAG_P;
	alst->content = ft_free(alst->content);
	if (!p && alst->flag & FLAG_PR && alst->precision == 0)
	{
		if (!(alst->content = ft_strdup("")))
			return (0);
		return (1);
	}
	if (!(alst->content = ft_pointer_hexa(p)))
		return (0);
	return (1);
}

int	ft_pr_pointer(t_list *alst, int pr)
{
	char	*str;
	char	*new;
	int		l;
	int		i;

	str = alst->content;
	l = ft_strlen(str);
	if (pr <= l)
		return (1);
	if (!(new = (char *)malloc(sizeof(char) * (pr + 3))))
		return (0);
	i = 0;
	l = pr - (l - 2);
	new[i++] = *str++;
	new[i++] = *str++;
	while (l--)
		new[i++] = '0';
	while (*str)
		new[i++] = *str++;
	new[i] = 0;
	free(alst->content);
	alst->content = new;
	return (1);
}
