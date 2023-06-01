/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_precision.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/10/13 16:52:34 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 16:52:46 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_pr_num(t_list *alst, int pr, int l)
{
	char	*str;
	char	*new;
	int		i;

	str = alst->content;
	if (!(new = (char *)malloc(sizeof(char) * (pr + 1))))
		return (0);
	i = 0;
	l = pr - l;
	if (alst->flag & FLAG_D && str[0] == '-')
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

int	ft_pr_string(t_list *alst, int pr)
{
	char	*str;

	str = alst->content;
	if (!(alst->content = ft_substr(str, 0, pr)))
		return (0);
	str = ft_free(str);
	return (1);
}
