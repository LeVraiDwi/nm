#include "bit_read.h"

t_file    *get_file_string(char   *path) {
    int fd;
    t_file  *file;

    file = new_file();
    if (!file)
        return 0;
    fd = ft_open(path);
    if (!fd) {
        rm_file(file);
        return 0;
    }
    if (fstat(fd, &file->buf)) {
        ft_close(fd);
        rm_file(file);
        return 0;
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
    file->addr = mmap(NULL, file->buf.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (ft_close(fd)) {
        rm_file(file);
        return (0);
    }
    if ((void *)file->addr == (void *)-1) {
        rm_file(file);
        return 0;
    }
    return file;
}