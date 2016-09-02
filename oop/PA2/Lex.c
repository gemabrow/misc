// Gerald Brown
// 1377271
// PA2

//-----------------------------------------------------------------------------
// Lex.c
// A client program which takes in two command line arguments
// giving the names of an input file and an output file
// The output file will contain the same lines as the input
// but rearranged alphabetically.
//-----------------------------------------------------------------------------

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "List.h"

#define MAX_LEN 160

int main(int argc, char * argv[])
{
	int i, j, numLines = 0;
	FILE *in, *out, *tempRead;
	char line[MAX_LEN];
	char **allLines = NULL;
	
	
	// check command lines for correct number of arguments
	if( argc != 3 ) {
		printf("Usage: %s <input file> <output file>\n", argv[0]);
		exit(1);
	}
	
	// open files for reading and writing
	in = fopen(argv[1], "r");
	tempRead = fopen(argv[1], "r");
	out = fopen(argv[2], "w");
	if( in==NULL ) {
		printf("Unable to open file %s for reading\n", argv[1]);
		exit(1);
	}
	if( out==NULL ) {
		printf("Unable to open file %s for writing\n", argv[2]);
		exit(1);
	}


	/* read each line of input file*/
	while(fgets(line, MAX_LEN, tempRead) != NULL)  {
		numLines++;
	}

	allLines = malloc(numLines * (sizeof(char*)) );

	while (fgets(line, MAX_LEN, in) != NULL) {
		allLines[i] = malloc(strlen(line)+1);
		strcpy(allLines[i], line);
		i++;
	}

	List L = newList();
	//---------------------------------------------------------------
	for(i = 0; i < numLines; i++) {
		moveTo(L, 0);
		printf("//successful moveTo(L,0)\n");

		for(j = 0; j < length(L); j++) {
			printf(" //length(L) called\n");
			if( strcmp(allLines[i], allLines[getElement(L)]) < 0 ){
				printf(" //strcmp success \n");
				break;
			}
			if( j != (length(L) - 1) ){
				moveNext(L);
				printf("//moveNext() success \n");
			}
		}
		
		if(length(L) == 0){
			append(L, i);
			printf("//append success \n");
		}
		else if( j < length(L) ) {
			insertBefore(L, i);
			printf("//insertBefore() success \n");
		}
		else
			append(L, i);
	}
	
	moveTo(L, 0);
	printList(out, L);
	printf("//printList() success \n");
	clear(L);
	printf("//clear() success \n");
	freeList(&L);
	printf("//freeList() success \n");

	
	/* close files */
	fclose(in);
	fclose(tempRead);
	fclose(out);

	return(0);
}
