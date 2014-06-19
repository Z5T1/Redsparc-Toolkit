#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VERSION "1.0.0"

#define LINE_BUFFER_SIZE 1024

struct label {
	char name[65];
	int address;
};

struct ifile {
	char* name;
	int offset;
	FILE* fp;
};

char is_numeric_char(char c);

int get_address(struct label* labels, int size, char* name);

int main(int argc, char** argv) {
	struct ifile ifnames[128] = {NULL};
	char* ofname = "a.rs";
	char include[256] = DEFAULT_INCLUDE_PATH;
	FILE* ofp;
	int ifcount = 0;

	struct label* labels;
	int label_count = 0;

	char line[LINE_BUFFER_SIZE];
	int i, i2;
	int offset = 0;
	
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--help") == 0) {
			printf(	"Usage: %s [options] file\n"
					"Options\n"
					"	--help	displays this message\n"
					"	--version	displays version information\n"
					"	-o <file>	output to file instead of a.rs\n"
					"	-I <path>	uses path as the default library directory\n"
					"	-l <lib>	links lib into output\n",
					argv[0]);
			return 0;
		}
		else if (strcmp(argv[i], "--version") == 0) {
			printf("Z5T1's Linker Version "VERSION"\nhttp://z5t1.com/redsparc\n");
			return 0;
		}
		else if (strcmp(argv[i], "-o") == 0) {
			if (i == argc-1) {
				printf("Error: no output file specified\n");
				return 1;
			}
			else {
				i++;
				ofname = argv[i];
			}
		}
		else if (strcmp(argv[i], "-I") == 0) {
			if (i == argc-1) {
				printf("Error: no include directory specified\n");
				return 1;
			}
			else {
				i++;
				strcpy(include, argv[i]);
			}
		}
		else if (strncmp(argv[i], "-l", 2) == 0) {
			if (i == argc-1 && argv[i][2] == 0) {
				printf("Error: no library specified\n");
				return 1;
			}
			else if (include[0] == 0) {
				printf("Error: no include path specified\n");
				return 1;
			}
			else if (argv[i][2] != 0) {
				ifnames[ifcount].name = malloc(strlen(include) + strlen(argv[i]+2) + 5);
				sprintf(ifnames[ifcount].name, "%s/%s.zob", include, argv[i]+2);
				ifcount++;
			}
			else {
				i++;
				ifnames[ifcount].name = malloc(strlen(include) + strlen(argv[i]) + 5);
				sprintf(ifnames[ifcount].name, "%s/%s.zob", include, argv[i]);
				ifcount++;
			}
		}
		else {
			ifnames[ifcount].name = argv[i];
			ifcount++;
		}
	}
	
	if (ifcount == 0) {
		printf("Error: no input file specified\n");
		return 1;
	}
	
	for (i = 0; i < ifcount; i++) {
		ifnames[i].fp = fopen(ifnames[i].name, "r");
		if (ifnames[i].fp == NULL) {
			printf("Error: could not open %s\n", ifnames[i].name);
			return 1;
		}
	}
	ofp = fopen(ofname, "w");
	
	// First Pass - Count labels and Calculate offsets
	for (i = 0; i < ifcount; i++) {
		ifnames[i].offset = offset;
		while (fgets(line, LINE_BUFFER_SIZE, ifnames[i].fp) != NULL) {
			if (!isspace(line[0]))
				label_count++;
			else if (line[0] != '\n')
				offset++;
		}
	}
	
	labels = malloc(label_count * sizeof(struct label));

	// Second Pass - Store labels
	i2 = 0;
	for (i = 0; i < ifcount; i++) {
		fseek(ifnames[i].fp, 0, SEEK_SET);
		while (fgets(line, LINE_BUFFER_SIZE, ifnames[i].fp) != NULL) {
			if (!isspace(line[0])) {
				char* address;
				
				strtok(line, "\n");
				strcpy(labels[i2].name, line);
				fgets(line, LINE_BUFFER_SIZE, ifnames[i].fp);
				
				address = strtok(line, "\t ");
				strtok(NULL, "\t ");
				
				labels[i2].address = ifnames[i].offset + atoi(address);
				i2++;
			}
		}
	}
	
	// Third Pass - Replace labels with addresses
	for (i = 0; i < ifcount; i++) {
		fseek(ifnames[i].fp, 0, SEEK_SET);
		while (fgets(line, LINE_BUFFER_SIZE, ifnames[i].fp) != NULL) {
			if (isspace(line[0])) {
				char* argv[5];
				int argc;
				
				argv[0] = strtok(line, "\t \n");
				for (argc = 1; (argv[argc] = strtok(NULL, "\t \n")) != NULL; argc++) {}
				
				fprintf(ofp, "var set ram%i ", ifnames[i].offset + atoi(argv[0]));
				if (is_numeric_char(argv[1][0])) {
					fprintf(ofp, "%s\n", argv[1]);
				}
				else {
					int address = get_address(labels, label_count, argv[1]);
					
					if (address < 0) {
						fprintf(stderr, "Invalid address (%s) at line %i\n", argv[1], i+1);
						exit(2);
					}
					
					fprintf(ofp, "%i\n", address);
				}
			}
		}
	}

	free(labels);

	for (i = 0; i < ifcount; i++) {
		fclose(ifnames[i].fp);
	}
	fclose(ofp);

	return 0;
}

char is_numeric_char(char c) {
	if (c >= '0' && c <= '9')
		return 1;
	else
		return 0;
}

int get_address(struct label* labels, int size, char* name) {
	int i;
	
	for (i = 0; i < size+5; i++) {
		if (strcmp(labels[i].name, name) == 0) {
			return labels[i].address;
		}
	}
	
	return -1;
}
