//-----------------------------------------------------------------------------
// List.h
// Header file for List ADT
//-----------------------------------------------------------------------------

#ifndef _LIST_H_INCLUDE_
#define _LIST_H_INCLUDE_


// Exported type --------------------------------------------------------------
typedef struct ListObj* List;


// Constructors-Destructors ---------------------------------------------------

// newList()
// Returns reference to new empty List object.
List newList(void);

// freeList()
// Frees all heap memory associated with List *pL, and sets *pL to NULL.
void freeList(List* pL);


// Access functions -----------------------------------------------------------

// length()
// Returns the length of L.
int length(List L);

// getIndex()
// Returns the index of cursor on L,
// or returns -1 if the cursor is undefined.
// Pre: length()>0 && cursor != NULL.
int getIndex(List L);

// front()
// Returns the value at the front of L.
// Pre: length()>0
int front(List L);

// back()
// Returns the value at the back of L.
// Pre: length()>0
int back(List L);

// getElement()
// Returns the value at the cursor on L.
// Pre: length()>0 && cursor != NULL.
int getElement(List L);

// equals()
// returns true (1) if A is identical to B, false (0) otherwise
int equals(List A, List B);

// Manipulation procedures ----------------------------------------------------

// clear()
// Re-sets this List to the empty state
void clear(List L);

// moveTo()
// If 0<=i<=length()-1, moves the cursor to the element
// at index i, otherwise the cursor becomes undefined.
void moveTo(List L, int i);

// movePrev()
// If 0 < getIndex() <= length()-1, moves the cursor one step toward the
// front of the list. If getIndex() == 0, cursor becomes undefined.
// If getIndex() == -1, cursor remains undefined. This operation is
// equivalent to moveTo(getIndex()-1).
void movePrev(List L);

// moveNext()
// If 0<=getIndex()<length()-1, moves the cursor one step toward the
// back of the list. If getIndex()==length()-1, cursor becomes
// undefined. If index==-1, cursor remains undefined. This
// operation is equivalent to moveTo(getIndex()+1).
void moveNext(List L);

// prepend()
// Places new data element at the beginning of L.
void prepend(List L, int data);

// append()
// Places new data element at the end of L.
void append(List L, int data);

// insertBefore()
// Inserts new element before cursor in L.
// Pre: length() > 0, getIndex() >= 0
void insertBefore(List L, int data);

// insertAfter()
// Inserts new element after cursor in L.
void insertAfter(List L, int data);

// deleteFront()
// Deletes element at front of L
// Pre: length()>0
void deleteFront(List L);

// deleteBack()
// Deletes element at back of L
// Pre: length()>0
void deleteBack(List L);

// delete()
// Deletes cursor element in this List. Cursor is undefined after this
// operation.
// Pre: length()>0, getIndex()>=0
void delete(List L);

// Other Functions ------------------------------------------------------------

// printList()
// Prints L to the file pointed to by out as a space-separated string.
void printList(FILE* out, List L);

// copyList()
// Returns a new list representing the same integer sequence as this
// list. The cursor in the new list is undefined, regardless of the
// state of the cursor in this List. This List is unchanged.
List copyList(List L);

#endif
