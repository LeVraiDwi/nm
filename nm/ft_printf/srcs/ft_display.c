/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_display.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/07 08:30:17 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 16:41:11 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_display(t_list *alst, int fd)
{
	int				i;
	unsigned int	l;

	i = 0;
	while (alst)
	{
		if (alst->precision == -1 && alst->flag & FLAG_M)
			l = alst->margin;
		else if (alst->precision == -1)
			l = ft_strlen((char *)alst->content) + 1;
		else
			l = ft_strlen((char *)alst->content);
		i += l;
		write(fd, alst->content, l);
		alst = alst->next;
	}
	return (i);
}
