/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_lstnew.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dwi <marvin@42.fr>                         +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/05/15 16:03:05 by dwi               #+#    #+#             */
/*   Updated: 2020/10/06 11:03:49 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

t_list	*ft_lstnew(void *content)
{
	t_list	*new;

	if (!(new = (struct s_list *)malloc(sizeof(struct s_list))))
		return (0);
	new->content = content;
	new->flag = 0;
	new->margin = 0;
	new->precision = 0;
	new->next = 0;
	return (new);
}
