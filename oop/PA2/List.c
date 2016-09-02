// Gerald Brown
// 1377271
// PA2

//-----------------------------------------------------------------------------
// List.c
// Implementation file for List ADT
//-----------------------------------------------------------------------------

#include<stdio.h>
#include<stdlib.h>
#include "List.h"

// structs --------------------------------------------------------------------

// private NodeObj type
typedef struct NodeObj {
	int data;
	struct NodeObj* next;
	struct NodeObj* prev;
} NodeObj;

// private Node type
typedef NodeObj* Node;

// private ListObj type
typedef struct ListObj {
	Node front;
	Node back;
	Node cursor;
	int length;
} ListObj;


// Constructors-Destructors ---------------------------------------------------

// newNode()
// Returns reference to new Node object. Initializes next,
// prev, and data fields.
// Private.
Node newNode(int data)
{
	Node N = malloc(sizeof(NodeObj));
	N->data = data;
	N->next = NULL;
	N->prev = NULL;
	return(N);
}

// freeNode()
// Frees heap memory pointed to by *pN, sets *pN to NULL.
// Private.
void freeNode(Node* pN)
{
	if( pN!=NULL && *pN!=NULL ) {
		free(*pN);
		*pN = NULL;
	}
}

// newList()
// Returns reference to new empty List object.
List newList(void)
{
	List L;
	L = malloc(sizeof(ListObj));
	L->front = L->back = L->cursor = NULL;
	L->length = 0;
	return(L);
}


// freeList()
// Frees all heap memory associated with List *pL, and sets *pL to NULL
void freeList(List* pL)
{
	if(pL==NULL || *pL==NULL) {
		return;
	}
	while( length(*pL)>0 ) {
		deleteFront(*pL);
	}
	free(*pL);
	*pL = NULL;
}


// Access functions -----------------------------------------------------------

// length()
// Returns the length of L.
int length(List L)
{
	return(L->length);
}

// getIndex()
// Returns the index of cursor on L,
// or returns -1 if the cursor is undefined.
// Pre: length()>0 && cursor != NULL.
int getIndex(List L)
{
	if( L->cursor==NULL ) {
		printf("List Error: calling getIndex() on NULL Cursor reference\n");
		return(-1);
	}
	if( length(L) == 0 ) {
		printf("List Error: calling getIndex() on empty list\n");
		return(0);
	}

	int cursorIndex = 0;
	Node temp = L->front;

	while ((temp->data) != (L->cursor->data)) {
		temp = temp->next;
		cursorIndex++;
	}
	return(cursorIndex);
}

// front()
// Returns the value at the front of L.
// Pre: length()>0
int front(List L)
{
	if( (L->length)==0) {
		printf("List Error: calling front() on an empty List\n");
		exit(1);
	}
	return(L->front->data);
}

// back()
// Returns the value at the back of L.
// Pre: length()>0
int back(List L)
{
	if( L->length==0 ) {
		printf("List Error: calling back() on an empty List\n");
		exit(1);
	}
	return(L->back->data);
}

// getElement()
// Returns the value at the cursor on L.
// Pre: length()>0 && cursor != NULL.
int getElement(List L)
{
	if( L->length==0 ) {
		printf("List Error: calling getElement() on an empty List\n");
		exit(1);
	}
	if( L->cursor==NULL ) {
		printf("List Error: calling getElement() on NULL Cursor reference\n");
		exit(1);
	}

	return(L->cursor->data);
}

// equals()
// returns true (1) if A is identical to B, false (0) otherwise
int equals(List A, List B)
{
	int flag = 1;
	Node N = NULL;
	Node M = NULL;

	if( A==NULL || B==NULL ) {
		printf("List Error: calling equals() on NULL List reference\n");
		exit(1);
	}
	N = A->front;
	M = B->front;
	if( A->length != B->length ) {
		return 0;
	}
	while( flag && N!=NULL) {
		flag = (N->data==M->data);
		N = N->next;
		M = M->next;
	}
	return flag;
}

// Manipulation procedures ----------------------------------------------------

// clear()
// Re-sets this List to the empty state
void clear(List L)
{
	if( L==NULL ) {
		printf("List Error: calling clear() on NULL List reference\n");
		exit(1);
	}
	while( L->length > 0) {
		deleteFront(L);
	}
}

// moveTo()
// If 0<=i<=(L->length-1), moves the cursor to the element
// at index i, otherwise the cursor becomes undefined.
void moveTo(List L, int i)
{
	int cursorIndex = 0;

	if( (0<=i) && (i<(L->length)) ) {
		L->cursor = L->front;
		while (cursorIndex != i) {
			L->cursor = L->cursor->next;
			cursorIndex++;
		}
	} else {
		L->cursor = NULL;
	}
}
// movePrev()
// If 0 < getIndex() <= length()-1, moves the cursor one step toward the
// front of the list. If getIndex() == 0, cursor becomes undefined.
// If getIndex() == -1, cursor remains undefined. This operation is
// equivalent to moveTo(getIndex()-1).
void movePrev(List L)
{
	int cursorIndex = getIndex(L);

	if( (0<cursorIndex) && (cursorIndex <= (L->length-1)) ) {
		L->cursor = L->cursor->prev;
	} else {
		L->cursor = NULL;
	}
}
// moveNext()
// If 0<=getIndex()<length()-1, moves the cursor one step toward the
// back of the list. If getIndex()==length()-1, cursor becomes
// undefined. If index==-1, cursor remains undefined. This
// operation is equivalent to moveTo(getIndex()+1).
void moveNext(List L)
{
	int cursorIndex = getIndex(L);

	if( (0<=cursorIndex) && (cursorIndex < (L->length-1)) ) {
		L->cursor = L->cursor->next;
	} else {
		L->cursor = NULL;
	}
}

// prepend()
// Places new data element at the beginning of L.
void prepend(List L, int data)
{
	Node N = newNode(data);

	if( L->length==0 ) {
		L->back = L->front = N;
	} else {
		L->front->prev = N;
		N->next = L->front;
		L->front = N;
	}
	L->length++;
}

// append()
// Places new data element at the end of L
void append(List L, int data)
{
	Node N = newNode(data);

	if( L->length==0 ) {
		L->front = L->back = N;
	} else {
		L->back->next = N;
		N->prev = L->back;
		L->back = N;
	}
	L->length++;
}

// insertBefore()
// Inserts new element before cursor in L.
// Pre: length() > 0, getIndex() >= 0
void insertBefore(List L, int data)
{

	Node N = newNode(data);

	if( L->length==0 ) {
		printf("List Error: calling insertBefore() on empty List\n");
		exit(1);
	}
	if( getIndex(L) < 0 ) {
		printf("List Error: calling insertBefore() on NULL cursor reference\n");
		exit(1);
	}
	N->prev = L->cursor->prev;
	N->next = L->cursor;
	L->cursor->prev->next = N;
	L->cursor->prev = N;
	L->length++;
}
// insertAfter()
// Inserts new element after cursor in L.
void insertAfter(List L, int data)
{

	Node N = newNode(data);

	if( L==NULL ) {
		printf("List Error: calling insertAfter() on NULL List reference\n");
		exit(1);
	}
	if( L->length==0 ) {
		printf("List Error: calling insertAfter() on empty List\n");
		exit(1);
	}
	if( L->cursor==NULL ) {
		printf("List Error: calling insertAfter() on NULL cursor reference\n");
		exit(1);
	}
	N->next = L->cursor->next;
	N->prev = L->cursor;
	L->cursor->next->prev = N;
	L->cursor->next = N;
	L->length++;
}

// deleteFront()
// Deletes element at front of L
// Pre: length(L)>0
void deleteFront(List L)
{
	if( length(L) <= 0 ) {
		printf("List Error: calling deleteFront() on an empty List\n");
		exit(1);
	}
	
	Node N = L->front;
	
	if( length(L)>1 ) {
		L->front = L->front->next;
		L->front->prev = NULL;
	} else {
		L->front = L->back = NULL;
	}
	L->length--;
	freeNode(&N);
}

// deleteBack()
// Deletes element at back of L
// Pre: length()>0
void deleteBack(List L)
{
	if( length(L) <= 0 ) {
		printf("List Error: calling deleteBack() on an empty List\n");
		exit(1);
	}
	
	Node N = L->back;
	
	if( length(L)>1 ) {
		L->back = L->back->prev;
		L->back->next = NULL;
	} else {
		L->back = L->front = NULL;
	}
	L->length--;
	freeNode(&N);
}

// delete()
// Deletes cursor element in this List. Cursor is undefined after this
// operation.
// Pre: length()>0, getIndex()>=0
void delete(List L)
{

	if( L==NULL ) {
		printf("List Error: calling delete() on NULL List reference\n");
		exit(1);
	}
	if( L->length==0 ) {
		printf("List Error: calling delete() on empty list\n");
		exit(1);
	}
	if( L->cursor==NULL ) {
		printf("List Error: calling delete() on NULL cursor reference\n");
		exit(1);
	}

	if( length(L)>1 ) {
		L->cursor->prev->next = L->cursor->next;
		L->cursor->next->prev = L->cursor->prev;
	} else {
		L->back = L->front = L->cursor = NULL;
	}
	L->length--;
	freeNode(&(L->cursor));
}

// Other Functions ------------------------------------------------------------

// printList()
// Prints L to the file pointed to by out as a space-separated string.
void printList(FILE* out, List L)
{
	if( L==NULL ) {
		printf("List Error: calling printList() on NULL List reference\n");
		exit(1);
	}
	Node temp = L->front;
	int i;
	for(i=0; i<length(L); i++) {
		fprintf(out, "%d ", temp->data);
		temp = temp->next;
	}
}

// copyList()
// Returns a new list representing the same integer sequence as this
// list. The cursor in the new list is undefined, regardless of the
// state of the cursor in this List. This List is unchanged.
List copyList(List L)
{
	if( L==NULL ) {
		printf("List Error: calling copyList() on NULL List reference\n");
		exit(1);
	}

	List duplicate = newList();
	Node temp = L->front;

	while(temp != NULL ) {
		prepend(duplicate, temp->data);
		temp = temp->next;
	}

	return(duplicate);
}
