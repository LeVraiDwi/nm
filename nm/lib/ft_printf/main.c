/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: tcosse <tcosse@student.42.fr>              +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/09/11 14:31:56 by tcosse            #+#    #+#             */
/*   Updated: 2020/10/13 16:11:02 by tcosse           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

int	main()
{
	char *str;
	char *str1;
	char *str2;
	char *str3;
	char *str4;

	str = "asd";
	str1 = "sdg";
	str2 = "asdgasdg";
	str3 = "asdgasdg";
	str4 = "asdgasdg";
	ft_printf("%-5c\n", 0);
	printf("%-5c\n", 0);
	return (1);
}
