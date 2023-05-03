#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int ft_strlen(char *str) {
	int l;

	l = 0;
	while (str && *str++)
		l++;
	return l;
}

int	ft_open(char *path) {
	int	fd;
	
	fd = open(path, O_RDONLY);
	if (!fd)
		return 0;
	return fd;
}

int main(int argc, char **argv) {
	char		*tmp;
	int			i;
	int			fd;
	struct stat	buf;
	void 		*addr;

	if (argc <= 1) {
		tmp = "a.out";
	}
	else tmp = argv[1];
	i = 0;
	while(i < argc) {
		fd = ft_open(tmp);
		if (fd) {
			fstat(fd, &buf);
			// printf("File type:                ");
			// switch (buf.st_mode & S_IFMT) {
    		// 	case S_IFBLK:  printf("block device\n");            break;
   			//  	case S_IFCHR:  printf("character device\n");        break;
    		// 	case S_IFDIR:  printf("directory\n");               break;
    		// 	case S_IFIFO:  printf("FIFO/pipe\n");               break;
    		// 	case S_IFLNK:  printf("symlink\n");                 break;
    		// 	case S_IFREG:  printf("regular file\n");            break;
    		// 	case S_IFSOCK: printf("socket\n");                  break;
    		// 	default:       printf("unknown?\n");                break;
    		// }

   			// printf("I-node number:            %ld\n", (long) buf.st_ino);

   			// printf("Mode:                     %lo (octal)\n",
            // 	(unsigned long) buf.st_mode);

   			// printf("Link count:               %ld\n", (long) buf.st_nlink);
    		// printf("Ownership:                UID=%ld   GID=%ld\n",
            // 	(long) buf.st_uid, (long) buf.st_gid);

   			// printf("Preferred I/O block size: %ld bytes\n",
            // 	(long) buf.st_blksize);
    		// printf("File size:                %lld bytes\n",
            // 	(long long) buf.st_size);
    		// printf("Blocks allocated:         %lld\n",
            // 	(long long) buf.st_blocks);

   			// printf("Last status change:       %s", ctime(&buf.st_ctime));
   			// printf("Last file access:         %s", ctime(&buf.st_atime));
    		// printf("Last file modification:   %s", ctime(&buf.st_mtime));
			addr = mmap(NULL, buf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
			for (int n = 0; n < 600; n++) {
				printf("%x\n", ((char *)addr)[n]);
			}
		}
		i++;
		if (i < argc)
			tmp = argv[i];
	}
	return 0;
}
