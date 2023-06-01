/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_is_specifier.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/09/14 16:18:19 by tcosse            #+#    #+#             */
/*   Updated: 2020/09/18 11:37:49 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

char	ft_is_specifier(char c)
{
	int	i;

	i = 0;
	while (SPECIFIER[i])
	{
		if (c == SPECIFIER[i])
			return (SPECIFIER[i]);
		i++;
	}
	return (0);
}
