/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_utils.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/09/11 14:10:50 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 17:30:28 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	ft_addstr(t_list *alst, int start, char *add)
{
	int		l;
	char	*tmp;
	char	*new;
	int		i;

	if (!add || !alst->content)
		return (0);
	tmp = (char *)alst->content;
	l = ft_strlen(add) + start;
	i = 0;
	if (!(new = (char *)malloc(sizeof(char) *
		(ft_strlen((char *)alst->content) + ft_strlen(add) - 1))))
		return (-1);
	while (start--)
		new[i++] = *(char *)alst->content++;
	i--;
	while (*add)
		new[i++] = *add++;
	while (*(char *)alst->content)
		new[i++] = *(char *)alst->content++;
	new[i] = 0;
	tmp = ft_free(tmp);
	alst->content = new;
	return (l - 1);
}

int	ft_insertstr(t_list *alst, int start, char *add)
{
	int		l;
	char	*tmp;
	char	*new;
	int		i;

	if (!add || !alst->content)
		return (0);
	tmp = (char *)alst->content;
	l = ft_strlen(add) + start;
	i = 0;
	if (!(new = (char *)malloc(sizeof(char) *
		(ft_strlen((char *)alst->content) + ft_strlen(add)))))
		return (-1);
	while (start--)
		new[i++] = *(char *)alst->content++;
	while (*add)
		new[i++] = *add++;
	while (*(char *)alst->content)
		new[i++] = *(char *)alst->content++;
	new[i] = 0;
	tmp = ft_free(tmp);
	alst->content = new;
	return (l - 1);
}

int	ft_error(char **a)
{
	if (*a)
		*a = ft_free(*a);
	return (0);
}

int	ft_errorclean(t_list **alst, va_list lst_arg)
{
	ft_lstclear(alst, &ft_del);
	va_end(lst_arg);
	return (0);
}
