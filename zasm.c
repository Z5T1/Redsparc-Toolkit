#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VERSION "1.0.0"

#define LINE_BUFFER_SIZE 1024

int line_number;

char is_numeric_char(char c);

int get_register_address(char* name);

void assemble(FILE* out, char* line);

int main(int argc, char** argv) {
	char* ifname = NULL;
	char* ofname = "a.zob";
	FILE* ifp;
	FILE* ofp;

	char line[LINE_BUFFER_SIZE];
	int i;
	
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--help") == 0) {
			printf(	"Usage: %s [options] file\n"
					"Options\n"
					"	--help	displays this message\n"
					"	--version	displays version information\n"
					"	-o <file>	output to file instead of a.zob\n",
					argv[0]);
			return 0;
		}
		else if (strcmp(argv[i], "--version") == 0) {
			printf("Z5T1's Assembler Version "VERSION"\nhttp://z5t1.com/redsparc\n");
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
		else {
			ifname = argv[i];
		}
	}
	
	if (ifname == NULL) {
		printf("Error: no input file specified\n");
		return 1;
	}
	
	ifp = fopen(ifname, "r");
	ofp = fopen(ofname, "w");
	
	if (ifp == NULL) {
		printf("Error: could not open %s\n", ifname);
		return 1;
	}
	
	for (line_number = 1; fgets(line, LINE_BUFFER_SIZE, ifp) != NULL; line_number++) {
		assemble(ofp, line);
	}

	fclose(ifp);
	fclose(ofp);

	return 0;
}

char is_numeric_char(char c) {
	if (c >= '0' && c <= '9')
		return 1;
	else
		return 0;
}

int get_register_address(char* name) {
	if (strcmp(name, "ax") == 0 || strcmp(name, "AX") == 0)
		return 0;
	else if (strcmp(name, "bx") == 0 || strcmp(name, "BX") == 0)
		return 1;
	else if (strcmp(name, "cx") == 0 || strcmp(name, "CX") == 0)
		return 2;
	else if (strcmp(name, "dx") == 0 || strcmp(name, "DX") == 0)
		return 3;
	else if (strcmp(name, "si") == 0 || strcmp(name, "SI") == 0)
		return 4;
	else if (strcmp(name, "di") == 0 || strcmp(name, "DI") == 0)
		return 5;
	else if (strcmp(name, "sp") == 0 || strcmp(name, "SP") == 0)
		return 6;
	else if (strcmp(name, "bp") == 0 || strcmp(name, "BP") == 0)
		return 7;
	else
		return -1;
}

void assemble(FILE* out, char* line) {
	static int address = 0;
	
	if (line[0] == ';' || line[0] == '\n')
		return;
	else if (!isspace(line[0])) {
		strtok(line, "\t\n\r:;");
		fprintf(out, "%s\n", line);
	}
	else {
		char* argv[16];
		int argc;
		
		strtok(line, "\t\n\r;");
		while (strtok(NULL, "\t\n\r;") != NULL) {}
		
		argv[0] = strtok(line, "\t ,");
		for (argc = 1; (argv[argc] = strtok(NULL, "\t ,")) != NULL; argc++) {}
		
		if (strcmp(argv[0], "org") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\torg\tno origin specified\n", line_number);
				exit(2);
			}
			address = atoi(argv[1]);
		}
		else if (strcmp(argv[0], "dw") == 0) {
			if (argc < 1) {
				fprintf(out, "\t%i 0\n", address);
				address++;
			}
			else if (argc < 2) {
				fprintf(out, "\t%i %s\n", address, argv[1]);
				address++;
			}
			else {
				int i;
				int n = atoi(argv[2]);
				
				for (i = 0; i < n; i++) {
					fprintf(out, "\t%i %s\n", address, argv[1]);
					address++;
				}
			}
		}
		else if (strcmp(argv[0], "hlt") == 0) {
			fprintf(out, "\t%i 0\n", address);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
		}
		else if (strcmp(argv[0], "out") == 0) {
			int reg;
			reg = get_register_address(argv[1]);
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tout\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			if (reg < 0) {
				fprintf(out, "\t%i 1\n", address);
				address++;
				fprintf(out, "\t%i %s\n", address, argv[1]);
				address++;
				fprintf(out, "\t%i %s\n", address, argv[2]);
				address++;
			}
			else {
				fprintf(out, "\t%i 2\n", address);
				address++;
				fprintf(out, "\t%i %i\n", address, reg);
				address++;
				fprintf(out, "\t%i %s\n", address, argv[2]);
				address++;
			}
			
		}
		else if (strcmp(argv[0], "in") == 0) {
			int reg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tin\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			reg = get_register_address(argv[1]);
			
			if (reg < 0) {
				fprintf(stderr, "%i:\tin\tinvalid register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 3\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, reg);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[2]);
			address++;
			
		}
		else if (strcmp(argv[0], "push") == 0) {
			int reg;
			
			if (argc < 2) {
				fprintf(stderr, "%i:\tpush\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			reg = get_register_address(argv[1]);
			
			if (reg < 0) {
				fprintf(stderr, "%i:\tpush\tinvalid register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 8\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, reg);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "pop") == 0) {
			int reg;
			
			if (argc < 2) {
				fprintf(stderr, "%i:\tpop\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			reg = get_register_address(argv[1]);
			
			if (reg < 0) {
				fprintf(stderr, "%i:\tpop\tinvalid register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 9\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, reg);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "call") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tcall\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 10\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "ret") == 0) {
			fprintf(out, "\t%i 11\n", address);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "jmp") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tjmp\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 12\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "mov") == 0) {
			if (argc < 3) {
				fprintf(stderr, "%i:\tmov\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			else if (argv[1][0] == '[') {
				int reg;
				
				strtok(argv[1], "]");
				reg = get_register_address(argv[1]+1);
				
				if (reg < 0) {
					int dreg = get_register_address(argv[2]);
					
					if (argv[2][0] == '[') {
						strtok(argv[2], "]");
						
						fprintf(out, "\t%i 22\n", address);
						address++;
						fprintf(out, "\t%i %s\n", address, argv[1]+1);
						address++;
						fprintf(out, "\t%i %s\n", address, argv[2]+1);
						address++;
					}
					else if (dreg < 0) {
						fprintf(out, "\t%i 20\n", address);
						address++;
						fprintf(out, "\t%i %s\n", address, argv[1]+1);
						address++;
						fprintf(out, "\t%i %s\n", address, argv[2]);
						address++;
					}
					else {
						fprintf(out, "\t%i 21\n", address);
						address++;
						fprintf(out, "\t%i %s\n", address, argv[1]+1);
						address++;
						fprintf(out, "\t%i %i\n", address, dreg);
						address++;
					}
				}
				else {
					int dreg;
					
					dreg = get_register_address(argv[2]);
						
					if (dreg < 0) {
						fprintf(stderr, "%i:\tmov\tinvalid source register\n", line_number);
						exit(2);
					}
					
					fprintf(out, "\t%i 23\n", address);
					address++;
					fprintf(out, "\t%i %i\n", address, reg);
					address++;
					fprintf(out, "\t%i %i\n", address, dreg);
					address++;
				}
			}
			else if (is_numeric_char(argv[1][0])) {
				fprintf(stderr, "%i:\tmov\tcannot use a constant as mov destination\n", line_number);
				exit(2);
			}
			else {
				int dreg = get_register_address(argv[2]);
				int reg = get_register_address(argv[1]);
				
				if (reg < 0) {
					fprintf(stderr, "%i:\tmov\tinvalid destination register\n", line_number);
					exit(2);
				}
				else if (argv[2][0] == '[') {
					strtok(argv[2], "]");
					dreg = get_register_address(argv[2]+1);
					
					if (dreg < 0) {
						fprintf(out, "\t%i 18\n", address);
						address++;
						fprintf(out, "\t%i %i\n", address, reg);
						address++;
						fprintf(out, "\t%i %s\n", address, argv[2]+1);
						address++;
					}
					else {					
						fprintf(out, "\t%i 19\n", address);
						address++;
						fprintf(out, "\t%i %i\n", address, reg);
						address++;
						fprintf(out, "\t%i %i\n", address, dreg);
						address++;
					}
				}
				else if (dreg < 0) {
					fprintf(out, "\t%i 16\n", address);
					address++;
					fprintf(out, "\t%i %i\n", address, reg);
					address++;
					fprintf(out, "\t%i %s\n", address, argv[2]);
					address++;
				}
				else {			
					fprintf(out, "\t%i 17\n", address);
					address++;
					fprintf(out, "\t%i %i\n", address, reg);
					address++;
					fprintf(out, "\t%i %i\n", address, dreg);
					address++;
				}
			}
		}
		else if (strcmp(argv[0], "add") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tadd\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tadd\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tadd\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 32\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "sub") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tsub\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tsub\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tsub\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 33\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "mul") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tmul\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tmul\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tmul\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 34\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "div") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tdiv\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tdiv\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tdiv\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 35\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "mod") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tmod\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tmod\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tmod\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 36\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "and") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tand\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tand\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tand\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 37\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "or") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tor\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tor\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tor\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 38\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "xor") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\txor\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\txor\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\txor\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 39\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "inc") == 0) {
			int reg;
			
			if (argc < 2) {
				fprintf(stderr, "%i:\tinc\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			reg = get_register_address(argv[1]);
			
			if (reg < 0) {
				fprintf(stderr, "%i:\tinc\tinvalid register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 40\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, reg);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "dec") == 0) {
			int reg;
			
			if (argc < 2) {
				fprintf(stderr, "%i:\tdec\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			reg = get_register_address(argv[1]);
			
			if (reg < 0) {
				fprintf(stderr, "%i:\tdec\tinvalid register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 41\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, reg);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "cmp") == 0) {
			int dreg;
			int sreg;
			
			if (argc < 3) {
				fprintf(stderr, "%i:\tcmp\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			dreg = get_register_address(argv[1]);
			sreg = get_register_address(argv[2]);
			
			if (dreg < 0) {
				fprintf(stderr, "%i:\tcmp\tinvalid destination register address\n", line_number);
				exit(2);
			}
			if (sreg < 0) {
				fprintf(stderr, "%i:\tcmp\tinvalid source register address\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 48\n", address);
			address++;
			fprintf(out, "\t%i %i\n", address, dreg);
			address++;
			fprintf(out, "\t%i %i\n", address, sreg);
			address++;
			
		}
		else if (strcmp(argv[0], "je") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tje\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 49\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "jne") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tjne\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 50\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "jg") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tjg\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 51\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "jge") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tjge\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 52\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "jl") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tjl\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 53\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (strcmp(argv[0], "jle") == 0) {
			if (argc < 2) {
				fprintf(stderr, "%i:\tjle\tnot enough arguments specified\n", line_number);
				exit(2);
			}
			
			fprintf(out, "\t%i 54\n", address);
			address++;
			fprintf(out, "\t%i %s\n", address, argv[1]);
			address++;
			fprintf(out, "\t%i 0\n", address);
			address++;
			
		}
		else if (argv[0][0] != ';' && !isspace(argv[0][0]))
			fprintf(stderr, "Warning: unrecognized symbol at line %i\n", line_number);
	}
	
	return;
}
