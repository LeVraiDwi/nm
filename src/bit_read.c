#include "ft_nm.h"

int get_map_string(char   *path, t_map *map) {
    int fd;

    fd = ft_open(path);
    if (!fd) {
        rm_map(map);
        return -1; //error
    }
    if (fstat(fd, &map->buf)) {
        ft_close(fd);
        rm_map(map);
        return -1; //error
    }
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
    map->addr = mmap(NULL, map->buf.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
    if (ft_close(fd)) {
        rm_map(map);
        return (-1); //error
    }
    if ((void *)map->addr == (void *)-1) {
        rm_map(map);
        return -1; //error
    }
    return 0;
}