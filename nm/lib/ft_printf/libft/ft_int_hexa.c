/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_int_hexa.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/31 16:18:17 by tcosse            #+#    #+#             */
/*   Updated: 2020/08/31 17:23:06 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void			int_hexa(unsigned int n, char *str)
{
	char	*hexa;

	hexa = "0123456789abcdef";
	if (n / 16 != 0)
		int_hexa(n / 16, str - 1);
	*str = hexa[n % 16];
}

void			int_uhexa(unsigned int n, char *str)
{
	char	*hexa;

	hexa = "0123456789ABCDEF";
	if (n / 16 != 0)
		int_uhexa(n / 16, str - 1);
	*str = hexa[n % 16];
}

unsigned int	size_hexa(unsigned int n)
{
	int	l;

	l = 1;
	while ((n / 16) != 0)
	{
		n = n / 16;
		l++;
	}
	return (l);
}

char			*ft_int_hexa(unsigned int n, int upper)
{
	int		l;
	char	*str;

	l = size_hexa(n) + 1;
	if (!(str = (char *)malloc(sizeof(char) * l)))
		return (0);
	str[l - 1] = 0;
	if (upper)
		int_uhexa(n, str + l - 2);
	else
		int_hexa(n, str + l - 2);
	return (str);
}
