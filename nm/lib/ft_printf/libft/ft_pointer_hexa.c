/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_pointer_hexa.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/08/31 16:18:17 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/08 11:43:26 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void			long_hexa(unsigned long n, char *str)
{
	char	*hexa;

	hexa = "0123456789abcdef";
	if (n / 16 != 0)
		long_hexa(n / 16, str - 1);
	*str = hexa[n % 16];
}

unsigned int	size_long_hexa(unsigned long n)
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

char			*ft_pointer_hexa(void *p)
{
	unsigned int		l;
	unsigned long		n;
	char				*str;

	n = (unsigned long)p;
	l = size_long_hexa(n) + 1;
	if (!(str = (char *)malloc(sizeof(char) * l)))
		return (0);
	str[l - 1] = 0;
	long_hexa(n, str + l - 2);
	return (str);
}
