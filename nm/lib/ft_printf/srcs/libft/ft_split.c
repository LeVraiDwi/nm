/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/05/04 17:16:48 by tcosse            #+#    #+#             */
/*   Updated: 2020/08/07 08:42:22 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

int		count(char const *s, char c)
{
	int i;
	int j;

	i = 0;
	j = 0;
	while (s[j] && s[j] == c)
		j++;
	if (s[j])
		i++;
	while (s[j])
		if (s[j++] == c)
		{
			while (s[j] == c)
				j++;
			if (!s[j])
				return (i);
			i++;
		}
	return (i);
}

char	**cleantab(char **tab, char *buf)
{
	free(tab);
	free(buf);
	return (0);
}

char	**ft_split(char const *s, char c)
{
	int		i;
	int		j;
	char	*buf;
	char	**strtab;

	j = 0;
	if (!s || !(buf = (char *)malloc(sizeof(char *) * ft_strlen(s))))
		return (0);
	if (!(strtab = (char **)malloc(sizeof(char *) * (count(s, c) + 1))))
		return (0);
	while (*s)
	{
		i = 0;
		while (*s && *s != c)
			buf[i++] = *s++;
		buf[i] = '\0';
		while (*s && *s == c)
			s++;
		if (*buf)
			if (!(strtab[j++] = ft_strdup(buf)))
				return (cleantab(strtab, buf));
	}
	strtab[j] = NULL;
	free(buf);
	return (strtab);
}
