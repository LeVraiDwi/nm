/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_margin.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/10/08 09:59:49 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 17:31:37 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_format_margin(t_list *alst)
{
	unsigned int	l;

	l = ft_strlen((char *)alst->content);
	if (alst->flag & FLAG_C && alst->precision == -1)
		l++;
	else if (alst->flag & FLAG_P && alst->flag & FLAG_Z
		&& !(alst->flag & FLAG_PR))
		l += 2;
	if (alst->margin > l)
	{
		if (alst->flag & FLAG_M)
		{
			if (!(ft_addfront(alst, alst->margin, l, ' ')))
				return (0);
		}
		else if (!(ft_addback(alst, alst->margin, l, ft_zero_space(alst))))
			return (0);
	}
	return (1);
}

int	ft_zero_space(t_list *alst)
{
	if (alst->flag & FLAG_M)
		return (' ');
	if (alst->flag & FLAG_Z)
	{
		if (alst->flag & FLAG_C)
			return ('0');
		if (!(alst->flag & FLAG_PR) || (alst->flag & FLAG_S))
			return ('0');
	}
	return (' ');
}

int	ft_addfront(t_list *alst, int n, int l, char c)
{
	char	*str;
	int		i;

	i = 0;
	if (!(str = malloc(sizeof(char) * n + 1)))
		return (0);
	n = n - l;
	while (l--)
	{
		str[i] = ((char *)alst->content)[i];
		i++;
	}
	while (n--)
		str[i++] = c;
	str[i] = 0;
	free(alst->content);
	alst->content = str;
	return (1);
}

int	ft_addback(t_list *alst, int margin, int l, char c)
{
	char	*str;
	char	*tmp;
	int		i;

	i = 0;
	tmp = (char *)alst->content;
	if (!(str = malloc(sizeof(char) * margin + 1)))
		return (0);
	margin = margin - l;
	if (alst->flag & FLAG_D && tmp[0] == '-' && alst->flag & FLAG_Z
		&& !(alst->flag & FLAG_PR))
		str[i++] = *tmp++;
	while (margin--)
		str[i++] = c;
	while (l--)
		str[i++] = *tmp++;
	str[i] = 0;
	free(alst->content);
	alst->content = str;
	return (1);
}
